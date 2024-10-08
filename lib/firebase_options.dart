// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyBdLxqtilOZr_FssJr7965PTORVEmNG11E',
    appId: '1:996221582414:web:08219e0f7aff17baf6d71f',
    messagingSenderId: '996221582414',
    projectId: 'ektraksi-file-gpt-4',
    authDomain: 'ektraksi-file-gpt-4.firebaseapp.com',
    storageBucket: 'ektraksi-file-gpt-4.appspot.com',
    measurementId: 'G-9T6CMC0JCJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbuq8QOGMqzSmKnZ--C_e0vT0Rt5wr7E0',
    appId: '1:996221582414:android:dae87f47503fc0eaf6d71f',
    messagingSenderId: '996221582414',
    projectId: 'ektraksi-file-gpt-4',
    storageBucket: 'ektraksi-file-gpt-4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC6naoZ1kMdfGH70AvjIDhuYVNQV1y7n4c',
    appId: '1:996221582414:ios:3aaa9067e347ddeff6d71f',
    messagingSenderId: '996221582414',
    projectId: 'ektraksi-file-gpt-4',
    storageBucket: 'ektraksi-file-gpt-4.appspot.com',
    iosBundleId: 'com.example.aplikasiEkstraksiFileGpt4',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC6naoZ1kMdfGH70AvjIDhuYVNQV1y7n4c',
    appId: '1:996221582414:ios:3aaa9067e347ddeff6d71f',
    messagingSenderId: '996221582414',
    projectId: 'ektraksi-file-gpt-4',
    storageBucket: 'ektraksi-file-gpt-4.appspot.com',
    iosBundleId: 'com.example.aplikasiEkstraksiFileGpt4',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBdLxqtilOZr_FssJr7965PTORVEmNG11E',
    appId: '1:996221582414:web:1018539fcd39bcd3f6d71f',
    messagingSenderId: '996221582414',
    projectId: 'ektraksi-file-gpt-4',
    authDomain: 'ektraksi-file-gpt-4.firebaseapp.com',
    storageBucket: 'ektraksi-file-gpt-4.appspot.com',
    measurementId: 'G-T057NDJE1N',
  );
}
