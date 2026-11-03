import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Firebase configuration for BuildStock.
///
/// The web configuration is the Firebase project supplied by the business:
/// `inventory-management-be3d1`.
///
/// Android needs an **Android app** registered in that same Firebase project.
/// Its app ID is not a secret, but it must be created in the Firebase console
/// (the web app ID cannot authenticate an Android client). Provide it at build
/// time rather than inventing one:
///
///   flutter build apk --dart-define=FIREBASE_ANDROID_APP_ID=1:...:android:...
///
/// Until that is supplied the app starts in a fully functional offline mode and
/// the Sync Center explains exactly what is missing.
class FirebaseConfig {
  const FirebaseConfig._();

  static const String projectId = 'inventory-management-be3d1';
  static const String apiKey = 'AIzaSyCaKEwCnlUYS9K1j-PgFYVrDUU69MLCIV4';
  static const String authDomain = 'inventory-management-be3d1.firebaseapp.com';
  static const String storageBucket =
      'inventory-management-be3d1.firebasestorage.app';
  static const String messagingSenderId = '800582767727';
  static const String webAppId = '1:800582767727:web:96625189f610f7d68c699a';

  static const String androidAppId = String.fromEnvironment(
    'FIREBASE_ANDROID_APP_ID',
    defaultValue: '',
  );

  static const String iosAppId = String.fromEnvironment(
    'FIREBASE_IOS_APP_ID',
    defaultValue: '',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: apiKey,
    appId: webAppId,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    authDomain: authDomain,
    storageBucket: storageBucket,
  );

  static FirebaseOptions? mobile() {
    final appId = switch (defaultTargetPlatform) {
      TargetPlatform.android => androidAppId,
      TargetPlatform.iOS => iosAppId,
      _ => '',
    };
    if (appId.isEmpty) return null;
    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket,
    );
  }
}

/// Result of initializing Firebase once at startup.
class FirebaseRuntime {
  const FirebaseRuntime({
    this.app,
    this.auth,
    this.firestore,
    this.unavailableReason,
  });

  final FirebaseApp? app;
  final FirebaseAuth? auth;
  final FirebaseFirestore? firestore;
  final String? unavailableReason;

  bool get isReady => app != null && auth != null && firestore != null;
  bool get isSignedIn => auth?.currentUser != null;
  String? get uid => auth?.currentUser?.uid;

  factory FirebaseRuntime.unavailable(String reason) =>
      FirebaseRuntime(unavailableReason: reason);
}

abstract final class FirebaseBootstrap {
  static Future<FirebaseRuntime> initialize() async {
    try {
      final options = kIsWeb ? FirebaseConfig.web : FirebaseConfig.mobile();
      if (options == null) {
        return FirebaseRuntime.unavailable(
          'No Firebase Android app is registered for this build. '
          'Add FIREBASE_ANDROID_APP_ID with --dart-define after creating the '
          'Android app in the Firebase console.',
        );
      }
      final app = await Firebase.initializeApp(options: options);
      final firestore = FirebaseFirestore.instance;
      // Offline persistence is enabled by default on Android. Keeping the
      // default avoids double-enabling errors on web.
      return FirebaseRuntime(
        app: app,
        auth: FirebaseAuth.instance,
        firestore: firestore,
      );
    } on FirebaseException catch (error) {
      return FirebaseRuntime.unavailable(
        'Firebase initialization failed: ${error.code} ${error.message ?? ''}',
      );
    } catch (error) {
      return FirebaseRuntime.unavailable(
        'Firebase initialization failed: $error',
      );
    }
  }
}

/// Thin authentication wrapper. The rest of the app never imports
/// firebase_auth directly.
class AuthService {
  AuthService(this.runtime);

  final FirebaseRuntime runtime;

  bool get isAvailable => runtime.auth != null;
  bool get isSignedIn => runtime.isSignedIn;

  Stream<User?> authStateChanges() =>
      runtime.auth?.authStateChanges() ?? const Stream.empty();

  Future<User> signIn({required String email, required String password}) async {
    final auth = runtime.auth;
    if (auth == null) {
      throw StateError('Firebase Authentication is not configured.');
    }
    final credential = await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) throw StateError('Sign-in returned no user.');
    return user;
  }

  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final auth = runtime.auth;
    if (auth == null) {
      throw StateError('Firebase Authentication is not configured.');
    }
    final credential = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) throw StateError('Sign-up returned no user.');
    await user.updateDisplayName(displayName.trim());
    return user;
  }

  Future<void> sendPasswordReset(String email) async {
    final auth = runtime.auth;
    if (auth == null) {
      throw StateError('Firebase Authentication is not configured.');
    }
    await auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    await runtime.auth?.signOut();
  }
}
