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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBDbM50E78uztw6RqsyrU_sCeg1KT5HiPE',
    appId: '1:245189991911:web:15fa2ae2c9c5b7b464f142',
    messagingSenderId: '245189991911',
    projectId: 'notes-e7747',
    authDomain: 'notes-e7747.firebaseapp.com',
    storageBucket: 'notes-e7747.appspot.com',
    measurementId: 'G-TP79PCCP7P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAfq1Fuu7fLcxkr57D6jQAgk95Ee7MAF9w',
    appId: '1:245189991911:android:3aab7fe5300ba15f64f142',
    messagingSenderId: '245189991911',
    projectId: 'notes-e7747',
    storageBucket: 'notes-e7747.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvJedjzeBKih8efq5ZZrJ1MzXODVe_cEA',
    appId: '1:245189991911:ios:5283e248d1d1d30464f142',
    messagingSenderId: '245189991911',
    projectId: 'notes-e7747',
    storageBucket: 'notes-e7747.appspot.com',
    iosBundleId: 'com.example.notes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBvJedjzeBKih8efq5ZZrJ1MzXODVe_cEA',
    appId: '1:245189991911:ios:5283e248d1d1d30464f142',
    messagingSenderId: '245189991911',
    projectId: 'notes-e7747',
    storageBucket: 'notes-e7747.appspot.com',
    iosBundleId: 'com.example.notes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBDbM50E78uztw6RqsyrU_sCeg1KT5HiPE',
    appId: '1:245189991911:web:e9845fb7ea7e26fc64f142',
    messagingSenderId: '245189991911',
    projectId: 'notes-e7747',
    authDomain: 'notes-e7747.firebaseapp.com',
    storageBucket: 'notes-e7747.appspot.com',
    measurementId: 'G-C7BJJE1LWV',
  );

}