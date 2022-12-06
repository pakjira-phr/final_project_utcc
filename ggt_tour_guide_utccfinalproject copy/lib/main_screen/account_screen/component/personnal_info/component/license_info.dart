import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;

import '../../../../../constant.dart';
import '../../../../../intro_screen/privacy_policy.dart';
import '../../../../../utillties/custom_page_route.dart';
import '../../../../../utillties/get_message.dart';
import '../../../../../utillties/show_sheet_picker.dart';
import '../../../../../widget/popup_dialog.dart';
import '../../../../../widget/show_error_dialog.dart';
import '../../../../../widget/text_form.dart';

class LicenseInfo extends StatefulWidget {
  const LicenseInfo({super.key});

  @override
  State<LicenseInfo> createState() => _LicenseInfoState();
}

class _LicenseInfoState extends State<LicenseInfo> {
  TextEditingController? licenseNumController;
  TextEditingController? typeOfLicenseController;
  String? licenseCardPicURL;

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();

  bool isLoading = false;
  bool loadingSuss = false;
  bool isChangePhotoLoading = false;
  bool dataMap = false;
  Map<String, dynamic>? userData;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    licenseNumController = TextEditingController();
    typeOfLicenseController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    licenseNumController?.dispose();
    typeOfLicenseController?.dispose();
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
              licenseNumController?.text = userData!['licenseCardNo'];
              typeOfLicenseController?.text = userData!['typeOfLicense'];
              licenseCardPicURL = userData!['licenseCardPic'];
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
                      padding:
                          const EdgeInsets.only(left: 30, right: 20, top: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "License Card Information",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: 28),
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
                            SizedBox(height: size.height * 0.03),
                            SizedBox(
                              width: size.width * 0.9,
                              height: size.height * 0.34,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Tourist Guide License Card",
                                    style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                        fontSize: 16),
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  licenseCardPicURL == '' ||
                                          licenseCardPicURL == null
                                      ? Image.asset(
                                          'assets/images/tempPassportPic.png',
                                          width: size.width * 0.9,
                                          height: size.height * 0.3,
                                          fit: BoxFit.cover,
                                        )
                                      : SizedBox(
                                          width: size.width * 0.9,
                                          height: size.height * 0.3,
                                          child: CachedNetworkImage(
                                            imageUrl: licenseCardPicURL!,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(color: Colors.white,),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),

                                  // Image.network(
                                  //     licenseCardPicURL!,
                                  //     width: size.width * 0.9,
                                  //     height: size.height * 0.3,
                                  //   )
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Center(
                                child: InkWell(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        isChangePhotoLoading = true;
                                      });
                                      devtools.log('tap Change Photo');
                                      XFile? pickedFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      devtools.log('Photo');
                                      try {
                                        File image = File(pickedFile!.path);
                                        devtools.log(image.toString());

                                        final pictureRef = storageRef
                                            .child("photo")
                                            .child('${user?.uid}')
                                            .child("licenseCard.jpg");
                                        await pictureRef
                                            .putFile(image)
                                            .whenComplete(() =>
                                                devtools.log('image added'));
                                        String link =
                                            await pictureRef.getDownloadURL();
                                        devtools.log('Uploaded');
                                        // user?.updatePhotoURL(link);
                                        devtools.log('licenseCardPic : $link');
                                        firestore
                                            .collection('users')
                                            .doc('${user?.uid}')
                                            .update({'licenseCardPic': link});
                                        devtools.log('data added to firestore');
                                        setState(() {
                                          licenseCardPicURL = link;
                                          isChangePhotoLoading = false;
                                        });
                                        if (!mounted) return;
                                        showPopupDialog(
                                            context,
                                            'Uplode Photo Successfully',
                                            'Success', [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("OK"))
                                        ]);
                                      } catch (e) {
                                        devtools.log(e.toString());
                                        if (e.toString() ==
                                            'Null check operator used on a null value') {
                                          if (!mounted) return;
                                          showErrorDialog(context,
                                              'You did not choose any image');
                                        } else {
                                          if (!mounted) return;
                                          showErrorDialog(
                                              context, e.toString());
                                        }

                                        setState(() {
                                          isChangePhotoLoading = false;
                                        });
                                      }
                                    },
                                    child: Container(
                                        height: size.height * 0.05,
                                        width: size.width * 0.4,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ]),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, right: 16.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  isChangePhotoLoading
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            CircularProgressIndicator(
                                                              color:
                                                                  Colors.black,
                                                            )
                                                          ],
                                                        )
                                                      : Text(
                                                          licenseCardPicURL ==
                                                                  ''
                                                              ? 'Uplode Photo'
                                                              : 'Change Photo',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                ]))))),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, bottom: 10),
                                child: Form(
                                    key: formKey,
                                    child: Column(children: [
                                      Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                            right: size.width / 30,
                                          ),
                                          decoration: BoxDecoration(
                                            // color: Colors.white.withOpacity(.4),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: buildTypeOfLicenseFormField()),
                                      SizedBox(height: size.height * 0.015),
                                      textForm(
                                        null,
                                        'Enter your license card No.',
                                        false,
                                        false,
                                        licenseNumController,
                                        context,
                                        null,
                                        MultiValidator([
                                          RequiredValidator(
                                              errorText: 'ID is required'),
                                          MinLengthValidator(7,
                                              errorText:
                                                  'ID must be at least 7 digits long'),
                                          MaxLengthValidator(7,
                                              errorText:
                                                  'ID must less than 7 characters'),
                                        ]),
                                        'License Card No.',
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
                                    isLoading = true;
                                  });
                                  if (formKey.currentState!.validate() &&
                                      licenseCardPicURL != '') {
                                    formKey.currentState!.save();

                                    try {
                                      firestore
                                          .collection('users')
                                          .doc('${user?.uid}')
                                          .update({
                                        'licenseCardNo':
                                            licenseNumController?.text,
                                        'typeOfLicense':
                                            typeOfLicenseController?.text,
                                        'licenseCardpic': licenseCardPicURL,
                                      }).then((value) => showPopupDialog(
                                                context,
                                                'Update License Card Information Successful',
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
                                      devtools
                                          .log(getMessageFromErrorCode(e.code));
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
                                  } else if (licenseCardPicURL == '') {
                                    showErrorDialog(context,
                                        'Please uplode your license card');
                                    setState(() {
                                      isLoading = false;
                                    });
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
                                    Navigator.of(context).push(FadePageRoute(
                                        const PrivacyPolicyScreen()));
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
                            SizedBox(height: size.height * 0.04),
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
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        });
  }

  int selectedTypeOfLicenseValue = 0;
  TextFormField buildTypeOfLicenseFormField() {
    Widget buildTypeOfLicensePicker() => SizedBox(
        height: 180,
        child: CupertinoPicker(
            itemExtent: 30,
            scrollController: FixedExtentScrollController(
                initialItem: selectedTypeOfLicenseValue),
            children: const [
              Text('Genaral'),
              Text('Central region'),
              Text('North region'),
              Text('Northeast region'),
              Text('South region'),
              Text('Local'),
            ],
            onSelectedItemChanged: (value) {
              setState(() {
                selectedTypeOfLicenseValue = value;
                devtools.log(value.toString());
                if (value == 1) {
                  setState(() {
                    typeOfLicenseController?.text = 'Central region';
                  });
                } else if (value == 2) {
                  setState(() {
                    typeOfLicenseController?.text = 'North region';
                  });
                } else if (value == 3) {
                  setState(() {
                    typeOfLicenseController?.text = 'Northeast region';
                  });
                } else if (value == 4) {
                  setState(() {
                    typeOfLicenseController?.text = 'South region';
                  });
                } else if (value == 5) {
                  setState(() {
                    typeOfLicenseController?.text = 'Local';
                  });
                } else {
                  setState(() {
                    typeOfLicenseController?.text = 'Genaral';
                  });
                }
              });
            }));
    return TextFormField(
        validator: RequiredValidator(errorText: 'Type Of License is required'),
        controller: typeOfLicenseController,
        style: TextStyle(color: secondaryBackgroundColor),
        readOnly: true,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: secondaryBackgroundColor),
          labelStyle: TextStyle(color: secondaryBackgroundColor),
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
          labelText: "Type Of License",
          hintText: "Select your type of license",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.blueAccent),
            gapPadding: 10,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
          suffixIcon: Icon(
            Icons.arrow_drop_down_circle,
            color: primaryTextColor,
          ),
        ),
        onTap: () {
          showSheet(
            context,
            child: buildTypeOfLicensePicker(),
            onClicked: () {
              // final value = Stext; // เก็บค่าอยู่ในนี้
              // setStext(value);

              Navigator.of(context, rootNavigator: true).pop();
              devtools.log('${typeOfLicenseController?.text}');
              if (typeOfLicenseController?.text == 'Genaral' ||
                  typeOfLicenseController?.text == 'Central region') {
              } else {
                devtools.log('${typeOfLicenseController?.text}');
                showPopupDialog(context, 'You can not get job in Bangkok',
                    'For your information', [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"))
                ]);
              }
              // print(value);
            },
          );
        });
  }
}
