import 'package:buildstock/core/domain/enums.dart';

/// Permission keys. These exact strings are used by Firestore rules and by the
/// local authorization layer, so hiding a button is never the only defence.
abstract final class Permissions {
  static const viewDashboard = 'view_dashboard';
  static const createSales = 'create_sales';
  static const finalizeInvoices = 'finalize_invoices';
  static const applyDiscounts = 'apply_discounts';
  static const viewPurchasePrices = 'view_purchase_prices';
  static const manageProducts = 'manage_products';
  static const manageInventory = 'manage_inventory';
  static const manageStores = 'manage_stores';
  static const manageGodowns = 'manage_godowns';
  static const manageCustomers = 'manage_customers';
  static const manageSuppliers = 'manage_suppliers';
  static const manageStaff = 'manage_staff';
  static const manageDrivers = 'manage_drivers';
  static const manageAttendance = 'manage_attendance';
  static const manageSalaries = 'manage_salaries';
  static const manageExpenses = 'manage_expenses';
  static const managePurchases = 'manage_purchases';
  static const recordPayments = 'record_payments';
  static const manageReturns = 'manage_returns';
  static const manageDeliveries = 'manage_deliveries';
  static const manageReports = 'manage_reports';
  static const manageBusinessSettings = 'manage_business_settings';
  static const manageUsers = 'manage_users';

  static const all = [
    viewDashboard,
    createSales,
    finalizeInvoices,
    applyDiscounts,
    viewPurchasePrices,
    manageProducts,
    manageInventory,
    manageStores,
    manageGodowns,
    manageCustomers,
    manageSuppliers,
    manageStaff,
    manageDrivers,
    manageAttendance,
    manageSalaries,
    manageExpenses,
    managePurchases,
    recordPayments,
    manageReturns,
    manageDeliveries,
    manageReports,
    manageBusinessSettings,
    manageUsers,
  ];
}

/// Default permissions per role. The owner always has every permission, and
/// permissions can be granted per staff member on top of the role defaults.
abstract final class RolePermissions {
  static const Map<String, Set<String>> defaults = {
    UserRole.owner: {
      Permissions.viewDashboard,
      Permissions.createSales,
      Permissions.finalizeInvoices,
      Permissions.applyDiscounts,
      Permissions.viewPurchasePrices,
      Permissions.manageProducts,
      Permissions.manageInventory,
      Permissions.manageStores,
      Permissions.manageGodowns,
      Permissions.manageCustomers,
      Permissions.manageSuppliers,
      Permissions.manageStaff,
      Permissions.manageDrivers,
      Permissions.manageAttendance,
      Permissions.manageSalaries,
      Permissions.manageExpenses,
      Permissions.managePurchases,
      Permissions.recordPayments,
      Permissions.manageReturns,
      Permissions.manageDeliveries,
      Permissions.manageReports,
      Permissions.manageBusinessSettings,
      Permissions.manageUsers,
    },
    UserRole.admin: {...Permissions.all},
    UserRole.manager: {
      Permissions.viewDashboard,
      Permissions.createSales,
      Permissions.finalizeInvoices,
      Permissions.applyDiscounts,
      Permissions.viewPurchasePrices,
      Permissions.manageProducts,
      Permissions.manageInventory,
      Permissions.manageStores,
      Permissions.manageGodowns,
      Permissions.manageCustomers,
      Permissions.manageSuppliers,
      Permissions.manageStaff,
      Permissions.manageDrivers,
      Permissions.manageAttendance,
      Permissions.manageExpenses,
      Permissions.managePurchases,
      Permissions.recordPayments,
      Permissions.manageReturns,
      Permissions.manageDeliveries,
      Permissions.manageReports,
    },
    UserRole.cashier: {
      Permissions.viewDashboard,
      Permissions.createSales,
      Permissions.finalizeInvoices,
      Permissions.manageCustomers,
      Permissions.recordPayments,
    },
    UserRole.accountant: {
      Permissions.viewDashboard,
      Permissions.viewPurchasePrices,
      Permissions.manageExpenses,
      Permissions.manageSalaries,
      Permissions.recordPayments,
      Permissions.manageReports,
      Permissions.manageReturns,
    },
    UserRole.staff: {
      Permissions.viewDashboard,
      Permissions.manageInventory,
      Permissions.manageDeliveries,
    },
    UserRole.driver: {Permissions.viewDashboard, Permissions.manageDeliveries},
  };

  static Set<String> forRole(String role) => defaults[role] ?? const <String>{};
}
