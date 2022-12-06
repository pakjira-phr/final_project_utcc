import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; //ใช้ DataFormat แต่มันขึ้นเตือนเลย ignore
import 'package:language_picker/languages.dart';
import '../../../../../constant.dart';
import '../../../../../intro_screen/privacy_policy.dart';
import '../../../../../utillties/custom_page_route.dart';
import '../../../../../utillties/get_message.dart';
import '../../../../../utillties/show_sheet_picker.dart';
import '../../../../../widget/popup_dialog.dart';
import '../../../../../widget/show_error_dialog.dart';
import '../../../../../widget/text_form.dart';
import 'dart:developer' as devtools show log;
import 'package:language_picker/language_picker.dart';

class GeneralInfo extends StatefulWidget {
  const GeneralInfo({super.key});

  @override
  State<GeneralInfo> createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  TextEditingController? fNameController;
  TextEditingController? lNameController;
  TextEditingController? birthdayController;
  TextEditingController? genderController;

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  bool loadingSuss = false;
  bool dataMap = false;
  Map<String, dynamic>? userData;
  Map<String, dynamic>? categoryData;
  final formKey = GlobalKey<FormState>();

  // multiple choice value
  List<String> aptitutes = [];

  List<String> languageList = [];

  // list of string options
  List<String> options = [
    // 'Sights & Landmarks',
    // 'Religious Sites',
    // 'Historic Sites',
    // 'Shopping',
    // 'Architectural Buildings',
    // 'Observation Decks & Towers',
    // 'Arenas & Stadiums',
    // 'Museums',
    // 'Nature & Parks',
    // 'Water & Amusement Parks',
    // 'Zoos & Aquariums',
  ];
  List<String> languagesOptions = [
    'English',
    'Mandarin Chinese',
    'Hindi',
    'Spanish',
    'French',
    'Arabic',
    'Russian ',
    'Portuguese',
    'Japanese',
    'German',
    'Indonesian/Malaysian',
    'Korean',
  ];

  @override
  void initState() {
    fNameController = TextEditingController();
    lNameController = TextEditingController();
    birthdayController = TextEditingController();
    genderController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    fNameController?.dispose();
    lNameController?.dispose();
    birthdayController?.dispose();
    genderController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference collectionRef = firestore.collection('users');
    CollectionReference collectionRef2 = firestore.collection('category');
    Widget buildDialogItem(Language language) => Row(
          children: <Widget>[
            Text(language.name),
          ],
        );
    void openLanguagePickerDialog() {
      showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: LanguagePickerDialog(
                titlePadding: const EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration:
                    const InputDecoration(hintText: 'Search...'),
                isSearchable: true,
                title: const Text('Select your language'),
                onValuePicked: (Language language) => setState(() {
                      devtools.log(language.name);
                      devtools.log(language.isoCode);
                      if (!languageList.contains(language.name)) {
                        if (!languagesOptions.contains(language.name)) {
                          languagesOptions.add(language.name);
                        }
                        languageList.add(language.name);
                      }
                    }),
                itemBuilder: buildDialogItem)),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
        future: collectionRef2.doc('category').get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done || loadingSuss) {
            if (!dataMap) {
              categoryData = snapshot.data!.data() as Map<String, dynamic>;
              List temp = categoryData?['Types of Attractions'] ?? [];
              options = temp.map((e) => e.toString()).toList();
              // options = categoryData?['Types of Attractions'];
              devtools.log(options.toString());
            }
            return FutureBuilder<DocumentSnapshot>(
                future: collectionRef.doc(user!.uid).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done ||
                      loadingSuss) {
                    loadingSuss = true;
                    devtools.log(aptitutes.toString());
                    if (!dataMap) {
                      userData = snapshot.data!.data() as Map<String, dynamic>;
                      dataMap = true;
                      fNameController?.text = userData?['firstName'];
                      lNameController?.text = userData?['lastName'];
                      birthdayController?.text = userData?['birthDay'];
                      genderController?.text = userData?['gender'];
                      List tempLanguage = userData!['language'];
                      languageList = tempLanguage.cast<String>();
                      for (int i = 0; i < languageList.length; i++) {
                        if (!languagesOptions.contains(languageList[i])) {
                          languagesOptions.add(languageList[i]);
                        }
                      }
                      if (userData?['aptitutes'] == '') {
                        aptitutes = [];
                      } else {
                        List getDataAptitutes =
                            json.decode(userData?['aptitutes']) ?? [];
                        aptitutes =
                            getDataAptitutes.map((e) => e.toString()).toList();
                      }
                    }
                    devtools.log(aptitutes.toString());
                    return Scaffold(
                        // floatingActionButton: FloatingActionButton(
                        //   onPressed: () {

                        //   },
                        // ),
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
                                padding: const EdgeInsets.only(
                                    left: 30, right: 20, top: 20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // LanguagePickerDropdown(
                                      //     onValuePicked: (Language language) {
                                      //   print(language.name);
                                      // }),
                                      Text(
                                        "General Information",
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
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 30.0, bottom: 10),
                                          child: Form(
                                              key: formKey,
                                              child: Column(children: [
                                                textForm(
                                                  null,
                                                  'Enter your first name',
                                                  false,
                                                  false,
                                                  fNameController,
                                                  context,
                                                  null,
                                                  RequiredValidator(
                                                      errorText:
                                                          'First Name is required'),
                                                  'First Name',
                                                  null,
                                                  false,
                                                  false,
                                                ),
                                                SizedBox(
                                                    height:
                                                        size.height * 0.015),
                                                textForm(
                                                  null,
                                                  'Enter your last name',
                                                  false,
                                                  false,
                                                  lNameController,
                                                  context,
                                                  null,
                                                  RequiredValidator(
                                                      errorText:
                                                          'Last Name is required'),
                                                  'Last Name',
                                                  null,
                                                  false,
                                                  false,
                                                ),
                                                SizedBox(
                                                    height:
                                                        size.height * 0.015),
                                                Container(
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.only(
                                                      right: size.width / 30,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      // color: Colors.white.withOpacity(.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child:
                                                        buildBirthDayFormField()),
                                                SizedBox(
                                                    height:
                                                        size.height * 0.015),
                                                Container(
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.only(
                                                      right: size.width / 30,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      // color: Colors.white.withOpacity(.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: buildSexFormField()),
                                              ]))),
                                      SizedBox(height: size.height * 0.01),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: primaryBackgroundColor,
                                          border: Border.all(
                                              color: primaryTextColor,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: size.height * 0.01),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(
                                                  left: size.width * 0.02,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Please select the type of attraction you are good at.",
                                                        style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            color:
                                                                primaryTextColor,
                                                            fontSize: 15),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: primaryTextColor,
                                              thickness: 2,
                                            ),
                                            ChipsChoice<String>.multiple(
                                              value: aptitutes,
                                              onChanged: (val) {
                                                setState(() => aptitutes = val);
                                              },
                                              choiceItems: C2Choice.listFrom<
                                                  String, String>(
                                                source: options,
                                                value: (i, v) => v,
                                                label: (i, v) => v,
                                              ),
                                              choiceStyle: C2ChoiceStyle(
                                                color: Colors.black,
                                                borderColor: primaryTextColor,
                                              ),
                                              choiceActiveStyle: C2ChoiceStyle(
                                                  color: secondaryColor),
                                              wrapped: true,
                                              textDirection: null,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // SizedBox(height: size.height * 0.01),
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //     color: primaryBackgroundColor,
                                      //     border: Border.all(
                                      //         color: primaryTextColor,
                                      //         width: 2),
                                      //     borderRadius:
                                      //         BorderRadius.circular(15),
                                      //   ),
                                      //   child: Column(
                                      //     children: [
                                      //       SizedBox(
                                      //           height: size.height * 0.01),
                                      //       Padding(
                                      //         padding:
                                      //             const EdgeInsets.all(8.0),
                                      //         child: Container(
                                      //           alignment: Alignment.center,
                                      //           padding: EdgeInsets.only(
                                      //             left: size.width * 0.02,
                                      //           ),
                                      //           child: Row(
                                      //             children: [
                                      //               Expanded(
                                      //                 child: Text(
                                      //                   "Please select country by you can communicate in the official language.",
                                      //                   style: TextStyle(
                                      //                       // fontWeight: FontWeight.bold,
                                      //                       color:
                                      //                           primaryTextColor,
                                      //                       fontSize: 15),
                                      //                   textAlign:
                                      //                       TextAlign.center,
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       Divider(
                                      //         color: primaryTextColor,
                                      //         thickness: 2,
                                      //       ),
                                      //       ListView.builder(
                                      //           physics:
                                      //               const NeverScrollableScrollPhysics(),
                                      //           shrinkWrap: true,
                                      //           itemCount: language.length,
                                      //           itemBuilder: (context, index) {
                                      //             return Card(
                                      //               child: ListTile(
                                      //                 title:
                                      //                     Text(language[index]),
                                      //                 trailing: InkWell(
                                      //                   onTap: () {
                                      //                     setState(() {
                                      //                       language.remove(
                                      //                           language[
                                      //                               index]);
                                      //                     });
                                      //                   },
                                      //                   child: const Icon(Icons
                                      //                       .delete_outline),
                                      //                 ),
                                      //               ),
                                      //             );
                                      //           }),
                                      //       InkWell(
                                      //         onTap: () {
                                      //           showCountryPicker(
                                      //             context: context,
                                      //             onSelect: (Country country) {
                                      //               devtools.log(
                                      //                   'Select country: ${country.name}');
                                      //               setState(() {
                                      //                 language.add(country.name
                                      //                     .toString());
                                      //               });
                                      //             },
                                      //           );
                                      //         },
                                      //         child: const Card(
                                      //           child: ListTile(
                                      //             title: Text(
                                      //               'Add country...',
                                      //               style: TextStyle(
                                      //                   color: Colors.blue),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      SizedBox(height: size.height * 0.01),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: primaryBackgroundColor,
                                          border: Border.all(
                                              color: primaryTextColor,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: size.height * 0.01),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(
                                                  left: size.width * 0.02,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "Please select the language you are good at.",
                                                        style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            color:
                                                                primaryTextColor,
                                                            fontSize: 15),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: primaryTextColor,
                                              thickness: 2,
                                            ),
                                            ChipsChoice<String>.multiple(
                                              value: languageList,
                                              onChanged: (val) {
                                                setState(
                                                    () => languageList = val);
                                              },
                                              choiceItems: C2Choice.listFrom<
                                                  String, String>(
                                                source: languagesOptions,
                                                value: (i, v) => v,
                                                label: (i, v) => v,
                                              ),
                                              choiceStyle: C2ChoiceStyle(
                                                color: Colors.black,
                                                borderColor: primaryTextColor,
                                              ),
                                              choiceActiveStyle: C2ChoiceStyle(
                                                  color: secondaryColor),
                                              wrapped: true,
                                              textDirection: null,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: InkWell(
                                                onTap: () {
                                                  openLanguagePickerDialog();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    // color: Colors.amber,
                                                    color: secondaryColor,
                                                    border: Border.all(
                                                        color: secondaryColor,
                                                        width:
                                                            size.width * 0.005),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(20),
                                                      // topRight: Radius.circular(20),
                                                    ),
                                                  ),
                                                  height: size.height * 0.05,
                                                  width: size.width * 0.4,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Add more...',
                                                          // : 'Duration ${durationToString(durationCount.inMinutes)} hr',
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.width *
                                                                    0.04,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // -_-
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
                                                .validate()) {
                                              formKey.currentState!.save();

                                              try {
                                                firestore
                                                    .collection('users')
                                                    .doc('${user?.uid}')
                                                    .update({
                                                  'firstName':
                                                      fNameController?.text,
                                                  'lastName':
                                                      lNameController?.text,
                                                  'birthDay':
                                                      birthdayController?.text,
                                                  'gender':
                                                      genderController?.text,
                                                  'aptitutes':
                                                      jsonEncode(aptitutes),
                                                  'language': languageList,
                                                }).then((value) =>
                                                        showPopupDialog(
                                                          context,
                                                          'Update General Information Successful',
                                                          'Success',
                                                          [
                                                            TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    devtools.log(
                                                                        '${user?.displayName}');
                                                                    devtools.log(
                                                                        '${fNameController?.text}');
                                                                    devtools.log(
                                                                        'last');
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
                                            const EdgeInsets.only(bottom: 20.0),
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
                                                  // decoration: TextDecoration.underline,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.04),
                                    ]))));
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
}
