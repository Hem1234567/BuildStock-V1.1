import 'package:buildstock/core/domain/enums.dart';

/// A document fetched from the cloud sync backend.
class RemoteDocument {
  const RemoteDocument({
    required this.id,
    required this.data,
    required this.version,
  });

  final String id;
  final Map<String, dynamic> data;
  final int version;
}

class SyncConflictException implements Exception {
  const SyncConflictException(this.message);
  final String message;
}

class SyncNotConfiguredException implements Exception {
  const SyncNotConfiguredException();
}

/// Abstraction over the cloud so the sync engine can be unit-tested with an
/// in-memory backend and so the UI never touches Firestore directly.
abstract class SyncBackend {
  bool get isConfigured;
  String get shopId;

  Future<void> push({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
    required int baseVersion,
    required String operationId,
    required String deviceId,
    required String userId,
  });

  Future<List<RemoteDocument>> pull({
    required String collection,
    String? cursor,
    int limit = 200,
  });
}

/// Used when Firebase is not configured. Every push throws a typed exception
/// that the engine records as a configuration problem, never as success.
class DisabledSyncBackend implements SyncBackend {
  const DisabledSyncBackend();

  @override
  bool get isConfigured => false;

  @override
  String get shopId => 'local';

  @override
  Future<void> push({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
    required int baseVersion,
    required String operationId,
    required String deviceId,
    required String userId,
  }) async {
    throw const SyncNotConfiguredException();
  }

  @override
  Future<List<RemoteDocument>> pull({
    required String collection,
    String? cursor,
    int limit = 200,
  }) async => const [];
}

/// Collections that participate in synchronization. Keep this in step with
/// firestore.rules and the backend repository.
abstract final class SyncCollections {
  static const businessProfile = 'business_profile';
  static const stores = 'stores';
  static const godowns = 'godowns';
  static const categories = 'categories';
  static const brands = 'brands';
  static const units = 'units';
  static const priceLists = 'price_lists';
  static const products = 'products';
  static const inventory = 'inventory';
  static const stockMovements = 'stock_movements';
  static const stockTransfers = 'stock_transfers';
  static const stockTransferItems = 'stock_transfer_items';
  static const customers = 'customers';
  static const suppliers = 'suppliers';
  static const staff = 'staff';
  static const drivers = 'drivers';
  static const vehicles = 'vehicles';
  static const attendance = 'attendance';
  static const salaryRecords = 'salary_records';
  static const salaryPayments = 'salary_payments';
  static const sales = 'sales';
  static const saleItems = 'sale_items';
  static const purchases = 'purchases';
  static const purchaseItems = 'purchase_items';
  static const payments = 'payments';
  static const expenses = 'expenses';
  static const expenseCategories = 'expense_categories';
  static const returns = 'returns';
  static const returnItems = 'return_items';
  static const orders = 'orders';
  static const deliveries = 'deliveries';
  static const deliveryItems = 'delivery_items';
  static const deliveryProofs = 'delivery_proofs';
  static const imageMetadata = 'image_metadata';
  static const auditLogs = 'audit_logs';

  static const all = [
    businessProfile,
    stores,
    godowns,
    categories,
    brands,
    units,
    priceLists,
    products,
    inventory,
    stockMovements,
    stockTransfers,
    stockTransferItems,
    customers,
    suppliers,
    staff,
    drivers,
    vehicles,
    attendance,
    salaryRecords,
    salaryPayments,
    sales,
    saleItems,
    purchases,
    purchaseItems,
    payments,
    expenses,
    expenseCategories,
    returns,
    returnItems,
    orders,
    deliveries,
    deliveryItems,
    deliveryProofs,
    imageMetadata,
    auditLogs,
  ];

  /// Push order: parents before children, configuration before transactions.
  static const pushOrder = [
    expenseCategories,
    categories,
    brands,
    units,
    priceLists,
    stores,
    godowns,
    products,
    customers,
    suppliers,
    staff,
    drivers,
    vehicles,
    businessProfile,
    inventory,
    stockMovements,
    stockTransfers,
    stockTransferItems,
    sales,
    saleItems,
    purchases,
    purchaseItems,
    payments,
    expenses,
    returns,
    returnItems,
    orders,
    salaryRecords,
    salaryPayments,
    attendance,
    deliveries,
    deliveryItems,
    deliveryProofs,
    imageMetadata,
    auditLogs,
  ];

  static int priorityFor(String collection) {
    final index = pushOrder.indexOf(collection);
    return index < 0 ? 100 : index;
  }
}

/// Local table that mirrors each cloud collection.
abstract final class SyncTableNames {
  static const Map<String, String> collectionToTable = {
    SyncCollections.businessProfile: 'business_profiles',
    SyncCollections.stores: 'stores',
    SyncCollections.godowns: 'godowns',
    SyncCollections.categories: 'categories',
    SyncCollections.brands: 'brands',
    SyncCollections.units: 'units',
    SyncCollections.priceLists: 'price_lists',
    SyncCollections.products: 'products',
    SyncCollections.inventory: 'inventories',
    SyncCollections.stockMovements: 'stock_movements',
    SyncCollections.stockTransfers: 'stock_transfers',
    SyncCollections.stockTransferItems: 'stock_transfer_items',
    SyncCollections.customers: 'customers',
    SyncCollections.suppliers: 'suppliers',
    SyncCollections.staff: 'staff_members',
    SyncCollections.drivers: 'drivers',
    SyncCollections.vehicles: 'vehicles',
    SyncCollections.attendance: 'attendance_records',
    SyncCollections.salaryRecords: 'salary_records',
    SyncCollections.salaryPayments: 'salary_payments',
    SyncCollections.sales: 'sales',
    SyncCollections.saleItems: 'sale_items',
    SyncCollections.purchases: 'purchases',
    SyncCollections.purchaseItems: 'purchase_items',
    SyncCollections.payments: 'payments',
    SyncCollections.expenses: 'expenses',
    SyncCollections.expenseCategories: 'expense_categories',
    SyncCollections.returns: 'returns',
    SyncCollections.returnItems: 'return_items',
    SyncCollections.orders: 'orders',
    SyncCollections.deliveries: 'deliveries',
    SyncCollections.deliveryItems: 'delivery_items',
    SyncCollections.deliveryProofs: 'delivery_proofs',
    SyncCollections.imageMetadata: 'image_metadata',
    SyncCollections.auditLogs: 'audit_logs',
  };
}

/// Wire status strings (kept next to the collections for clarity).
const String syncPending = SyncStatus.pending;
