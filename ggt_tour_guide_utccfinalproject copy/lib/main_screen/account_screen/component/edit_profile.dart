import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constant.dart';
import '../../../utillties/custom_page_route.dart';
import '../../../utillties/get_message.dart';
import '../../../utillties/validator.dart';
import '../../../widget/avatar.dart';
import 'dart:developer' as devtools show log;

import '../../../widget/popup_dialog.dart';
import '../../../widget/show_error_dialog.dart';
import '../../../widget/text_form.dart';
import '../../main_screen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController? userNameController;
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? profileURL;
  bool isLoading = false;
  bool isChangePhotoLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    userNameController = TextEditingController();
    userNameController?.text = user!.displayName!;
    profileURL = user!.photoURL;

    super.initState();
  }

  @override
  void dispose() {
    userNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                "Edit Profile",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: 30),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: size.height * 0.03),
              Avatar(
                avatarUrl: profileURL,
                onTap: () {
                  devtools.log('tap Avatar');
                },
              ),
              SizedBox(height: size.height * 0.02),
              Center(
                child: InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      isChangePhotoLoading = true;
                    });
                    devtools.log('tap Change Photo');

                    try {
                      XFile? pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      devtools.log('Photo');
                      File image = File(pickedFile!.path);
                      devtools.log(image.toString());
                      final storageRef = FirebaseStorage.instance.ref();
                      final pictureRef = storageRef
                          .child("photo")
                          .child('${user?.uid}')
                          .child("profile.jpg");
                      await pictureRef
                          .putFile(image)
                          .whenComplete(() => devtools.log('image added'));
                      final String link = await pictureRef.getDownloadURL();
                      devtools.log('Uploaded');
                      user?.updatePhotoURL(link);
                      devtools.log('updatePhotoURL : $link');
                      firestore
                          .collection('users')
                          .doc('${user?.uid}')
                          .update({'photoProfileURL': link});
                      devtools.log('data added to firestore');
                      setState(() {
                        profileURL = link;
                        isChangePhotoLoading = false;
                      });
                    } catch (e) {
                      devtools.log(e.toString());
                      if (e.toString() ==
                          'Null check operator used on a null value') {
                        if (!mounted) return;
                        showErrorDialog(
                            context, 'You did not choose any image');
                      } else {
                        if (!mounted) return;
                        showErrorDialog(context, e.toString());
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
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isChangePhotoLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircularProgressIndicator(
                                      color: Colors.black,
                                    )
                                  ],
                                )
                              : Text(
                                  'Change Photo',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                child: Form(
                  key: formKey,
                  child: textForm(
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
                        user
                            ?.updateDisplayName('${userNameController?.text}')
                            .then((value) => showPopupDialog(
                                  context,
                                  'Edit Profile Successful',
                                  'Success',
                                  [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            devtools
                                                .log('${user?.displayName}');
                                            devtools.log(
                                                '${userNameController?.text}');
                                            devtools.log('last');
                                            isLoading = false;
                                          });
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  FadePageRoute(
                                                      MainScreen(index: 3)),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        },
                                        child: const Text("OK"))
                                  ],
                                ));

                        // devtools.log('True');
                      } on FirebaseAuthException catch (e) {
                        devtools.log(e.toString());
                        devtools.log(getMessageFromErrorCode(e.code));
                        showErrorDialog(context,
                            getMessageFromErrorCode(e.code).toString());
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
                    } else {
                      setState(() {
                        isLoading = false;
                      });
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
                                  'Edit profile',
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
            ]),
      )),
    );
  }
}
