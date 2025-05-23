import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
            authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '',
            projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
            storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
            messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
            appId: dotenv.env['FIREBASE_APP_ID'] ?? ''));
  } else {
    await Firebase.initializeApp();
  }
}

String get googleVisionApiKey => dotenv.env['GOOGLE_VISION_API_KEY'] ?? '';

