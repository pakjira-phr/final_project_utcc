import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ggt_tourist_utccfinalproject/intro_screen/verifiy_email.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/main_screen.dart';

import '../constant.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

import 'intro_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseFirestore? firestore;
  User? user;

  @override
  void initState() {
    //For debug จะได้ไม่ต้องขึ้น keybord ค้าง
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  Future checkUserdb() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Future.delayed(const Duration(milliseconds: 2000));
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: checkUserdb(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (user != null) {
                if (user!.emailVerified) {
                  devtools.log('emailVerified');
                  return MainScreen(index: 0);
                } else {
                  devtools.log('not verified');
                  devtools.log('user : $user');
                  return const VerifiyEmailScreen();

                }
              } else {
                // return const IntroScreen();
                devtools.log('go to IntroAuthScreen');
                devtools.log('user : $user');
                return const IntroAuthScreen();
              }
            default:
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: primaryBackgroundColor),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/TouristLogo2.png',
                      width: size.width * 0.5,
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                      child: Text(
                        'Welcome to',
                        style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: tertiaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                      child: Text(
                        appName,
                        style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: tertiaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 120),
                      child: Text(
                        'Globle Guide Thailand',
                        style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: tertiaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    CircularProgressIndicator(
                      color: tertiaryColor,
                    ),
                  ],
                ),
              );
          }
        }),
      ),
    );
  }
}
