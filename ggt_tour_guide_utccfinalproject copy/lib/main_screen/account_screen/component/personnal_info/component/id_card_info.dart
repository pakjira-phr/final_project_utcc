import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;

import '../../../../../constant.dart';
import '../../../../../intro_screen/privacy_policy.dart';
import '../../../../../utillties/custom_page_route.dart';
import '../../../../../utillties/get_message.dart';
import '../../../../../utillties/validator.dart';
import '../../../../../widget/popup_dialog.dart';
import '../../../../../widget/show_error_dialog.dart';
import '../../../../../widget/text_form.dart';

class IDCardInfo extends StatefulWidget {
  const IDCardInfo({super.key});

  @override
  State<IDCardInfo> createState() => _IDCardInfoState();
}

class _IDCardInfoState extends State<IDCardInfo> {
  TextEditingController? idNumController;
  String? idCardPicURL;

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
    idNumController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    idNumController?.dispose();
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
              idNumController?.text = userData!['thaiIdCardNo'];
              idCardPicURL = userData!['thaiIdCardPic'];
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
                              "Thai ID Card Information",
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
                            SizedBox(height: size.height * 0.03),
                            SizedBox(
                              width: size.width * 0.9,
                              height: size.height * 0.34,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Thai identification card",
                                    style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                        fontSize: 16),
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  idCardPicURL == '' || idCardPicURL == null
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
                                            imageUrl: idCardPicURL!,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(color: Colors.white,),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),

                                  // Image.network(
                                  //     idCardPicURL!,
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
                                            .child("thaiIDCard.jpg");
                                        await pictureRef
                                            .putFile(image)
                                            .whenComplete(() =>
                                                devtools.log('image added'));
                                        String link =
                                            await pictureRef.getDownloadURL();
                                        devtools.log('Uploaded');
                                        // user?.updatePhotoURL(link);
                                        devtools.log('thaiIdCardPic : $link');
                                        firestore
                                            .collection('users')
                                            .doc('${user?.uid}')
                                            .update({'thaiIdCardPic': link});
                                        devtools.log('data added to firestore');
                                        setState(() {
                                          idCardPicURL = link;
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
                                                          idCardPicURL == ''
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
                                      textForm(
                                        null,
                                        'Enter your Thai ID Card No.',
                                        false,
                                        false,
                                        idNumController,
                                        context,
                                        null,
                                        thaiIDCardValidator,
                                        'Thai ID Card No.',
                                        null,
                                        true,
                                        false,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 25.0),
                                        child: InkWell(
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();
                                            setState(() {
                                              devtools
                                                  .log(isLoading.toString());
                                              isLoading = true;
                                              devtools
                                                  .log(isLoading.toString());
                                            });
                                            if (formKey.currentState!
                                                    .validate() &&
                                                idCardPicURL != '') {
                                              formKey.currentState!.save();

                                              try {
                                                firestore
                                                    .collection('users')
                                                    .doc('${user?.uid}')
                                                    .update({
                                                  'thaiIdCardNo':
                                                      idNumController?.text,
                                                  'thaiIdCardPic': idCardPicURL,
                                                }).then((value) =>
                                                        showPopupDialog(
                                                          context,
                                                          'Update Thai ID Card Information Successful',
                                                          'Success',
                                                          [
                                                            TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    isLoading =
                                                                        false;
                                                                  });
                                                                  Navigator.of(
                                                                      context)
                                                                    ..pop()
                                                                    ..pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "OK"))
                                                          ],
                                                        ));

                                                devtools.log('update sussces');
                                              } on FirebaseAuthException catch (e) {
                                                devtools.log(e.toString());
                                                devtools.log(
                                                    getMessageFromErrorCode(
                                                        e.code));
                                                showErrorDialog(
                                                    context,
                                                    getMessageFromErrorCode(
                                                            e.code)
                                                        .toString());
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                // handle if reauthenticatation was not successful
                                              } catch (e) {
                                                devtools.log(e.toString());
                                                showErrorDialog(
                                                    context, e.toString());
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }
                                            } else if (idCardPicURL == '') {
                                              showErrorDialog(context,
                                                  'Please uplode your passport or Thai ID card');
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
                                                  BorderRadius.circular(
                                                      8 + 32 * (1)),
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
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                        )
                                                      : const Text(
                                                          'Update',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  FadePageRoute(
                                                      const PrivacyPolicyScreen()));
                                            },
                                            child: Text(
                                              "Why do I need to provide my information",
                                              style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  color: secondaryColor,
                                                  // decoration:
                                                  //     TextDecoration.underline,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]))),
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
}
