import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ggt_tour_guide_utccfinalproject/constant.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as devtools show log;

import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../../../firebase_options_tourist.dart';
import '../../../../utillties/custom_page_route.dart';
import '../../../../utillties/get_message.dart';
import '../../../../utillties/show_sheet_picker.dart';
import '../../../../widget/popup_dialog.dart';
import '../../../../widget/show_error_dialog.dart';
import '../../../../widget/text_form.dart';
import '../job_detail.dart';

// ignore: must_be_immutable
class OutsideReplacer extends StatefulWidget {
  OutsideReplacer(
      {super.key,
      required this.detail,
      required this.indexToBack,
      required this.orderAllData});
  Map detail;
  int indexToBack;
  Map orderAllData;

  @override
  // ignore: no_logic_in_create_state
  State<OutsideReplacer> createState() => _OutsideReplacerState(
      detail: detail, indexToBack: indexToBack, orderAllData: orderAllData);
}

class _OutsideReplacerState extends State<OutsideReplacer> {
  _OutsideReplacerState(
      {required this.detail,
      required this.indexToBack,
      required this.orderAllData});
  Map detail;
  int indexToBack;
  Map orderAllData;

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();

  bool isLoading = false;
  bool loadingSuss = false;
  bool isChangePhotoLoading = false;
  bool dataMap = false;
  String link = '';

  final formKey = GlobalKey<FormState>();
  Map? replacer;
  TextEditingController? replacerLicenseNumController;
  TextEditingController? replacerTypeOfLicenseController;
  String? replacerLicenseCardPicURL;
  TextEditingController? fNameController;
  TextEditingController? lNameController;
  TextEditingController? birthdayController;
  TextEditingController? genderController;
  TextEditingController? emailController;
  TextEditingController? phoneNumberController;
  DateTime? planDate;

  @override
  void initState() {
    devtools.log('initState');
    replacer = detail['replacer'];
    replacerLicenseNumController = TextEditingController();
    replacerTypeOfLicenseController = TextEditingController();
    fNameController = TextEditingController();
    lNameController = TextEditingController();
    birthdayController = TextEditingController();
    genderController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    if (replacer != null) {
      replacerLicenseCardPicURL = replacer?['licenseCardURL'];
      replacerLicenseNumController?.text = replacer?['licenseCardNo'];
      replacerTypeOfLicenseController?.text = replacer?['typeOfLicense'];
      fNameController?.text = replacer?['firstName'];
      lNameController?.text = replacer?['lastName'];
      birthdayController?.text = replacer?['birthDay'];
      genderController?.text = replacer?['gender'];
      emailController?.text = replacer?['email'];
      phoneNumberController?.text = replacer?['phoneNumber'];
    }
    planDate = DateFormat("dd-MM-yyyy").parse(detail['datePlan']);
    super.initState();
  }

  @override
  void dispose() {
    replacerLicenseNumController?.dispose();
    replacerTypeOfLicenseController?.dispose();
    fNameController?.dispose();
    lNameController?.dispose();
    birthdayController?.dispose();
    genderController?.dispose();
    emailController?.dispose();
    phoneNumberController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     devtools.log("detail : $detail");
      //   },
      // ),
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryBackgroundColor,
        title: const Text('Replacer Infomation'),
        actions: replacer != null
            ? [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: const Icon(Icons.delete),
                    onTap: () {
                      showPopupDialog(
                          context,
                          'Are you sure to delete replacer information',
                          'Are you sure?', [
                        TextButton(
                            onPressed: () async {
                              detail.removeWhere(
                                  (key, value) => key == "replacer");
                              firestore
                                  .collection('users')
                                  .doc(user?.uid)
                                  .collection('order')
                                  .doc('${detail['jobOrderFileName']}')
                                  .update({
                                'replacer': FieldValue.delete()
                              }).whenComplete(() {
                                devtools.log('replacer Deleted');
                              });
                              Navigator.of(context).pushAndRemoveUntil(
                                  FadePageRoute(JobDetail(
                                    detail: detail,
                                    indexToBack: indexToBack,
                                    orderAllData: orderAllData,
                                  )),
                                  (Route<dynamic> route) => false);
                              // Navigator.of(context).pop();
                            },
                            child: const Text("OK")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"))
                      ]);
                    },
                  ),
                )
              ]
            : [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.9,
                height: size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Replacer Tourist Guide License Card",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 20),
                    ),
                    SizedBox(height: size.height * 0.01),
                    replacerLicenseCardPicURL == '' ||
                            replacerLicenseCardPicURL == null
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
                              imageUrl: replacerLicenseCardPicURL!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),

                    // Image.network(
                    //     replacerLicenseCardPicURL!,
                    //     width: size.width * 0.9,
                    //     height: size.height * 0.3,
                    //   ),
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
                                    .child('order')
                                    .child(
                                        '${detail['jobOrderFileName']}_guidereplacer')
                                    .child("replacerLicenseCard.jpg");
                                await pictureRef.putFile(image).whenComplete(
                                    () => devtools.log('image added'));
                                String link = await pictureRef.getDownloadURL();
                                devtools.log('Uploaded');
                                devtools.log('replacerLicenseCard : $link');
                                replacer?['replacerLicenseCard'] = link;
                                devtools.log('replacer : $replacer');

                                setState(() {
                                  replacerLicenseCardPicURL = link;
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
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  replacerLicenseCardPicURL ==
                                                              '' ||
                                                          replacerLicenseCardPicURL ==
                                                              null
                                                      ? 'Uplode Photo'
                                                      : 'Change Photo',
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                        ]))))),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 10),
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
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: buildTypeOfLicenseFormField()),
                        SizedBox(height: size.height * 0.015),
                        textForm(
                          null,
                          'Enter license card No.',
                          false,
                          false,
                          replacerLicenseNumController,
                          context,
                          null,
                          MultiValidator([
                            RequiredValidator(errorText: 'ID is required'),
                            MinLengthValidator(7,
                                errorText: 'ID must be at least 7 digits long'),
                            MaxLengthValidator(7,
                                errorText: 'ID must less than 7 characters'),
                          ]),
                          'License Card No.',
                          null,
                          true,
                          false,
                        ),
                        SizedBox(height: size.height * 0.015),
                        textForm(
                          null,
                          'Enter first name',
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
                          'Enter last name',
                          false,
                          false,
                          lNameController,
                          context,
                          null,
                          RequiredValidator(errorText: 'Last Name is required'),
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
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                              right: size.width / 30,
                            ),
                            decoration: BoxDecoration(
                              // color: Colors.white.withOpacity(.4),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: buildSexFormField()),
                        SizedBox(height: size.height * 0.015),
                        textForm(
                          null,
                          'Enter your email',
                          false,
                          false,
                          emailController,
                          context,
                          null,
                          RequiredValidator(errorText: 'Email is required'),
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
                          true,
                          false,
                        ),
                      ]))),
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 50),
                child: InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      isLoading = true;
                    });
                    if (formKey.currentState!.validate() &&
                        !(replacerLicenseCardPicURL == null)) {
                      formKey.currentState!.save();
                      replacer = {
                        'firstName': fNameController?.text,
                        'lastName': lNameController?.text,
                        'birthDay': birthdayController?.text,
                        'gender': genderController?.text,
                        'licenseCardURL': replacerLicenseCardPicURL,
                        'licenseCardNo': replacerLicenseNumController?.text,
                        'typeOfLicense': replacerTypeOfLicenseController?.text,
                        'email': emailController?.text,
                        'phoneNumber': phoneNumberController?.text,
                        'replacerType': 'outside_replacer',
                      };
                      detail['replacer'] = replacer;
                      try {
                        FirebaseApp touristApp = await Firebase.initializeApp(
                          name: 'touristApp',
                          options:
                              DefaultFirebaseOptionsTourist.currentPlatform,
                        );
                        FirebaseFirestore touristAppFirestore =
                            FirebaseFirestore.instanceFor(app: touristApp);

                        touristAppFirestore
                            .collection('users')
                            .doc(detail['touristUid'])
                            .collection('order')
                            .doc('${detail['jobOrderFileName']}')
                            .update({
                          'replacer': replacer,
                        }).then((value) {
                          setState(() {
                            devtools.log("doc touristApp update replacer");
                          });
                        });

                        String today = DateFormat("EEEE, dd MMMM " 'yyyy')
                            .format(DateTime.now());
                        String date =
                            DateFormat("dd MMMM yyyy").format(planDate!);
                        String tourOperatorName = 'Globle Guide'; //ข้อมูลสมมุติ
                        String licenseNo = '1101893'; //ข้อมูลสมมุติ
                        String tourGuideName =
                            '${replacer?["firstName"]} ${replacer?["lastName"]}';
                        String licensetourGuideNo =
                            '${replacer?["licenseCardNo"]}';
                        List attractionData = [];
                        // devtools.log('${detail['attractions']['attractionsSelected']}');
                        for (int i = 0;
                            i <
                                detail['attractions']['attractionsSelected']
                                    .length;
                            i++) {
                          List temp = [];
                          temp.add(date);
                          temp.add(
                              detail['attractions']['attractionsSelected'][i]);
                          attractionData.add(temp);
                        }
                        await _createPDF(
                            int.parse(detail['jobOrderFileName'].toString()),
                            today,
                            tourOperatorName,
                            licenseNo,
                            tourGuideName,
                            licensetourGuideNo,
                            int.parse(detail['tourGuideFee'].toString()),
                            int.parse(detail['numAdults'].toString()),
                            int.parse(detail['numChilds'].toString()),
                            json.decode(detail['touristData']),
                            attractionData);

                        //update
                        firestore
                            .collection('users')
                            .doc(user?.uid)
                            .collection('order')
                            .doc('${detail['jobOrderFileName']}')
                            .update({'replacer': replacer}).then((value) =>
                                showPopupDialog(
                                  context,
                                  'Update Replacer Information Successful',
                                  'Success',
                                  [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          // if (!mounted) return;
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  FadePageRoute(JobDetail(
                                                    detail: detail,
                                                    indexToBack: indexToBack,
                                                    orderAllData: orderAllData,
                                                  )),
                                                  (Route<dynamic> route) =>
                                                      false);
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
                        // handle if reauthenticatation was not successful
                      } catch (e) {
                        devtools.log(e.toString());
                        showErrorDialog(context, e.toString());
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } else if (replacerLicenseCardPicURL == null) {
                      showErrorDialog(context, 'Please uplode license card');
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
                                  'Save',
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
        ),
      ),
    );
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
              // Text('North region'),
              // Text('Northeast region'),
              // Text('South region'),
              // Text('Local'),
            ],
            onSelectedItemChanged: (value) {
              setState(() {
                selectedTypeOfLicenseValue = value;
                devtools.log(value.toString());
                if (value == 1) {
                  setState(() {
                    replacerTypeOfLicenseController?.text = 'Central region';
                  });
                  // } else if (value == 2) {
                  //   setState(() {
                  //     replacerTypeOfLicenseController?.text = 'North region';
                  //   });
                  // } else if (value == 3) {
                  //   setState(() {
                  //     replacerTypeOfLicenseController?.text = 'Northeast region';
                  //   });
                  // } else if (value == 4) {
                  //   setState(() {
                  //     replacerTypeOfLicenseController?.text = 'South region';
                  //   });
                  // } else if (value == 5) {
                  //   setState(() {
                  //     replacerTypeOfLicenseController?.text = 'Local';
                  //   });
                } else {
                  setState(() {
                    replacerTypeOfLicenseController?.text = 'Genaral';
                  });
                }
              });
            }));
    return TextFormField(
        validator: RequiredValidator(errorText: 'Type Of License is required'),
        controller: replacerTypeOfLicenseController,
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
          hintText: "Select type of license",
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
              devtools.log('${replacerTypeOfLicenseController?.text}');
              if (replacerTypeOfLicenseController?.text == 'Genaral' ||
                  replacerTypeOfLicenseController?.text == 'Central region') {
              } else {
                devtools.log('${replacerTypeOfLicenseController?.text}');
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

  int selectedGenderValue = 0;
  TextFormField buildSexFormField() {
    Widget buildGenderPicker() => SizedBox(
        height: 180,
        child: CupertinoPicker(
            itemExtent: 30,
            scrollController: FixedExtentScrollController(initialItem: 2),
            children: const [
              Text('Male'),
              Text('Female'),
              Text('Other'),
            ],
            onSelectedItemChanged: (value) {
              setState(() {
                selectedGenderValue = value;
                devtools.log(value.toString());
                if (value == 1) {
                  setState(() {
                    genderController?.text = 'Female';
                  });
                } else if (value == 2) {
                  setState(() {
                    genderController?.text = 'Other';
                  });
                } else {
                  setState(() {
                    genderController?.text = 'Male';
                  });
                }
              });
            }));
    return TextFormField(
        validator: RequiredValidator(errorText: 'Gender is required'),
        controller: genderController,
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
          labelText: "Gender",
          hintText: "Select your gender",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.blueAccent),
            gapPadding: 10,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        ),
        onTap: () {
          showSheet(
            context,
            child: buildGenderPicker(),
            onClicked: () {
              // final value = Stext; // เก็บค่าอยู่ในนี้
              // setStext(value);
              Navigator.of(context, rootNavigator: true).pop();
              // print(value);
            },
          );
        });
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
        style: TextStyle(color: secondaryBackgroundColor),
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
          suffixIcon: Icon(
            Icons.arrow_drop_down_circle,
            color: primaryTextColor,
          ),
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

  Future _createPDF(
      int id,
      String today,
      String tourOperatorName,
      String licenseNo,
      String tourGuideName,
      String licensetourGuideNo,
      int tourGuideFee,
      int numAdults,
      int numChilds,
      List touristData,
      List attractionData) async {
    devtools.log('in _createPDF');
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    final Size pageSize = page.getClientSize();

    PdfLayoutFormat layoutFormat = PdfLayoutFormat(
        layoutType: PdfLayoutType.paginate,
        breakType: PdfLayoutBreakType.fitPage);

    //header----------------------------------------------------------------
    page.graphics.drawString(
        'Job Order', PdfStandardFont(PdfFontFamily.helvetica, 24),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 30),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));
    page.graphics.drawLine(
        PdfPens.black, const Offset(50, 35), Offset(pageSize.width - 50, 35));

    //Box แรก-------------------------------------------------------------
    PdfTextElement(
            text: 'Tour operator',
            font: PdfStandardFont(PdfFontFamily.helvetica, 18),
            format: PdfStringFormat(
                alignment: PdfTextAlignment.center,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                10, 65, pageSize.width - 20, pageSize.height - 100))!;
    PdfTextElement(
            text:
                'License No. : $licenseNo\tJob Order Number: $id\tDate: $today',
            font: PdfStandardFont(PdfFontFamily.helvetica, 11),
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
            page: page,
            bounds:
                Rect.fromLTWH(10, 95, pageSize.width - 20, pageSize.height))!;
    PdfTextElement(
            text: 'Tour operator name : $tourOperatorName',
            font: PdfStandardFont(PdfFontFamily.helvetica, 11),
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
            page: page,
            bounds:
                Rect.fromLTWH(10, 110, pageSize.width - 20, pageSize.height))!;
    PdfTextElement(
            text:
                'Tour Guide name : $tourGuideName\tLicense number : $licensetourGuideNo',
            font: PdfStandardFont(PdfFontFamily.helvetica, 11),
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
            page: page,
            bounds:
                Rect.fromLTWH(10, 125, pageSize.width - 20, pageSize.height))!;
    PdfTextElement(
            text: 'Tour guide fee : $tourGuideFee',
            font: PdfStandardFont(PdfFontFamily.helvetica, 11),
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
            page: page,
            bounds:
                Rect.fromLTWH(10, 140, pageSize.width - 20, pageSize.height))!;

    //Line Box
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 50, pageSize.width, 115), pen: PdfPens.black);
    // page.graphics.drawLine(
    //     PdfPens.gray, const Offset(0, 165), Offset(pageSize.width, 165));

    //box2------------------------------------------------------------------

    PdfTextElement(
            text: 'List of Tourist',
            font: PdfStandardFont(PdfFontFamily.helvetica, 18),
            format: PdfStringFormat(
                alignment: PdfTextAlignment.center,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
            page: page,
            bounds:
                Rect.fromLTWH(10, 185, pageSize.width - 20, pageSize.height))!;

    PdfTextElement(
            text:
                'Number of toursit\tAdults : $numAdults\tChildent : $numChilds',
            font: PdfStandardFont(PdfFontFamily.helvetica, 9),
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(
                10, 205, pageSize.width - 20, pageSize.height - 100))!;

    getTouristTable(touristData).draw(
        page: page,
        bounds: Rect.fromLTWH(0, 220, pageSize.width, pageSize.height));

    PdfTextElement(
            text: 'Package Tour',
            font: PdfStandardFont(PdfFontFamily.helvetica, 18),
            format: PdfStringFormat(
                alignment: PdfTextAlignment.center,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
      page: page,
      bounds: Rect.fromLTWH(10, 220 + 34 + (22 * touristData.length) + 30,
          pageSize.width - 20, pageSize.height),
    )!;
    getPackageTourTable(attractionData).draw(
        page: page,
        bounds: Rect.fromLTWH(0, 220 + 34 + (22 * touristData.length) + 20 + 50,
            pageSize.width, pageSize.height),
        format: layoutFormat);

    //save launch file
    Future<List<int>> bytes = document.save();
    List<int> bytesList = await bytes;
    document.dispose();

    await saveAndLaunchFile(bytesList, '$id.pdf', id, planDate!);
  }

  PdfGrid getTouristTable(
    List touristData,
  ) {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 5);
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Number';
    headerRow.cells[1].value = 'Name-Sername';
    headerRow.cells[2].value = 'Thai ID No. or\nPassport No.';
    headerRow.cells[3].value = 'County';
    headerRow.cells[4].value = 'Note';

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = touristData[0][0];
    row.cells[1].value = touristData[0][1];
    row.cells[2].value = touristData[0][2];
    row.cells[3].value = touristData[0][3];

    for (int i = 1; i < touristData.length; i++) {
      row = grid.rows.add();
      row.cells[0].value = touristData[i][0];
      row.cells[1].value = touristData[i][1];
      row.cells[2].value = touristData[i][2];
      row.cells[3].value = touristData[i][3];
    }

    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      headerRow.cells[i].stringFormat.alignment = PdfTextAlignment.center;
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  PdfGrid getPackageTourTable(List attractionData) {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 3);
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Date';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Attraction ';
    headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[2].value = 'Note';
    headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = attractionData[0][0];
    row.cells[1].value = attractionData[0][1];

    for (int i = 1; i < attractionData.length; i++) {
      row = grid.rows.add();
      row.cells[0].value = attractionData[i][0];
      row.cells[1].value = attractionData[i][1];
    }

    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    // grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable1LightAccent2);

    return grid;
  }

  Future saveAndLaunchFile(
      List<int> bytesList, String fileName, int id, DateTime planDate) async {
    final path = Platform.isAndroid
        ? (await getExternalStorageDirectory())?.path
        : (await getApplicationSupportDirectory()).path;

    final file = File('$path/$fileName');
    await file.writeAsBytes(bytesList, flush: true);
    // OpenFile.open('$path/$fileName');

//-------------------------add to firebase--------------------------------------------------
    FirebaseApp touristApp = await Firebase.initializeApp(
      name: 'touristApp', //note ผิดแน่ แต่ทำงานได้ งงอยู่
      options: DefaultFirebaseOptionsTourist.currentPlatform,
    );
    final storage = FirebaseStorage.instanceFor(app: touristApp);
    final storageRef = storage.ref();
    final fileRef = storageRef.child("jobOrder").child('$id').child(fileName);
    await fileRef.putFile(file).whenComplete(() => devtools.log('pdf added'));
    link = await fileRef.getDownloadURL();
  }
}
