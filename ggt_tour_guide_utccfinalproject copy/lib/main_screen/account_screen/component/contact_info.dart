import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ggt_tour_guide_utccfinalproject/widget/text_form2.dart';

import '../../../constant.dart';
import '../../../intro_screen/privacy_policy.dart';
import '../../../utillties/custom_page_route.dart';
import '../../../utillties/get_message.dart';
import '../../../widget/popup_dialog.dart';
import '../../../widget/show_error_dialog.dart';
import '../../../widget/text_form.dart';

import 'dart:developer' as devtools show log;

class ContactInfo extends StatefulWidget {
  const ContactInfo({super.key});

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  TextEditingController? emailController;
  TextEditingController? phoneNumberController;

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool loadingSuss = false;
  bool dataMap = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController?.dispose();
    phoneNumberController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference collectionRef = firestore.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: collectionRef.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done || loadingSuss) {
          loadingSuss = true;
          if (!dataMap) {
            userData = snapshot.data!.data() as Map<String, dynamic>;
            dataMap = true;
            emailController?.text = userData!['email'];
            phoneNumberController?.text = userData!['phoneNumber'];
          }
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
                          "Contact Information",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                              fontSize: 30),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Please enter your real infomation",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                    fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                // Row(
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.only(left: 40),
                                //       child: Column(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.start,
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: [
                                //           Text('Email : '),
                                //           Padding(
                                //             padding: const EdgeInsets.only(
                                //                 top: 10, bottom: 10),
                                //             child: Text(
                                //                 '${emailController?.text}'),
                                //           ),
                                //         ],
                                //       ),
                                //     )
                                //   ],
                                // ),
                                textForm2(
                                  null,
                                  'Enter your email',
                                  false,
                                  false,
                                  emailController,
                                  context,
                                  null,
                                  RequiredValidator(
                                      errorText: 'Email is required'),
                                  'Email',
                                  null,
                                  false,
                                  false,
                                ),
                                SizedBox(height: size.height * 0.02),
                                textForm(
                                  null,
                                  '0800000000',
                                  false,
                                  false,
                                  phoneNumberController,
                                  context,
                                  null,
                                  RequiredValidator(
                                      errorText: 'Phone Number is required'),
                                  'Phone Number(+66)',
                                  null,
                                  false,
                                  false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                devtools.log(isLoading.toString());
                                isLoading = true;
                                devtools.log(isLoading.toString());
                              });
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                try {
                                  firestore
                                      .collection('users')
                                      .doc('${user?.uid}')
                                      .update({
                                    'email': emailController?.text,
                                    'phoneNumber': phoneNumberController?.text,
                                  }).then((value) => showPopupDialog(
                                            context,
                                            'Update Contact Information Successful',
                                            'Success',
                                            [
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    Navigator.of(context)
                                                      ..pop()
                                                      ..pop();
                                                  },
                                                  child: const Text("OK"))
                                            ],
                                          ));

                                  devtools.log('update sussces');
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
                                  // handle if reauthenticatation was not successful
                                } catch (e) {
                                  devtools.log(e.toString());
                                  showErrorDialog(context, e.toString());
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            child: Container(
                              height: 58,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(8 + 32 * (1)),
                                color: primaryColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    isLoading
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            ],
                                          )
                                        : const Text(
                                            'Update',
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
                        SizedBox(height: size.height * 0.015),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                    FadePageRoute(const PrivacyPolicyScreen()));
                              },
                              child: Text(
                                "Why do I need to provide my information",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: secondaryColor,
                                    // decoration: TextDecoration.underline,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ])),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [primaryColor, primaryTextColor, secondaryColor],
              //   stops: const [0, 0.5, 1],
              //   begin: const AlignmentDirectional(1, -1),
              //   end: const AlignmentDirectional(-1, 1),
              // ),
              color: primaryBackgroundColor),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
