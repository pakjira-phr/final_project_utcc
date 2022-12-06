import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/plan/summary/summary.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/validator.dart';

import '../../../../../utillties/custom_page_route.dart';
import '../../../../../widget/text_form.dart';

// ignore: must_be_immutable
class ContactInfoOrder extends StatefulWidget {
  // const ContactInfoOrder({super.key});
  ContactInfoOrder({
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
    required this.contactData,
    required this.meetingPoint,
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
  Map contactData;
  Map meetingPoint;

  @override
  // ignore: no_logic_in_create_state
  State<ContactInfoOrder> createState() => _ContactInfoOrderState(
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
      contactData: contactData,
      meetingPoint: meetingPoint);
}

class _ContactInfoOrderState extends State<ContactInfoOrder> {
  _ContactInfoOrderState({
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
    required this.contactData,
    required this.meetingPoint,
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
  Map contactData;
  Map meetingPoint;

  final formKey = GlobalKey<FormState>();
  TextEditingController? emailController;
  TextEditingController? phoneNumberController;
  TextEditingController? nameController;
  @override
  void initState() {
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    nameController = TextEditingController();
    emailController?.text = '${contactData['email']}';
    phoneNumberController?.text = '${contactData['phoneNumber']}';
    nameController?.text = '${contactData['userName']}';
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
    return Scaffold(
        backgroundColor: secondaryBackgroundColor,
        appBar: AppBar(
          toolbarHeight: size.height * 0.06,
          backgroundColor: secondaryBackgroundColor,
          // title: Text(
          //   'Contact Information',
          //   style: TextStyle(color: primaryTextColor),
          // ),
          centerTitle: true,
          leading: IconButton(
            icon:
                Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor),
            onPressed: () {
              // FocusScope.of(context).unfocus();
              // Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                  FadePageRoute(Summary(
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
                    contactData: contactData,
                    meetingPoint: meetingPoint,
                  )),
                  (Route<dynamic> route) => false);
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
                            color: deactivatedText,
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
                      child: Column(children: [
                        textForm2(
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
                          phoneValidator,
                          'Phone Number(+66)',
                          null,
                          true,
                          false,
                        ),
                        SizedBox(height: size.height * 0.02),
                        textForm(
                          null,
                          'Your name',
                          false,
                          false,
                          nameController!,
                          context,
                          null,
                          RequiredValidator(errorText: 'Name is required'),
                          'Name',
                          null,
                          false,
                          false,
                        ),
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: InkWell(
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        contactData['email'] = emailController?.text;
                        contactData['phoneNumber'] =
                            phoneNumberController?.text;
                        contactData['userName'] = nameController?.text;
                        devtools.log(contactData.toString());
                        Navigator.of(context).pushAndRemoveUntil(
                            FadePageRoute(Summary(
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
                              contactData: contactData,
                              meetingPoint: meetingPoint,
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
                              'Confirm',
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
              ]),
        )));
  }
}
