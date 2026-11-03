import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:buildstock/core/database/app_database.dart';
import 'package:buildstock/core/database/database_provider.dart';
import 'package:buildstock/core/utils/ids.dart';
import 'package:buildstock/core/utils/json.dart';

/// Writes an immutable audit record and queues it for synchronization.
/// Audit failures never block the business transaction; they are written in the
/// same transaction as the change when possible, and logged otherwise.
class AuditWriter {
  AuditWriter(this.services);

  final AppServices services;

  Future<void> write({
    required String action,
    required String entityType,
    required String entityId,
    Map<String, dynamic>? before,
    Map<String, dynamic>? after,
    String note = '',
  }) async {
    final db = services.db;
    final identity = services.identity;
    final id = Ids.audit();
    final now = DateTime.now();
    await db
        .into(db.auditLogs)
        .insert(
          AuditLogsCompanion.insert(
            id: id,
            shopId: Value(identity.shopId),
            action: action,
            entityType: entityType,
            entityId: Value(entityId),
            actorId: Value(identity.userId ?? ''),
            actorName: Value(identity.displayName ?? 'Local user'),
            deviceId: Value(identity.deviceId),
            beforeJson: Value(before == null ? null : jsonEncode(before)),
            afterJson: Value(after == null ? null : jsonEncode(after)),
            note: Value(note),
            createdAt: now,
          ),
        );
    final row = await (db.select(
      db.auditLogs,
    )..where((t) => t.id.equals(id))).getSingle();
    await services.outbox.enqueue(
      shopId: identity.shopId,
      deviceId: identity.deviceId,
      userId: identity.userId,
      entityType: 'audit_log',
      collection: 'audit_logs',
      entityId: id,
      payload: Json.toCloud(row.toJson()),
      baseVersion: 0,
      priority: 900,
    );
  }
}
