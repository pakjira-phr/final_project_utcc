import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/intro_screen/login.dart';
import 'package:ggt_tourist_utccfinalproject/intro_screen/privacy_policy.dart';
import 'package:ggt_tourist_utccfinalproject/intro_screen/terms_of_service.dart';
import 'package:ggt_tourist_utccfinalproject/intro_screen/verifiy_email.dart';

import '../../constant.dart';
import '../../utillties/custom_page_route.dart';
import '../../utillties/get_message.dart';
import '../../utillties/validator.dart';
import '../../widget/show_error_dialog.dart';
import '../../widget/text_form.dart';
import 'dart:developer' as devtools show log;

import 'intro_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController? userNameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? confirmPasswordController;

  bool password = true;
  bool conPassword = true;
  final formKey = GlobalKey<FormState>();
  bool isChecked = false;
  bool needCheck = false;
  bool isLoading = false;

  @override
  void initState() {
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    userNameController!.dispose();
    emailController!.dispose();
    passwordController!.dispose();
    confirmPasswordController!.dispose();
    super.dispose();
  }

  void toggle(int indexToggle) {
    if (indexToggle == 0) {
      setState(() {
        password = !password;
      });
    } else {
      setState(() {
        conPassword = !conPassword;
      });
    }
  }

  Color getColor(Set<MaterialState> states) {
    if (isChecked || needCheck) {
      if (isChecked) {
        return primaryColor;
      }
      return Colors.red;
    } else {
      return primaryColor;
    }
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
            FocusScope.of(context).unfocus();
            Navigator.of(context).pushAndRemoveUntil(
                FadePageRoute(const IntroAuthScreen()),
                (Route<dynamic> route) => false);
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 30),
            child: Text(
              "Create Account",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                  fontSize: 36),
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
                    "Create your account by filling in the information below to access the app.",
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: deactivatedText,
                        fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            textForm(
                              Icons.account_box_outlined,
                              'Nickname for your profile',
                              false,
                              false,
                              userNameController!,
                              context,
                              null,
                              userNameValidator,
                              'User Name',
                              null,
                              false,
                              false,
                            ),
                            SizedBox(height: size.height * 0.02),
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
                            SizedBox(height: size.height * 0.02),
                            textForm(
                              null,
                              '******',
                              password,
                              false,
                              passwordController!,
                              context,
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () => toggle(0),
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
                            SizedBox(height: size.height * 0.02),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                right: size.width / 30,
                              ),
                              child: TextFormField(
                                validator: (val) {
                                  if (val == '' || val == null) {
                                    return 'password is required';
                                  }
                                  if (val != passwordController!.text) {
                                    return 'password Not Match';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Colors.black.withOpacity(.8)),
                                cursorColor: Colors.black,
                                obscureText: conPassword,
                                controller: confirmPasswordController,
                                enableSuggestions: conPassword ? false : true,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  fillColor: Colors.black.withOpacity(.03),
                                  filled: true,
                                  labelText: 'Confrim Password',
                                  hintText: '******',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide: const BorderSide(
                                        color: Colors.blueAccent),
                                    gapPadding: 10,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 42, vertical: 17),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: InkWell(
                                      onTap: () => toggle(1),
                                      child: Icon(
                                        conPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Checkbox(
                                checkColor: tertiaryColor,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    FocusScope.of(context).unfocus();
                                    isChecked = value!;
                                  });
                                },
                              ),
                            ),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: "I have read and agree to our",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: primaryTextColor,
                                ),
                              ),
                              TextSpan(
                                text: " Terms of Service",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    FocusScope.of(context).unfocus();
                                    devtools.log("Go to TermsOfServiceScreen");
                                    Navigator.of(context).push(FadePageRoute(
                                        const TermsOfServiceScreen()));
                                  },
                                style: TextStyle(
                                  fontSize: 13,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "\nand our ",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: primaryTextColor,
                                ),
                              ),
                              TextSpan(
                                text: " Privacy Policy",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    FocusScope.of(context).unfocus();
                                    devtools.log("Go to PrivacyPolicyScreen");
                                    Navigator.of(context).push(FadePageRoute(
                                        const PrivacyPolicyScreen()));
                                  },
                                style: TextStyle(
                                  fontSize: 13,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ])),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: InkWell(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            String? email;
                            String? password;
                            String? userName;
                            setState(() {
                              email = emailController!.text;
                              password = passwordController!.text;
                              userName = userNameController!.text;
                            });

                            if (formKey.currentState!.validate()) {
                              if (isChecked != false) {
                                isLoading = true;
                                formKey.currentState!.save();
                                devtools.log('1');
                                try {
                                  final userCredential = await FirebaseAuth
                                      .instance
                                      .createUserWithEmailAndPassword(
                                          email: email!, password: password!);
                                  devtools.log('2');
                                  devtools.log(userCredential.toString());
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  await user?.updateDisplayName(userName);
                                  devtools.log(user.toString());
                                  await user?.sendEmailVerification();
                                  devtools.log('sent email verify');
                                  if (!mounted) return;
                                  isLoading = false;
                                  devtools.log('go to VerifiyEmailScreen');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const VerifiyEmailScreen())));
                                } on FirebaseAuthException catch (e) {
                                  devtools.log(e.toString());
                                  devtools.log(getMessageFromErrorCode(e.code));
                                  showErrorDialog(
                                      context,
                                      getMessageFromErrorCode(e.code)
                                          .toString());
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
                                setState(() {
                                  needCheck = true;
                                  isLoading = false;
                                });
                                devtools.log('not validate checkbox}');
                              }
                            } else {
                              setState(() {
                                needCheck = true;
                              });
                              devtools.log('not validate}');
                              devtools.log("$email:$password");
                              isLoading = false;
                            }
                          },
                          child: Container(
                            height: 58,
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
                                          'Create Account',
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
                              "Have an account? ",
                              style: TextStyle(
                                color: deactivatedText,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            InkWell(
                              onTap: (() {
                                devtools.log("Go to LoginScreen");
                                Navigator.of(context)
                                    .push(FadePageRoute(const LoginScreen()));
                              }),
                              child: Text(
                                'Login',
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
        ],
      )),
    );
  }
}
