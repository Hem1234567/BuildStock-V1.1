import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:buildstock/core/sync/sync_controller.dart';

final connectivityProvider = StreamProvider<List<ConnectivityResult>>(
  (ref) => Connectivity().onConnectivityChanged,
);

/// Triggers synchronization when the app starts, resumes, or regains a network
/// interface. Connectivity is only a trigger: the engine still handles cloud
/// failures and keeps the outbox intact.
class AppLifecycleSync extends ConsumerStatefulWidget {
  const AppLifecycleSync({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLifecycleSync> createState() => _AppLifecycleSyncState();
}

class _AppLifecycleSyncState extends ConsumerState<AppLifecycleSync>
    with WidgetsBindingObserver {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sync();
    }
  }

  void _sync() {
    if (!mounted) return;
    if (!_started) _started = true;
    unawaited(ref.read(syncControllerProvider.notifier).run());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(connectivityProvider, (previous, next) {
      final results = next.value;
      if (results == null) return;
      final online = results.any(
        (result) =>
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.ethernet ||
            result == ConnectivityResult.vpn,
      );
      if (online) _sync();
    });
    return widget.child;
  }
}
