// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

// ใช้ในการ initializeApp ทุกครั้งที่จะต่อ
  // FirebaseApp tourGuideApp = await Firebase.initializeApp(
  //         name: 'tourGuideApp',
  //         options: DefaultFirebaseOptionsTourGuide.currentPlatform,
  //       );
  //       FirebaseFirestore tourGuideFirestore =
  //           FirebaseFirestore.instanceFor(app: tourGuideApp);

class DefaultFirebaseOptionsTourGuide {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdHg3wYRPfN8fj1FwBOpZqznVp1OK4a00',
    appId: '1:802699524528:android:c6e2b0d4b03dd17042be75',
    messagingSenderId: '802699524528',
    projectId: 'ggt-tourgiude-utccfp',
    storageBucket: 'ggt-tourgiude-utccfp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAGQxE0yJ3rAuFIFNxuxdjIgqnbjUqLaic',
    appId: '1:802699524528:ios:1a2efe8a7b18525a42be75',
    messagingSenderId: '802699524528',
    projectId: 'ggt-tourgiude-utccfp',
    storageBucket: 'ggt-tourgiude-utccfp.appspot.com',
    iosClientId: '802699524528-1u99d2lt774o1i24m0k51himqn06dn4t.apps.googleusercontent.com',
    iosBundleId: 'com.example.ggtTourGuideUtccfinalproject',
  );
}
