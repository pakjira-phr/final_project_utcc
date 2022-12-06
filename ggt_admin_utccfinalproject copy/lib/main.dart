import 'package:flutter/material.dart';
import 'package:ggt_admin_utccfinalproject/constant.dart';
import 'package:ggt_admin_utccfinalproject/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(const MyApp());
  runApp(MaterialApp(
    title: appName,
    theme: ThemeData(
        brightness: Brightness.light,
        // primarySwatch: primarySwatch,
        // ยังไม่ทำงาน เนื่องจาก font ผิด
        fontFamily: 'Lexend Deca'),
    home: const SplashScreen(),
    // routes: {
    //   loginRoute: (context) => const LoginView(),
    //   // registerRoute: (context) => const RegisterScreen(),
    //   // notesRoute: (context) => const NotesView(),
    //   // verifyEmailRoute: (context) => const VerifyEmailView(),
    // },
    debugShowCheckedModeBanner: false,
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const OverViewPage(),
//     );
//   }
// }

