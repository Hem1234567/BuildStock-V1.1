import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _destinations = [
    (
      label: 'Home',
      icon: Icons.home_outlined,
      selected: Icons.home_rounded,
      path: '/',
    ),
    (
      label: 'Sales',
      icon: Icons.receipt_long_outlined,
      selected: Icons.receipt_long_rounded,
      path: '/sales',
    ),
    (
      label: 'Inventory',
      icon: Icons.inventory_2_outlined,
      selected: Icons.inventory_2_rounded,
      path: '/inventory',
    ),
    (
      label: 'Accounts',
      icon: Icons.account_balance_wallet_outlined,
      selected: Icons.account_balance_wallet_rounded,
      path: '/accounts',
    ),
    (
      label: 'More',
      icon: Icons.grid_view_outlined,
      selected: Icons.grid_view_rounded,
      path: '/more',
    ),
  ];

  int _indexFor(String location) {
    if (location == '/' || location.isEmpty) return 0;
    if (location.startsWith('/sales')) return 1;
    if (location.startsWith('/inventory')) return 2;
    if (location.startsWith('/accounts')) return 3;
    if (location.startsWith('/more')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _indexFor(location);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 960;
        if (wide) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    selectedIndex: index,
                    onDestinationSelected: (value) =>
                        context.go(_destinations[value].path),
                    labelType: NavigationRailLabelType.all,
                    leading: Padding(
                      padding: const EdgeInsets.only(bottom: 16, top: 8),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.apartment_rounded,
                          size: 20,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    destinations: _destinations
                        .map(
                          (item) => NavigationRailDestination(
                            icon: Icon(item.icon),
                            selectedIcon: Icon(item.selected),
                            label: Text(item.label),
                          ),
                        )
                        .toList(),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: child),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (value) =>
                context.go(_destinations[value].path),
            destinations: _destinations
                .map(
                  (item) => NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selected),
                    label: item.label,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
