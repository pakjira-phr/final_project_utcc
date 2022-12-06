import 'package:flutter/material.dart';

import 'constant.dart';
// import 'dart:developer' as devtools show log;

import 'intro_screen/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(const MyApp());
  runApp(MaterialApp(
    title: appName,
    theme: ThemeData(
        brightness: Brightness.dark,
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
