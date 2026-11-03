import 'package:drift/drift.dart';

/// Local schema for BuildStock.
///
/// Money is stored as integer **paise** (`*_paise`).
/// Quantities are stored as integer **milli-units** (`*_milli`), i.e. 1.250 = 1250.
/// Tax rates are stored as **basis points** (`*_bps`), i.e. 18% = 1800.
/// Nothing financial is stored as a floating point number.

// ---------------------------------------------------------------------------
// Configuration and identity
// ---------------------------------------------------------------------------

@DataClassName('BusinessProfileRow')
class BusinessProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get ownerName => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get altPhone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get area => text().withDefault(const Constant(''))();
  TextColumn get city => text().withDefault(const Constant(''))();
  TextColumn get district => text().withDefault(const Constant(''))();
  TextColumn get state => text().withDefault(const Constant('Tamil Nadu'))();
  TextColumn get pinCode => text().withDefault(const Constant(''))();
  TextColumn get gstin => text().withDefault(const Constant(''))();
  TextColumn get pan => text().withDefault(const Constant(''))();
  TextColumn get stateCode => text().withDefault(const Constant('33'))();
  TextColumn get logoRef => text().nullable()();
  TextColumn get signatureRef => text().nullable()();
  TextColumn get stampRef => text().nullable()();
  TextColumn get upiId => text().withDefault(const Constant(''))();
  TextColumn get upiPayeeName => text().withDefault(const Constant(''))();
  TextColumn get bankName => text().withDefault(const Constant(''))();
  TextColumn get bankAccountNumber => text().withDefault(const Constant(''))();
  TextColumn get ifsc => text().withDefault(const Constant(''))();
  DateTimeColumn get openingDate => dateTime().nullable()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get invoicePrefix => text().withDefault(const Constant('VBA'))();
  IntColumn get templateVersion => integer().withDefault(const Constant(1))();
  BoolColumn get isGstRegistered =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UserRow')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get displayName => text()();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get role => text().withDefault(const Constant('staff'))();
  TextColumn get permissionsJson => text().withDefault(const Constant('[]'))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DeviceRow')
class Devices extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  TextColumn get platform => text().withDefault(const Constant('android'))();
  TextColumn get appVersion => text().withDefault(const Constant(''))();
  TextColumn get deviceCode => text().withDefault(const Constant('DEVICE01'))();
  DateTimeColumn get registeredAt => dateTime()();
  DateTimeColumn get lastSeenAt => dateTime()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AppSettingRow')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

// ---------------------------------------------------------------------------
// Stores, godowns and catalogue
// ---------------------------------------------------------------------------

@DataClassName('StoreRow')
class Stores extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  TextColumn get code => text()();
  TextColumn get managerId => text().nullable()();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get altPhone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get city => text().withDefault(const Constant(''))();
  TextColumn get state => text().withDefault(const Constant('Tamil Nadu'))();
  TextColumn get pinCode => text().withDefault(const Constant(''))();
  DateTimeColumn get openingDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  TextColumn get lastOperationId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GodownRow')
class Godowns extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get storeId => text().references(Stores, #id)();
  TextColumn get name => text()();
  TextColumn get code => text()();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get contactPerson => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get capacity => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BrandRow')
class Brands extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UnitRow')
class Units extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  TextColumn get symbol => text()();
  IntColumn get decimalPlaces => integer().withDefault(const Constant(3))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PriceListRow')
class PriceLists extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  TextColumn get type => text().withDefault(const Constant('retail'))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ProductRow')
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  TextColumn get sku => text().withDefault(const Constant(''))();
  TextColumn get barcode => text().withDefault(const Constant(''))();
  TextColumn get categoryId => text().nullable()();
  TextColumn get brandId => text().nullable()();
  TextColumn get unitId => text().nullable()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get hsnCode => text().withDefault(const Constant(''))();
  IntColumn get gstRateBps => integer().withDefault(const Constant(0))();
  IntColumn get purchasePricePaise =>
      integer().withDefault(const Constant(0))();
  IntColumn get retailPricePaise => integer().withDefault(const Constant(0))();
  IntColumn get wholesalePricePaise =>
      integer().withDefault(const Constant(0))();
  IntColumn get minStockMilli => integer().withDefault(const Constant(0))();
  TextColumn get mainImageRef => text().nullable()();
  TextColumn get galleryJson => text().withDefault(const Constant('[]'))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  TextColumn get lastOperationId => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Inventory ledger
// ---------------------------------------------------------------------------

@DataClassName('InventoryRow')
class Inventories extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get storeId => text().nullable()();
  TextColumn get godownId => text().nullable()();
  IntColumn get quantityMilli => integer().withDefault(const Constant(0))();
  IntColumn get reservedMilli => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StockMovementRow')
class StockMovements extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get storeId => text().nullable()();
  TextColumn get godownId => text().nullable()();
  TextColumn get type => text()();
  IntColumn get quantityMilli => integer()();
  IntColumn get unitCostPaise => integer().withDefault(const Constant(0))();
  TextColumn get referenceType => text().withDefault(const Constant(''))();
  TextColumn get referenceId => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get createdBy => text().withDefault(const Constant(''))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StockTransferRow')
class StockTransfers extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get transferNumber => text()();
  TextColumn get sourceStoreId => text().nullable()();
  TextColumn get sourceGodownId => text().nullable()();
  TextColumn get destinationStoreId => text().nullable()();
  TextColumn get destinationGodownId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get createdBy => text().withDefault(const Constant(''))();
  TextColumn get receivedBy => text().nullable()();
  DateTimeColumn get receivedAt => dateTime().nullable()();
  DateTimeColumn get transferDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StockTransferItemRow')
class StockTransferItems extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get transferId => text().references(StockTransfers, #id)();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get quantityMilli => integer()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Parties
// ---------------------------------------------------------------------------

@DataClassName('CustomerRow')
class Customers extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  TextColumn get businessName => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get altPhone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get billingAddress => text().withDefault(const Constant(''))();
  TextColumn get deliveryAddress => text().withDefault(const Constant(''))();
  TextColumn get city => text().withDefault(const Constant(''))();
  TextColumn get state => text().withDefault(const Constant('Tamil Nadu'))();
  TextColumn get pinCode => text().withDefault(const Constant(''))();
  TextColumn get gstin => text().withDefault(const Constant(''))();
  TextColumn get pan => text().withDefault(const Constant(''))();
  TextColumn get customerType => text().withDefault(const Constant('retail'))();
  IntColumn get creditLimitPaise => integer().withDefault(const Constant(0))();
  TextColumn get priceListId => text().nullable()();
  IntColumn get openingBalancePaise =>
      integer().withDefault(const Constant(0))();
  TextColumn get photoRef => text().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  TextColumn get lastOperationId => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SupplierRow')
class Suppliers extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  TextColumn get businessName => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get altPhone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get city => text().withDefault(const Constant(''))();
  TextColumn get state => text().withDefault(const Constant('Tamil Nadu'))();
  TextColumn get pinCode => text().withDefault(const Constant(''))();
  TextColumn get gstin => text().withDefault(const Constant(''))();
  TextColumn get pan => text().withDefault(const Constant(''))();
  IntColumn get openingBalancePaise =>
      integer().withDefault(const Constant(0))();
  TextColumn get photoRef => text().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  TextColumn get lastOperationId => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Workforce
// ---------------------------------------------------------------------------

@DataClassName('StaffRow')
class StaffMembers extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get employeeCode => text()();
  TextColumn get fullName => text()();
  TextColumn get photoRef => text().nullable()();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get altPhone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  DateTimeColumn get joiningDate => dateTime().nullable()();
  TextColumn get employmentType =>
      text().withDefault(const Constant('Permanent'))();
  TextColumn get department => text().withDefault(const Constant(''))();
  TextColumn get designation => text().withDefault(const Constant(''))();
  TextColumn get role => text().withDefault(const Constant('staff'))();
  TextColumn get assignedStoreId => text().nullable()();
  TextColumn get assignedGodownId => text().nullable()();
  TextColumn get managerId => text().nullable()();
  TextColumn get salaryType => text().withDefault(const Constant('monthly'))();
  IntColumn get basicSalaryPaise => integer().withDefault(const Constant(0))();
  TextColumn get bankDetails => text().withDefault(const Constant(''))();
  TextColumn get upiId => text().withDefault(const Constant(''))();
  TextColumn get emergencyContactName =>
      text().withDefault(const Constant(''))();
  TextColumn get emergencyContactPhone =>
      text().withDefault(const Constant(''))();
  TextColumn get identityDocRefs => text().withDefault(const Constant('[]'))();
  TextColumn get permissionsJson => text().withDefault(const Constant('[]'))();
  TextColumn get employmentStatus =>
      text().withDefault(const Constant('active'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  TextColumn get lastOperationId => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DriverRow')
class Drivers extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get driverCode => text()();
  TextColumn get fullName => text()();
  TextColumn get photoRef => text().nullable()();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get altPhone => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  DateTimeColumn get joiningDate => dateTime().nullable()();
  TextColumn get licenceNumber => text().withDefault(const Constant(''))();
  TextColumn get licenceType => text().withDefault(const Constant(''))();
  DateTimeColumn get licenceExpiryDate => dateTime().nullable()();
  TextColumn get assignedStoreId => text().nullable()();
  TextColumn get vehicleId => text().nullable()();
  TextColumn get salaryType => text().withDefault(const Constant('monthly'))();
  IntColumn get basicSalaryPaise => integer().withDefault(const Constant(0))();
  TextColumn get bankDetails => text().withDefault(const Constant(''))();
  TextColumn get upiId => text().withDefault(const Constant(''))();
  TextColumn get emergencyContact => text().withDefault(const Constant(''))();
  TextColumn get licenceDocRef => text().nullable()();
  TextColumn get identityDocRef => text().nullable()();
  TextColumn get employmentStatus =>
      text().withDefault(const Constant('active'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  TextColumn get lastOperationId => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('VehicleRow')
class Vehicles extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get registrationNumber => text()();
  TextColumn get vehicleType => text().withDefault(const Constant(''))();
  TextColumn get make => text().withDefault(const Constant(''))();
  TextColumn get model => text().withDefault(const Constant(''))();
  TextColumn get capacity => text().withDefault(const Constant(''))();
  TextColumn get assignedStoreId => text().nullable()();
  TextColumn get assignedDriverId => text().nullable()();
  DateTimeColumn get insuranceExpiry => dateTime().nullable()();
  DateTimeColumn get fitnessExpiry => dateTime().nullable()();
  DateTimeColumn get pollutionExpiry => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AttendanceRow')
class AttendanceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get staffId => text().references(StaffMembers, #id)();
  TextColumn get storeId => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get checkInTime => dateTime().nullable()();
  DateTimeColumn get checkOutTime => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('present'))();
  IntColumn get overtimeMinutes => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get recordedBy => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SalaryRecordRow')
class SalaryRecords extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get personId => text()();
  TextColumn get personType => text().withDefault(const Constant('staff'))();
  TextColumn get personName => text().withDefault(const Constant(''))();
  TextColumn get storeId => text().nullable()();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  IntColumn get basicSalaryPaise => integer().withDefault(const Constant(0))();
  IntColumn get overtimePaise => integer().withDefault(const Constant(0))();
  IntColumn get incentivePaise => integer().withDefault(const Constant(0))();
  IntColumn get bonusPaise => integer().withDefault(const Constant(0))();
  IntColumn get advanceDeductionPaise =>
      integer().withDefault(const Constant(0))();
  IntColumn get attendanceDeductionPaise =>
      integer().withDefault(const Constant(0))();
  IntColumn get otherDeductionsPaise =>
      integer().withDefault(const Constant(0))();
  IntColumn get grossSalaryPaise => integer().withDefault(const Constant(0))();
  IntColumn get netSalaryPaise => integer().withDefault(const Constant(0))();
  IntColumn get amountPaidPaise => integer().withDefault(const Constant(0))();
  IntColumn get balanceDuePaise => integer().withDefault(const Constant(0))();
  DateTimeColumn get paymentDate => dateTime().nullable()();
  TextColumn get paymentMethod => text().withDefault(const Constant(''))();
  TextColumn get paymentReference => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get createdBy => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get finalizedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SalaryPaymentRow')
class SalaryPayments extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get salaryId => text().references(SalaryRecords, #id)();
  IntColumn get amountPaise => integer()();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get method => text().withDefault(const Constant('cash'))();
  TextColumn get reference => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get idempotencyKey => text()();
  TextColumn get createdBy => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Sales documents (invoice / estimate / quotation)
// ---------------------------------------------------------------------------

@DataClassName('SaleRow')
class Sales extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get invoiceNumber => text()();
  TextColumn get documentType =>
      text().withDefault(const Constant('invoice'))();
  TextColumn get documentStatus =>
      text().withDefault(const Constant('draft'))();
  TextColumn get saleType => text().withDefault(const Constant('retail'))();
  TextColumn get storeId => text().nullable()();
  TextColumn get godownId => text().nullable()();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get deviceCode => text().withDefault(const Constant('DEVICE01'))();
  TextColumn get customerId => text().nullable()();
  DateTimeColumn get invoiceDate => dateTime()();
  TextColumn get invoiceTime => text().withDefault(const Constant(''))();
  TextColumn get sellerSnapshotJson =>
      text().withDefault(const Constant('{}'))();
  TextColumn get buyerSnapshotJson =>
      text().withDefault(const Constant('{}'))();
  IntColumn get subtotalPaise => integer().withDefault(const Constant(0))();
  IntColumn get discountPaise => integer().withDefault(const Constant(0))();
  IntColumn get taxableAmountPaise =>
      integer().withDefault(const Constant(0))();
  IntColumn get cgstPaise => integer().withDefault(const Constant(0))();
  IntColumn get sgstPaise => integer().withDefault(const Constant(0))();
  IntColumn get igstPaise => integer().withDefault(const Constant(0))();
  IntColumn get roundOffPaise => integer().withDefault(const Constant(0))();
  IntColumn get grandTotalPaise => integer().withDefault(const Constant(0))();
  IntColumn get amountPaidPaise => integer().withDefault(const Constant(0))();
  IntColumn get balanceDuePaise => integer().withDefault(const Constant(0))();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  TextColumn get upiReference => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get isGst => boolean().withDefault(const Constant(false))();
  TextColumn get priceListId => text().nullable()();
  IntColumn get templateVersion => integer().withDefault(const Constant(1))();
  TextColumn get createdBy => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get finalizedAt => dateTime().nullable()();
  DateTimeColumn get cancelledAt => dateTime().nullable()();
  TextColumn get cancelReason => text().withDefault(const Constant(''))();
  DateTimeColumn get validUntil => dateTime().nullable()();
  TextColumn get convertedInvoiceId => text().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  TextColumn get lastOperationId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SaleItemRow')
class SaleItems extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get saleId => text().references(Sales, #id)();
  TextColumn get productId => text().nullable()();
  TextColumn get productName => text()();
  TextColumn get sku => text().withDefault(const Constant(''))();
  TextColumn get hsnCode => text().withDefault(const Constant(''))();
  TextColumn get unit => text().withDefault(const Constant('Nos'))();
  IntColumn get quantityMilli => integer()();
  IntColumn get unitPricePaise => integer()();
  IntColumn get discountPaise => integer().withDefault(const Constant(0))();
  IntColumn get taxRateBps => integer().withDefault(const Constant(0))();
  IntColumn get taxAmountPaise => integer().withDefault(const Constant(0))();
  IntColumn get lineTotalPaise => integer().withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Purchases
// ---------------------------------------------------------------------------

@DataClassName('PurchaseRow')
class Purchases extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get purchaseNumber => text()();
  TextColumn get supplierId => text().nullable()();
  TextColumn get storeId => text().nullable()();
  TextColumn get godownId => text().nullable()();
  TextColumn get supplierInvoiceNumber =>
      text().withDefault(const Constant(''))();
  DateTimeColumn get purchaseDate => dateTime()();
  IntColumn get subtotalPaise => integer().withDefault(const Constant(0))();
  IntColumn get discountPaise => integer().withDefault(const Constant(0))();
  IntColumn get taxableAmountPaise =>
      integer().withDefault(const Constant(0))();
  IntColumn get cgstPaise => integer().withDefault(const Constant(0))();
  IntColumn get sgstPaise => integer().withDefault(const Constant(0))();
  IntColumn get igstPaise => integer().withDefault(const Constant(0))();
  IntColumn get grandTotalPaise => integer().withDefault(const Constant(0))();
  IntColumn get amountPaidPaise => integer().withDefault(const Constant(0))();
  IntColumn get balanceDuePaise => integer().withDefault(const Constant(0))();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  TextColumn get status => text().withDefault(const Constant('finalized'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get attachmentRefsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get createdBy => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PurchaseItemRow')
class PurchaseItems extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get purchaseId => text().references(Purchases, #id)();
  TextColumn get productId => text()();
  TextColumn get productName => text()();
  TextColumn get sku => text().withDefault(const Constant(''))();
  TextColumn get unit => text().withDefault(const Constant('Nos'))();
  IntColumn get quantityMilli => integer()();
  IntColumn get unitPricePaise => integer()();
  IntColumn get discountPaise => integer().withDefault(const Constant(0))();
  IntColumn get taxRateBps => integer().withDefault(const Constant(0))();
  IntColumn get taxAmountPaise => integer().withDefault(const Constant(0))();
  IntColumn get lineTotalPaise => integer().withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Money movements
// ---------------------------------------------------------------------------

@DataClassName('PaymentRow')
class Payments extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get partyType => text().withDefault(const Constant('customer'))();
  TextColumn get partyId => text().nullable()();
  TextColumn get partyName => text().withDefault(const Constant(''))();
  TextColumn get direction => text().withDefault(const Constant('in'))();
  IntColumn get amountPaise => integer()();
  TextColumn get method => text().withDefault(const Constant('cash'))();
  TextColumn get reference => text().withDefault(const Constant(''))();
  TextColumn get upiReference => text().withDefault(const Constant(''))();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get invoiceId => text().nullable()();
  TextColumn get purchaseId => text().nullable()();
  TextColumn get salaryId => text().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get idempotencyKey => text()();
  TextColumn get createdBy => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExpenseCategoryRow')
class ExpenseCategories extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExpenseRow')
class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get categoryId => text().nullable()();
  TextColumn get categoryName => text().withDefault(const Constant(''))();
  IntColumn get amountPaise => integer()();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get method => text().withDefault(const Constant('cash'))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get storeId => text().nullable()();
  TextColumn get attachmentRef => text().nullable()();
  TextColumn get referenceType => text().withDefault(const Constant(''))();
  TextColumn get referenceId => text().nullable()();
  TextColumn get createdBy => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Returns and orders
// ---------------------------------------------------------------------------

@DataClassName('ReturnRow')
class Returns extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get returnNumber => text()();
  TextColumn get type => text().withDefault(const Constant('sale_return'))();
  TextColumn get originalDocumentId => text().nullable()();
  TextColumn get originalDocumentNumber =>
      text().withDefault(const Constant(''))();
  TextColumn get partyId => text().nullable()();
  TextColumn get partyName => text().withDefault(const Constant(''))();
  TextColumn get reason => text().withDefault(const Constant(''))();
  IntColumn get amountPaise => integer().withDefault(const Constant(0))();
  TextColumn get refundMethod => text().withDefault(const Constant('credit'))();
  TextColumn get stockAction => text().withDefault(const Constant('restock'))();
  TextColumn get status => text().withDefault(const Constant('finalized'))();
  TextColumn get createdBy => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get finalizedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReturnItemRow')
class ReturnItems extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get returnId => text().references(Returns, #id)();
  TextColumn get productId => text()();
  TextColumn get productName => text()();
  IntColumn get quantityMilli => integer()();
  IntColumn get unitPricePaise => integer()();
  IntColumn get taxRateBps => integer().withDefault(const Constant(0))();
  IntColumn get lineTotalPaise => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OrderRow')
class Orders extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get orderNumber => text()();
  TextColumn get customerId => text().nullable()();
  TextColumn get customerName => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('open'))();
  DateTimeColumn get expectedDate => dateTime().nullable()();
  TextColumn get itemsJson => text().withDefault(const Constant('[]'))();
  IntColumn get totalPaise => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get createdBy => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Delivery
// ---------------------------------------------------------------------------

@DataClassName('DeliveryRow')
class Deliveries extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get deliveryNumber => text()();
  TextColumn get invoiceId => text().nullable()();
  TextColumn get invoiceNumber => text().withDefault(const Constant(''))();
  TextColumn get customerId => text().nullable()();
  TextColumn get customerName => text().withDefault(const Constant(''))();
  TextColumn get storeId => text().nullable()();
  TextColumn get godownId => text().nullable()();
  TextColumn get driverId => text().nullable()();
  TextColumn get driverName => text().withDefault(const Constant(''))();
  TextColumn get vehicleId => text().nullable()();
  TextColumn get vehicleNumber => text().withDefault(const Constant(''))();
  TextColumn get deliveryAddress => text().withDefault(const Constant(''))();
  DateTimeColumn get deliveryDate => dateTime()();
  TextColumn get expectedDeliveryTime =>
      text().withDefault(const Constant(''))();
  DateTimeColumn get actualDeliveryTime => dateTime().nullable()();
  IntColumn get deliveryChargePaise =>
      integer().withDefault(const Constant(0))();
  IntColumn get additionalExpensePaise =>
      integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get proofImageRefs => text().withDefault(const Constant('[]'))();
  TextColumn get customerAcknowledgement =>
      text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get createdBy => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DeliveryItemRow')
class DeliveryItems extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get deliveryId => text().references(Deliveries, #id)();
  TextColumn get productId => text()();
  TextColumn get productName => text()();
  IntColumn get quantityMilli => integer()();
  IntColumn get deliveredMilli => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DeliveryProofRow')
class DeliveryProofs extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get deliveryId => text().references(Deliveries, #id)();
  TextColumn get imageRef => text()();
  DateTimeColumn get capturedAt => dateTime()();
  TextColumn get capturedBy => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Files, audit and synchronization
// ---------------------------------------------------------------------------

@DataClassName('ImageMetadataRow')
class ImageMetadata extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get ownerType => text()();
  TextColumn get ownerId => text()();
  TextColumn get role => text().withDefault(const Constant('primary'))();
  TextColumn get localPath => text().withDefault(const Constant(''))();
  TextColumn get remoteUrl => text().nullable()();
  TextColumn get mimeType => text().withDefault(const Constant('image/jpeg'))();
  IntColumn get byteSize => integer().withDefault(const Constant(0))();
  TextColumn get sha256 => text().withDefault(const Constant(''))();
  IntColumn get width => integer().withDefault(const Constant(0))();
  IntColumn get height => integer().withDefault(const Constant(0))();
  TextColumn get uploadStatus =>
      text().withDefault(const Constant('pending'))();
  TextColumn get provider => text().withDefault(const Constant('imgbb'))();
  TextColumn get ownerUid => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AuditLogRow')
class AuditLogs extends Table {
  TextColumn get id => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get action => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text().withDefault(const Constant(''))();
  TextColumn get actorId => text().withDefault(const Constant(''))();
  TextColumn get actorName => text().withDefault(const Constant(''))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get beforeJson => text().nullable()();
  TextColumn get afterJson => text().nullable()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SyncQueueRow')
class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get operationId => text()();
  TextColumn get shopId => text().withDefault(const Constant(''))();
  TextColumn get entityType => text()();
  TextColumn get collectionName => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payloadJson => text().withDefault(const Constant('{}'))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime()();
  TextColumn get lastError => text().nullable()();
  IntColumn get baseVersion => integer().withDefault(const Constant(0))();
  IntColumn get priority => integer().withDefault(const Constant(100))();
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  TextColumn get userId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SyncMetadataRow')
class SyncMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get collectionName => text()();
  TextColumn get lastPulledAt => text().nullable()();
  TextColumn get lastPushedAt => text().nullable()();
  TextColumn get cursor => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('NumberSequenceRow')
class NumberSequences extends Table {
  TextColumn get id => text()();
  TextColumn get prefix => text().withDefault(const Constant(''))();
  IntColumn get nextValue => integer().withDefault(const Constant(1))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
