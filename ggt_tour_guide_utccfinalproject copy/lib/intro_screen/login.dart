import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import '../main_screen/main_screen.dart';
import '../utillties/custom_page_route.dart';
import '../utillties/get_message.dart';
import '../utillties/validator.dart';
import '../widget/show_error_dialog.dart';
import '../widget/text_form.dart';
import 'dart:developer' as devtools show log;

import 'forgot_password.dart';
import 'register.dart';
import 'verifiy_email.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool password = true;
  bool isLoading = false;
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController!.dispose();
    passwordController!.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      password = !password;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        toolbarHeight: size.height * 0.05,
        backgroundColor: primaryBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor),
          onPressed: () {
            // FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 30),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.045,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Use the form below to access your account.",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                            fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.5),
                //         spreadRadius: 2,
                //         blurRadius: 7,
                //         offset:
                //             const Offset(0, 3), // changes position of shadow
                //       ),
                //     ],
                //   ),
                //   child: Image.asset(
                //     'assets/logo/logo_temp.png',
                //     width: size.width * 0.8,
                //     height: size.height * 0.25,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            textForm(
                              Icons.email_outlined,
                              'your@email.com',
                              false,
                              true,
                              emailController!,
                              context,
                              null,
                              emailValidator,
                              'Email',
                              null,
                              false,
                              false,
                            ),
                            SizedBox(height: size.height * 0.03),
                            textForm(
                              Icons.lock_outline,
                              '******',
                              password,
                              false,
                              passwordController!,
                              context,
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () => _toggle(),
                                  child: Icon(
                                    password
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: primaryTextColor,
                                  ),
                                ),
                              ),
                              passwordValidator,
                              'Password',
                              null,
                              false,
                              true,
                            ),
                            InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                devtools.log('Go to ForgotPasswordPage');
                                Navigator.of(context).push(FadePageRoute(
                                    const ForgotPasswordScreen()));
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                margin: const EdgeInsets.all(10),
                                child: Text(
                                  "Forgot your password?",
                                  style: TextStyle(
                                      fontSize: 12, color: secondaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: InkWell(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            final email = emailController!.text;
                            final password = passwordController!.text;
                            devtools.log("$email:$password");
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              formKey.currentState!.save();
                              Map kpi = {
                               'score' :'5.0',
                               'ratingsCount' : '0',
                               '1star' : '0',
                               '2star' : '0',
                               '3star' : '0',
                               '4star' : '0',
                               '5star' : '0',
                              };
                              try {
                                final userCredential = await FirebaseAuth
                                    .instance
                                    .signInWithEmailAndPassword(
                                        email: email, password: password);
                                devtools.log(userCredential.toString());
                                final user = userCredential.user;
                                devtools.log(
                                    'user emailVerified : ${user?.emailVerified}');
                                if (user?.emailVerified ?? false) {
                                  devtools.log('emailVerified');
                                  FirebaseFirestore firestore =
                                      FirebaseFirestore.instance;
                                  var docRef = firestore
                                      .collection("users")
                                      .doc(user?.uid);
                                  await docRef.get().then((doc) => {
                                        if (doc.exists)
                                          {
                                            devtools.log("doc created"),
                                          }
                                        else
                                          {
                                            devtools.log("creating doc"),
                                            firestore
                                                .collection('users')
                                                .doc('${user?.uid}')
                                                .set({
                                              'user_name': user?.displayName,
                                              'email': emailController?.text,
                                              'password(Debug)':
                                                  passwordController?.text,
                                              'photoProfileURL':
                                                  user?.photoURL ?? 'null',
                                              'firstName': '',
                                              'lastName': '',
                                              'birthDay': '',
                                              'gender': '',
                                              'thaiIdCardNo': '',
                                              'thaiIdCardPic': '',
                                              'licenseCardNo': '',
                                              'typeOfLicense': '',
                                              'licenseCardpic': '',
                                              'aptitutes': '',
                                              'workDay': [],
                                              'freeDay': [],
                                              'language': [],
                                              'tourGuideID': user?.uid,
                                              'kpi':kpi
                                              
                                            }).then((value) {
                                              devtools.log("doc Added");
                                            })
                                          }
                                      });
                                  if (!mounted) return;
                                  Navigator.of(context).pushAndRemoveUntil(
                                      FadePageRoute(MainScreen(index: 0)),
                                      (Route<dynamic> route) => false);
                                } else {
                                  if (!mounted) return;
                                  setState(() {
                                    isLoading = false;
                                  });
                                  devtools.log('go to VerifiyEmailScreen');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const VerifiyEmailScreen())));
                                }
                              } on FirebaseAuthException catch (e) {
                                devtools.log(e.toString());
                                devtools.log(
                                    getMessageFromErrorCode(e.code).toString());
                                showErrorDialog(context,
                                    getMessageFromErrorCode(e.code).toString());
                                setState(() {
                                  isLoading = false;
                                });
                              } catch (e) {
                                devtools.log(e.toString());
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            } else {
                              devtools.log('_formKey not validate}');
                              devtools.log("$email:$password");
                            }
                          },
                          child: Container(
                            height: size.height * 0.07,
                            width: size.width * 0.9,
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
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            InkWell(
                              onTap: (() {
                                FocusScope.of(context).unfocus();
                                devtools.log("Go to RegisterPage");
                                Navigator.of(context).push(
                                    FadePageRoute(const RegisterScreen()));
                              }),
                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
