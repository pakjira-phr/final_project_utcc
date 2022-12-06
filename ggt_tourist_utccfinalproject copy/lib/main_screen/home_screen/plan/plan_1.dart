import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/plan/your_team/your_team.dart';
import 'package:ggt_tourist_utccfinalproject/widget/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

import '../../../constant.dart';
import '../../../utillties/custom_page_route.dart';
import '../../../widget/circle_button.dart';
import '../../../widget/show_date_picker.dart';
import '../../../widget/small_user_card2.dart';
import '../../../widget/small_user_card3.dart';
import '../../main_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'guide/select_guide.dart';
import 'location/select_location.dart';
import 'summary/summary.dart';

// ignore: must_be_immutable
class Plan1 extends StatefulWidget {
  // const Plan1({super.key});
  Plan1({
    super.key,
    required this.attractions,
    required this.attractionsAndCategory,
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
  State<Plan1> createState() => _Plan1State(
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
        meetingPoint: meetingPoint,
        contactData: contactData,
      );
}

class _Plan1State extends State<Plan1> {
  _Plan1State({
    required this.attractions,
    required this.attractionsAndCategory,
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

  bool isFirebaseBug = false;
  bool yourTeamInfoCheck = true;

  // String? timeSelected;

  List? attractionsSelected;
  List? typeAttractionsSelected;
  List? picAttractionsSelected;
  Duration durationCount = const Duration(hours: 0, minutes: 0); //for debug

  bool isLoading = false;

  @override
  void initState() {
    attractionsSelected = attractions['attractionsSelected'] ?? [];
    typeAttractionsSelected = attractions['typeAttractionsSelected'] ?? [];
    picAttractionsSelected = attractions['picAttractionsSelected'] ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (yourTeamInfo.isNotEmpty) {
      for (int i = 0; i < yourTeamInfo['adultsInfo'].length; i++) {
        // devtools.log(yourTeamInfo['adultsInfo'][i].toString());
        if (yourTeamInfo['adultsInfo'][i].isEmpty) {
          // devtools.log('empty');
          yourTeamInfoCheck = false;
        }
      }
      for (int j = 0; j < yourTeamInfo['childrenInfo'].length; j++) {
        if (yourTeamInfo['childrenInfo'][j].isEmpty) {
          // devtools.log('empty');
          yourTeamInfoCheck = false;
        }
      }
    }

    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {

        //     // devtools.log('difference : $difference');
        //   },
        // ),
        backgroundColor: secondaryBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: secondaryBackgroundColor,
          elevation: 0,
          title: Text(
            "PLAN",
            style: TextStyle(
              color: tertiaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon:
                Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor),
            onPressed: () {
              // FocusScope.of(context).unfocus();
              Navigator.of(context).pushAndRemoveUntil(
                  FadePageRoute(MainScreen(index: 0)),
                  (Route<dynamic> route) => false);
            },
          ),
        ),
        body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              selectDate(size),
              selectTime(size),
              numberOfPeople(size),
              sedan(size),
              van(size),
              location(size),
              guide(size),
              bottonBooking(size),
            ])));
  }

  Widget selectDate(Size size) {
    return Column(
      children: [
        Container(
          // color: Colors.amber,
          width: size.width,
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 30, bottom: 2),
            child: Text(
              "Select Date",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                fontSize: size.height * 0.025,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: primaryBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: size.width,
                  height: size.height * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // border:
                      //     Border.all(color: tertiaryColor.withOpacity(0.2)),
                      color: primaryColor),
                  child: InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker2(
                          context: context,
                          initialDate: planDate,
                          firstDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day + 4),
                          lastDate: DateTime(DateTime.now().year + 2,
                              DateTime.now().month, DateTime.now().day));
                      devtools.log(DateFormat("EEEE, d MMM " 'yyyy')
                          .format(planDate)
                          .toString());
                      setState(() {
                        planDate = pickedDate ?? planDate;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: size.height * 0.1,
                        ),
                        Text(
                          DateFormat(planDate ==
                                      DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day + 1)
                                  ? "'Tomorrow'\nEEEE,\nd MMM "
                                      'yyyy' //เดียวต้องเอาออก แต่คงไว้ก่อน
                                  : "EEEE,\nd MMM " 'yyyy')
                              .format(planDate),
                          style: TextStyle(
                            color: tertiaryColor,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.04,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget selectTime(Size size) {
    return Column(
      children: [
        Container(
          // color: Colors.amber,
          width: size.width,
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 30, bottom: 2),
            child: Text(
              "Select Time",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                fontSize: size.height * 0.025,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: SizedBox(
                height: size.height * 0.205,
                child: ListView(
                  // shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: InkWell(
                        onTap: () {
                          devtools.log("tap All Day");
                          setState(() {
                            timeSelected = 'All Day';
                          });
                        },
                        child: Column(children: [
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20),
                                // border:
                                //     Border.all(color: tertiaryColor.withOpacity(0.2)),
                                color: timeSelected == 'All Day'
                                    ? Colors.black87
                                    : primaryBackgroundColor),
                            child: SizedBox(
                              width: size.width * 0.4,
                              height: size.height * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                  Text(
                                    "All Day",
                                    style: TextStyle(
                                      color: timeSelected == 'All Day'
                                          ? Colors.white
                                          : tertiaryColor,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "08:00 to 20:00",
                                    style: TextStyle(
                                      color: timeSelected == 'All Day'
                                          ? Colors.white
                                          : tertiaryColor,
                                      fontSize: size.height * 0.018,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  // SizedBox(
                                  //   height: size.height * 0.01,
                                  // ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.wb_sunny,
                                            color: const Color.fromARGB(
                                                255, 255, 191, 0),
                                            size: size.height * 0.04,
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: size.height * 0.04,
                                              ),
                                              Icon(
                                                CupertinoIcons.moon_fill,
                                                color: Colors.deepPurple,
                                                size: size.height * 0.04,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          devtools.log("tap Half Day");
                          setState(() {
                            timeSelected = 'Half Day';
                          });
                        },
                        child: Column(children: [
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20),
                                color: timeSelected == 'Half Day'
                                    ? Colors.yellow.shade300
                                    : primaryBackgroundColor),
                            child: SizedBox(
                              width: size.width * 0.4,
                              height: size.height * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Text(
                                    "Half Day",
                                    style: TextStyle(
                                      color: tertiaryColor,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "12:00 to 18:00",
                                    style: TextStyle(
                                      color: tertiaryColor,
                                      fontSize: size.height * 0.018,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.wb_sunny,
                                        color: Colors.amber,
                                        size: size.height * 0.06,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: InkWell(
                        onTap: () {
                          devtools.log("tap Night");
                          setState(() {
                            timeSelected = "Night";
                          });
                        },
                        child: Column(children: [
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20),
                                // border:
                                //     Border.all(color: tertiaryColor.withOpacity(0.2)),
                                color: timeSelected == 'Night'
                                    ? Colors.deepPurple.withOpacity(0.5)
                                    : primaryBackgroundColor),
                            child: SizedBox(
                              width: size.width * 0.4,
                              height: size.height * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Text(
                                    "Night",
                                    style: TextStyle(
                                      color: tertiaryColor,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "17:00 to 21:00",
                                    style: TextStyle(
                                      color: tertiaryColor,
                                      fontSize: size.height * 0.018,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        CupertinoIcons.moon_stars_fill,
                                        color: Colors.deepPurple,
                                        size: size.height * 0.06,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ))),
      ],
    );
  }

  Widget numberOfPeople(Size size) {
    return Column(
      children: [
        Container(
          // color: Colors.amber,
          width: size.width,
          alignment: Alignment.topLeft,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 30, left: 30, bottom: 2, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your team infomation",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.025,
                  ),
                  textAlign: TextAlign.left,
                ),
                InkWell(
                  onTap: () {
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
                  },
                  child: Text(
                    "Add more >",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                      fontSize: size.height * 0.015,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),

        // (numAdult + numChildren) == 0 ? Text('data')
        Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: SizedBox(
              // color: Colors.red,
              width: size.width,
              height: size.height * 0.2,
              child: (numAdult + numChildren) == 0
                  ? InkWell(
                      onTap: () {
                        devtools.log("tap add info");
                        // setState(() {
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
                        // });
                      },
                      child: Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: size.width * 0.6,
                          height: size.height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: size.height * 0.1,
                              ),
                              Text(
                                'Add Infomation',
                                style: TextStyle(fontSize: size.height * 0.03),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        devtools.log("tap add info");
                        // setState(() {
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
                        // });
                      },
                      child: Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: size.width * 0.6,
                          height: size.height * 0.15,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon(
                              //   Icons.add,
                              //   size: size.height * 0.1,
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, left: 30, right: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Adult',
                                      style: TextStyle(
                                          fontSize: size.height * 0.022),
                                    ),
                                    Text(
                                      '$numAdult',
                                      style: TextStyle(
                                          fontSize: size.height * 0.022),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, left: 30, right: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Children',
                                      style: TextStyle(
                                          fontSize: size.height * 0.022),
                                    ),
                                    Text(
                                      '$numChildren',
                                      style: TextStyle(
                                          fontSize: size.height * 0.022),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, left: 30, right: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height * 0.022),
                                    ),
                                    Text(
                                      '${numChildren + numAdult}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height * 0.022),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: SizedBox(
            width: size.width,
            child: numAdult == 0
                ? const Text(
                    'You need at least 1 adult.',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.right,
                  )
                : Text(
                    yourTeamInfoCheck
                        ? ''
                        : 'You need to add everyone information.',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.right,
                  ),
          ),
        )
      ],
    );
  }

  Widget sedan(Size size) {
    return Column(
      children: [
        Container(
          // color: Colors.amber,
          width: size.width,
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, bottom: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Need a car for your trip?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.025,
                  ),
                  textAlign: TextAlign.left,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "if you not select one of this, we will use public transportation",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: deactivatedText,
                          fontSize: size.height * 0.02,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 15, bottom: 2, right: 15),
          child: Container(
            width: size.width,
            height: size.height * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              // boxShadow: [
              //   BoxShadow(color: Colors.green, spreadRadius: 3),
              // ],
            ),
            // color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                    color: Colors.white,
                    // semanticContainer: true,
                    // clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    // margin: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: size.width * 0.4,
                      height: size.height * 0.25,
                      child: Image.asset('assets/images/Sedan.jpg'),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sedan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: size.height * 0.023,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '1 driver for 4 passengers\n฿1300 / Unit ',
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: deactivatedText,
                          fontSize: size.height * 0.018,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.25,
                              child: Text(
                                '฿$sedanPrice',
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: size.height * 0.02,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    devtools.log('tap -sedanPrice');
                                    if (sedanPrice != 0) {
                                      setState(() {
                                        setState(() {
                                          sedanPrice = sedanPrice - 1300;
                                          sedanCount--;
                                        });
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: size.height * 0.03,
                                    width: size.width * 0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // border:
                                      //     Border.all(color: tertiaryColor.withOpacity(0.2)),
                                      color: sedanPrice == 0
                                          ? secondaryTextColor
                                          : primaryColor,
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      size: 20,
                                      color: tertiaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.09,
                                  child: Text(
                                    sedanCount.toString(),
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                      fontSize: size.height * 0.018,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    devtools.log('tap +sedanPrice');
                                    if (sedanCount < 4) {
                                      setState(() {
                                        sedanPrice = sedanPrice + 1300;
                                        sedanCount++;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: size.height * 0.03,
                                    width: size.width * 0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // border:
                                      //     Border.all(color: tertiaryColor.withOpacity(0.2)),
                                      color: sedanCount >= 4
                                          ? secondaryTextColor
                                          : primaryColor,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                      color: tertiaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget van(Size size) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 15, bottom: 2, right: 15),
          child: Container(
            width: size.width,
            height: size.height * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              // boxShadow: [
              //   BoxShadow(color: Colors.green, spreadRadius: 3),
              // ],
            ),
            // color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                    color: Colors.white,
                    // semanticContainer: true,
                    // clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    // margin: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: size.width * 0.4,
                      height: size.height * 0.25,
                      child: Image.asset('assets/images/Van.jpg'),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Van',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: size.height * 0.023,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '1 driver for 12 passengers\n฿1300 / Unit ',
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: deactivatedText,
                          fontSize: size.height * 0.018,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.25,
                              child: Text(
                                '฿$vanPrice',
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: size.height * 0.02,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    devtools.log('tap -vanPrice');
                                    if (vanPrice != 0) {
                                      setState(() {
                                        setState(() {
                                          vanPrice = vanPrice - 1500;
                                          vanCount--;
                                        });
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: size.height * 0.03,
                                    width: size.width * 0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // border:
                                      //     Border.all(color: tertiaryColor.withOpacity(0.2)),
                                      color: vanPrice == 0
                                          ? secondaryTextColor
                                          : primaryColor,
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      size: 20,
                                      color: tertiaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.08,
                                  child: Text(
                                    vanCount.toString(),
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                      fontSize: size.height * 0.018,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    devtools.log('tap +vanPrice');
                                    if (vanCount < 2) {
                                      setState(() {
                                        vanPrice = vanPrice + 1500;
                                        vanCount++;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: size.height * 0.03,
                                    width: size.width * 0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // border:
                                      //     Border.all(color: tertiaryColor.withOpacity(0.2)),
                                      color: vanCount >= 2
                                          ? secondaryTextColor
                                          : primaryColor,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                      color: tertiaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget location(Size size) {
    return Column(
      children: [
        Container(
          // color: Colors.amber,
          width: size.width,
          alignment: Alignment.topLeft,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 30, left: 30, bottom: 2, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Location you want to go",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.025,
                  ),
                  textAlign: TextAlign.left,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        FadePageRoute(SelectLocation(
                          attractionsSelected: attractionsSelected!,
                          selectedAttractions: attractions,
                          getFilter: const [],
                          tourGuide: tourGuide,
                          numAdult: numAdult,
                          numChildren: numChildren,
                          planDate: planDate,
                          sedanCount: sedanCount,
                          sedanPrice: sedanPrice,
                          timeSelected: timeSelected,
                          vanCount: vanCount,
                          vanPrice: vanPrice,
                          yourTeamInfo: yourTeamInfo,
                          meetingPoint: meetingPoint,
                          contactData: contactData,
                        )),
                        (Route<dynamic> route) => false);
                  },
                  child: Text(
                    "Add more >",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                      fontSize: size.height * 0.015,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 15, bottom: 2, right: 15),
          child: SizedBox(
              // color: Colors.red,
              // height: size.height * 0.5,
              child: attractionsSelected!.isEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            devtools.log("tap add");
                            setState(() {
                              Navigator.of(context).pushAndRemoveUntil(
                                  FadePageRoute(SelectLocation(
                                    attractionsSelected: attractionsSelected!,
                                    selectedAttractions: attractions,
                                    getFilter: const [],
                                    tourGuide: tourGuide,
                                    numAdult: numAdult,
                                    numChildren: numChildren,
                                    planDate: planDate,
                                    sedanCount: sedanCount,
                                    sedanPrice: sedanPrice,
                                    timeSelected: timeSelected,
                                    vanCount: vanCount,
                                    vanPrice: vanPrice,
                                    yourTeamInfo: yourTeamInfo,
                                    meetingPoint: meetingPoint,
                                    contactData: contactData,
                                  )),
                                  (Route<dynamic> route) => false);
                            });
                          },
                          child: Card(
                            color: Colors.white,
                            child: SizedBox(
                              width: size.width * 0.6,
                              height: size.height * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: size.height * 0.1,
                                  ),
                                  Text(
                                    'Add location',
                                    style:
                                        TextStyle(fontSize: size.height * 0.03),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: attractionsSelected!.length,
                      itemBuilder: (context, index) {
                        attractionsSelected?.sort((a, b) => a.compareTo(b));
                        return InkWell(
                          onTap: () {
                            devtools
                                .log("tap ${picAttractionsSelected![index]}");
                            setState(() {});
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(children: [
                                  Card(
                                    color: Colors.white,
                                    child: SizedBox(
                                      width: size.width * 0.3,
                                      height: size.height * 0.12,
                                      child: isFirebaseBug
                                          ? const Icon(Icons.developer_board)
                                          : CachedNetworkImage(
                                              imageUrl: picAttractionsSelected![
                                                  index],
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),

                                      // Image.network(
                                      //     picAttractionsSelected![index],
                                      //     fit: BoxFit.fill,
                                      //   )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: SizedBox(
                                      // color: Colors.amber,
                                      width: size.width * 0.5,
                                      // alignment: Alignment.topLeft,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  attractionsSelected![index],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                    fontSize:
                                                        size.height * 0.018,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                  // overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  typeAttractionsSelected![
                                                      index],
                                                  style: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                    fontSize:
                                                        size.height * 0.018,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: CircleButton(
                                        onTap: () {
                                          devtools.log("Cool");
                                          setState(() {
                                            picAttractionsSelected?.remove(
                                                picAttractionsSelected![index]);
                                            attractionsSelected?.remove(
                                                attractionsSelected![index]);
                                            typeAttractionsSelected?.remove(
                                                typeAttractionsSelected![
                                                    index]);
                                          });
                                        },
                                        iconData: Icons.delete),
                                  ),
                                ]),
                              ),
                              SizedBox(
                                height: size.height * 0.005,
                              )
                            ],
                          ),
                        );
                      })),
        ),
      ],
    );
  }

  Widget guide(Size size) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 30, left: 30, bottom: 2, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // color: Colors.amber,
                alignment: Alignment.topLeft,
                child: Text(
                  "Select Tour Guide",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.025,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              InkWell(
                onTap: () {
                  String date = DateFormat("yyyy-MM-dd").format(planDate);
                  Navigator.of(context).push(FadePageRoute(SelectGuide(
                    attractionsAndCategory: attractionsAndCategory,
                    attractions: attractions,
                    tourGuide: tourGuide,
                    getFilter: attractions['typeAttractionsSelected'],
                    date: date,
                    numAdult: numAdult,
                    numChildren: numChildren,
                    planDate: planDate,
                    sedanCount: sedanCount,
                    sedanPrice: sedanPrice,
                    timeSelected: timeSelected,
                    vanCount: vanCount,
                    vanPrice: vanPrice,
                    yourTeamInfo: yourTeamInfo,
                    getFilterGender: const [],
                    getFilterLanguages: const [],
                    durationCount: durationCount,
                    meetingPoint: meetingPoint,
                    contactData: contactData,
                  )));
                },
                child: Text(
                  "See more >",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                    fontSize: size.height * 0.015,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: SmallUserCardd2(
            userName:
                tourGuide['user_name'] == '' || tourGuide['user_name'] == null
                    ? 'Tour Guide'
                    : tourGuide['user_name'],
            userMoreInfo: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: tourGuide['user_name'] == '' ||
                        tourGuide['user_name'] == null
                    ? Text(
                        "Select Tour Guide >",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primaryTextColor,
                        ),
                      )
                    : Column(
                        children: [
                          Text(
                            "Gender: ${tourGuide['gender']}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      )),
            userProfilePic: tourGuide['photoProfileURL'] == '' ||
                    tourGuide['photoProfileURL'] == null
                ? null
                : NetworkImage(tourGuide['photoProfileURL']),
            // : AssetImage(user!.photoURL.toString()),
            cardColor: Colors.white,
            onTap: () {
              devtools.log("tap");
              FocusScope.of(context).unfocus();
              devtools.log(DateFormat("yyyy-MM-dd").format(planDate));
              String date = DateFormat("yyyy-MM-dd").format(planDate);
              setState(() {
                Navigator.of(context).push(FadePageRoute(SelectGuide(
                  attractionsAndCategory: attractionsAndCategory,
                  attractions: attractions,
                  tourGuide: tourGuide,
                  getFilter: attractions['typeAttractionsSelected'],
                  date: date,
                  numAdult: numAdult,
                  numChildren: numChildren,
                  planDate: planDate,
                  sedanCount: sedanCount,
                  sedanPrice: sedanPrice,
                  timeSelected: timeSelected,
                  vanCount: vanCount,
                  vanPrice: vanPrice,
                  yourTeamInfo: yourTeamInfo,
                  getFilterGender: const [],
                  getFilterLanguages: const [],
                  durationCount: durationCount,
                  meetingPoint: meetingPoint,
                  contactData: contactData,
                )));
                // isLoading = !isLoading; //for test
              });
            },
          ),
        ),
      ],
    );
  }

  Widget bottonBooking(Size size) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 50),
          child: InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              if (attractions['attractionsSelected'].isEmpty ||
                  attractionsAndCategory.isEmpty ||
                  tourGuide.isEmpty ||
                  timeSelected == null ||
                  yourTeamInfo.isEmpty ||
                  numAdult + numChildren == 0 ||
                  numAdult == 0 ||
                  !yourTeamInfoCheck) {
                devtools.log('you need to complate all data');
                showErrorDialog(context, 'you need to complate all data');
              } else {
                setState(() {
                  isLoading = true;
                });
                if (contactData.isEmpty) {
                  User? user = FirebaseAuth.instance.currentUser;
                  CollectionReference collectionRef =
                      FirebaseFirestore.instance.collection('users');
                  var querySnapshot = await collectionRef.doc(user!.uid).get();
                  Map userData = querySnapshot.data() as Map<String, dynamic>;
                  Map contactDataTemp = {
                    'email': userData['email'],
                    'phoneNumber': userData['phoneNumber'],
                    'userName': userData['userName'],
                  };
                  contactData = contactDataTemp;
                }
                // ignore: use_build_context_synchronously
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

              // setState(() {
              //   isLoading = !isLoading; //for test
              // });
            },
            child: Container(
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8 + 32 * (1)),
                color: isLoading ? tertiaryColor : primaryColor,
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
                        : Text(
                            'Next',
                            style: TextStyle(
                              color: tertiaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget summary(Size size) {
    return Column(
      children: [
        Container(
          // color: Colors.amber,
          width: size.width,
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, bottom: 2),
            child: Text(
              "Summary ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                fontSize: size.height * 0.025,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Date and Time",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: deactivatedText,
                    fontSize: size.height * 0.02,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Card(
                color: Colors.white,
                child: SizedBox(
                  width: size.width,
                  // height: size.height * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat("EEEE, d MMMM " 'yyyy')
                                  .format(planDate)
                                  .toString(),
                              style: TextStyle(
                                  fontSize: size.height * 0.025,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '',
                              style: TextStyle(fontSize: size.height * 0.02),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                timeSelected == 'All Day'
                                    ? '08:00 - 20:00'
                                    : timeSelected == 'Half Day'
                                        ? '12:00 - 18:00'
                                        : timeSelected == 'Night'
                                            ? '17:00 - 21:00'
                                            : 'Please select time',
                                style: TextStyle(fontSize: size.height * 0.025),
                              ),
                              Text(
                                '',
                                style: TextStyle(fontSize: size.height * 0.02),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: secondaryBackgroundColor,
          width: size.width,
          height: size.height * 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Tour Guide",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: deactivatedText,
                    fontSize: size.height * 0.02,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: size.width,
                  // height: size.height * 0.2,
                  child: SmallUserCardd3(
                    userName: tourGuide['user_name'] == '' ||
                            tourGuide['user_name'] == null
                        ? 'Tour Guide'
                        : tourGuide['user_name'],
                    userMoreInfo: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: tourGuide['user_name'] == '' ||
                                tourGuide['user_name'] == null
                            ? Text(
                                "Select Tour Guide >",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: primaryTextColor,
                                ),
                              )
                            : Column(
                                children: [
                                  Text(
                                    "Gender: ${tourGuide['gender']}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                ],
                              )),
                    userProfilePic: tourGuide['photoProfileURL'] == '' ||
                            tourGuide['photoProfileURL'] == null
                        ? null
                        : NetworkImage(tourGuide['photoProfileURL']),
                    // : AssetImage(user!.photoURL.toString()),
                    cardColor: Colors.white,
                    onTap: () {
                      // devtools.log("tap");
                      // FocusScope.of(context).unfocus();
                      // devtools
                      //     .log(DateFormat("yyyy-MM-dd").format(planDate));
                      // String date =
                      //     DateFormat("yyyy-MM-dd").format(planDate);
                      // setState(() {
                      //   Navigator.of(context)
                      //       .push(FadePageRoute(SelectGuide(
                      //     attractionsAndCategory: attractionsAndCategory,
                      //     attractions: attractions,
                      //     tourGuide: tourGuide,
                      //     getFilter:
                      //         attractions['typeAttractionsSelected'],
                      //     date: date,
                      //     numAdult: numAdult,
                      //     numChildren: numChildren,
                      //     planDate: planDate,
                      //     sedanCount: sedanCount,
                      //     sedanPrice: sedanPrice,
                      //     timeSelected: timeSelected,
                      //     vanCount: vanCount,
                      //     vanPrice: vanPrice,
                      //     yourTeamInfo: yourTeamInfo,
                      //     getFilterGender: const [],
                      //     getFilterLanguages: const [],
                      //   )));
                      //   // isLoading = !isLoading; //for test
                      // });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Number of",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: deactivatedText,
                    fontSize: size.height * 0.02,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Card(
                color: Colors.white,
                child: SizedBox(
                  width: size.width,
                  // height: size.height * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon(
                            //   Icons.add,
                            //   size: size.height * 0.1,
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, right: 30, left: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Adult',
                                    style: TextStyle(
                                        fontSize: size.height * 0.022),
                                  ),
                                  Text(
                                    '$numAdult',
                                    style: TextStyle(
                                        fontSize: size.height * 0.022),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, right: 30, left: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Children',
                                    style: TextStyle(
                                        fontSize: size.height * 0.022),
                                  ),
                                  Text(
                                    '$numChildren',
                                    style: TextStyle(
                                        fontSize: size.height * 0.022),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, right: 30, left: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height * 0.022),
                                  ),
                                  Text(
                                    '${numChildren + numAdult}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height * 0.022),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: secondaryBackgroundColor,
          width: size.width,
          height: size.height * 0.02,
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Attractions",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: deactivatedText,
                    fontSize: size.height * 0.02,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 15, bottom: 2, right: 15),
                child: SizedBox(
                    // color: Colors.red,
                    // height: size.height * 0.5,
                    child: attractionsSelected!.isEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  devtools.log("tap add");
                                  setState(() {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        FadePageRoute(SelectLocation(
                                          attractionsSelected:
                                              attractionsSelected!,
                                          selectedAttractions: attractions,
                                          getFilter: const [],
                                          tourGuide: tourGuide,
                                          numAdult: numAdult,
                                          numChildren: numChildren,
                                          planDate: planDate,
                                          sedanCount: sedanCount,
                                          sedanPrice: sedanPrice,
                                          timeSelected: timeSelected,
                                          vanCount: vanCount,
                                          vanPrice: vanPrice,
                                          yourTeamInfo: yourTeamInfo,
                                          meetingPoint: meetingPoint,
                                          contactData: contactData,
                                        )),
                                        (Route<dynamic> route) => false);
                                  });
                                },
                                child: Card(
                                  color: Colors.white,
                                  child: SizedBox(
                                    width: size.width * 0.6,
                                    height: size.height * 0.2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: size.height * 0.1,
                                        ),
                                        Text(
                                          'Add location',
                                          style: TextStyle(
                                              fontSize: size.height * 0.03),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: attractionsSelected!.length,
                            itemBuilder: (context, index) {
                              attractionsSelected
                                  ?.sort((a, b) => a.compareTo(b));
                              return InkWell(
                                onTap: () {
                                  devtools.log(
                                      "tap ${picAttractionsSelected![index]}");
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Row(children: [
                                        Card(
                                          color: Colors.white,
                                          child: SizedBox(
                                            width: size.width * 0.3,
                                            height: size.height * 0.12,
                                            child: isFirebaseBug
                                                ? const Icon(
                                                    Icons.developer_board)
                                                : CachedNetworkImage(
                                                    imageUrl:
                                                        picAttractionsSelected![
                                                            index],
                                                    placeholder: (context,
                                                            url) =>
                                                        const CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),

                                            // Image.network(
                                            //     picAttractionsSelected![
                                            //         index],
                                            //     fit: BoxFit.fill,
                                            //   )
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: SizedBox(
                                            // color: Colors.amber,
                                            width: size.width * 0.55,
                                            // alignment: Alignment.topLeft,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        attractionsSelected![
                                                            index],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              primaryTextColor,
                                                          fontSize:
                                                              size.height *
                                                                  0.018,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                        // overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        typeAttractionsSelected![
                                                            index],
                                                        style: TextStyle(
                                                          // fontWeight: FontWeight.bold,
                                                          color:
                                                              primaryTextColor,
                                                          fontSize:
                                                              size.height *
                                                                  0.018,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       right: 5),
                                        //   child: CircleButton(
                                        //       onTap: () {
                                        //         devtools.log("Cool");
                                        //         setState(() {
                                        //           picAttractionsSelected
                                        //               ?.remove(
                                        //                   picAttractionsSelected![
                                        //                       index]);
                                        //           attractionsSelected?.remove(
                                        //               attractionsSelected![
                                        //                   index]);
                                        //           typeAttractionsSelected
                                        //               ?.remove(
                                        //                   typeAttractionsSelected![
                                        //                       index]);
                                        //         });
                                        //       },
                                        //       iconData: Icons.delete),
                                        // ),
                                      ]),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.005,
                                    )
                                  ],
                                ),
                              );
                            })),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Payment",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: deactivatedText,
                          fontSize: size.height * 0.02,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: SizedBox(
                        width: size.width,
                        // height: size.height * 0.2,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon(
                                  //   Icons.add,
                                  //   size: size.height * 0.1,
                                  // ),
                                  sedanCount != 0
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12, right: 20, left: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                      // color: Colors.amber,
                                                      border: Border.all(
                                                          color: primaryColor,
                                                          width: 1.5),
                                                    ),
                                                    height: size.height * 0.04,
                                                    width: size.width * 0.08,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('$sedanCount'
                                                            'x'),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: size.width * 0.05,
                                                  ),
                                                  Text(
                                                    'Sedan',
                                                    style: TextStyle(
                                                        fontSize: size.height *
                                                            0.022),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '$sedanPrice',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.022),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const Text(''),
                                  vanCount != 0
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12, right: 20, left: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                      // color: Colors.amber,
                                                      border: Border.all(
                                                          color: primaryColor,
                                                          width: 1.5),
                                                    ),
                                                    height: size.height * 0.04,
                                                    width: size.width * 0.08,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('$vanCount'
                                                            'x'),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: size.width * 0.05,
                                                  ),
                                                  Text(
                                                    'Van',
                                                    style: TextStyle(
                                                        fontSize: size.height *
                                                            0.022),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '$vanPrice',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.022),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const Text(''),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, right: 20, left: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                // color: Colors.amber,
                                                border: Border.all(
                                                    color: primaryColor,
                                                    width: 1.5),
                                              ),
                                              height: size.height * 0.04,
                                              width: size.width * 0.08,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: const [
                                                  Text('1'
                                                      'x'),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            Text(
                                              'Tour Guide',
                                              style: TextStyle(
                                                  fontSize:
                                                      size.height * 0.022),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '1500',
                                          style: TextStyle(
                                              fontSize: size.height * 0.022),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, right: 20, left: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.height * 0.022),
                                        ),
                                        Text(
                                          '${sedanPrice + vanPrice + 1500}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.height * 0.022),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ])
      ],
    );
  }
}
