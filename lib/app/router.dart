import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:buildstock/features/accounts/presentation/account_screens.dart';
import 'package:buildstock/features/business/data/business_repository.dart';
import 'package:buildstock/features/customers/presentation/party_screens.dart';
import 'package:buildstock/features/dashboard/presentation/dashboard_screen.dart';
import 'package:buildstock/features/deliveries/presentation/delivery_screens.dart';
import 'package:buildstock/features/inventory/presentation/inventory_screen.dart';
import 'package:buildstock/features/invoices/presentation/invoice_screens.dart';
import 'package:buildstock/features/products/presentation/product_screens.dart';
import 'package:buildstock/features/purchases/presentation/purchase_screens.dart';
import 'package:buildstock/features/reports/presentation/reports_screen.dart';
import 'package:buildstock/features/sales/presentation/checkout_screen.dart';
import 'package:buildstock/features/sales/presentation/sales_screen.dart';
import 'package:buildstock/features/settings/presentation/settings_screens.dart';
import 'package:buildstock/features/setup/presentation/setup_screen.dart';
import 'package:buildstock/features/staff/presentation/workforce_screens.dart';
import 'package:buildstock/features/stores/presentation/store_screens.dart';
import 'package:buildstock/features/sync/presentation/sync_screen.dart';
import 'more_screen.dart';
import 'shell.dart';

class _ProfileRefresh extends ChangeNotifier {
  _ProfileRefresh(Ref ref) {
    ref.listen(businessProfileProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _ProfileRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final profile = ref.read(businessProfileProvider);
      if (profile.isLoading) return null;
      final hasProfile = profile.value != null;
      final atSetup = state.matchedLocation == '/setup';
      if (!hasProfile && !atSetup) return '/setup';
      if (hasProfile && atSetup) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/setup', builder: (context, state) => const SetupScreen()),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/more',
            builder: (context, state) => const MoreScreen(),
          ),
          GoRoute(
            path: '/sales',
            builder: (context, state) => const SalesScreen(),
          ),
          GoRoute(
            path: '/sales/checkout',
            builder: (context, state) => const CheckoutScreen(),
          ),
          GoRoute(
            path: '/invoices',
            builder: (context, state) => const InvoiceHistoryScreen(),
          ),
          GoRoute(
            path: '/estimates',
            builder: (context, state) =>
                const InvoiceHistoryScreen(documentType: 'estimate'),
          ),
          GoRoute(
            path: '/invoices/:id',
            builder: (context, state) =>
                InvoicePreviewScreen(saleId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/inventory',
            builder: (context, state) => const InventoryScreen(),
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) => const ProductListScreen(),
          ),
          GoRoute(
            path: '/products/new',
            builder: (context, state) => const ProductFormScreen(),
          ),
          GoRoute(
            path: '/products/:id',
            builder: (context, state) =>
                ProductDetailScreen(productId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/products/:id/edit',
            builder: (context, state) =>
                ProductFormScreen(productId: state.pathParameters['id']),
          ),
          GoRoute(
            path: '/categories',
            builder: (context, state) => const CatalogueSettingsScreen(),
          ),
          GoRoute(
            path: '/customers',
            builder: (context, state) => const CustomerListScreen(),
          ),
          GoRoute(
            path: '/customers/new',
            builder: (context, state) => const CustomerFormScreen(),
          ),
          GoRoute(
            path: '/customers/:id',
            builder: (context, state) =>
                CustomerDetailScreen(customerId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/customers/:id/edit',
            builder: (context, state) =>
                CustomerFormScreen(customerId: state.pathParameters['id']),
          ),
          GoRoute(
            path: '/suppliers',
            builder: (context, state) => const SupplierListScreen(),
          ),
          GoRoute(
            path: '/suppliers/new',
            builder: (context, state) => const SupplierFormScreen(),
          ),
          GoRoute(
            path: '/suppliers/:id',
            builder: (context, state) =>
                SupplierDetailScreen(supplierId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/suppliers/:id/edit',
            builder: (context, state) =>
                SupplierFormScreen(supplierId: state.pathParameters['id']),
          ),
          GoRoute(
            path: '/purchases',
            builder: (context, state) => const PurchaseListScreen(),
          ),
          GoRoute(
            path: '/purchases/new',
            builder: (context, state) => const PurchaseFormScreen(),
          ),
          GoRoute(
            path: '/accounts',
            builder: (context, state) => const AccountsScreen(),
          ),
          GoRoute(
            path: '/expenses',
            builder: (context, state) => const AccountsScreen(),
          ),
          GoRoute(
            path: '/expenses/new',
            builder: (context, state) => const ExpenseFormScreen(),
          ),
          GoRoute(
            path: '/day-book',
            builder: (context, state) => const AccountsScreen(),
          ),
          GoRoute(
            path: '/stores',
            builder: (context, state) => const StoreListScreen(),
          ),
          GoRoute(
            path: '/stores/new',
            builder: (context, state) => const StoreFormScreen(),
          ),
          GoRoute(
            path: '/godowns/new',
            builder: (context, state) => const GodownFormScreen(),
          ),
          GoRoute(
            path: '/staff',
            builder: (context, state) => const StaffListScreen(),
          ),
          GoRoute(
            path: '/staff/new',
            builder: (context, state) => const StaffFormScreen(),
          ),
          GoRoute(
            path: '/staff/:id/edit',
            builder: (context, state) =>
                StaffFormScreen(staffId: state.pathParameters['id']),
          ),
          GoRoute(
            path: '/drivers',
            builder: (context, state) => const DriverListScreen(),
          ),
          GoRoute(
            path: '/drivers/new',
            builder: (context, state) => const DriverFormScreen(),
          ),
          GoRoute(
            path: '/drivers/:id/edit',
            builder: (context, state) =>
                DriverFormScreen(driverId: state.pathParameters['id']),
          ),
          GoRoute(
            path: '/attendance',
            builder: (context, state) => const AttendanceScreen(),
          ),
          GoRoute(
            path: '/salary',
            builder: (context, state) => const SalaryScreen(),
          ),
          GoRoute(
            path: '/deliveries',
            builder: (context, state) => const DeliveryListScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/settings/business',
            builder: (context, state) => const BusinessProfileSettingsScreen(),
          ),
          GoRoute(
            path: '/settings/printer',
            builder: (context, state) => const PrinterSettingsScreen(),
          ),
          GoRoute(
            path: '/settings/about',
            builder: (context, state) => const AboutScreen(),
          ),
          GoRoute(
            path: '/sync',
            builder: (context, state) => const SyncCenterScreen(),
          ),
        ],
      ),
    ],
  );
});
