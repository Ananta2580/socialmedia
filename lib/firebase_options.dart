// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD4CDyIL5nS3g4b-ok_24afYFeOfYSAojg',
    appId: '1:106271426536:web:e64228984f67e8643a465d',
    messagingSenderId: '106271426536',
    projectId: 'linkup-60ba5',
    authDomain: 'linkup-60ba5.firebaseapp.com',
    storageBucket: 'linkup-60ba5.appspot.com',
    measurementId: 'G-DP5RW2KKZW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5QtDMcKL24UIWdT93sKL5HjHuax6WvIU',
    appId: '1:106271426536:android:866026755934c9613a465d',
    messagingSenderId: '106271426536',
    projectId: 'linkup-60ba5',
    storageBucket: 'linkup-60ba5.appspot.com',
  );
}
