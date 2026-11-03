import 'package:flutter_test/flutter_test.dart';

import 'package:buildstock/core/domain/enums.dart';
import 'package:buildstock/core/security/permissions.dart';
import 'package:buildstock/core/session/session_service.dart';

void main() {
  AppIdentity identity(String role, Set<String> permissions) => AppIdentity(
    deviceId: 'dev',
    deviceName: 'Test device',
    deviceCode: 'DEV01',
    shopId: 'shop',
    role: role,
    permissions: permissions,
  );

  test('owner and admin bypass explicit permission lists', () {
    expect(identity(UserRole.owner, {}).can(Permissions.manageUsers), isTrue);
    expect(
      identity(UserRole.admin, {}).can(Permissions.manageBusinessSettings),
      isTrue,
    );
  });

  test('cashier is limited to sales and customer permissions', () {
    final cashier = identity(
      UserRole.cashier,
      RolePermissions.forRole(UserRole.cashier),
    );
    expect(cashier.can(Permissions.createSales), isTrue);
    expect(cashier.can(Permissions.manageCustomers), isTrue);
    expect(cashier.can(Permissions.manageSalaries), isFalse);
    expect(cashier.can(Permissions.manageUsers), isFalse);
  });

  test('a custom permission can be granted on top of a role', () {
    final staff = identity(UserRole.staff, {
      ...RolePermissions.forRole(UserRole.staff),
      Permissions.recordPayments,
    });
    expect(staff.can(Permissions.recordPayments), isTrue);
    expect(staff.can(Permissions.manageInventory), isTrue);
    expect(staff.can(Permissions.manageStaff), isFalse);
  });
}
