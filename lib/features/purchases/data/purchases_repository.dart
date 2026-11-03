import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buildstock/core/audit/audit_writer.dart';
import 'package:buildstock/core/database/app_database.dart';
import 'package:buildstock/core/database/database_provider.dart';
import 'package:buildstock/core/domain/enums.dart';
import 'package:buildstock/core/errors/app_failure.dart';
import 'package:buildstock/core/utils/ids.dart';
import 'package:buildstock/core/utils/json.dart';
import 'package:buildstock/features/sales/domain/invoice_calculator.dart';

class PurchaseInput {
  const PurchaseInput({
    required this.lines,
    this.supplierId,
    this.storeId,
    this.godownId,
    this.supplierInvoiceNumber = '',
    this.invoiceDiscountPaise = 0,
    this.isGst = true,
    this.interState = false,
    this.amountPaidPaise = 0,
    this.paymentMethod = PaymentMethods.cash,
    this.notes = '',
    this.attachments = const [],
    this.date,
  });

  final List<InvoiceLine> lines;
  final String? supplierId;
  final String? storeId;
  final String? godownId;
  final String supplierInvoiceNumber;
  final int invoiceDiscountPaise;
  final bool isGst;
  final bool interState;
  final int amountPaidPaise;
  final String paymentMethod;
  final String notes;
  final List<String> attachments;
  final DateTime? date;
}

class PurchasesRepository {
  PurchasesRepository(this.services);

  final AppServices services;

  AppDatabase get db => services.db;
  AuditWriter get audit => AuditWriter(services);

  Stream<List<PurchaseRow>> watchPurchases({String query = ''}) {
    final statement = db.select(db.purchases)
      ..orderBy([(t) => OrderingTerm.desc(t.purchaseDate)]);
    if (query.trim().isNotEmpty) {
      final pattern = '%${query.trim()}%';
      statement.where(
        (t) =>
            t.purchaseNumber.like(pattern) |
            t.supplierInvoiceNumber.like(pattern),
      );
    }
    return statement.watch();
  }

  Future<PurchaseRow?> purchaseById(String id) => (db.select(
    db.purchases,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<PurchaseItemRow>> itemsForPurchase(String purchaseId) {
    return (db.select(db.purchaseItems)
          ..where((t) => t.purchaseId.equals(purchaseId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<String> createPurchase(PurchaseInput input) async {
    if (input.lines.isEmpty) {
      throw const ValidationFailure('Add at least one product');
    }
    final totals = InvoiceCalculator.compute(
      lines: input.lines,
      invoiceDiscountPaise: input.invoiceDiscountPaise,
      isGst: input.isGst,
      interState: input.interState,
      amountPaidPaise: input.amountPaidPaise,
    );
    final identity = services.identity;
    final now = DateTime.now();
    final date = input.date ?? now;
    final purchaseId = Ids.purchase();
    var purchaseNumber = '';

    await db.transaction(() async {
      final sequence = await db.nextSequence(
        key: InvoiceNumber.sequenceKey(
          documentType: 'purchase',
          deviceCode: identity.deviceCode,
          date: date,
        ),
        prefix: 'PUR',
      );
      purchaseNumber = InvoiceNumber.build(
        prefix: 'PUR',
        date: date,
        deviceCode: identity.deviceCode,
        sequence: sequence,
      );

      await db
          .into(db.purchases)
          .insert(
            PurchasesCompanion.insert(
              id: purchaseId,
              shopId: Value(identity.shopId),
              purchaseNumber: purchaseNumber,
              supplierId: Value(input.supplierId),
              storeId: Value(input.storeId),
              godownId: Value(input.godownId),
              supplierInvoiceNumber: Value(input.supplierInvoiceNumber),
              purchaseDate: date,
              subtotalPaise: Value(totals.subtotalPaise),
              discountPaise: Value(totals.discountPaise),
              taxableAmountPaise: Value(totals.taxableAmountPaise),
              cgstPaise: Value(totals.cgstPaise),
              sgstPaise: Value(totals.sgstPaise),
              igstPaise: Value(totals.igstPaise),
              grandTotalPaise: Value(totals.grandTotalPaise),
              amountPaidPaise: Value(totals.amountPaidPaise),
              balanceDuePaise: Value(totals.balanceDuePaise),
              paymentMethod: Value(input.paymentMethod),
              status: const Value(DocumentStatus.finalized),
              notes: Value(input.notes),
              attachmentRefsJson: Value(jsonEncode(input.attachments)),
              createdBy: Value(identity.displayName ?? 'Local user'),
              createdAt: now,
              updatedAt: now,
              deviceId: Value(identity.deviceId),
              syncStatus: const Value(SyncStatus.pending),
            ),
          );

      var order = 0;
      for (final line in totals.lines) {
        final itemId = Ids.purchaseItem();
        await db
            .into(db.purchaseItems)
            .insert(
              PurchaseItemsCompanion.insert(
                id: itemId,
                shopId: Value(identity.shopId),
                purchaseId: purchaseId,
                productId: line.input.productId ?? '',
                productName: line.input.name,
                sku: Value(line.input.sku),
                unit: Value(line.input.unit),
                quantityMilli: line.input.quantityMilli,
                unitPricePaise: line.input.unitPricePaise,
                discountPaise: Value(line.discountPaise),
                taxRateBps: Value(line.input.taxRateBps),
                taxAmountPaise: Value(line.taxPaise),
                lineTotalPaise: Value(line.totalPaise),
                sortOrder: Value(order++),
                createdAt: now,
                deviceId: Value(identity.deviceId),
                syncStatus: const Value(SyncStatus.pending),
              ),
            );
        if (line.input.productId != null) {
          await _receiveStock(
            productId: line.input.productId!,
            storeId: input.storeId,
            godownId: input.godownId,
            quantityMilli: line.input.quantityMilli,
            unitCostPaise: line.input.unitPricePaise,
            purchaseId: purchaseId,
            date: date,
          );
        }
        final item = await (db.select(
          db.purchaseItems,
        )..where((t) => t.id.equals(itemId))).getSingle();
        await services.outbox.enqueue(
          shopId: identity.shopId,
          deviceId: identity.deviceId,
          userId: identity.userId,
          entityType: 'purchase_item',
          collection: 'purchase_items',
          entityId: itemId,
          payload: Json.toCloud(item.toJson()),
          baseVersion: 0,
          priority: 75,
        );
      }

      if (totals.amountPaidPaise > 0) {
        await _paySupplier(
          supplierId: input.supplierId,
          amountPaise: totals.amountPaidPaise,
          method: input.paymentMethod,
          purchaseId: purchaseId,
          reference: purchaseNumber,
          date: date,
        );
      }

      final purchase = await purchaseById(purchaseId);
      await services.outbox.enqueue(
        shopId: identity.shopId,
        deviceId: identity.deviceId,
        userId: identity.userId,
        entityType: 'purchase',
        collection: 'purchases',
        entityId: purchaseId,
        payload: Json.toCloud(purchase!.toJson()),
        baseVersion: 0,
        priority: 65,
      );
      await audit.write(
        action: 'purchase_created',
        entityType: 'purchase',
        entityId: purchaseId,
        after: {
          'purchase_number': purchaseNumber,
          'grand_total_paise': totals.grandTotalPaise,
        },
      );
    });
    return purchaseId;
  }

  Future<void> _receiveStock({
    required String productId,
    required String? storeId,
    required String? godownId,
    required int quantityMilli,
    required int unitCostPaise,
    required String purchaseId,
    required DateTime date,
  }) async {
    final identity = services.identity;
    final existing =
        await (db.select(db.inventories)..where(
              (t) =>
                  t.productId.equals(productId) &
                  t.storeId.equalsNullable(storeId) &
                  t.godownId.equalsNullable(godownId),
            ))
            .getSingleOrNull();
    final newQuantity = (existing?.quantityMilli ?? 0) + quantityMilli;
    final inventoryId = Ids.inventoryKey(
      productId: productId,
      storeId: storeId,
      godownId: godownId,
    );
    await db
        .into(db.inventories)
        .insertOnConflictUpdate(
          InventoriesCompanion.insert(
            id: inventoryId,
            shopId: Value(identity.shopId),
            productId: productId,
            storeId: Value(storeId),
            godownId: Value(godownId),
            quantityMilli: Value(newQuantity),
            updatedAt: date,
            version: Value((existing?.version ?? 0) + 1),
            deviceId: Value(identity.deviceId),
            syncStatus: const Value(SyncStatus.pending),
          ),
        );

    final movementId = Ids.stockMovement();
    await db
        .into(db.stockMovements)
        .insert(
          StockMovementsCompanion.insert(
            id: movementId,
            shopId: Value(identity.shopId),
            productId: productId,
            storeId: Value(storeId),
            godownId: Value(godownId),
            type: MovementType.purchaseIn,
            quantityMilli: quantityMilli,
            unitCostPaise: Value(unitCostPaise),
            referenceType: const Value('purchase'),
            referenceId: Value(purchaseId),
            occurredAt: date,
            createdBy: Value(identity.displayName ?? 'Local user'),
            deviceId: Value(identity.deviceId),
            createdAt: date,
          ),
        );

    final inventory = await (db.select(
      db.inventories,
    )..where((t) => t.id.equals(inventoryId))).getSingle();
    final movement = await (db.select(
      db.stockMovements,
    )..where((t) => t.id.equals(movementId))).getSingle();
    await services.outbox.enqueue(
      shopId: identity.shopId,
      deviceId: identity.deviceId,
      userId: identity.userId,
      entityType: 'stock_movement',
      collection: 'stock_movements',
      entityId: movementId,
      payload: Json.toCloud(movement.toJson()),
      baseVersion: 0,
      priority: 45,
    );
    await services.outbox.enqueue(
      shopId: identity.shopId,
      deviceId: identity.deviceId,
      userId: identity.userId,
      entityType: 'inventory',
      collection: 'inventory',
      entityId: inventoryId,
      payload: Json.toCloud(inventory.toJson()),
      baseVersion: existing?.version ?? 0,
      priority: 35,
    );
  }

  Future<void> _paySupplier({
    required String? supplierId,
    required int amountPaise,
    required String method,
    required String purchaseId,
    required String reference,
    required DateTime date,
  }) async {
    final identity = services.identity;
    final paymentId = Ids.payment();
    final now = DateTime.now();
    String? supplierName;
    if (supplierId != null) {
      supplierName = (await (db.select(
        db.suppliers,
      )..where((t) => t.id.equals(supplierId))).getSingleOrNull())?.name;
    }
    await db
        .into(db.payments)
        .insert(
          PaymentsCompanion.insert(
            id: paymentId,
            shopId: Value(identity.shopId),
            partyType: const Value(PartyType.supplier),
            partyId: Value(supplierId),
            partyName: Value(supplierName ?? ''),
            direction: const Value(PaymentDirection.outgoing),
            amountPaise: amountPaise,
            method: Value(method),
            reference: Value(reference),
            paidAt: date,
            purchaseId: Value(purchaseId),
            idempotencyKey: 'purchase-initial:$purchaseId',
            createdBy: Value(identity.displayName ?? 'Local user'),
            createdAt: now,
            deviceId: Value(identity.deviceId),
          ),
        );
    final payment = await (db.select(
      db.payments,
    )..where((t) => t.id.equals(paymentId))).getSingle();
    await services.outbox.enqueue(
      shopId: identity.shopId,
      deviceId: identity.deviceId,
      userId: identity.userId,
      entityType: 'payment',
      collection: 'payments',
      entityId: paymentId,
      payload: Json.toCloud(payment.toJson()),
      baseVersion: 0,
      priority: 85,
    );
  }
}

final purchasesRepositoryProvider = Provider<PurchasesRepository>(
  (ref) => PurchasesRepository(ref.watch(servicesProvider)),
);

final purchasesStreamProvider =
    StreamProvider.family<List<PurchaseRow>, String>((ref, query) {
      return ref
          .watch(purchasesRepositoryProvider)
          .watchPurchases(query: query);
    });
