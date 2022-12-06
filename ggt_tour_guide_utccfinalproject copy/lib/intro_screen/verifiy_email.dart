import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as devtools show log;

import '../constant.dart';
import '../utillties/custom_page_route.dart';
import '../utillties/get_message.dart';
import '../widget/show_error_dialog.dart';
import 'intro_auth.dart';
import 'login.dart';

class VerifiyEmailScreen extends StatefulWidget {
  const VerifiyEmailScreen({super.key});

  @override
  State<VerifiyEmailScreen> createState() => _VerifiyEmailScreenState();
}

class _VerifiyEmailScreenState extends State<VerifiyEmailScreen> {
  int secondsRemaining = 60;
  bool enableResend = false;
  bool visible = false;
  Timer? timer;
  @override
  initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        devtools.log("here");
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  dispose() {
    timer!.cancel();
    timer = null;
    super.dispose();
  }

  Future resendCode() async {
    devtools.log("1");
    User? user = FirebaseAuth.instance.currentUser;
    devtools.log("$user");
    await user?.sendEmailVerification();
    devtools.log("Send Email Verification");
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: size.height * 0.05,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Reset"),
                        content: Text(
                            'Tap actions to do somting with an account (${user?.email})'),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                try {
                                  await user?.delete();
                                  devtools.log('delete user');
                                  if (!mounted) return;
                                  Navigator.of(context).pushAndRemoveUntil(
                                      FadePageRoute(const IntroAuthScreen()),
                                      (Route<dynamic> route) => false);
                                } on FirebaseAuthException catch (e) {
                                  Navigator.of(context).pop();
                                  devtools.log(e.toString());
                                  devtools.log(getMessageFromErrorCode(e.code)
                                      .toString());
                                  showErrorDialog(
                                      context,
                                      getMessageFromErrorCode(e.code)
                                          .toString());
                                } catch (e) {
                                  devtools.log(e.toString());
                                }
                              },
                              child: const Text("Delete")),
                          TextButton(
                              onPressed: () async {
                                devtools.log('logout');
                                await FirebaseAuth.instance.signOut();
                                if (!mounted) return;
                                Navigator.of(context).pushAndRemoveUntil(
                                    FadePageRoute(const IntroAuthScreen()),
                                    (Route<dynamic> route) => false);
                              },
                              child: const Text("Logout")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"))
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.reset_tv))
          ],
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: primaryBackgroundColor,
          elevation: 0,
        ),
        backgroundColor: primaryBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Text(
                    "Verify Email",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "We previously sent you a confirmation email (${user?.email}). Please open and follow the steps in the email to confirm your email address.",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: deactivatedText,
                            fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "If you successfully verified your email\nPlease Login again",
                        style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 16),
                  child: InkWell(
                    onTap: () async {
                      devtools.log("go to LoginScreen");
                      Navigator.of(context)
                          .push(FadePageRoute(const LoginScreen()));
                    },
                    child: Container(
                      height: 50,
                      width: size.width * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primaryColor,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.5),
                        //     spreadRadius: 2,
                        //     blurRadius: 7,
                        //     offset: const Offset(
                        //         0, 3), // changes position of shadow
                        //   ),
                        // ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              color: secondaryBackgroundColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Didn’t get verification email ?",
                        style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                      icon: visible
                          ? const Icon(Icons.arrow_drop_down_circle_sharp)
                          : const Icon(Icons.arrow_drop_down_sharp),
                      color: primaryColor,
                    )
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Visibility(
                  visible: visible,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "If you didn’t get an email verifying your account after you set it up, follow the steps below.",
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "1. Check your spam or bulk mail folder.\n2. If you haven’t an email verify, tou can sent new verification email at botton below.",
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 20, 0, 10),
                            child: InkWell(
                              onTap: () async {
                                devtools.log("enableResend : $enableResend");
                                if (enableResend) {
                                  setState(() {
                                    secondsRemaining = 60;
                                    enableResend = false;
                                  });
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  devtools.log("$user");
                                  await user?.sendEmailVerification();
                                  devtools.log("Send Email Verification off");
                                } else {
                                  devtools.log("can't tap");
                                  return;
                                }

                                devtools.log("sent link");
                              },
                              child: Container(
                                height: 50,
                                width: enableResend
                                    ? size.width * 0.85
                                    : size.width * 0.6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: enableResend
                                      ? primaryColor
                                      : secondaryBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      enableResend
                                          ? 'Sent Link'
                                          : 'Please check your email',
                                      style: TextStyle(
                                        color: enableResend
                                            ? secondaryBackgroundColor
                                            : primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: enableResend ? 0 : size.width * 0.1,
                          ),
                          Center(
                            child: Text(
                              enableResend ? '' : '$secondsRemaining',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
