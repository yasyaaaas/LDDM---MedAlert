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

  static FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAUNVYsAiBSg-PuNasQLaEJy4HO3LvYRyg',
    appId: '1:330083266186:web:1491363e1ffb219f3a8773',
    messagingSenderId: '330083266186',
    projectId: 'bdremedios-796da',
    authDomain: 'bdremedios-796da.firebaseapp.com',
    storageBucket: 'bdremedios-796da.firebasestorage.app',
    measurementId: 'G-S9RF83C5MP',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCWzkQVP_qDPNzUkVn38ofUrBjPLeaHHn0',
    appId: '1:330083266186:android:6d8bbcb8aad465be3a8773',
    messagingSenderId: '330083266186',
    projectId: 'bdremedios-796da',
    storageBucket: 'bdremedios-796da.firebasestorage.app',
  );

  static FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAUNVYsAiBSg-PuNasQLaEJy4HO3LvYRyg',
    appId: '1:330083266186:web:604d54a3506a6d7f3a8773',
    messagingSenderId: '330083266186',
    projectId: 'bdremedios-796da',
    authDomain: 'bdremedios-796da.firebaseapp.com',
    storageBucket: 'bdremedios-796da.firebasestorage.app',
    measurementId: 'G-B3YLYRKXD1',
  );
}
