import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:ggt_tourist_utccfinalproject/intro_screen/forgot_password.dart';
import 'package:ggt_tourist_utccfinalproject/intro_screen/register_screen.dart';
import 'package:ggt_tourist_utccfinalproject/intro_screen/verifiy_email.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/main_screen.dart';

import '../utillties/custom_page_route.dart';
import '../utillties/get_message.dart';
import '../utillties/validator.dart';
import '../widget/show_error_dialog.dart';
import '../widget/text_form.dart';
import 'dart:developer' as devtools show log;

import 'intro_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool password = true;
  bool isLoading = false;
  String? passportPicURL;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  final storageRef = FirebaseStorage.instance.ref();

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
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).pushAndRemoveUntil(
                FadePageRoute(const IntroAuthScreen()),
                (Route<dynamic> route) => false);
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
                            color: deactivatedText,
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
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
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
                                      fontSize: 12,
                                      color: primaryColor),
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
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              _formKey.currentState!.save();
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
                                              'touristID': user?.uid,
                                              'userName': user?.displayName,
                                              'email': emailController?.text,
                                              'password(Debug)':
                                                  passwordController?.text,
                                              'firstName': '',
                                              'lastName': '',
                                              'birthDay': '',
                                              'passportOrIDCardPic': '',
                                              'passportID': '',
                                              'ThaiIDNumber': '',
                                              'national': '',
                                              'photoProfileURL':
                                                  user?.photoURL ?? 'null',
                                              'phoneNumber':
                                                  user?.phoneNumber ?? '',
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
                              color: tertiaryColor,
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
                                color: deactivatedText,
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
                                  color: primaryColor,
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
