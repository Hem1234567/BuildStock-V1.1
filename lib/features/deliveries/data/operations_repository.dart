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

class StoreInput {
  const StoreInput({
    required this.name,
    required this.code,
    this.phone = '',
    this.address = '',
    this.city = '',
    this.state = 'Tamil Nadu',
    this.pinCode = '',
    this.notes = '',
    this.managerId,
  });

  final String name;
  final String code;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final String notes;
  final String? managerId;
}

class GodownInput {
  const GodownInput({
    required this.storeId,
    required this.name,
    required this.code,
    this.address = '',
    this.contactPerson = '',
    this.phone = '',
    this.capacity = '',
    this.notes = '',
  });

  final String storeId;
  final String name;
  final String code;
  final String address;
  final String contactPerson;
  final String phone;
  final String capacity;
  final String notes;
}

class OperationsRepository {
  OperationsRepository(this.services);

  final AppServices services;

  AppDatabase get db => services.db;
  AuditWriter get audit => AuditWriter(services);

  // ------------------------------------------------------------------ stores

  Stream<List<StoreRow>> watchStores() =>
      (db.select(db.stores)
            ..where((t) => t.archived.equals(false))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  Stream<List<GodownRow>> watchGodowns({String? storeId}) {
    final statement = db.select(db.godowns)
      ..where((t) => t.archived.equals(false));
    if (storeId != null) {
      statement.where((t) => t.storeId.equals(storeId));
    }
    statement.orderBy([(t) => OrderingTerm.asc(t.name)]);
    return statement.watch();
  }

  Future<String> saveStore(StoreInput input, {String? existingId}) async {
    if (input.name.trim().isEmpty) {
      throw const ValidationFailure('Store name is required');
    }
    final existing = existingId == null
        ? null
        : await (db.select(
            db.stores,
          )..where((t) => t.id.equals(existingId))).getSingleOrNull();
    final id = existing?.id ?? Ids.store();
    final now = DateTime.now();
    final identity = services.identity;
    await db.transaction(() async {
      await db
          .into(db.stores)
          .insertOnConflictUpdate(
            StoresCompanion.insert(
              id: id,
              shopId: Value(identity.shopId),
              name: input.name.trim(),
              code: input.code.trim(),
              managerId: Value(input.managerId),
              phone: Value(input.phone),
              address: Value(input.address),
              city: Value(input.city),
              state: Value(input.state),
              pinCode: Value(input.pinCode),
              notes: Value(input.notes),
              createdAt: existing?.createdAt ?? now,
              updatedAt: now,
              version: Value((existing?.version ?? 0) + 1),
              deviceId: Value(identity.deviceId),
            ),
          );
      final row = await (db.select(
        db.stores,
      )..where((t) => t.id.equals(id))).getSingle();
      await services.outbox.enqueue(
        shopId: identity.shopId,
        deviceId: identity.deviceId,
        userId: identity.userId,
        entityType: 'store',
        collection: 'stores',
        entityId: id,
        payload: Json.toCloud(row.toJson()),
        baseVersion: existing?.version ?? 0,
        priority: 8,
      );
      await audit.write(
        action: existing == null ? 'store_created' : 'store_updated',
        entityType: 'store',
        entityId: id,
        before: existing?.toJson(),
        after: row.toJson(),
      );
    });
    return id;
  }

  Future<String> saveGodown(GodownInput input, {String? existingId}) async {
    if (input.name.trim().isEmpty) {
      throw const ValidationFailure('Godown name is required');
    }
    final existing = existingId == null
        ? null
        : await (db.select(
            db.godowns,
          )..where((t) => t.id.equals(existingId))).getSingleOrNull();
    final id = existing?.id ?? Ids.godown();
    final now = DateTime.now();
    final identity = services.identity;
    await db.transaction(() async {
      await db
          .into(db.godowns)
          .insertOnConflictUpdate(
            GodownsCompanion.insert(
              id: id,
              shopId: Value(identity.shopId),
              storeId: input.storeId,
              name: input.name.trim(),
              code: input.code.trim(),
              address: Value(input.address),
              contactPerson: Value(input.contactPerson),
              phone: Value(input.phone),
              capacity: Value(input.capacity),
              notes: Value(input.notes),
              createdAt: existing?.createdAt ?? now,
              updatedAt: now,
              version: Value((existing?.version ?? 0) + 1),
              deviceId: Value(identity.deviceId),
            ),
          );
      final row = await (db.select(
        db.godowns,
      )..where((t) => t.id.equals(id))).getSingle();
      await services.outbox.enqueue(
        shopId: identity.shopId,
        deviceId: identity.deviceId,
        userId: identity.userId,
        entityType: 'godown',
        collection: 'godowns',
        entityId: id,
        payload: Json.toCloud(row.toJson()),
        baseVersion: existing?.version ?? 0,
        priority: 8,
      );
    });
    return id;
  }

  // -------------------------------------------------------------- deliveries

  Stream<List<DeliveryRow>> watchDeliveries({
    String status = '',
    String driverId = '',
    String query = '',
  }) {
    final statement = db.select(db.deliveries)
      ..orderBy([(t) => OrderingTerm.desc(t.deliveryDate)]);
    if (status.isNotEmpty) statement.where((t) => t.status.equals(status));
    if (driverId.isNotEmpty) {
      statement.where((t) => t.driverId.equals(driverId));
    }
    if (query.trim().isNotEmpty) {
      final pattern = '%${query.trim()}%';
      statement.where(
        (t) =>
            t.deliveryNumber.like(pattern) |
            t.customerName.like(pattern) |
            t.invoiceNumber.like(pattern),
      );
    }
    return statement.watch();
  }

  Future<List<DeliveryItemRow>> deliveryItems(String deliveryId) {
    return (db.select(
      db.deliveryItems,
    )..where((t) => t.deliveryId.equals(deliveryId))).get();
  }

  Future<String> createDeliveryFromInvoice({
    required String invoiceId,
    String? driverId,
    String? vehicleId,
    String? address,
    DateTime? date,
    int deliveryChargePaise = 0,
    String notes = '',
  }) async {
    final sale = await (db.select(
      db.sales,
    )..where((t) => t.id.equals(invoiceId))).getSingleOrNull();
    if (sale == null || sale.documentType != DocumentType.invoice) {
      throw const AppFailure(FailureCode.notFound, 'Invoice not found');
    }
    if (sale.documentStatus != DocumentStatus.finalized) {
      throw const AppFailure(
        FailureCode.validation,
        'Only finalized invoices can have deliveries',
      );
    }
    final saleItems = await (db.select(
      db.saleItems,
    )..where((t) => t.saleId.equals(invoiceId))).get();
    final identity = services.identity;
    final now = DateTime.now();
    final deliveryId = Ids.delivery();
    final buyer = Json.decodeMap(sale.buyerSnapshotJson);

    String? driverName;
    if (driverId != null) {
      driverName = (await (db.select(
        db.drivers,
      )..where((t) => t.id.equals(driverId))).getSingleOrNull())?.fullName;
    }
    String? vehicleNumber;
    if (vehicleId != null) {
      vehicleNumber =
          (await (db.select(
                db.vehicles,
              )..where((t) => t.id.equals(vehicleId))).getSingleOrNull())
              ?.registrationNumber;
    }

    await db.transaction(() async {
      final sequence = await db.nextSequence(
        key: InvoiceNumber.sequenceKey(
          documentType: 'delivery',
          deviceCode: identity.deviceCode,
          date: now,
        ),
        prefix: 'DLV',
      );
      final number = InvoiceNumber.build(
        prefix: 'DLV',
        date: now,
        deviceCode: identity.deviceCode,
        sequence: sequence,
      );
      await db
          .into(db.deliveries)
          .insert(
            DeliveriesCompanion.insert(
              id: deliveryId,
              shopId: Value(identity.shopId),
              deliveryNumber: number,
              invoiceId: Value(invoiceId),
              invoiceNumber: Value(sale.invoiceNumber),
              customerId: Value(sale.customerId),
              customerName: Value(buyer['name']?.toString() ?? ''),
              storeId: Value(sale.storeId),
              godownId: Value(sale.godownId),
              driverId: Value(driverId),
              driverName: Value(driverName ?? ''),
              vehicleId: Value(vehicleId),
              vehicleNumber: Value(vehicleNumber ?? ''),
              deliveryAddress: Value(
                address?.trim().isNotEmpty == true
                    ? address!.trim()
                    : buyer['address']?.toString() ?? '',
              ),
              deliveryDate: date ?? now,
              deliveryChargePaise: Value(deliveryChargePaise),
              status: Value(
                driverId == null
                    ? DeliveryStatus.pending
                    : DeliveryStatus.assigned,
              ),
              notes: Value(notes),
              createdBy: Value(identity.displayName ?? 'Local user'),
              createdAt: now,
              updatedAt: now,
              deviceId: Value(identity.deviceId),
            ),
          );
      for (final item in saleItems) {
        final itemId = Ids.deliveryItem();
        await db
            .into(db.deliveryItems)
            .insert(
              DeliveryItemsCompanion.insert(
                id: itemId,
                shopId: Value(identity.shopId),
                deliveryId: deliveryId,
                productId: item.productId ?? '',
                productName: item.productName,
                quantityMilli: item.quantityMilli,
                updatedAt: now,
                deviceId: Value(identity.deviceId),
              ),
            );
      }
      final delivery = await (db.select(
        db.deliveries,
      )..where((t) => t.id.equals(deliveryId))).getSingle();
      await services.outbox.enqueue(
        shopId: identity.shopId,
        deviceId: identity.deviceId,
        userId: identity.userId,
        entityType: 'delivery',
        collection: 'deliveries',
        entityId: deliveryId,
        payload: Json.toCloud(delivery.toJson()),
        baseVersion: 0,
        priority: 90,
      );
      final items = await deliveryItems(deliveryId);
      for (final item in items) {
        await services.outbox.enqueue(
          shopId: identity.shopId,
          deviceId: identity.deviceId,
          userId: identity.userId,
          entityType: 'delivery_item',
          collection: 'delivery_items',
          entityId: item.id,
          payload: Json.toCloud(item.toJson()),
          baseVersion: 0,
          priority: 91,
        );
      }
      await audit.write(
        action: 'delivery_created',
        entityType: 'delivery',
        entityId: deliveryId,
        after: {'number': number, 'invoice': sale.invoiceNumber},
      );
    });
    return deliveryId;
  }

  Future<void> assignDelivery({
    required String deliveryId,
    required String driverId,
    String? vehicleId,
  }) async {
    final delivery = await (db.select(
      db.deliveries,
    )..where((t) => t.id.equals(deliveryId))).getSingleOrNull();
    if (delivery == null) {
      throw const AppFailure(FailureCode.notFound, 'Delivery not found');
    }
    final driver = await (db.select(
      db.drivers,
    )..where((t) => t.id.equals(driverId))).getSingleOrNull();
    if (driver == null) {
      throw const AppFailure(FailureCode.notFound, 'Driver not found');
    }
    String? vehicleNumber;
    if (vehicleId != null) {
      vehicleNumber =
          (await (db.select(
                db.vehicles,
              )..where((t) => t.id.equals(vehicleId))).getSingleOrNull())
              ?.registrationNumber;
    }
    final identity = services.identity;
    final now = DateTime.now();
    await db.transaction(() async {
      await (db.update(
        db.deliveries,
      )..where((t) => t.id.equals(deliveryId))).write(
        DeliveriesCompanion(
          driverId: Value(driverId),
          driverName: Value(driver.fullName),
          vehicleId: Value(vehicleId ?? delivery.vehicleId),
          vehicleNumber: Value(vehicleNumber ?? delivery.vehicleNumber),
          status: const Value(DeliveryStatus.assigned),
          updatedAt: Value(now),
          version: Value(delivery.version + 1),
          syncStatus: const Value(SyncStatus.pending),
          deviceId: Value(identity.deviceId),
        ),
      );
      final updated = await (db.select(
        db.deliveries,
      )..where((t) => t.id.equals(deliveryId))).getSingle();
      await services.outbox.enqueue(
        shopId: identity.shopId,
        deviceId: identity.deviceId,
        userId: identity.userId,
        entityType: 'delivery',
        collection: 'deliveries',
        entityId: deliveryId,
        payload: Json.toCloud(updated.toJson()),
        baseVersion: delivery.version,
        priority: 90,
      );
      await audit.write(
        action: 'delivery_driver_assigned',
        entityType: 'delivery',
        entityId: deliveryId,
        after: {'driver_id': driverId},
      );
    });
  }

  Future<void> updateDeliveryStatus({
    required String deliveryId,
    required String status,
    Map<String, int> deliveredQuantities = const {},
    String note = '',
  }) async {
    final delivery = await (db.select(
      db.deliveries,
    )..where((t) => t.id.equals(deliveryId))).getSingleOrNull();
    if (delivery == null) {
      throw const AppFailure(FailureCode.notFound, 'Delivery not found');
    }
    final now = DateTime.now();
    final identity = services.identity;
    await db.transaction(() async {
      await (db.update(
        db.deliveries,
      )..where((t) => t.id.equals(deliveryId))).write(
        DeliveriesCompanion(
          status: Value(status),
          actualDeliveryTime: Value(
            status == DeliveryStatus.delivered ||
                    status == DeliveryStatus.partiallyDelivered
                ? now
                : null,
          ),
          notes: Value(
            note.isEmpty ? delivery.notes : '${delivery.notes}\n$note'.trim(),
          ),
          updatedAt: Value(now),
          version: Value(delivery.version + 1),
          syncStatus: const Value(SyncStatus.pending),
        ),
      );
      if (status == DeliveryStatus.delivered ||
          status == DeliveryStatus.partiallyDelivered) {
        final items = await deliveryItems(deliveryId);
        for (final item in items) {
          final delivered = status == DeliveryStatus.delivered
              ? item.quantityMilli
              : (deliveredQuantities[item.id] ?? item.deliveredMilli);
          await (db.update(
            db.deliveryItems,
          )..where((t) => t.id.equals(item.id))).write(
            DeliveryItemsCompanion(
              deliveredMilli: Value(delivered.clamp(0, item.quantityMilli)),
              updatedAt: Value(now),
              version: Value(item.version + 1),
              syncStatus: const Value(SyncStatus.pending),
            ),
          );
          final updated = await (db.select(
            db.deliveryItems,
          )..where((t) => t.id.equals(item.id))).getSingle();
          await services.outbox.enqueue(
            shopId: identity.shopId,
            deviceId: identity.deviceId,
            userId: identity.userId,
            entityType: 'delivery_item',
            collection: 'delivery_items',
            entityId: item.id,
            payload: Json.toCloud(updated.toJson()),
            baseVersion: item.version,
            priority: 91,
          );
        }
      }
      final updated = await (db.select(
        db.deliveries,
      )..where((t) => t.id.equals(deliveryId))).getSingle();
      await services.outbox.enqueue(
        shopId: identity.shopId,
        deviceId: identity.deviceId,
        userId: identity.userId,
        entityType: 'delivery',
        collection: 'deliveries',
        entityId: deliveryId,
        payload: Json.toCloud(updated.toJson()),
        baseVersion: delivery.version,
        priority: 90,
      );
      await audit.write(
        action: 'delivery_status_changed',
        entityType: 'delivery',
        entityId: deliveryId,
        before: {'status': delivery.status},
        after: {'status': status},
      );
    });
  }

  Future<void> addDeliveryProof({
    required String deliveryId,
    required String imageRef,
    String note = '',
  }) async {
    final identity = services.identity;
    final now = DateTime.now();
    final proofId = Ids.deliveryProof();
    await db.transaction(() async {
      await db
          .into(db.deliveryProofs)
          .insert(
            DeliveryProofsCompanion.insert(
              id: proofId,
              shopId: Value(identity.shopId),
              deliveryId: deliveryId,
              imageRef: imageRef,
              capturedAt: now,
              capturedBy: Value(identity.displayName ?? 'Local user'),
              note: Value(note),
              createdAt: now,
              deviceId: Value(identity.deviceId),
            ),
          );
      final delivery = await (db.select(
        db.deliveries,
      )..where((t) => t.id.equals(deliveryId))).getSingleOrNull();
      if (delivery != null) {
        final refs = Json.decodeList(delivery.proofImageRefs)..add(imageRef);
        await (db.update(
          db.deliveries,
        )..where((t) => t.id.equals(deliveryId))).write(
          DeliveriesCompanion(
            proofImageRefs: Value(jsonEncode(refs)),
            updatedAt: Value(now),
            version: Value(delivery.version + 1),
            syncStatus: const Value(SyncStatus.pending),
          ),
        );
        final updated = await (db.select(
          db.deliveries,
        )..where((t) => t.id.equals(deliveryId))).getSingle();
        await services.outbox.enqueue(
          shopId: identity.shopId,
          deviceId: identity.deviceId,
          userId: identity.userId,
          entityType: 'delivery',
          collection: 'deliveries',
          entityId: deliveryId,
          payload: Json.toCloud(updated.toJson()),
          baseVersion: delivery.version,
          priority: 90,
        );
      }
      final proof = await (db.select(
        db.deliveryProofs,
      )..where((t) => t.id.equals(proofId))).getSingle();
      await services.outbox.enqueue(
        shopId: identity.shopId,
        deviceId: identity.deviceId,
        userId: identity.userId,
        entityType: 'delivery_proof',
        collection: 'delivery_proofs',
        entityId: proofId,
        payload: Json.toCloud(proof.toJson()),
        baseVersion: 0,
        priority: 92,
      );
    });
  }
}

final operationsRepositoryProvider = Provider<OperationsRepository>(
  (ref) => OperationsRepository(ref.watch(servicesProvider)),
);

final storesStreamProvider = StreamProvider<List<StoreRow>>(
  (ref) => ref.watch(operationsRepositoryProvider).watchStores(),
);

final godownsStreamProvider = StreamProvider.family<List<GodownRow>, String?>((
  ref,
  storeId,
) {
  return ref.watch(operationsRepositoryProvider).watchGodowns(storeId: storeId);
});

final deliveriesStreamProvider =
    StreamProvider.family<List<DeliveryRow>, String>((ref, status) {
      return ref
          .watch(operationsRepositoryProvider)
          .watchDeliveries(status: status);
    });
