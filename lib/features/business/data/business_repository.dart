import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buildstock/core/database/app_database.dart';
import 'package:buildstock/core/database/database_provider.dart';
import 'package:buildstock/core/domain/enums.dart';
import 'package:buildstock/core/security/permissions.dart';
import 'package:buildstock/core/utils/json.dart';

class BusinessProfileInput {
  const BusinessProfileInput({
    required this.name,
    this.ownerName = '',
    this.phone = '',
    this.altPhone = '',
    this.email = '',
    this.address = '',
    this.area = '',
    this.city = '',
    this.district = '',
    this.state = 'Tamil Nadu',
    this.pinCode = '',
    this.gstin = '',
    this.pan = '',
    this.stateCode = '33',
    this.logoRef,
    this.signatureRef,
    this.stampRef,
    this.upiId = '',
    this.upiPayeeName = '',
    this.bankName = '',
    this.bankAccountNumber = '',
    this.ifsc = '',
    this.openingDate,
    this.description = '',
    this.invoicePrefix = 'VBA',
    this.isGstRegistered = false,
  });

  final String name;
  final String ownerName;
  final String phone;
  final String altPhone;
  final String email;
  final String address;
  final String area;
  final String city;
  final String district;
  final String state;
  final String pinCode;
  final String gstin;
  final String pan;
  final String stateCode;
  final String? logoRef;
  final String? signatureRef;
  final String? stampRef;
  final String upiId;
  final String upiPayeeName;
  final String bankName;
  final String bankAccountNumber;
  final String ifsc;
  final DateTime? openingDate;
  final String description;
  final String invoicePrefix;
  final bool isGstRegistered;
}

class BusinessRepository {
  BusinessRepository(this.services);

  final AppServices services;

  AppDatabase get db => services.db;

  Stream<BusinessProfileRow?> watchProfile() {
    return db.select(db.businessProfiles).watchSingleOrNull();
  }

  Future<BusinessProfileRow?> profile() =>
      (db.select(db.businessProfiles)
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<void> saveProfile(BusinessProfileInput input) async {
    if (input.name.trim().isEmpty) {
      throw ArgumentError('Business name is required');
    }
    final identity = services.identity;
    // A single tenant profile with a stable local ID. The shop path in
    // Firestore carries the tenant identity, so this ID never has to change
    // when the owner signs in or links a device.
    const id = 'default';
    final existing = await profile();
    final now = DateTime.now();
    final prefix = input.invoicePrefix.trim().isEmpty
        ? 'VBA'
        : input.invoicePrefix.trim().toUpperCase();

    await db.transaction(() async {
      await db
          .into(db.businessProfiles)
          .insertOnConflictUpdate(
            BusinessProfilesCompanion.insert(
              id: id,
              name: Value(input.name.trim()),
              ownerName: Value(input.ownerName.trim()),
              phone: Value(input.phone.trim()),
              altPhone: Value(input.altPhone.trim()),
              email: Value(input.email.trim()),
              address: Value(input.address.trim()),
              area: Value(input.area.trim()),
              city: Value(input.city.trim()),
              district: Value(input.district.trim()),
              state: Value(input.state.trim()),
              pinCode: Value(input.pinCode.trim()),
              gstin: Value(input.gstin.trim().toUpperCase()),
              pan: Value(input.pan.trim().toUpperCase()),
              stateCode: Value(input.stateCode.trim()),
              logoRef: Value(input.logoRef),
              signatureRef: Value(input.signatureRef),
              stampRef: Value(input.stampRef),
              upiId: Value(input.upiId.trim()),
              upiPayeeName: Value(
                input.upiPayeeName.trim().isEmpty
                    ? input.name.trim()
                    : input.upiPayeeName.trim(),
              ),
              bankName: Value(input.bankName.trim()),
              bankAccountNumber: Value(input.bankAccountNumber.trim()),
              ifsc: Value(input.ifsc.trim().toUpperCase()),
              openingDate: Value(input.openingDate),
              description: Value(input.description.trim()),
              invoicePrefix: Value(prefix),
              isGstRegistered: Value(input.isGstRegistered),
              updatedAt: now,
            ),
          );
      final row = await profile();
      await services.outbox.enqueue(
        shopId: identity.shopId,
        deviceId: identity.deviceId,
        userId: identity.userId,
        entityType: 'business_profile',
        collection: 'business_profile',
        entityId: id,
        payload: Json.toCloud(row!.toJson()),
        baseVersion: existing == null ? 0 : 1,
        priority: 1,
      );
    });

    await ensureCloudShop();
  }

  /// Creates the Firestore shop document and the owner's membership on the
  /// first signed-in save. Firestore rules allow this only for the UID that
  /// owns the shop ID; failures are surfaced by the Sync Center rather than
  /// pretending the shop exists in the cloud.
  Future<bool> ensureCloudShop() async {
    final runtime = services.runtime;
    final user = runtime.auth?.currentUser;
    final firestore = runtime.firestore;
    if (user == null || firestore == null) return false;
    final shopId = user.uid;
    if (services.identity.shopId != shopId) return false;
    try {
      final shopRef = firestore.collection('shops').doc(shopId);
      final snapshot = await shopRef.get();
      if (!snapshot.exists) {
        final profile = await this.profile();
        await shopRef.set({
          'id': shopId,
          'owner_id': shopId,
          'name': profile?.name ?? 'Vijay Balaji Agency',
          'created_at': DateTime.now().toUtc().toIso8601String(),
          'schema_version': 1,
        });
      }
      final memberRef = shopRef.collection('users').doc(shopId);
      final member = await memberRef.get();
      if (!member.exists) {
        await memberRef.set({
          'uid': shopId,
          'shop_id': shopId,
          'display_name':
              user.displayName ?? (await profile())?.ownerName ?? 'Owner',
          'email': user.email ?? '',
          'role': UserRole.owner,
          'permissions': Permissions.all,
          'active': true,
          'created_at': DateTime.now().toUtc().toIso8601String(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        });
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Stream<Map<String, String>> watchSettings() {
    return db
        .select(db.appSettings)
        .watch()
        .map((rows) => {for (final row in rows) row.key: row.value});
  }

  Future<void> putSetting(String key, String value) =>
      db.setSetting(key, value);

  Future<String?> getSetting(String key) => db.getSetting(key);
}

final businessRepositoryProvider = Provider<BusinessRepository>(
  (ref) => BusinessRepository(ref.watch(servicesProvider)),
);

final businessProfileProvider = StreamProvider<BusinessProfileRow?>(
  (ref) => ref.watch(businessRepositoryProvider).watchProfile(),
);

final appSettingsProvider = StreamProvider<Map<String, String>>(
  (ref) => ref.watch(businessRepositoryProvider).watchSettings(),
);
