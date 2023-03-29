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
    apiKey: 'AIzaSyC1cmDuND2RDAuqd-NAORL3uKDeuq8PeuY',
    appId: '1:852677675867:web:79af04a5220164fc59287e',
    messagingSenderId: '852677675867',
    projectId: 'chat-playground-201a3',
    authDomain: 'chat-playground-201a3.firebaseapp.com',
    storageBucket: 'chat-playground-201a3.appspot.com',
    measurementId: 'G-00KNTWBP35',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCavlo6NA9zxqX2mdvWZNdxhQ-_XAjPAdU',
    appId: '1:852677675867:android:b6022f206de88cd359287e',
    messagingSenderId: '852677675867',
    projectId: 'chat-playground-201a3',
    storageBucket: 'chat-playground-201a3.appspot.com',
  );
}
