// import 'dart:io';

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/constant.dart';
import 'package:ggt_tour_guide_utccfinalproject/firebase_options_tourist.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/component/job_detail/replacer/inside_replacer/component/guide_info.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/component/job_detail/replacer/outside_replacer.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/component/job_detail/replacer/replacer_screen.dart';
import 'package:ggt_tour_guide_utccfinalproject/widget/popup_dialog.dart';
import 'dart:developer' as devtools show log;
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:url_launcher/url_launcher.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../../utillties/calculate_age.dart';
import '../../../utillties/custom_page_route.dart';
import '../../main_screen.dart';
import '../location_info.dart';

// import '../../utillties/custom_page_route.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_pdf_viewer/flutter_pdf_viewer.dart';

// ignore: must_be_immutable
class JobDetail extends StatefulWidget {
  JobDetail(
      {super.key,
      required this.detail,
      required this.indexToBack,
      required this.orderAllData});
  Map detail;
  int indexToBack;
  Map orderAllData;

  @override
  // ignore: no_logic_in_create_state
  State<JobDetail> createState() =>
      // ignore: no_logic_in_create_state
      _JobDetailState(
          detail: detail, indexToBack: indexToBack, orderAllData: orderAllData);
}

class _JobDetailState extends State<JobDetail> {
  _JobDetailState(
      {required this.detail,
      required this.indexToBack,
      required this.orderAllData});
  int indexToBack;
  Map detail;
  Map orderAllData;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  String time = '';
  bool isFirebaseBug = false;
  bool isLoading = false;

  getStringTime() {
    if (detail['timePlan'] == 'All Day') {
      time = "08:00 to 20:00";
    } else if (detail['timePlan'] == 'Half Day') {
      time = "12:00 to 18:00";
    } else {
      time = "17:00 to 21:00";
    }
  }

  Icon? statusIcon;
  String status = '';
  getStatusIcon() {
    setState(() {
      if (status == 'Pending') {
        statusIcon = const Icon(Icons.pending);
      } else if (status == 'Accepted') {
        statusIcon = const Icon(Icons.play_circle_sharp);
      } else if (status == 'In Progress') {
        statusIcon = const Icon(Icons.incomplete_circle_sharp);
      } else if (status == 'Finished') {
        statusIcon = const Icon(Icons.check_circle_rounded);
      } else {
        statusIcon = const Icon(Icons.error);
      }
    });
  }

  List? attractionsSelected;
  List? typeAttractionsSelected;
  List? picAttractionsSelected;
  Map meetingPoint = {};
  var touristData = [];

  Map? replacer;
  String? replacerType;
  //  FirebaseApp? touristApp;
  //  FirebaseFirestore? touristAppFirestore;

  @override
  void initState() {
    attractionsSelected = detail['attractions']['attractionsSelected'] ?? [];
    typeAttractionsSelected =
        detail['attractions']['typeAttractionsSelected'] ?? [];
    picAttractionsSelected =
        detail['attractions']['picAttractionsSelected'] ?? [];
    touristData = json.decode(detail['touristData']);
    status = detail['status'];
    meetingPoint = detail['meetingPoint'];
    replacer = detail['replacer'];
    replacerType = replacer?['replacerType'];
    devtools.log('replacer $replacer');
    if (replacer != null && status == 'Pending') {
      status = 'Accepted';
      changePendingForReplacer();
    }
    getStringTime();
    getStatusIcon();
    super.initState();
  }

  changePendingForReplacer() async {
    firestore
        .collection('users')
        .doc(user?.uid)
        .collection('order')
        .doc('${detail['jobOrderFileName']}')
        .update({
      'status': status,
    }).then((value) => () {
              setState(() {
                devtools.log("doc TourGuide update status");
              });
            });
    FirebaseApp touristApp = await Firebase.initializeApp(
      name: 'touristApp', //note ผิดแน่ แต่ทำงานได้ งงอยู่
      options: DefaultFirebaseOptionsTourist.currentPlatform,
    );
    FirebaseFirestore touristAppFirestore =
        FirebaseFirestore.instanceFor(app: touristApp);

    touristAppFirestore
        .collection('users')
        .doc(detail['touristUid'])
        .collection('order')
        .doc('${detail['jobOrderFileName']}')
        .update({
      'status': status,
    }).then((value) {
      setState(() {
        devtools.log("doc touristApp update status");
      });
    });
  }

  int getHoursBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final timeStamp =
        DateFormat('dd/MM/yyyy, HH:mm').parse(detail['timeStamp']);
    final now = DateTime.now();
    int timestampDifNow = getHoursBetween(timeStamp, now);
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      floatingActionButton: SizedBox(
        height: size.height * 0.07,
        width: size.width * 0.8,
        child: replacerType == 'inside_replacer' || (status == 'Canceled')
            ? const SizedBox()
            : FloatingActionButton(
                backgroundColor: checkTime() ? primaryColor : Colors.grey,
                onPressed: () async {
                  // setState(() {
                  //   devtools.log('$meetingPoint');
                  // });
                  if (checkTime()) {
                    showPopupDialog(context, 'Are you sure to change status',
                        'Are you sure', [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              changeStatus(null);
                            });
                          },
                          child: const Text("OK"))
                    ]);
                  } else {
                    devtools.log('tap');
                    if (status == 'In Finished') {
                      showPopupDialog(context, 'Your job is done', 'Finished', [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"))
                      ]);
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(
                              color: Colors.white,
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              status == 'Pending'
                                  ? 'Accepted'
                                  : status == 'Accepted'
                                      ? (checkTime()
                                          ? 'In Progress'
                                          : 'Accepted')
                                      : status == 'In Progress'
                                          ? 'Finished'
                                          : 'Finished',
                              style: const TextStyle(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: const Text("Detail"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                devtools.log('tap pdf');
                final Uri url = Uri.parse('${detail['jobOrderFile']}');
                devtools.log('$url');
                if (!await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                  webViewConfiguration:
                      const WebViewConfiguration(enableJavaScript: false),
                )) {
                  devtools.log('Could not launch $url');
                }
              },
              icon: const Icon(Icons.file_download))
          // icon: const Icon(Icons.picture_as_pdf))
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: secondaryBackgroundColor),
          onPressed: () {
            // FocusScope.of(context).unfocus();
            if (orderAllData.isNotEmpty) {
              // Navigator.of(context).push(FadePageRoute(JobsHistory(
              //   orderAllData: orderAllData,
              // )));
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  FadePageRoute(MainScreen(index: indexToBack)),
                  (Route<dynamic> route) => false);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            head(size, timestampDifNow, timeStamp),
            replacerInfo(size),
            attrations(size),
            tourists(size),
            replacerBotton(size),
            SizedBox(
              height: size.height * 0.1,
            ),
          ],
        ),
      )),
    );
  }

  bool checkTime() {
    bool check = false;
    DateTime now = DateTime.now();
    if (status == 'Accepted') {
      if (DateFormat("dd-MM-yyyy").format(now) == detail['datePlan']) {
        switch (time) {
          case "08:00 to 20:00":
            if (now.hour >= 8) {
              check = true;
            }
            break;
          case "12:00 to 18:00":
            if (now.hour >= 12) {
              check = true;
            }
            break;
          case "17:00 to 21:00":
            if (now.hour >= 17) {
              check = true;
            }
            break;
          default:
            check = false;
        }
      } else {
        check = false;
      }
    } else {
      check = true;
    }

    if (status == 'Finished') {
      check = false;
    }

    return check;
  }

  changeStatus(String? order) async {
    switch (status) {
      case 'Pending':
        status = 'Accepted';
        break;
      case 'Accepted':
        status = 'In Progress';
        break;
      case 'In Progress':
        status = 'Finished';
        isLoading = true;
        break;
      default:
        // status = 'error';
        status = 'Pending'; //for debug
    }

    int? earnings;
    Map? transactions;
    final documentUserSnapshot =
        await firestore.collection('users').doc(user?.uid).get();
    final userData = documentUserSnapshot.data();

    if (status == 'Finished') {
      earnings = (userData?['earnings'] ?? 0) +
          int.parse(detail['tourGuideFee'].toString());
      transactions = userData?['transactions'] ?? {};
      String timeStamp = DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now());
      String tempStr = transactions?.length.toString() ?? '0';
      int tempInt = int.parse(tempStr);
      int countId = tempInt + 1;
      // devtools.log('${countId}');
      if (transactions!.isEmpty) {
        transactions = {
          '$countId': {
            'total': int.parse(detail['tourGuideFee'].toString()),
            'timeStamp': timeStamp,
            'type': 'Earnings',
            'orderID': detail['jobOrderFileName']
          }
        };
      } else {
        transactions['$countId'] = {
          'total': int.parse(detail['tourGuideFee'].toString()),
          'timeStamp': timeStamp,
          'type': 'Earnings',
          'orderID': detail['jobOrderFileName']
        };
      }

      firestore
          .collection('users')
          .doc(user?.uid)
          .update({'earnings': earnings, 'transactions': transactions});
    }

    firestore
        .collection('users')
        .doc(user?.uid)
        .collection('order')
        .doc('${detail['jobOrderFileName']}')
        .update({
      'status': status,
    }).then((value) => () {
              setState(() {
                devtools.log("doc TourGuide update status");
              });
            });
    FirebaseApp touristApp = await Firebase.initializeApp(
      name: 'touristApp', //note ผิดแน่ แต่ทำงานได้ งงอยู่
      options: DefaultFirebaseOptionsTourist.currentPlatform,
    );
    FirebaseFirestore touristAppFirestore =
        FirebaseFirestore.instanceFor(app: touristApp);

    touristAppFirestore
        .collection('users')
        .doc(detail['touristUid'])
        .collection('order')
        .doc('${detail['jobOrderFileName']}')
        .update({
      'status': status,
    }).then((value) {
      setState(() {
        devtools.log("doc touristApp update status");
        getStatusIcon();
        if (status == 'Finished') {
          Navigator.of(context).pushAndRemoveUntil(
              FadePageRoute(MainScreen(index: 0)),
              (Route<dynamic> route) => false);
        }
      });
    });
  }

  Widget head(Size size, timestampDifNow, timeStamp) {
    String travelBy = '';
    // devtools.log('${detail['sedanCount']}');
    // devtools.log('${detail['vanCount']}');

    if (detail['sedanCount'] > 0 && detail['vanCount'] > 0) {
      travelBy = 'Car (sedan) and Van';
    } else if (detail['sedanCount'] > 0) {
      travelBy = 'Car (sedan)';
    } else if (detail['vanCount'] > 0) {
      travelBy = 'Van';
    } else {
      travelBy = 'Public transportation';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "Job order NO.",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                fontSize: size.height * 0.035),
            textAlign: TextAlign.left,
          ),
        ),
        Text(
          "${detail['jobOrderFileName']}",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
              fontSize: size.height * 0.035),
          textAlign: TextAlign.left,
        ),
        detail['isReplacerJob'] == true
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    const Icon(Icons.repeat),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Text(
                      "Replacer Job",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: size.height * 0.025),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Text(
                    "${detail['datePlan']}",
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: size.height * 0.025),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.access_time_filled),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Text(
                    time,
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: size.height * 0.025),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              statusIcon ?? const Icon(Icons.error),
              SizedBox(
                width: size.width * 0.02,
              ),
              Text(
                "Status : $status",
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.025),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              travelBy == 'Public transportation'
                  ? const Icon(Icons.directions_bus_sharp)
                  : const Icon(Icons.directions_car),
              SizedBox(
                width: size.width * 0.01,
              ),
              Text(
                "Travel by : $travelBy",
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.025),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              const Icon(Icons.attach_money_rounded),
              SizedBox(
                width: size.width * 0.01,
              ),
              Text(
                "Earnings : ${detail['tourGuideFee']}",
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.025),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // const Icon(Icons.book),
              // SizedBox(
              //   width: size.width * 0.01,
              // ),
              Text(
                "Booked $timestampDifNow hours ago",
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.025),
                textAlign: TextAlign.left,
              ),
              InkWell(
                  onTap: () {
                    showPopupDialog(
                        context,
                        "If you don't accepted this job, tourist can cancel this booking all the time and tourist also can change tour guide in 24 hours.\n\nTourist Booked Date :\n${DateFormat('dd MMMM yyyy, HH:mm').format(timeStamp)}",
                        'For your information', [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"))
                    ]);
                  },
                  child: const Icon(Icons.info, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget replacerInfo(Size size) {
    return replacer == null
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Tour Guide Replacer',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: size.height * 0.035),
                      textAlign: TextAlign.left,
                    ),
                    InkWell(
                      onTap: () {
                        if (replacerType == 'outside_replacer') {
                          Navigator.of(context).push(FadePageRoute(
                              OutsideReplacer(
                                  detail: detail,
                                  indexToBack: indexToBack,
                                  orderAllData: orderAllData)));
                        } else {
                          devtools.log('Here ==========\n$replacer');
                          Navigator.of(context).push(FadePageRoute(GuideInfo(
                            guideData: replacer!,
                          )));
                        }
                      },
                      child: Text(
                        (replacerType == 'inside_replacer')
                            ? 'See >'
                            : "Edit >",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                          fontSize: size.height * 0.02,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name : ${replacer?['firstName']} ${replacer?['lastName']}',
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                color: primaryTextColor,
                                fontSize: size.height * 0.025),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Gender : ${replacer?['gender']}',
                                  style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      color: primaryTextColor,
                                      fontSize: size.height * 0.025),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Age : ${calculateAge(replacer?['birthDay'])}',
                                  style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      color: primaryTextColor,
                                      fontSize: size.height * 0.025),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Text(
                            'Email : ${replacer?['email']}',
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                color: primaryTextColor,
                                fontSize: size.height * 0.025),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Text(
                            'Phone Number : ${replacer?['phoneNumber']}',
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                color: primaryTextColor,
                                fontSize: size.height * 0.025),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget attrations(Size size) {
    void onLoadingLocationInfo(int index) async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: size.height * 0.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      );
      devtools.log('tab attraction (${attractionsSelected![index]})');
      FirebaseApp touristApp = await Firebase.initializeApp(
        name: 'touristApp', //note ผิดแน่ แต่ทำงานได้ งงอยู่
        options: DefaultFirebaseOptionsTourist.currentPlatform,
      );
      FirebaseFirestore touristAppFirestore =
          FirebaseFirestore.instanceFor(app: touristApp);
      var document =
          touristAppFirestore.collection('locations').doc('locationInfo');
      var data = await document.get();
      Map<String, dynamic> attractionData = data.data() ?? {};
      // devtools.log(
      //     '${attractionData['${attractionsSelected![index]}']} ');
      Map attractionsSelect = attractionData['${attractionsSelected![index]}'];
      // devtools.log('${suggestedDuration}');
      // ignore: use_build_context_synchronously
      Navigator.pop(context); //pop dialog
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(FadePageRoute(LocationInfo(
        attractionsSelect: attractionsSelect,
        category: typeAttractionsSelected![index],
        name: attractionsSelected![index],
      )));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: Text(
            "Meeting Point",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
              fontSize: size.height * 0.035,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  int? index =
                      attractionsSelected?.indexOf(meetingPoint['name']);
                  // devtools.log('index ${meetingPoint['name']} : $index');
                  onLoadingLocationInfo(index!);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Row(children: [
                    Card(
                      color: Colors.white.withOpacity(0.1),
                      child: SizedBox(
                        width: size.width * 0.3,
                        height: size.height * 0.12,
                        child: isFirebaseBug
                            ? const Icon(Icons.developer_board)
                            : CachedNetworkImage(
                                imageUrl: meetingPoint['pic'],
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                        // Image.network(
                        //     meetingPoint['pic'],
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
                                    meetingPoint['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                      fontSize: size.height * 0.018,
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
                                    meetingPoint['type'],
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                      fontSize: size.height * 0.018,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 15),
          child: Text(
            "Attractions",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
              fontSize: size.height * 0.035,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: attractionsSelected!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  onLoadingLocationInfo(index);
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: Row(children: [
                        Card(
                          color: Colors.white.withOpacity(0.1),
                          child: SizedBox(
                            width: size.width * 0.3,
                            height: size.height * 0.12,
                            child: isFirebaseBug
                                ? const Icon(Icons.developer_board)
                                : CachedNetworkImage(
                                    imageUrl: picAttractionsSelected![index],
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                    errorWidget: (context, url, error) =>
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
                            width: size.width * 0.55,
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
                                          fontSize: size.height * 0.018,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        typeAttractionsSelected![index],
                                        style: TextStyle(
                                          color: primaryTextColor,
                                          fontSize: size.height * 0.018,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: size.height * 0.005,
                    )
                  ],
                ),
              );
            }),
      ],
    );
  }

  Widget tourists(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: Text(
            "Tourist",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
              fontSize: size.height * 0.035,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(
            "Number of Adults : ${detail['numAdults']}, Children : ${detail['numChilds']}",
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              color: primaryTextColor,
              fontSize: size.height * 0.02,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: touristData.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white.withOpacity(0.1),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: size.height * 0.05,
                            child: Text(
                              '${touristData[index][0]}',
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                                fontSize: size.height * 0.03,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '${touristData[index][1]}',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                            fontSize: size.height * 0.02,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 15),
          child: Text(
            "Contact of tourists",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
              fontSize: size.height * 0.035,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Card(
          color: Colors.white.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_circle),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Text(
                      "${detail['contactData']['userName']}",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: size.height * 0.025),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  children: [
                    const Icon(Icons.email),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Text(
                      "${detail['contactData']['email']}",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: size.height * 0.025),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  children: [
                    const Icon(Icons.phone),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Text(
                      "${detail['contactData']['phoneNumber']}",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: size.height * 0.025),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget replacerBotton(Size size) {
    return replacer == null &&
            !(status == 'In Progress') &&
            !(status == 'Canceled')
        ? Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: () {
                //ส่งไปหา Replacer
                if (!(status == 'In Progress')) {
                  devtools.log('tab Replacer');
                  Navigator.of(context).push(FadePageRoute(ReplacerScreen(
                      detail: detail,
                      indexToBack: indexToBack,
                      orderAllData: orderAllData)));
                  // Navigator.of(context).push(FadePageRoute(OutsideReplacer(
                  //     detail: detail,
                  //     indexToBack: indexToBack,
                  //     orderAllData: orderAllData)));
                }
              },
              child: Container(
                height: size.height * 0.07,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: status == 'In Progress' ? Colors.grey : primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Need tour guide replacer?",
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
          )
        : const SizedBox();
  }
}
