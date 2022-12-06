import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as devtools show log;
import '../../../constant.dart';
import '../../../utillties/get_message.dart';
import '../../../utillties/validator.dart';
import '../../../widget/popup_dialog.dart';
import '../../../widget/show_error_dialog.dart';
import '../../../widget/text_form.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController? oldPassController;
  TextEditingController? newPassController;
  TextEditingController? conNewPassController;
  bool visOldPassword = true;
  bool visNewPassword = true;
  bool visConNewPassword = true;
  User? user;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void _toggle(int indexToggle) {
    setState(() {
      if (indexToggle == 0) {
        visOldPassword = !visOldPassword;
      } else if (indexToggle == 1) {
        visNewPassword = !visNewPassword;
      } else {
        visConNewPassword = !visConNewPassword;
      }
    });
  }

  @override
  void initState() {
    oldPassController = TextEditingController();
    newPassController = TextEditingController();
    conNewPassController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    oldPassController?.dispose();
    newPassController?.dispose();
    conNewPassController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    devtools.log('here');
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        toolbarHeight: size.height * 0.06,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: secondaryBackgroundColor),
          onPressed: () {
            // FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Change Password",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                  fontSize: 30),
              textAlign: TextAlign.left,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: textForm(
                          Icons.lock_outline,
                          'Enter your old password',
                          visOldPassword,
                          false,
                          oldPassController,
                          context,
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () => _toggle(0),
                              child: Icon(
                                visOldPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                          passwordValidator,
                          'Old password',
                          null,
                          false,
                          true),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: textForm(
                          Icons.lock_outline,
                          'Enter your New password',
                          visNewPassword,
                          false,
                          newPassController,
                          context,
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () => _toggle(1),
                              child: Icon(
                                visNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                          passwordValidator,
                          'New password',
                          null,
                          false,
                          true),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                          right: size.width / 30,
                        ),
                        child: TextFormField(
                          validator: (val) {
                            if (val == '' || val == null) {
                              return 'password is required';
                            }
                            if (val != newPassController!.text) {
                              return 'password Not Match';
                            }
                            return null;
                          },
                          style: TextStyle(color: secondaryBackgroundColor),
                          cursorColor: Colors.black,
                          obscureText: visConNewPassword,
                          controller: conNewPassController,
                          enableSuggestions: visConNewPassword ? false : true,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: secondaryBackgroundColor),
                            labelStyle:
                                TextStyle(color: secondaryBackgroundColor),
                            focusColor: secondaryColor,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: secondaryBackgroundColor,
                                width: 2.0,
                              ),
                            ),
                            fillColor: Colors.black.withOpacity(.03),
                            filled: false,
                            labelText: 'Confrim Password',
                            hintText: '******',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide:
                                  const BorderSide(color: Colors.blueAccent),
                              gapPadding: 10,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 42, vertical: 17),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                onTap: () => _toggle(2),
                                child: Icon(
                                  visConNewPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: primaryTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: InkWell(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    formKey.currentState!.save();
                    user = FirebaseAuth.instance.currentUser;
                    String? email = user?.email;
                    final credential = EmailAuthProvider.credential(
                        email: email.toString(),
                        password: oldPassController!.text);
                    try {
                      await user?.reauthenticateWithCredential(credential);
                      await user!
                          .updatePassword(conNewPassController!.text)
                          .then(
                            (value) => showPopupDialog(
                              context,
                              'Password Changed Successful',
                              'Success',
                              [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                        ..pop()
                                        ..pop();
                                    },
                                    child: const Text("OK"))
                              ],
                            ),
                          );
                      setState(() {
                        isLoading = false;
                      });
                      // devtools.log('True');
                    } on FirebaseAuthException catch (e) {
                      devtools.log(e.toString());
                      devtools.log(getMessageFromErrorCode(e.code));
                      showErrorDialog(
                          context, getMessageFromErrorCode(e.code).toString());
                      setState(() {
                        isLoading = false;
                      });
                      // handle if reauthenticatation was not successful
                    } catch (e) {
                      devtools.log(e.toString());
                      setState(() {
                        isLoading = false;
                      });
                    }
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
                      children: [
                        isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                ],
                              )
                            : const Text(
                                'Update Password',
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
          ],
        ),
      )),
    );
  }
}
