import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:buildstock/core/database/app_database.dart';
import 'package:buildstock/core/domain/enums.dart';
import 'package:buildstock/core/utils/ids.dart';
import 'package:buildstock/core/utils/json.dart';

/// Durable outbox. Every local business write appends a queue row in the same
/// database transaction as the write itself, so closing the app can never lose
/// an unsynchronized record.
class Outbox {
  Outbox(this.db);

  final AppDatabase db;

  static const int defaultPriority = 100;

  Future<String> enqueue({
    required String shopId,
    required String deviceId,
    required String entityType,
    required String collection,
    required String entityId,
    required Map<String, dynamic> payload,
    required int baseVersion,
    String operation = 'upsert',
    int priority = defaultPriority,
    String? userId,
    DateTime? now,
  }) async {
    final operationId = Ids.operation();
    final timestamp = now ?? DateTime.now();
    await db
        .into(db.syncQueue)
        .insert(
          SyncQueueCompanion.insert(
            id: Ids.queue(),
            operationId: operationId,
            shopId: Value(shopId),
            entityType: entityType,
            collectionName: collection,
            entityId: entityId,
            operation: operation,
            payloadJson: Value(jsonEncode(payload)),
            priority: Value(priority),
            baseVersion: Value(baseVersion),
            deviceId: Value(deviceId),
            userId: Value(userId),
            nextAttemptAt: timestamp,
            createdAt: timestamp,
            updatedAt: timestamp,
          ),
        );
    return operationId;
  }

  /// Re-queues a failed operation, preserving its operation ID (idempotent).
  Future<void> retryFailed({int limit = 100}) async {
    final failed =
        await (db.select(db.syncQueue)
              ..where((t) => t.status.equals(SyncStatus.failed))
              ..limit(limit))
            .get();
    final now = DateTime.now();
    for (final row in failed) {
      await (db.update(db.syncQueue)..where((t) => t.id.equals(row.id))).write(
        SyncQueueCompanion(
          status: const Value(SyncStatus.pending),
          attempts: const Value(0),
          nextAttemptAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    }
  }

  /// Marks operations that have been in `syncing` state after a crash as
  /// pending again. Called once on application start.
  Future<int> recoverInterrupted() async {
    final now = DateTime.now();
    return (db.update(
      db.syncQueue,
    )..where((t) => t.status.equals(SyncStatus.syncing))).write(
      SyncQueueCompanion(
        status: const Value(SyncStatus.pending),
        nextAttemptAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Stream<List<SyncQueueRow>> watchQueue({String? status}) {
    final query = db.select(db.syncQueue)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    if (status != null) {
      query.where((t) => t.status.equals(status));
    }
    return query.watch();
  }

  Future<Map<String, int>> statusCounts() async {
    final rows = await db
        .customSelect(
          'SELECT status, COUNT(*) AS n FROM sync_queue GROUP BY status',
        )
        .get();
    return {
      for (final row in rows) row.read<String>('status'): row.read<int>('n'),
    };
  }

  /// Backoff: 30s, 2m, 8m, 30m, 2h, capped at 6h.
  static Duration backoff(int attempts) {
    const seconds = [30, 120, 480, 1800, 7200, 21600];
    final index = attempts.clamp(0, seconds.length - 1);
    return Duration(seconds: seconds[index]);
  }

  static Map<String, dynamic> payloadOf(SyncQueueRow row) =>
      Json.decodeMap(row.payloadJson);
}

/// Payload helpers so repositories enqueue exactly what Firestore receives.
Map<String, dynamic> cloudPayload(Map<String, dynamic> rowJson) =>
    Json.toCloud(rowJson);
