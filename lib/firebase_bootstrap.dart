import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

class FirebaseBootstrap {
  static bool isConfigured = false;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      isConfigured = true;
    } on FirebaseException catch (error) {
      isConfigured = false;
      debugPrint('Firebase initialization failed: $error');
    }
  }
}
