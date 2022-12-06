import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

import '../main_screen/main_screen.dart';
import 'intro_auth.dart';
import 'verifiy_email.dart';

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
  // bool check = false;

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
    // เอาไว้ใช้ภายหลัง
    // FirebaseApp tourGuideApp = await Firebase.initializeApp(
    //   name: 'tourGuideApp',
    //   options: DefaultFirebaseOptionsTourGuide.currentPlatform,
    // );
    await Future.delayed(const Duration(milliseconds: 2000));
    user = FirebaseAuth.instance.currentUser;
  }

  // Future loginOut() async {
  //   devtools.log('logout');
  //   await FirebaseAuth.instance.signOut();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: checkUserdb(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:

              // return const IntroScreen();
              if (user != null) {
                if (user!.emailVerified) {
                  devtools.log('emailVerified');
                  // return check ? const HomeScreen() : const GetInfoIntro();
                  return MainScreen(index: 0);
                } else {
                  devtools.log('not verified');
                  // loginOut();
                  devtools.log('user : $user');
                  return const VerifiyEmailScreen();
                  // return const IntroScreen();
                  // return const Text('IntroScreen()');

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
                    // gradient: LinearGradient(
                    //   colors: [primaryColor, primaryTextColor, secondaryColor],
                    //   stops: const [0, 0.5, 1],
                    //   begin: const AlignmentDirectional(1, -1),
                    //   end: const AlignmentDirectional(-1, 1),
                    // ),
                    color: primaryBackgroundColor),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/TourGuideLogo2.png',
                      width: size.width * 0.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 24, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(
                            child: Text(
                              'Welcome to $appName',
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 120),
                      child: Column(
                        children: const [
                          Text(
                            'Globle Guide Thailand',
                            style: TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            'Tour Guide',
                            style: TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircularProgressIndicator(
                      color: Colors.white,
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
