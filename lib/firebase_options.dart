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
    apiKey: 'AIzaSyBpocIgeTBkcPfRgKRukd0ytR5VvaeMx8E',
    appId: '1:529926372992:web:430a1245425085b3e2f065',
    messagingSenderId: '529926372992',
    projectId: 'fail-2c718',
    authDomain: 'fail-2c718.firebaseapp.com',
    storageBucket: 'fail-2c718.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCrrX5NAgR_YVB7Ebq2tUhWA6fiJgrFCcA',
    appId: '1:529926372992:android:a16ee51b76b3ae17e2f065',
    messagingSenderId: '529926372992',
    projectId: 'fail-2c718',
    storageBucket: 'fail-2c718.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCVCEPvp0BLRa_JQLh4mcj3pC9gkNjT4PU',
    appId: '1:529926372992:ios:2804588b1c34b9e4e2f065',
    messagingSenderId: '529926372992',
    projectId: 'fail-2c718',
    storageBucket: 'fail-2c718.appspot.com',
    androidClientId: '529926372992-9pd1priqkelijdnbb1nitedom6mdo9nd.apps.googleusercontent.com',
    iosClientId: '529926372992-85i0dmp0e0ekras07l33f2n86ug534a2.apps.googleusercontent.com',
    iosBundleId: 'com.example.database',
  );
}
