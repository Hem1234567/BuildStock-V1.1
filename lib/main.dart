import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/preferences.dart';
import 'core/database/app_database.dart';
import 'core/database/database_provider.dart';
import 'core/firebase/firebase_runtime.dart';
import 'core/session/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final runtime = await FirebaseBootstrap.initialize();
  final database = AppDatabase(driftDatabase(name: 'buildstock'));
  final identity = await SessionService(database, runtime).load();
  final services = AppServices(
    db: database,
    runtime: runtime,
    identity: identity,
  );
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        servicesProvider.overrideWithValue(services),
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
      child: const BuildStockApp(),
    ),
  );
}
