import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:ggt_tourist_utccfinalproject/firebase_options_tour_guide.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/plan/summary/refund_policy.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/my_trip/component/cancel_booking/confirm_cancel.dart';
import 'package:ggt_tourist_utccfinalproject/widget/popup_dialog.dart';
import 'dart:developer' as devtools show log;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utillties/custom_page_route.dart';

import '../main_screen.dart';
import 'component/change_guide.dart';
import 'component/guide_info.dart';
import 'component/location_info.dart';
import 'component/review.dart';

// ignore: must_be_immutable
class BookingDetail extends StatefulWidget {
  BookingDetail(
      {super.key,
      required this.detail,
      required this.indexToBack,
      required this.bookingAllData});
  Map detail;
  int indexToBack;
  Map bookingAllData;

  @override
  // ignore: no_logic_in_create_state
  State<BookingDetail> createState() => _BookingDetailState(
      detail: detail, indexToBack: indexToBack, bookingAllData: bookingAllData);
}

class _BookingDetailState extends State<BookingDetail> {
  _BookingDetailState(
      {required this.detail,
      required this.indexToBack,
      required this.bookingAllData});
  int indexToBack;
  Map detail;
  Map bookingAllData;
  List? attractionsSelected;
  List? typeAttractionsSelected;
  List? picAttractionsSelected;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  String time = '';
  bool isFirebaseBug = false;
  bool isLoading = false;
  Map? replacer;
  bool isNeedChangeGuide = false;
  bool isCanCencle = false;
  bool isCanGetRefund = false;
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

  int getHoursBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours);
  }

  bool isGetData = false;
  String? refundStatus;
  String? refundTimeStamp;
  Future getRefundData() async {
    final documentUserSnapshot = await firestore
        .collection('refund')
        .doc(detail['jobOrderFileName'])
        .get();
    final refundData = documentUserSnapshot.data();
    refundStatus = refundData?['status'];
    DateTime? getTimeStamp = refundData?['timeStamp'].toDate();
    if (getTimeStamp != null) {
      refundTimeStamp = DateFormat('dd/MM/yyyy HH:mm').format(getTimeStamp);
    }

    devtools.log('getTimeStamp $getTimeStamp');
    isGetData = true;
  }

  List<String> filter = [];
  int timestampDifNow = 0;

  @override
  void initState() {
    status = detail['status'];
    // if (status == 'Canceled') {
    //   getRefundData();
    // }
    // final timeStamp =
    //     DateFormat('dd/MM/yyyy, HH:mm').parse(detail['timeStamp']);
    // final now = DateTime.now();
    // timestampDifNow = getHoursBetween(timeStamp, now);
    timestampDifNow = DateTime.now()
        .difference(
          DateFormat('dd/MM/yyyy, HH:mm').parse(detail['timeStamp']),
        )
        .inHours;
    if (timestampDifNow >= 24 && status == 'Pending') {
      isNeedChangeGuide = true;
    }
    if (timestampDifNow < 48 && status == 'Pending') {
      isCanCencle = true;
      isCanGetRefund = true;
    } else if (timestampDifNow > 48 && status == 'Pending') {
      isCanCencle = true;
    }
    // isNeedChangeGuide = true; //for debug
    for (int i = 0;
        i < detail['attractions']['typeAttractionsSelected'].length;
        i++) {
      for (int j = 0;
          j <
              detail['attractions']['typeAttractionsSelected'][i]
                  .split(', ')
                  .length;
          j++) {
        filter.add(
            detail['attractions']['typeAttractionsSelected'][i].split(', ')[j]);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   getRefundData();
    // });

    getStringTime();
    getStatusIcon();
    Size size = MediaQuery.of(context).size;
    replacer = detail['replacer'];
    attractionsSelected = detail['attractions']['attractionsSelected'] ?? [];
    typeAttractionsSelected =
        detail['attractions']['typeAttractionsSelected'] ?? [];
    picAttractionsSelected =
        detail['attractions']['picAttractionsSelected'] ?? [];

    return FutureBuilder(
        future: getRefundData(),
        builder: ((context, snapshot) {
          if (isGetData) {
            refundStatus ??= detail['refund'];
            return Scaffold(
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () async {
              //     devtools.log('refundStatus: ${getHoursBetween(
              //       DateTime.now(),
              //       DateFormat('dd/MM/yyyy, HH:mm').parse(detail['timeStamp']),
              //     )}');
              //     devtools.log('refundStatus: ${DateTime.now().difference(
              //           DateFormat('dd/MM/yyyy, HH:mm')
              //               .parse(detail['timeStamp']),
              //         ).inHours}');
              //     // devtools.log('date: ${detail['datePlan']}');
              //   },
              // ),
              backgroundColor: secondaryBackgroundColor,
              appBar: AppBar(
                elevation: 2,
                centerTitle: true,
                title: Text(
                  'Booking Detail',
                  style: TextStyle(color: primaryTextColor),
                ),
                backgroundColor: primaryBackgroundColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: primaryTextColor),
                  onPressed: () {
                    // FocusScope.of(context).unfocus();
                    if (bookingAllData.isNotEmpty) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 10, bottom: 5, left: 10, top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Booking Date',
                              style: TextStyle(
                                  color: deactivatedText, fontSize: 14),
                            ),
                            Text('${detail['date']} UTC+7',
                                style: TextStyle(
                                    color: deactivatedText, fontSize: 14)),
                          ]),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 10, bottom: 5, left: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Booking ID',
                              style: TextStyle(
                                  color: deactivatedText, fontSize: 14),
                            ),
                            Text('${detail['jobOrderFileName']}',
                                style: TextStyle(
                                    color: deactivatedText, fontSize: 14)),
                          ]),
                    ),
                    refundStatus == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                                right: 10, bottom: 10, left: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Request refund date',
                                    style: TextStyle(
                                        color: deactivatedText, fontSize: 14),
                                  ),
                                  Text('$refundTimeStamp',
                                      style: TextStyle(
                                          color: deactivatedText,
                                          fontSize: 14)),
                                ]),
                          ),
                    head(size),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    tourguide(size),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    meetingPoint(size),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    attraction(size),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    numberOf(size),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    payment(size),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    status == 'Finished' || status == 'In Progress'
                        ? status == 'In Progress'
                            ? const SizedBox()
                            : reviewBotton(size)
                        : status == 'Canceled'
                            ? contactUsBotton(size)
                            : isCanCencle
                                ? cancelBotton(size)
                                : const SizedBox(),
                  ],
                ),
              ),
            );
          }
          return Container(
            decoration: BoxDecoration(color: primaryBackgroundColor),
            child: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          );
        }));
  }

  void onLoadingLocationInfo(int index, size) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: size.height * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: primaryColor,
                ),
              ],
            ),
          ),
        );
      },
    );
    // devtools.log('tab attraction (${attractionsSelected![index]})');
    var document = firestore.collection('locations').doc('locationInfo');
    var data = await document.get();
    Map<String, dynamic> attractionData = data.data() ?? {};
    // devtools.log(
    //     '${attractionData['${attractionsSelected![index]}']} ');
    Map attractionsSelect = attractionData['${attractionsSelected![index]}'];
    if (!mounted) return;
    Navigator.pop(context); //pop dialog
    Navigator.of(context)
        .push(FadePageRoute(LocationInfo(
          attractionsSelect: attractionsSelect,
          category: typeAttractionsSelected![index],
          name: attractionsSelected![index],
        )))
        .then((_) => setState(() {}));
  }

  Widget head(Size size) {
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
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: primaryBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // replacer == null ?
                  'Detail',
                  // : "Tour Guide (replacer)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.025,
                  ),
                  textAlign: TextAlign.left,
                ),
                Row(
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
                          fontSize: size.height * 0.02),
                      textAlign: TextAlign.left,
                    ),
                    InkWell(
                        onTap: () {
                          showPopupDialog(
                              context,
                              "You can cancel this booking and get refund within 48 hours",
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                status == 'Canceled'
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.attach_money_outlined),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Text(
                              "Refund Status : $refundStatus",
                              style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: size.height * 0.025),
                              textAlign: TextAlign.left,
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tourguide(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size.width,
          decoration: BoxDecoration(
            color: primaryBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: Text(
              detail['replacer'] == null
                  ? 'Tour Guide'
                  : "Tour Guide (replacer)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                fontSize: size.height * 0.025,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            devtools.log('go to guide info');
            Navigator.of(context)
                .push(FadePageRoute(GuideInfo(
                    guideData: detail['replacer'] ?? detail['tourGuideInfo'])))
                .then((_) => setState(() {}));
          },
          child: Container(
            decoration: BoxDecoration(
              color: primaryBackgroundColor,
            ),
            height: size.height * 0.12,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: detail['tourGuideInfo']['photoProfileURL'] ==
                                  null ||
                              detail['tourGuideInfo']['photoProfileURL'] ==
                                  '' ||
                              isFirebaseBug ||
                              detail['replacer'] != null
                          ? CircleAvatar(
                              radius: size.height * 0.05,
                              backgroundColor: primaryColor,
                              child: Icon(
                                Icons.person,
                                size: size.height * 0.05,
                                color: primaryTextColor,
                              ),
                            )
                          : CircleAvatar(
                              radius: size.height * 0.05,
                              backgroundImage: NetworkImage(
                                  detail['tourGuideInfo']['photoProfileURL']),
                              //  NetworkImage(tourGuide['photoProfileURL'])
                            ),
                    ),
                    SizedBox(
                      width: size.width * 0.6,
                      // color: Colors.amber,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            detail['replacer'] == null
                                ? '${detail['tourGuideInfo']['user_name']}'
                                : detail['replacer']['user_name'] != null
                                    ? '${detail['replacer']['user_name']}'
                                    : '${detail['replacer']['firstName']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: primaryTextColor,
                            ),
                          ),
                          Text(
                            detail['replacer'] == null
                                ? '(${detail['tourGuideInfo']['firstName']} ${detail['tourGuideInfo']['lastName']})'
                                : '(${detail['replacer']['firstName']} ${detail['replacer']['lastName']})',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: primaryTextColor,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          Flexible(
                            child: Text(
                              detail['replacer'] == null
                                  ? 'Email : ${detail['tourGuideInfo']['email']}'
                                  : 'Email : ${detail['replacer']['email']}',
                              overflow: TextOverflow.ellipsis,
                              // maxLines: 1,
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                          Text(
                            detail['replacer'] == null
                                ? 'Phone number : ${detail['tourGuideInfo']['phoneNumber']}'
                                : 'Phone number : ${detail['replacer']['phoneNumber']}',
                            overflow: TextOverflow.ellipsis,
                            // maxLines: 1,
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    '>',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        isNeedChangeGuide
            ? Padding(
                padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
                child: InkWell(
                  onTap: () async {
                    devtools.log("Go to ChangeGuide");
                    DateTime tempDate =
                        DateFormat('dd-MM-yyyy').parse(detail['datePlan']);
                    String date = DateFormat('yyyy-MM-dd').format(tempDate);
                    Navigator.of(context)
                        .push(FadePageRoute(ChangeGuide(
                          date: date,
                          detail: detail,
                          getFilter: filter,
                          getFilterGender: const [],
                          getFilterLanguages: const [],
                        )))
                        .then((value) => {
                              setState(() {
                                if (value) {
                                  isNeedChangeGuide = false;
                                }
                              })
                            });
                  },
                  child: Container(
                    height: size.height * 0.07,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Change Tour Guide',
                          style: TextStyle(
                            color: tertiaryColor,
                            fontSize: size.height * 0.023,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  Widget meetingPoint(Size size) {
    return Container(
      decoration: BoxDecoration(
        color: primaryBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text(
              'Meeting Point',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                fontSize: size.height * 0.025,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: size.height * 0.005,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    int? index = attractionsSelected
                        ?.indexOf(detail['meetingPoint']['name']);
                    onLoadingLocationInfo(index ?? 0, size);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondaryBackgroundColor.withOpacity(0.8)),
                    child: Row(children: [
                      Card(
                        color: Colors.white.withOpacity(0.1),
                        child: SizedBox(
                          width: size.width * 0.3,
                          height: size.height * 0.1,
                          child: isFirebaseBug
                              ? const Icon(Icons.developer_board)
                              : CachedNetworkImage(
                                  imageUrl: detail['meetingPoint']['pic'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                          // Image.network(
                          //     detail['meetingPoint']['pic'],
                          //     fit: BoxFit.fill,
                          //   )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: SizedBox(
                          width: size.width * 0.5,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      detail['meetingPoint']['name'],
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
                                      detail['meetingPoint']['type'],
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
        ],
      ),
    );
  }

  Widget attraction(Size size) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: primaryBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          // height: size.height * 0.15,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  // replacer == null ?
                  'Attraction',
                  // : "Tour Guide (replacer)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.025,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: size.height * 0.005,
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: attractionsSelected!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        onLoadingLocationInfo(index, size);
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: secondaryBackgroundColor.withOpacity(0.8),
                            ),
                            child: Row(children: [
                              Card(
                                // color: Colors.white.withOpacity(0.1),
                                child: SizedBox(
                                  width: size.width * 0.3,
                                  height: size.height * 0.1,
                                  child: isFirebaseBug
                                      ? const Icon(Icons.developer_board)
                                      : CachedNetworkImage(
                                          imageUrl:
                                              picAttractionsSelected![index],
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
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
                          ),
                          // Divider(
                          //   color: primaryTextColor.withOpacity(0.1),
                          //   thickness: 1,
                          // )
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget numberOf(Size size) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: primaryBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text(
              'Number of',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                fontSize: size.height * 0.025,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            // color: Colors.white,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Adult',
                                style: TextStyle(fontSize: size.height * 0.02),
                              ),
                              Text(
                                '${detail['numAdults']}',
                                style: TextStyle(fontSize: size.height * 0.02),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12, right: 30, left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Children',
                                style: TextStyle(fontSize: size.height * 0.02),
                              ),
                              Text(
                                '${detail['numChilds']}',
                                style: TextStyle(fontSize: size.height * 0.02),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12, right: 30, left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height * 0.022),
                              ),
                              Text(
                                '${detail['numChilds'] + detail['numAdults']}',
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
    );
  }

  Widget payment(Size size) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: primaryBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text(
              'Payment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                fontSize: size.height * 0.025,
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
                        detail['sedanCount'] != 0
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
                                            children: [
                                              Text('${detail['sedanCount']}'
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
                                              fontSize: size.height * 0.02),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${detail['sedanPrice']}',
                                      style: TextStyle(
                                          fontSize: size.height * 0.02),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        detail['vanCount'] != 0
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
                                            children: [
                                              Text('${detail['vanCount']}'
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
                                              fontSize: size.height * 0.02),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${detail['vanPrice']}',
                                      style: TextStyle(
                                          fontSize: size.height * 0.02),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      // color: Colors.amber,
                                      border: Border.all(
                                          color: primaryColor, width: 1.5),
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
                                        fontSize: size.height * 0.020),
                                  ),
                                ],
                              ),
                              Text(
                                '${detail['tourGuideFee']}',
                                style: TextStyle(fontSize: size.height * 0.020),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12, right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.height * 0.022),
                              ),
                              Text(
                                '฿${detail['totalPayment']}',
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
    );
  }

  bool isUserChooseGPay = false;
  bool isUserChooseUs = false;
  Widget cancelBotton(Size size) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: InkWell(
        onTap: () async {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    // contentPadding: EdgeInsets.all(0.0),
                    title: const Text('Are you sure to cancel this booking?'),
                    content: isCanGetRefund
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You can get refund',
                                style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              const Text('Please select a refund method.'),
                              ListTile(
                                onTap: (() {
                                  setState(() {
                                    isUserChooseGPay = !isUserChooseGPay;
                                    isUserChooseUs = false;
                                  });
                                }),
                                leading: Checkbox(
                                  value: isUserChooseGPay,
                                  onChanged: (v) {
                                    setState(() {
                                      isUserChooseGPay = v ?? !isUserChooseGPay;
                                      isUserChooseUs = false;
                                    });
                                  },
                                ),
                                title: const Text('Refund by Google Pay'),
                              ),
                              ListTile(
                                onTap: (() {
                                  setState(() {
                                    isUserChooseUs = !isUserChooseUs;
                                    isUserChooseGPay = false;
                                  });
                                }),
                                leading: Checkbox(
                                  value: isUserChooseUs,
                                  onChanged: (v) {
                                    setState(() {
                                      isUserChooseUs = v ?? !isUserChooseUs;
                                      isUserChooseGPay = false;
                                    });
                                  },
                                ),
                                title: const Text('Refund by Globle Guide'),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: '*Please ',
                                  style: TextStyle(
                                      color: primaryTextColor, fontSize: 16),
                                  children: [
                                    TextSpan(
                                      text: "read this policy",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: primaryTextColor,
                                          fontSize: 16),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          devtools
                                              .log("Go to RefundPolicyScreen");
                                          Navigator.of(context).push(
                                              FadePageRoute(
                                                  const RefundPolicyScreen()));
                                        },
                                    ),
                                    TextSpan(
                                      text: ' before select',
                                      style: TextStyle(
                                          color: primaryTextColor,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            "You can cancel this booking but you can't get refund"),
                    actions: isCanGetRefund
                        ? [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(FadePageRoute(
                                      const RefundPolicyScreen()));
                                },
                                child: const Text("More Info")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No")),
                            TextButton(
                                onPressed: () async {
                                  devtools.log('Cancel Booking');
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: SizedBox(
                                          height: size.height * 0.1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                color: primaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  if (isUserChooseUs) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(FadePageRoute(
                                        ConfirmCancel(
                                            detail: detail,
                                            indexToBack: indexToBack,
                                            bookingAllData: bookingAllData)));
                                  } else if (isUserChooseGPay) {
                                    detail['status'] = 'Canceled';
                                    firestore
                                        .collection('refund')
                                        .doc(detail['jobOrderFileName'])
                                        .set({
                                      'refund': 'refund by GPay',
                                      'uid': user?.uid,
                                      'orderID':
                                          '${detail['jobOrderFileName']}',
                                      'status': 'refund by GPay',
                                      'timeStamp': DateTime.now(),
                                    });
                                    firestore
                                        .collection('users')
                                        .doc(user?.uid)
                                        .collection('order')
                                        .doc('${detail['jobOrderFileName']}')
                                        .update({
                                      'status': detail['status'],
                                      'refund': 'refund by GPay',
                                      // 'timeStamp'
                                    }).then((value) => () {
                                              setState(() {
                                                devtools.log(
                                                    "doc Toursit update status");
                                              });
                                            });

                                    // final documentUserSnapshot =
                                    //     await firestore.collection('user').doc(user?.uid).get();
                                    // final userData = documentUserSnapshot.data();
                                    FirebaseApp tourGuideApp =
                                        await Firebase.initializeApp(
                                      name:
                                          'tourGuideApp', //note ผิดแน่ แต่ทำงานได้ งงอยู่
                                      options: DefaultFirebaseOptionsTourGuide
                                          .currentPlatform,
                                    );
                                    FirebaseFirestore tourGuideAppFirestore =
                                        FirebaseFirestore.instanceFor(
                                            app: tourGuideApp);
                                    String tourguideID =
                                        detail['tourGuideInfo']['tourGuideID'];
                                    if (detail['replacer'] != null) {
                                      if (detail['replacer']['tourGuideID'] !=
                                          null) {
                                        tourguideID =
                                            detail['replacer']['tourGuideID'];
                                      }
                                    }

                                    final collectionRef = tourGuideAppFirestore
                                        .collection('users')
                                        .doc(tourguideID);
                                    final querySnapshot =
                                        await collectionRef.get();
                                    final tourGuideData = querySnapshot.data();
                                    List tourGuideWorkDay =
                                        tourGuideData?['workDay'];
                                    List tourGuideFreeDay =
                                        tourGuideData?['freeDay'];
                                    DateTime datePlan = DateFormat("dd-MM-yyyy")
                                        .parse(detail['datePlan']);
                                    tourGuideWorkDay.remove(
                                        DateFormat("yyyy-MM-dd")
                                            .format(datePlan));
                                    tourGuideFreeDay.add(
                                        DateFormat("yyyy-MM-dd")
                                            .format(datePlan));
                                    tourGuideWorkDay.toSet().toList();
                                    tourGuideFreeDay.toSet().toList();
                                    tourGuideAppFirestore
                                        .collection('users')
                                        .doc(tourguideID)
                                        .update({
                                      'workDay': tourGuideWorkDay,
                                      'freeDay': tourGuideFreeDay
                                    });
                                    tourGuideAppFirestore
                                        .collection('users')
                                        .doc(tourguideID)
                                        .collection('order')
                                        .doc('${detail['jobOrderFileName']}')
                                        .update({
                                      'status': detail['status'],
                                    }).then((value) {
                                      setState(() {
                                        devtools.log(
                                            "doc tourGuideApp update status");
                                        Navigator.of(context)
                                          ..pop()
                                          ..pop()
                                          ..pop();
                                      });
                                    });
                                  }
                                },
                                child: const Text("Yes")),
                          ]
                        : [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(FadePageRoute(
                                      const RefundPolicyScreen()));
                                },
                                child: const Text("More Info")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No")),
                            TextButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: SizedBox(
                                          height: size.height * 0.1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                color: primaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  detail['status'] = 'Canceled';
                                  firestore
                                      .collection('users')
                                      .doc(user?.uid)
                                      .collection('order')
                                      .doc('${detail['jobOrderFileName']}')
                                      .update({
                                    'status': detail['status'],
                                    'refund': 'no refund',
                                  }).then((value) => () {
                                            setState(() {
                                              devtools.log(
                                                  "doc Toursit update status");
                                            });
                                          });

                                  // final documentUserSnapshot =
                                  //     await firestore.collection('user').doc(user?.uid).get();
                                  // final userData = documentUserSnapshot.data();
                                  FirebaseApp tourGuideApp =
                                      await Firebase.initializeApp(
                                    name:
                                        'tourGuideApp', //note ผิดแน่ แต่ทำงานได้ งงอยู่
                                    options: DefaultFirebaseOptionsTourGuide
                                        .currentPlatform,
                                  );
                                  FirebaseFirestore tourGuideAppFirestore =
                                      FirebaseFirestore.instanceFor(
                                          app: tourGuideApp);
                                  String tourguideID =
                                      detail['tourGuideInfo']['tourGuideID'];
                                  if (detail['replacer'] != null) {
                                    if (detail['replacer']['tourGuideID'] !=
                                        null) {
                                      tourguideID =
                                          detail['replacer']['tourGuideID'];
                                    }
                                  }

                                  final collectionRef = tourGuideAppFirestore
                                      .collection('users')
                                      .doc(tourguideID);
                                  final querySnapshot =
                                      await collectionRef.get();
                                  final tourGuideData = querySnapshot.data();
                                  List tourGuideWorkDay =
                                      tourGuideData?['workDay'];
                                  List tourGuideFreeDay =
                                      tourGuideData?['freeDay'];
                                  DateTime datePlan = DateFormat("dd-MM-yyyy")
                                      .parse(detail['datePlan']);
                                  tourGuideWorkDay.remove(
                                      DateFormat("yyyy-MM-dd")
                                          .format(datePlan));
                                  tourGuideFreeDay.add(DateFormat("yyyy-MM-dd")
                                      .format(datePlan));
                                  tourGuideAppFirestore
                                      .collection('users')
                                      .doc(tourguideID)
                                      .update({
                                    'workDay': tourGuideWorkDay,
                                    'freeDay': tourGuideFreeDay
                                  });
                                  tourGuideAppFirestore
                                      .collection('users')
                                      .doc(tourguideID)
                                      .collection('order')
                                      .doc('${detail['jobOrderFileName']}')
                                      .update({
                                    'status': detail['status'],
                                  }).then((value) {
                                    setState(() {
                                      devtools.log(
                                          "doc tourGuideApp update status");
                                      Navigator.of(context)
                                        ..pop()
                                        ..pop()
                                        ..pop();
                                    });
                                  });
                                },
                                child: const Text("Yes")),
                          ],
                  );
                },
              );

              // devtools.log('Cancel Booking');
              // Navigator.of(context).push(FadePageRoute(ConfirmCancel(
              //     detail: detail,
              //     indexToBack: indexToBack,
              //     bookingAllData: bookingAllData)));
            },
          );
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
                  'Cancel Booking',
                  style: TextStyle(
                    color: tertiaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget reviewBotton(Size size) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: InkWell(
        onTap: () async {
          devtools.log('Cancel Booking');
          // showPopupDialog(context, 'ยังไม่เสร็จ', 'Cancel Booking', [
          //   TextButton(
          //       onPressed: () {
          //         Navigator.of(context).pop();
          //       },
          //       child: const Text("OK"))
          // ]);
          Navigator.of(context)
              .push(FadePageRoute(Review(detail: detail)))
              .then((_) => setState(() {}));
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
              children: detail['review'] == null
                  ? [
                      const Icon(Icons.star_border),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text(
                        'Review',
                        style: TextStyle(
                          color: tertiaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  : [
                      const Icon(Icons.star_border),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Text(
                        'Your Review',
                        style: TextStyle(
                          color: tertiaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }

  Widget contactUsBotton(Size size) {
    Future<void> launchUrlEmail() async {
      String email = "oopakjiraoo@gmail.com";
      String subject = "";
      String body = "\n\n\n\n(contact by ${user?.uid})";
      Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
      if (await launchUrl(mail)) {
        //email app opened
      } else {
        devtools.log('Could not launch');
      }
    }

    return Padding(
      padding: const EdgeInsets.all(30),
      child: InkWell(
        onTap: () async {
          devtools.log("Go to Contact email");
          launchUrlEmail();
        },
        child: Container(
          height: size.height * 0.07,
          width: size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Contact Us',
                style: TextStyle(
                  color: tertiaryColor,
                  fontSize: size.height * 0.023,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
