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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyANzHZnUgz2x8dcOc1bPIY3nmHh3NsHBUQ',
    appId: '1:262858953950:web:657f462ac6f8f404e01e4f',
    messagingSenderId: '262858953950',
    projectId: 'project-3-hadi',
    authDomain: 'project-3-hadi.firebaseapp.com',
    storageBucket: 'project-3-hadi.appspot.com',
    measurementId: 'G-WYJMMBSWX2',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7uxwUoJ78u3VZXgPfDSWL_Hmjayvy2wQ',
    appId: '1:262858953950:ios:ddf2e8008768d5e3e01e4f',
    messagingSenderId: '262858953950',
    projectId: 'project-3-hadi',
    storageBucket: 'project-3-hadi.appspot.com',
    iosClientId: '262858953950-nrls47pgadm87v7ut2ns6fnq3hb7tjs9.apps.googleusercontent.com',
    iosBundleId: 'com.example.project4',
  );
}
