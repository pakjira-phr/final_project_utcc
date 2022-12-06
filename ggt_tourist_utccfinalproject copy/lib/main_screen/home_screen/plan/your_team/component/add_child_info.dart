import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/plan/your_team/your_team.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/validator.dart';

import '../../../../../constant.dart';
import '../../../../../utillties/conutry_picker/country_picker.dart';
import '../../../../../utillties/custom_page_route.dart';

import 'dart:developer' as devtools show log;

import '../../../../../widget/popup_dialog.dart';
import '../../../../../widget/text_form.dart';

// ignore: must_be_immutable
class AddChildrenInfo extends StatefulWidget {
  // const AddInfo({super.key});
  AddChildrenInfo({
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
    required this.thisInfo,
    required this.index,
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
  List thisInfo;
  int index;
   Map meetingPoint;
    Map contactData;

  @override
  // ignore: no_logic_in_create_state
  State<AddChildrenInfo> createState() => _AddChildrenInfoState(
      attractions: attractions,
      attractionsAndCategory: attractionsAndCategory,
      numAdult: numAdult,
      numChildren: numChildren,
      planDate: planDate,
      sedanCount: sedanCount,
      sedanPrice: sedanPrice,
      timeSelected: timeSelected,
      tourGuide: tourGuide,
      vanCount: vanCount,
      vanPrice: vanPrice,
      yourTeamInfo: yourTeamInfo,
      thisInfo: thisInfo,
      index: index,
      durationCount: durationCount,meetingPoint: meetingPoint,contactData: contactData,);
}

class _AddChildrenInfoState extends State<AddChildrenInfo> {
  _AddChildrenInfoState({
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
    required this.thisInfo,
    required this.index,
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
  List thisInfo;
  int index;
   Map meetingPoint;
    Map contactData;

  TextEditingController? fNameController;
  TextEditingController? lNameController;
  TextEditingController? passportIDController;
  TextEditingController? nationalController;
  TextEditingController? thaiIDController;

  @override
  void initState() {
    fNameController = TextEditingController();
    lNameController = TextEditingController();
    passportIDController = TextEditingController();
    nationalController = TextEditingController();
    thaiIDController = TextEditingController();
    // passportPicURL = user!.photoURL;
    // fNameController?.text = user!.displayName!;
    if (thisInfo.isNotEmpty) {
      fNameController?.text = thisInfo[0];
      lNameController?.text = thisInfo[1];
      passportIDController?.text = thisInfo[2];
      thaiIDController?.text = thisInfo[3];
      nationalController?.text = thisInfo[4];
    } else {
      fNameController?.text = '';
      lNameController?.text = '';
      passportIDController?.text = '';
      thaiIDController?.text = '';
      nationalController?.text = '';
    }

    super.initState();
  }

  @override
  void dispose() {
    fNameController?.dispose();
    lNameController?.dispose();
    passportIDController?.dispose();
    thaiIDController?.dispose();
    nationalController?.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    devtools.log(yourTeamInfo.toString());
    return Scaffold(
        backgroundColor: secondaryBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: secondaryBackgroundColor,
          elevation: 0,
          title: Text(
            "Children Information",
            style: TextStyle(
              color: tertiaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: primaryTextColor),
              onPressed: () {
                // List temp = [
                //   fNameController?.text,
                //   lNameController?.text,
                //   passportIDController?.text,
                //   thaiIDController?.text,
                //   nationalController?.text
                // ];
                // Map teamInfo = yourTeamInfo;
                // teamInfo['adultsInfo'][index] = temp;
                // devtools.log(teamInfo.toString());
                FocusScope.of(context).unfocus();
                Navigator.of(context).pushAndRemoveUntil(
                    FadePageRoute(YourTeam(
                      attractions: attractions,
                      attractionsAndCategory: attractionsAndCategory,
                      numAdult: numAdult,
                      numChildren: numChildren,
                      planDate: planDate,
                      sedanCount: sedanCount,
                      sedanPrice: sedanPrice,
                      timeSelected: timeSelected,
                      tourGuide: tourGuide,
                      vanCount: vanCount,
                      vanPrice: vanPrice,
                      yourTeamInfo: yourTeamInfo,
                      durationCount: durationCount,
                      meetingPoint: meetingPoint,
                      contactData: contactData,
                    )),
                    (Route<dynamic> route) => false);
              }),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 20, top: 20),
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
                        RequiredValidator(errorText: 'First Name is required'),
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
                        RequiredValidator(errorText: 'Last Name is required'),
                        'Last Name',
                        null,
                        false,
                        false,
                      ),
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
                        RequiredValidator(errorText: 'Country is required'),
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
                padding: const EdgeInsets.only(top: 25.0, left: 20, right: 20),
                child: InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    if (formKey.currentState!.validate()) {
                      List temp = [
                        fNameController?.text,
                        lNameController?.text,
                        passportIDController?.text,
                        thaiIDController?.text,
                        nationalController?.text
                      ];
                      Map teamInfo = yourTeamInfo;
                      teamInfo['childrenInfo'][index] = temp;
                      devtools.log(teamInfo.toString());
                      Navigator.of(context).pushAndRemoveUntil(
                          FadePageRoute(YourTeam(
                            attractions: attractions,
                            attractionsAndCategory: attractionsAndCategory,
                            numAdult: numAdult,
                            numChildren: numChildren,
                            planDate: planDate,
                            sedanCount: sedanCount,
                            sedanPrice: sedanPrice,
                            timeSelected: timeSelected,
                            tourGuide: tourGuide,
                            vanCount: vanCount,
                            vanPrice: vanPrice,
                            yourTeamInfo: teamInfo,
                            durationCount: durationCount, meetingPoint: meetingPoint,
                            contactData: contactData,
                          )),
                          (Route<dynamic> route) => false);
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
                          Text(
                            'Save',
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
            ],
          ),
        ));
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

        // decoration: InputDecoration(
        //     prefixIcon: Icon(
        //       icon,
        //       color: Colors.black.withOpacity(.7),
        //     ),
        //     fillColor: Colors.black.withOpacity(.05),
        //     border: InputBorder.none,
        //     hintMaxLines: 1,
        //     hintText: hintText,
        //     hintStyle:
        //         TextStyle(fontSize: 14, color: Colors.black.withOpacity(.5)),
        //     suffixIcon: suffixIcon),
      ),
    );
  }
}
//   Widget buildPassportIDCardField() {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       // height: size.width / 6,
//       // width: size.width / 1.2,
//       alignment: Alignment.center,
//       padding: EdgeInsets.only(
//         right: size.width / 30,
//       ),
//       decoration: BoxDecoration(
//         // color: Colors.white.withOpacity(.4),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: TextFormField(
//         readOnly: thaiIDController?.text != '' ? true : false,
//         validator: thaiIDController?.text == ''
//             ? RequiredValidator(errorText: 'Passport ID is required')
//             : nullValidator,
//         style: TextStyle(color: Colors.black.withOpacity(.8)),
//         cursorColor: Colors.black,
//         controller: passportIDController,
//         // keyboardType: TextInputType.,
//         autocorrect: false,
//         decoration: InputDecoration(
//           fillColor: Colors.black.withOpacity(.08),
//           filled: thaiIDController?.text != '' ? true : false,
//           labelText: 'Passport ID',
//           hintText: 'Enter Your Passport ID',
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(28),
//             borderSide: const BorderSide(color: Colors.blueAccent),
//             gapPadding: 10,
//           ),
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
//         ),
//       ),
//     );
//   }

//   Widget textForm2(
//       IconData? icon,
//       String? hintText,
//       bool isPassword,
//       bool isEmail,
//       TextEditingController? textEditingController,
//       BuildContext context,
//       Widget? suffixIcon,
//       String? Function(String?)? validator,
//       String? labelText,
//       void Function()? ontap,
//       bool isPhonenumber,
//       bool isneedToggel) {
//     Size size = MediaQuery.of(context).size;

//     return Container(
//       // height: size.width / 6,
//       // width: size.width / 1.2,
//       alignment: Alignment.center,
//       padding: EdgeInsets.only(
//         right: size.width / 30,
//       ),
//       decoration: BoxDecoration(
//         // color: Colors.white.withOpacity(.4),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: TextFormField(
//         readOnly: true,
//         validator: validator,
//         style: TextStyle(color: Colors.black.withOpacity(.8)),
//         cursorColor: Colors.black,
//         obscureText: isPassword,
//         controller: textEditingController,
//         enableSuggestions: isPassword ? false : true,
//         inputFormatters: isPhonenumber
//             ? [
//                 FilteringTextInputFormatter.digitsOnly,
//               ]
//             : [],
//         keyboardType: isEmail
//             ? TextInputType.emailAddress
//             : isPhonenumber
//                 ? TextInputType.phone
//                 : TextInputType.text,
//         autocorrect: false,

//         decoration: InputDecoration(
//           fillColor: Colors.black.withOpacity(.03),
//           filled: false,
//           labelText: labelText,
//           hintText: hintText,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(28),
//             borderSide: const BorderSide(color: Colors.blueAccent),
//             gapPadding: 10,
//           ),
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
//           suffixIcon: isneedToggel
//               ? suffixIcon
//               : Icon(
//                   icon,
//                   color: primaryTextColor,
//                 ),
//         ),
//         onTap: () {
//           showCountryPicker(
//             context: context,
//             onSelect: (Country country) {
//               devtools.log('Select country: ${country.name}');
//               setState(() {
//                 nationalController?.text = country.name;
//               });
//             },
//           );
//         },

//         // decoration: InputDecoration(
//         //     prefixIcon: Icon(
//         //       icon,
//         //       color: Colors.black.withOpacity(.7),
//         //     ),
//         //     fillColor: Colors.black.withOpacity(.05),
//         //     border: InputBorder.none,
//         //     hintMaxLines: 1,
//         //     hintText: hintText,
//         //     hintStyle:
//         //         TextStyle(fontSize: 14, color: Colors.black.withOpacity(.5)),
//         //     suffixIcon: suffixIcon),
//       ),
//     );
//   }
// }
