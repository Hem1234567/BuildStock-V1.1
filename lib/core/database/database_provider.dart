import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buildstock/core/database/app_database.dart';
import 'package:buildstock/core/firebase/firebase_runtime.dart';
import 'package:buildstock/core/session/session_service.dart';
import 'package:buildstock/core/sync/outbox.dart';

/// Runtime container created once in `main()` and shared through Riverpod.
class AppServices {
  AppServices({
    required this.db,
    required this.runtime,
    required this.identity,
  });

  final AppDatabase db;
  final FirebaseRuntime runtime;
  AppIdentity identity;
  late final Outbox outbox = Outbox(db);
  late final AuthService auth = AuthService(runtime);

  Future<void> updateIdentity(AppIdentity next) async {
    identity = next;
  }
}

final servicesProvider = Provider<AppServices>(
  (ref) => throw UnimplementedError('AppServices must be overridden in main'),
);

final databaseProvider = Provider<AppDatabase>(
  (ref) => ref.watch(servicesProvider).db,
);

final identityProvider = Provider<AppIdentity>(
  (ref) => ref.watch(servicesProvider).identity,
);

final outboxProvider = Provider<Outbox>(
  (ref) => ref.watch(servicesProvider).outbox,
);

final firebaseRuntimeProvider = Provider<FirebaseRuntime>(
  (ref) => ref.watch(servicesProvider).runtime,
);

final authServiceProvider = Provider<AuthService>(
  (ref) => ref.watch(servicesProvider).auth,
);

final authStateProvider = StreamProvider((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});
