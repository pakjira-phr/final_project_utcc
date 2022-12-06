import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:ggt_tourist_utccfinalproject/intro_screen/privacy_policy.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/conutry_picker/country_picker.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/get_message.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/show_sheet_picker.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/validator.dart';
import 'package:ggt_tourist_utccfinalproject/widget/show_error_dialog.dart';
import 'package:ggt_tourist_utccfinalproject/widget/text_form.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; //ใช้ DataFormat แต่มันขึ้นเตือนเลย ignore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ggt_tourist_utccfinalproject/widget/popup_dialog.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:developer' as devtools show log;

import '../../../../../utillties/custom_page_route.dart';
import '../your_team.dart';

// ignore: must_be_immutable
class PersonnalInfo extends StatefulWidget {
  // const PersonnalInfo({super.key});
  PersonnalInfo({
    super.key,
    required this.attractions,
    required this.attractionsAndCategory,
    required this.durationCount,
    required this.tourGuide,
    required this.timeSelected,
    required this.numAdult,
    required this.numChildren,
    required this.sedanPrice,
    required this.sedanCount,
    required this.vanPrice,
    required this.vanCount,
    required this.planDate,
    required this.yourTeamInfo,
    required this.meetingPoint,
    required this.contactData,
  });
  Map attractions;
  List attractionsAndCategory;
  Duration durationCount;
  Map tourGuide;

  DateTime planDate;
  String? timeSelected;

  int numAdult;
  int numChildren;

  int sedanPrice;
  int sedanCount;
  int vanPrice;
  int vanCount;

  Map yourTeamInfo;
  Map meetingPoint;
  Map contactData;

  @override
  // ignore: no_logic_in_create_state
  State<PersonnalInfo> createState() => _PersonnalInfoState(
        attractions: attractions,
        attractionsAndCategory: attractionsAndCategory,
        tourGuide: tourGuide,
        timeSelected: timeSelected,
        numAdult: numAdult,
        numChildren: numChildren,
        sedanCount: sedanCount,
        sedanPrice: sedanPrice,
        vanCount: vanCount,
        vanPrice: vanPrice,
        planDate: planDate,
        yourTeamInfo: yourTeamInfo,
        durationCount: durationCount,
        meetingPoint: meetingPoint,
        contactData: contactData,
      );
}

class _PersonnalInfoState extends State<PersonnalInfo> {
  _PersonnalInfoState({
    // super.key,
    required this.attractions,
    required this.attractionsAndCategory,
    required this.durationCount,
    required this.tourGuide,
    required this.timeSelected,
    required this.numAdult,
    required this.numChildren,
    required this.sedanPrice,
    required this.sedanCount,
    required this.vanPrice,
    required this.vanCount,
    required this.planDate,
    required this.yourTeamInfo,
    required this.meetingPoint,
    required this.contactData,
  });
  Map attractions;
  List attractionsAndCategory;
  Duration durationCount;
  Map tourGuide;

  DateTime planDate;
  String? timeSelected;

  int numAdult;
  int numChildren;

  int sedanPrice;
  int sedanCount;
  int vanPrice;
  int vanCount;

  Map yourTeamInfo;
  Map meetingPoint;
  Map contactData;

  TextEditingController? fNameController;
  TextEditingController? lNameController;
  TextEditingController? birthdayController;
  TextEditingController? passportIDController;
  TextEditingController? nationalController;
  TextEditingController? thaiIDController;

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? passportPicURL;
  bool isLoading = false;
  bool isChangePhotoLoading = false;
  bool loadingSuss = false;
  bool dataMap = false;
  final formKey = GlobalKey<FormState>();
  final storageRef = FirebaseStorage.instance.ref();
  Map<String, dynamic>? userData;
  int selectedCardValue = 0;

  @override
  void initState() {
    fNameController = TextEditingController();
    lNameController = TextEditingController();
    birthdayController = TextEditingController();
    passportIDController = TextEditingController();
    nationalController = TextEditingController();
    thaiIDController = TextEditingController();
    // passportPicURL = user!.photoURL;
    // fNameController?.text = user!.displayName!;

    super.initState();
  }

  @override
  void dispose() {
    fNameController?.dispose();
    lNameController?.dispose();
    birthdayController?.dispose();
    passportIDController?.dispose();
    nationalController?.dispose();
    thaiIDController?.dispose();
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
            fNameController?.text = userData!['firstName'];
            lNameController?.text = userData!['lastName'];
            birthdayController?.text = userData!['birthDay'];
            passportIDController?.text = userData!['passportID'];
            thaiIDController?.text = userData!['ThaiIDNumber'];
            nationalController?.text = userData!['national'];
            passportPicURL = userData!['passportOrIDCardPic'];
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
              padding: const EdgeInsets.only(left: 30, right: 20, top: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Update Information",
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
                                color: deactivatedText,
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
                          const Text(
                            "Passport or Thai ID card",
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                          ),
                          SizedBox(height: size.height * 0.01),
                          passportPicURL == '' || passportPicURL == null
                              ? Image.asset(
                                  'assets/images/tempPassportPic.png',
                                  width: size.width * 0.9,
                                  height: size.height * 0.3,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: passportPicURL!,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                          // Image.network(
                          //     passportPicURL!,
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
                              .pickImage(source: ImageSource.gallery);
                          devtools.log('Photo');
                          try {
                            File image = File(pickedFile!.path);
                            devtools.log(image.toString());

                            final pictureRef = storageRef
                                .child("photo")
                                .child('${user?.uid}')
                                .child("passportPic.jpg");
                            await pictureRef.putFile(image).whenComplete(
                                () => devtools.log('image added'));
                            String link = await pictureRef.getDownloadURL();
                            devtools.log('Uploaded');
                            // user?.updatePhotoURL(link);
                            devtools.log('updatepassportOrIDCardPic : $link');
                            firestore
                                .collection('users')
                                .doc('${user?.uid}')
                                .update({'passportOrIDCardPic': link});
                            devtools.log('data added to firestore');
                            setState(() {
                              passportPicURL = link;
                              isChangePhotoLoading = false;
                            });
                            if (!mounted) return;
                            showPopupDialog(context,
                                'Uplode Photo Successfully', 'Success', [
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
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isChangePhotoLoading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          CircularProgressIndicator(
                                            color: Colors.black,
                                          )
                                        ],
                                      )
                                    : Text(
                                        passportPicURL == ''
                                            ? 'Uplode Photo'
                                            : 'Change Photo',
                                        style: TextStyle(
                                          color: tertiaryColor,
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
                        child: Column(
                          children: [
                            textForm(
                              null,
                              'Enter your first name',
                              false,
                              false,
                              fNameController,
                              context,
                              null,
                              RequiredValidator(
                                  errorText: 'First Name is required'),
                              'First Name',
                              null,
                              false,
                              false,
                            ),
                            SizedBox(height: size.height * 0.015),
                            textForm(
                              null,
                              'Enter your last name',
                              false,
                              false,
                              lNameController,
                              context,
                              null,
                              RequiredValidator(
                                  errorText: 'Last Name is required'),
                              'Last Name',
                              null,
                              false,
                              false,
                            ),
                            SizedBox(height: size.height * 0.015),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                  right: size.width / 30,
                                ),
                                decoration: BoxDecoration(
                                  // color: Colors.white.withOpacity(.4),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: buildBirthDayFormField()),
                            SizedBox(height: size.height * 0.015),
                            buildPassportIDCardField(),
                            SizedBox(height: size.height * 0.015),
                            buildThaiIDCardField(),
                            SizedBox(height: size.height * 0.015),
                            textForm2(
                              null,
                              'Where are you from?',
                              false,
                              false,
                              nationalController,
                              context,
                              Icon(
                                Icons.arrow_drop_down_circle,
                                color: primaryTextColor,
                              ),
                              RequiredValidator(
                                  errorText: 'Country is required'),
                              'Country',
                              null,
                              false,
                              true,
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
                          if (formKey.currentState!.validate() &&
                              passportPicURL != '') {
                            formKey.currentState!.save();

                            try {
                              firestore
                                  .collection('users')
                                  .doc('${user?.uid}')
                                  .update({
                                'firstName': fNameController?.text,
                                'lastName': lNameController?.text,
                                'birthDay': birthdayController?.text,
                                'passportID': passportIDController?.text,
                                'ThaiIDNumber': thaiIDController?.text,
                                'national': nationalController?.text
                              }).then((value) => showPopupDialog(
                                        context,
                                        'Update Personnal Information Successful',
                                        'Success',
                                        [
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  devtools.log(
                                                      '${user?.displayName}');
                                                  devtools.log(
                                                      '${fNameController?.text}');
                                                  devtools.log('last');
                                                  isLoading = false;
                                                });
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        FadePageRoute(YourTeam(
                                                          attractions:
                                                              attractions,
                                                          attractionsAndCategory:
                                                              attractionsAndCategory,
                                                          numAdult: numAdult,
                                                          numChildren:
                                                              numChildren,
                                                          planDate: planDate,
                                                          sedanCount:
                                                              sedanCount,
                                                          sedanPrice:
                                                              sedanPrice,
                                                          timeSelected:
                                                              timeSelected,
                                                          tourGuide: tourGuide,
                                                          vanCount: vanCount,
                                                          vanPrice: vanPrice,
                                                          yourTeamInfo:
                                                              yourTeamInfo,
                                                          durationCount:
                                                              durationCount,
                                                          meetingPoint:
                                                              meetingPoint,
                                                          contactData:
                                                              contactData,
                                                        )),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
                                                // Navigator.of(context)
                                                //     .pushAndRemoveUntil(
                                                //         FadePageRoute(
                                                //             MainScreen(
                                                //                 index: 2)),
                                                //         (Route<dynamic>
                                                //                 route) =>
                                                //             false);
                                              },
                                              child: const Text("OK"))
                                        ],
                                      ));

                              devtools.log('update sussces');
                            } on FirebaseAuthException catch (e) {
                              devtools.log(e.toString());
                              devtools.log(getMessageFromErrorCode(e.code));
                              showErrorDialog(context,
                                  getMessageFromErrorCode(e.code).toString());
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
                          } else if (passportPicURL == '') {
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
                            borderRadius: BorderRadius.circular(8 + 32 * (1)),
                            color: primaryColor,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(height: size.height * 0.04),
                  ]),
            )),
          );
        }
        return Container(
          decoration: BoxDecoration(color: primaryBackgroundColor),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  TextFormField buildBirthDayFormField() {
    DateTime dateTime = DateTime.now();
    Widget buildDatePicker() => SizedBox(
          height: 180,
          child: CupertinoDatePicker(
            minimumYear: 1900,
            maximumYear: DateTime.now().year,
            maximumDate: DateTime.now(),
            initialDateTime: dateTime,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (dateTimeNew) =>
                setState(() => dateTime = dateTimeNew),
          ),
        );
    return TextFormField(
        validator: RequiredValidator(errorText: 'Birthday is required'),
        controller: birthdayController,
        readOnly: true,
        decoration: InputDecoration(
          fillColor: Colors.black.withOpacity(.03),
          filled: false,
          labelText: 'Birthday',
          hintText: 'DD-MM-YYYY',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.blueAccent),
            gapPadding: 10,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
        ),
        onTap: () {
          showSheet(
            context,
            child: buildDatePicker(),
            onClicked: () {
              final value =
                  DateFormat('dd-MM-yyyy').format(dateTime); // เก็บค่าอยู่ในนี้
              devtools.log('selected date : $value');
              birthdayController?.text = value.toString();

              Navigator.of(context).pop();
            },
          );
        });
  }

  Widget buildThaiIDCardField() {
    Size size = MediaQuery.of(context).size;
    return Container(
      // height: size.width / 6,
      // width: size.width / 1.2,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        right: size.width / 30,
      ),
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        readOnly: passportIDController?.text != '' ? true : false,
        validator: passportIDController?.text != ''
            ? nullValidator
            : thaiIDCardValidator,
        style: TextStyle(color: Colors.black.withOpacity(.8)),
        cursorColor: Colors.black,
        controller: thaiIDController,
        keyboardType: TextInputType.number,
        autocorrect: false,
        decoration: InputDecoration(
          fillColor: Colors.black.withOpacity(.08),
          filled: passportIDController?.text != '' ? true : false,
          labelText: 'Thai Citizen ID',
          hintText: 'or Thai Citizen ID',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.blueAccent),
            gapPadding: 10,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
        ),
      ),
    );
  }

  bool checkthaiID() {
    bool a = true;
    if (thaiIDController?.text != '') {
      a = true;
      nationalController?.text = 'Thailand';
    } else {
      a = false;
    }
    return a;
  }

  Widget buildPassportIDCardField() {
    Size size = MediaQuery.of(context).size;
    return Container(
      // height: size.width / 6,
      // width: size.width / 1.2,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        right: size.width / 30,
      ),
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        readOnly: checkthaiID(),
        validator: thaiIDController?.text == ''
            ? RequiredValidator(errorText: 'Passport ID is required')
            : nullValidator,
        style: TextStyle(color: Colors.black.withOpacity(.8)),
        cursorColor: Colors.black,
        controller: passportIDController,
        // keyboardType: TextInputType.,
        autocorrect: false,
        decoration: InputDecoration(
          fillColor: Colors.black.withOpacity(.08),
          filled: checkthaiID(),
          labelText: 'Passport ID',
          hintText: 'Enter Your Passport ID',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.blueAccent),
            gapPadding: 10,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
        ),
      ),
    );
  }

  Widget textForm2(
      IconData? icon,
      String? hintText,
      bool isPassword,
      bool isEmail,
      TextEditingController? textEditingController,
      BuildContext context,
      Widget? suffixIcon,
      String? Function(String?)? validator,
      String? labelText,
      void Function()? ontap,
      bool isPhonenumber,
      bool isneedToggel) {
    Size size = MediaQuery.of(context).size;

    return Container(
      // height: size.width / 6,
      // width: size.width / 1.2,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        right: size.width / 30,
      ),
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        readOnly: true,
        validator: validator,
        style: TextStyle(color: Colors.black.withOpacity(.8)),
        cursorColor: Colors.black,
        obscureText: isPassword,
        controller: textEditingController,
        enableSuggestions: isPassword ? false : true,
        inputFormatters: isPhonenumber
            ? [
                FilteringTextInputFormatter.digitsOnly,
              ]
            : [],
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : isPhonenumber
                ? TextInputType.phone
                : TextInputType.text,
        autocorrect: false,
        decoration: InputDecoration(
          fillColor: Colors.black.withOpacity(.03),
          filled: false,
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.blueAccent),
            gapPadding: 10,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
          suffixIcon: isneedToggel
              ? suffixIcon
              : Icon(
                  icon,
                  color: primaryTextColor,
                ),
        ),
        onTap: () {
          checkthaiID()
              ? showPopupDialog(
                  context,
                  "You have Thai Citizen ID, So you don't need to select other country",
                  'Thailand',
                  [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"))
                  ],
                )
              : showCountryPicker(
                  context: context,
                  onSelect: (Country country) {
                    devtools.log('Select country: ${country.name}');
                    setState(() {
                      nationalController?.text = country.name;
                    });
                  },
                );
        },
      ),
    );
  }
}
