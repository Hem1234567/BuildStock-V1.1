import 'dart:async';

import 'package:drift/drift.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    BusinessProfiles,
    Users,
    Devices,
    AppSettings,
    Stores,
    Godowns,
    Categories,
    Brands,
    Units,
    PriceLists,
    Products,
    Inventories,
    StockMovements,
    StockTransfers,
    StockTransferItems,
    Customers,
    Suppliers,
    StaffMembers,
    Drivers,
    Vehicles,
    AttendanceRecords,
    SalaryRecords,
    SalaryPayments,
    Sales,
    SaleItems,
    Purchases,
    PurchaseItems,
    Payments,
    ExpenseCategories,
    Expenses,
    Returns,
    ReturnItems,
    Orders,
    Deliveries,
    DeliveryItems,
    DeliveryProofs,
    ImageMetadata,
    AuditLogs,
    SyncQueue,
    SyncMetadata,
    NumberSequences,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes();
      await _seedConfiguration();
    },
    onUpgrade: (m, from, to) async {
      // Every schema change adds a numbered migration step. Never rewrite an
      // existing step; append a new one so installed devices upgrade safely.
      for (var version = from; version < to; version++) {
        await _runMigration(m, version);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
      if (details.wasCreated) {
        // Seeding happens in onCreate; this branch only marks the schema.
      }
    },
  );

  /// Sequential migrations. Version 1 is the initial schema; future releases
  /// append `if (version == 1) { ... }` blocks here.
  Future<void> _runMigration(Migrator m, int version) async {
    switch (version) {
      case 1:
        break;
    }
  }

  Future<void> _createIndexes() async {
    const statements = <String>[
      'CREATE INDEX IF NOT EXISTS idx_products_name ON products(name)',
      'CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku)',
      'CREATE INDEX IF NOT EXISTS idx_products_barcode ON products(barcode)',
      'CREATE INDEX IF NOT EXISTS idx_customers_phone ON customers(phone)',
      'CREATE INDEX IF NOT EXISTS idx_customers_name ON customers(name)',
      'CREATE INDEX IF NOT EXISTS idx_suppliers_phone ON suppliers(phone)',
      'CREATE INDEX IF NOT EXISTS idx_suppliers_name ON suppliers(name)',
      'CREATE INDEX IF NOT EXISTS idx_sales_number ON sales(invoice_number)',
      'CREATE INDEX IF NOT EXISTS idx_sales_date ON sales(invoice_date)',
      'CREATE INDEX IF NOT EXISTS idx_sales_customer ON sales(customer_id)',
      'CREATE INDEX IF NOT EXISTS idx_sale_items_sale ON sale_items(sale_id)',
      'CREATE INDEX IF NOT EXISTS idx_purchases_supplier ON purchases(supplier_id)',
      'CREATE INDEX IF NOT EXISTS idx_purchase_items_purchase ON purchase_items(purchase_id)',
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_inventory_unique ON inventories(product_id, IFNULL(store_id, \'\'), IFNULL(godown_id, \'\'))',
      'CREATE INDEX IF NOT EXISTS idx_movements_product ON stock_movements(product_id, occurred_at)',
      'CREATE INDEX IF NOT EXISTS idx_movements_reference ON stock_movements(reference_id)',
      'CREATE INDEX IF NOT EXISTS idx_payments_party ON payments(party_id, paid_at)',
      'CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(paid_at)',
      'CREATE INDEX IF NOT EXISTS idx_deliveries_status ON deliveries(status, delivery_date)',
      'CREATE INDEX IF NOT EXISTS idx_deliveries_invoice ON deliveries(invoice_id)',
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_attendance_unique ON attendance_records(staff_id, date)',
      'CREATE INDEX IF NOT EXISTS idx_staff_name ON staff_members(full_name)',
      'CREATE INDEX IF NOT EXISTS idx_drivers_name ON drivers(full_name)',
      'CREATE INDEX IF NOT EXISTS idx_queue_status ON sync_queue(status, next_attempt_at)',
      'CREATE INDEX IF NOT EXISTS idx_audit_created ON audit_logs(created_at)',
    ];
    for (final statement in statements) {
      await customStatement(statement);
    }
  }

  /// Configuration only — no products, customers, invoices or other business
  /// records are seeded. Units, expense categories and the product categories
  /// named by the business are editable defaults.
  Future<void> _seedConfiguration() async {
    final now = DateTime.now();
    for (final unit in _seedUnits) {
      await into(units).insert(
        UnitsCompanion.insert(
          id: unit.$1,
          name: unit.$2,
          symbol: unit.$3,
          createdAt: now,
          updatedAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
    for (final category in _seedCategories) {
      await into(categories).insert(
        CategoriesCompanion.insert(
          id: category.$1,
          name: category.$2,
          sortOrder: Value(category.$3),
          createdAt: now,
          updatedAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
    for (final expense in _seedExpenseCategories) {
      await into(expenseCategories).insert(
        ExpenseCategoriesCompanion.insert(
          id: expense.$1,
          name: expense.$2,
          isSystem: const Value(true),
          updatedAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  static const List<(String, String, String)> _seedUnits = [
    ('unt_nos', 'Numbers', 'Nos'),
    ('unt_bag', 'Bag', 'Bag'),
    ('unt_ton', 'Tonne', 'Ton'),
    ('unt_cft', 'Cubic Feet', 'Cft'),
    ('unt_cum', 'Cubic Metre', 'Cum'),
    ('unt_kg', 'Kilogram', 'Kg'),
    ('unt_load', 'Load', 'Load'),
    ('unt_litre', 'Litre', 'Ltr'),
    ('unt_sqft', 'Square Feet', 'Sqft'),
    ('unt_piece', 'Piece', 'Pc'),
  ];

  static const List<(String, String, int)> _seedCategories = [
    ('cat_cement', 'Cement', 1),
    ('cat_msand', 'M-Sand', 2),
    ('cat_sand', 'Sand', 3),
    ('cat_jelly', 'Jelly', 4),
    ('cat_bluemetal', 'Blue Metal', 5),
    ('cat_bricks', 'Bricks', 6),
    ('cat_aac', 'AAC Blocks', 7),
    ('cat_other', 'Other Building Materials', 8),
  ];

  static const List<(String, String)> _seedExpenseCategories = [
    ('exc_rent', 'Rent'),
    ('exc_electricity', 'Electricity'),
    ('exc_transport', 'Transport'),
    ('exc_fuel', 'Vehicle Fuel'),
    ('exc_vehicle_service', 'Vehicle Maintenance'),
    ('exc_staff_salary', 'Staff Salary'),
    ('exc_driver_salary', 'Driver Salary'),
    ('exc_telephone', 'Telephone'),
    ('exc_office', 'Office Expenses'),
    ('exc_loading', 'Loading and Unloading'),
    ('exc_other', 'Other'),
  ];

  /// Atomically obtains the next document sequence for a device/year.
  Future<int> nextSequence({
    required String key,
    required String prefix,
  }) async {
    return transaction(() async {
      final existing = await (select(
        numberSequences,
      )..where((t) => t.id.equals(key))).getSingleOrNull();
      final next = existing?.nextValue ?? 1;
      if (existing == null) {
        await into(numberSequences).insert(
          NumberSequencesCompanion.insert(
            id: key,
            prefix: Value(prefix),
            nextValue: Value(next + 1),
            updatedAt: DateTime.now(),
          ),
        );
      } else {
        await (update(numberSequences)..where((t) => t.id.equals(key))).write(
          NumberSequencesCompanion(
            nextValue: Value(next + 1),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
      return next;
    });
  }

  Future<void> setSetting(String key, String value) async {
    await into(appSettings).insert(
      AppSettingsCompanion.insert(
        key: key,
        value: Value(value),
        updatedAt: DateTime.now(),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<String?> getSetting(String key) async {
    final row = await (select(
      appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
