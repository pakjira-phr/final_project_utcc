import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/validator.dart';
import 'package:ggt_tourist_utccfinalproject/widget/text_form.dart';
import 'dart:developer' as devtools show log;

import '../../../constant.dart';
import '../../../utillties/custom_page_route.dart';
import '../../../utillties/get_message.dart';
import '../../../widget/popup_dialog.dart';
import '../../../widget/show_error_dialog.dart';
import '../../main_screen.dart';

// ignore: must_be_immutable
class AddressInfo extends StatefulWidget {
  AddressInfo({super.key, required this.isFromAccountScreen});
  bool isFromAccountScreen;

  @override
  // ignore: no_logic_in_create_state
  State<AddressInfo> createState() =>
      // ignore: no_logic_in_create_state
      _AddressInfoState(isFromAccountScreen: isFromAccountScreen);
}

class _AddressInfoState extends State<AddressInfo> {
  _AddressInfoState({required this.isFromAccountScreen});
  bool isFromAccountScreen;
  TextEditingController? addressController;
  TextEditingController? cityController;
  TextEditingController? postCodeController;

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool loadingSuss = false;
  bool dataMap = false;
  Map<String, dynamic>? userData;
  Map? contactAddress;

  @override
  void initState() {
    addressController = TextEditingController();
    cityController = TextEditingController();
    postCodeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    addressController?.dispose();
    cityController?.dispose();
    postCodeController?.dispose();
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
              contactAddress = userData?['contactAddress'];
              if (contactAddress == null) {
                addressController?.text = '';
                cityController?.text = '';
                postCodeController?.text = '';
              } else {
                addressController?.text = contactAddress?['address'];
                cityController?.text = contactAddress?['city'];
                postCodeController?.text = contactAddress?['postCode'];
              }
            }
            return Scaffold(
              backgroundColor: primaryBackgroundColor,
              appBar: AppBar(
                toolbarHeight: size.height * 0.06,
                backgroundColor: primaryColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: primaryTextColor),
                  onPressed: () {
                    // FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
                ),
                elevation: 0,
              ),
              body: SingleChildScrollView(
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 20, top: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Contact Address Information",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: 26),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: size.height * 0.01),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Please enter your real infomation\n\nThis Information will use for refund when you cancel booking",
                                    style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        color: deactivatedText,
                                        fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.01),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, bottom: 10),
                                child: Form(
                                    key: formKey,
                                    child: Column(children: [
                                      textForm(
                                        null,
                                        '00/00 NW Bobcat Lane, St. Robert',
                                        false,
                                        false,
                                        addressController,
                                        context,
                                        null,
                                        RequiredValidator(
                                            errorText: 'Address is required'),
                                        'Address',
                                        null,
                                        false,
                                        false,
                                      ),
                                      SizedBox(height: size.height * 0.02),
                                      textForm(
                                        null,
                                        'Nottingham',
                                        false,
                                        false,
                                        cityController,
                                        context,
                                        null,
                                        RequiredValidator(
                                            errorText: 'City is required'),
                                        'City',
                                        null,
                                        false,
                                        false,
                                      ),
                                      SizedBox(height: size.height * 0.02),
                                      textForm(
                                        null,
                                        '57000',
                                        false,
                                        false,
                                        postCodeController,
                                        context,
                                        null,
                                        postCodeValidator,
                                        'Post Code',
                                        null,
                                        true,
                                        false,
                                      ),
                                    ]))),
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
                                    contactAddress = {
                                      'address': addressController?.text,
                                      'city': cityController?.text,
                                      'postCode': postCodeController?.text,
                                    };
                                    try {
                                      firestore
                                          .collection('users')
                                          .doc('${user?.uid}')
                                          .update({
                                        'contactAddress': contactAddress,
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
                                                        if (isFromAccountScreen) {
                                                          Navigator.of(context)
                                                              .pushAndRemoveUntil(
                                                                  FadePageRoute(
                                                                      MainScreen(
                                                                          index:
                                                                              2)),
                                                                  (Route<dynamic>
                                                                          route) =>
                                                                      false);
                                                        } else {
                                                          Navigator.of(context)
                                                            ..pop()
                                                            ..pop();
                                                        }
                                                      },
                                                      child: const Text("OK"))
                                                ],
                                              ));

                                      devtools.log('update sussces');
                                    } on FirebaseAuthException catch (e) {
                                      devtools.log(e.toString());
                                      devtools
                                          .log(getMessageFromErrorCode(e.code));
                                      showErrorDialog(
                                          context,
                                          getMessageFromErrorCode(e.code)
                                              .toString());
                                      setState(() {
                                        isLoading = false;
                                      });
                                    } catch (e) {
                                      devtools.log(e.toString());
                                      showErrorDialog(context, e.toString());
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        isLoading
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(
                                                    color: tertiaryColor,
                                                  )
                                                ],
                                              )
                                            : Text(
                                                'Update',
                                                style: TextStyle(
                                                  color: tertiaryColor,
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
                          ]))),
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
            child: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          );
        });
  }
}
