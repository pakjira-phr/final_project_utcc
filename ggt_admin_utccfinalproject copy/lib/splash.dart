import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ggt_admin_utccfinalproject/login.dart';
import 'package:ggt_admin_utccfinalproject/main_page/main_page.dart';

import '../constant.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

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
  Future? getFuture;
  // bool check = false;

  @override
  void initState() {
    //For debug จะได้ไม่ต้องขึ้น keybord ค้าง
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    getFuture = checkUserdb();
    super.initState();
  }

  Future checkUserdb() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Future.delayed(const Duration(milliseconds: 2000));
    user = FirebaseAuth.instance.currentUser;
    // check = true;
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
        future: getFuture,
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // return const IntroScreen();
              if (user != null) {
                devtools.log('user : $user');
                devtools.log('user.uid : ${user?.uid}');
                return MainPage(index: 0);
              } else {
                devtools.log('go to Login');
                devtools.log('user : $user');
                return const LoginScreen();
              }
            default:
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(color: primaryBackgroundColor),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/logo.png',
                      width: size.width * 0.5,
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 120),
                      child: Column(
                        children: const [
                          Text(
                            'Globle Guide Thailand',
                            style: TextStyle(
                              // fontFamily: 'Lexend Deca',
                              color: primaryTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            'Admin',
                            style: TextStyle(
                              // fontFamily: 'Lexend Deca',
                              color: primaryTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircularProgressIndicator(
                      color: primaryColor,
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
