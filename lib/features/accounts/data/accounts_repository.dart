import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buildstock/core/audit/audit_writer.dart';
import 'package:buildstock/core/database/app_database.dart';
import 'package:buildstock/core/database/database_provider.dart';
import 'package:buildstock/core/domain/enums.dart';
import 'package:buildstock/core/errors/app_failure.dart';
import 'package:buildstock/core/utils/dates.dart';
import 'package:buildstock/core/utils/ids.dart';
import 'package:buildstock/core/utils/json.dart';

class ExpenseInput {
  const ExpenseInput({
    required this.amountPaise,
    required this.categoryName,
    this.categoryId,
    this.paidAt,
    this.method = PaymentMethods.cash,
    this.description = '',
    this.storeId,
    this.attachmentRef,
  });

  final int amountPaise;
  final String categoryName;
  final String? categoryId;
  final DateTime? paidAt;
  final String method;
  final String description;
  final String? storeId;
  final String? attachmentRef;
}

class DayBookEntry {
  const DayBookEntry({
    required this.date,
    required this.type,
    required this.reference,
    required this.description,
    required this.amountPaise,
    required this.isIncoming,
    this.partyName = '',
  });

  final DateTime date;
  final String type;
  final String reference;
  final String description;
  final int amountPaise;
  final bool isIncoming;
  final String partyName;
}

class AccountsRepository {
  AccountsRepository(this.services);

  final AppServices services;

  AppDatabase get db => services.db;
  AuditWriter get audit => AuditWriter(services);

  Stream<List<ExpenseRow>> watchExpenses({String query = ''}) {
    final statement = db.select(db.expenses)
      ..orderBy([(t) => OrderingTerm.desc(t.paidAt)]);
    if (query.trim().isNotEmpty) {
      final pattern = '%${query.trim()}%';
      statement.where(
        (t) => t.description.like(pattern) | t.categoryName.like(pattern),
      );
    }
    return statement.watch();
  }

  Stream<List<ExpenseCategoryRow>> watchCategories() => (db.select(
    db.expenseCategories,
  )..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<String> saveExpense(ExpenseInput input) async {
    if (input.amountPaise <= 0) {
      throw const ValidationFailure('Expense amount must be greater than zero');
    }
    final identity = services.identity;
    final now = DateTime.now();
    final id = Ids.expense();
    await db.transaction(() async {
      await db
          .into(db.expenses)
          .insert(
            ExpensesCompanion.insert(
              id: id,
              shopId: Value(identity.shopId),
              categoryId: Value(input.categoryId),
              categoryName: Value(input.categoryName),
              amountPaise: input.amountPaise,
              paidAt: input.paidAt ?? now,
              method: Value(input.method),
              description: Value(input.description),
              storeId: Value(input.storeId),
              attachmentRef: Value(input.attachmentRef),
              createdBy: Value(identity.displayName ?? 'Local user'),
              createdAt: now,
              updatedAt: now,
              deviceId: Value(identity.deviceId),
            ),
          );
      final row = await (db.select(
        db.expenses,
      )..where((t) => t.id.equals(id))).getSingle();
      await services.outbox.enqueue(
        shopId: identity.shopId,
        deviceId: identity.deviceId,
        userId: identity.userId,
        entityType: 'expense',
        collection: 'expenses',
        entityId: id,
        payload: Json.toCloud(row.toJson()),
        baseVersion: 0,
        priority: 55,
      );
      await audit.write(
        action: 'expense_recorded',
        entityType: 'expense',
        entityId: id,
        after: {
          'amount_paise': input.amountPaise,
          'category': input.categoryName,
        },
      );
    });
    return id;
  }

  Future<String> addCategory(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Category name is required');
    }
    final id = Ids.expenseCategory();
    final now = DateTime.now();
    await db
        .into(db.expenseCategories)
        .insert(
          ExpenseCategoriesCompanion.insert(
            id: id,
            shopId: Value(services.identity.shopId),
            name: trimmed,
            updatedAt: now,
          ),
        );
    final row = await (db.select(
      db.expenseCategories,
    )..where((t) => t.id.equals(id))).getSingle();
    await services.outbox.enqueue(
      shopId: services.identity.shopId,
      deviceId: services.identity.deviceId,
      userId: services.identity.userId,
      entityType: 'expense_category',
      collection: 'expense_categories',
      entityId: id,
      payload: Json.toCloud(row.toJson()),
      baseVersion: 0,
      priority: 6,
    );
    return id;
  }

  Stream<List<PaymentRow>> watchPayments() {
    return (db.select(db.payments)
          ..orderBy([(t) => OrderingTerm.desc(t.paidAt)])
          ..limit(300))
        .watch();
  }

  Stream<List<DayBookEntry>> watchDayBook({
    required DateTime from,
    required DateTime to,
  }) {
    return db
        .customSelect(
          '''
          SELECT invoice_date AS entry_date, 'Sale' AS entry_type,
            invoice_number AS reference, buyer_snapshot_json AS description,
            grand_total_paise AS amount, 1 AS incoming
          FROM sales
          WHERE document_type = 'invoice' AND document_status = 'finalized'
            AND invoice_date BETWEEN ? AND ?
          UNION ALL
          SELECT purchase_date, 'Purchase', purchase_number, supplier_invoice_number,
            grand_total_paise, 0
          FROM purchases WHERE status = 'finalized'
            AND purchase_date BETWEEN ? AND ?
          UNION ALL
          SELECT paid_at, CASE WHEN direction = 'in' THEN 'Payment in' ELSE 'Payment out' END,
            reference, party_name, amount_paise, CASE WHEN direction = 'in' THEN 1 ELSE 0 END
          FROM payments WHERE paid_at BETWEEN ? AND ?
          UNION ALL
          SELECT paid_at, 'Expense', category_name, description, amount_paise, 0
          FROM expenses WHERE paid_at BETWEEN ? AND ?
          ORDER BY entry_date DESC
          ''',
          variables: [
            Variable(from),
            Variable(to),
            Variable(from),
            Variable(to),
            Variable(from),
            Variable(to),
            Variable(from),
            Variable(to),
          ],
          readsFrom: {db.sales, db.purchases, db.payments, db.expenses},
        )
        .watch()
        .map(
          (rows) => rows.map((row) {
            return DayBookEntry(
              date: DateTime.fromMillisecondsSinceEpoch(
                row.read<int>('entry_date') * 1000,
              ),
              type: row.read<String>('entry_type'),
              reference: row.read<String?>('reference') ?? '',
              description: row.read<String?>('description') ?? '',
              amountPaise: row.read<int>('amount'),
              isIncoming: row.read<int>('incoming') == 1,
            );
          }).toList(),
        );
  }

  Future<int> cashInHand() async {
    final row = await db
        .customSelect(
          '''
          SELECT
            (SELECT COALESCE(SUM(amount_paise), 0) FROM payments
              WHERE method = 'cash' AND direction = 'in') -
            (SELECT COALESCE(SUM(amount_paise), 0) FROM payments
              WHERE method = 'cash' AND direction = 'out') -
            (SELECT COALESCE(SUM(amount_paise), 0) FROM expenses
              WHERE method = 'cash') AS cash
          ''',
          readsFrom: {db.payments, db.expenses},
        )
        .getSingle();
    return row.read<int>('cash');
  }
}

final accountsRepositoryProvider = Provider<AccountsRepository>(
  (ref) => AccountsRepository(ref.watch(servicesProvider)),
);

final expensesStreamProvider = StreamProvider.family<List<ExpenseRow>, String>((
  ref,
  query,
) {
  return ref.watch(accountsRepositoryProvider).watchExpenses(query: query);
});

final expenseCategoriesProvider = StreamProvider<List<ExpenseCategoryRow>>(
  (ref) => ref.watch(accountsRepositoryProvider).watchCategories(),
);

final paymentsStreamProvider = StreamProvider<List<PaymentRow>>(
  (ref) => ref.watch(accountsRepositoryProvider).watchPayments(),
);

final dayBookProvider =
    StreamProvider.family<List<DayBookEntry>, DateTimeRange>((ref, range) {
      return ref
          .watch(accountsRepositoryProvider)
          .watchDayBook(
            from: AppDate.startOfDay(range.start),
            to: AppDate.endOfDay(range.end),
          );
    });
