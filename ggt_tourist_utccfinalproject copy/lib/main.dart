import 'package:flutter/material.dart';

import 'constant.dart';
// import 'dart:developer' as devtools show log;

import 'intro_screen/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(const MyApp());
  runApp(const MaterialApp(
    title: appName,
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
