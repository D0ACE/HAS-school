import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

class FirebaseBootstrap {
  static bool isConfigured = false;
  static Object? initializationError;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      isConfigured = true;
      initializationError = null;
    } on Object catch (error) {
      isConfigured = false;
      initializationError = error;
      debugPrint('Firebase initialization failed: $error');
    }
  }
}
