import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import '../utillties/get_message.dart';
import '../utillties/validator.dart';
import '../widget/show_error_dialog.dart';
import '../widget/text_form.dart';
import 'dart:developer' as devtools show log;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController? emailController;
  final formKey = GlobalKey<FormState>();
  bool check = false;
  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SnackBar snackBar = SnackBar(
      content: Text(
          'We alredy sent link to resent your password to ${emailController!.text}'),
    );

    resetPassword() async {
      String email = emailController!.text.trim();
      try {
        await auth.sendPasswordResetEmail(email: email);
        check = true;
      } on FirebaseAuthException catch (e) {
        devtools.log(e.toString());
        devtools.log(getMessageFromErrorCode(e.code).toString());
        showErrorDialog(context, getMessageFromErrorCode(e.code).toString());
      } catch (e) {
        devtools.log(e.toString());
      }
    }

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
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 30),
                child: Text(
                  "Forgot Password",
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
                        "We will send you an email with a link to reset your password, please enter the email associated with your account below.",
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
            padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Form(
                        key: formKey,
                        child: textForm(
                          Icons.mail_outlined,
                          'Email...',
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
                        )),
                  ),
                  SizedBox(height: size.height * 0.04),
                  InkWell(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final email = emailController!.text;
                      devtools.log(email);
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        resetPassword();
                        devtools.log('sent resetPassword email');
                        check
                            ? ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar)
                            : null;
                      } else {
                        devtools.log('not validate');
                      }
                    },
                    child: Container(
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8 + 32 * (1)),
                        color: primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Sent Link',
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
                ]),
          )
        ],
      )),
    );
  }
}
