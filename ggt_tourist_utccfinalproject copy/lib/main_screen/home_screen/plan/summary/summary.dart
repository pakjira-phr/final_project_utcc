import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:ggt_tourist_utccfinalproject/firebase_options_tour_guide.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/plan/plan_1.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/plan/summary/refund_policy.dart';
import 'package:ggt_tourist_utccfinalproject/widget/popup_dialog.dart';
import 'dart:developer' as devtools show log;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

import '../../../../utillties/custom_page_route.dart';
import '../../../../utillties/json_assets.dart';
import '../../../../widget/small_user_card3.dart';
import '../../../main_screen.dart';
import 'component/contact_info.dart';
import 'component/meeting_point.dart';

// ignore: must_be_immutable
class Summary extends StatefulWidget {
  // const Summary({super.key});
  Summary({
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
  State<Summary> createState() => _SummaryState(
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

class _SummaryState extends State<Summary> {
  _SummaryState({
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

  bool isFirebaseBug = false;
  List? attractionsSelected; //for debug
  List? typeAttractionsSelected;
  List? picAttractionsSelected;
  // Duration durationCount = const Duration(hours: 0, minutes: 0); //for debug
  int total = 0;
  int tourGuidePrice = 0;
  String link = '';
  bool isLoading = false;
  String contactEmail = '';
  String contactPhoneNum = '';
  String contactName = '';
  bool checkContactInfo = true;
  bool isAccepedRefundPolicy = false;

  @override
  void initState() {
    attractionsSelected = attractions['attractionsSelected'] ?? [];
    typeAttractionsSelected = attractions['typeAttractionsSelected'] ?? [];
    picAttractionsSelected = attractions['picAttractionsSelected'] ?? [];
    contactEmail = '${contactData['email']}';
    contactPhoneNum = '${contactData['phoneNumber']}';
    contactName = '${contactData['userName']}';
    if (contactEmail == '' || contactPhoneNum == '' || contactName == '') {
      checkContactInfo = false;
    }
    switch (timeSelected) {
      case 'All Day':
        tourGuidePrice = 1500;
        break;
      case 'Half Day':
        tourGuidePrice = 1000;
        break;
      case 'Night':
        tourGuidePrice = 1000;
        break;
      default:
        tourGuidePrice = 1500;
    }
    total = sedanPrice + vanPrice + tourGuidePrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     devtools.log('${checkContactInfo && meetingPoint.isNotEmpty}');

      //     // devtools.log(tourGuide['workDay'].toString());
      //     // [tourGuideSelected]
      //   },
      // ),
      backgroundColor: secondaryBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: secondaryBackgroundColor,
        elevation: 0,
        title: Text(
          "Summary",
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
                  FadePageRoute(Plan1(
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
                    meetingPoint: meetingPoint,
                    contactData: contactData,
                  )),
                  (Route<dynamic> route) => false);
            }),
      ),
      body: SingleChildScrollView(
        child: !isLoading
            ? Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            devtools.log('tap Contact Information');
                            Navigator.of(context).pushAndRemoveUntil(
                                FadePageRoute(ContactInfoOrder(
                                  attractions: attractions,
                                  attractionsAndCategory:
                                      attractionsAndCategory,
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
                          child: Card(
                            color: Colors.white,
                            child: SizedBox(
                              width: size.width,
                              // height: size.height * 0.2,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Contact Information',
                                          style: TextStyle(
                                              fontSize: size.height * 0.025,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Email : $contactEmail',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.023),
                                              ),
                                              Text(
                                                'Phone : $contactPhoneNum',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.023),
                                              ),
                                              Text(
                                                'Name : $contactName',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.023),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '>',
                                      style: TextStyle(
                                          fontSize: size.height * 0.04),
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
                  checkContactInfo
                      ? const SizedBox()
                      : const Text(
                          'You should complete the information.',
                          style: TextStyle(color: Colors.red),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 2, left: 10, right: 10, bottom: 2),
                    child: InkWell(
                      onTap: () {
                        devtools.log('tap Meeting point');
                        Navigator.of(context).pushAndRemoveUntil(
                            FadePageRoute(MeetingPoint(
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
                      child: Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: size.width,
                          // height: size.height * 0.2,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Meeting Point',
                                      style: TextStyle(
                                          fontSize: size.height * 0.025,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Row(children: [
                                              meetingPoint.isEmpty
                                                  ? const SizedBox()
                                                  : Card(
                                                      color: Colors.white,
                                                      child: SizedBox(
                                                        width: size.width * 0.3,
                                                        height:
                                                            size.height * 0.12,
                                                        child: isFirebaseBug
                                                            ? const Icon(Icons
                                                                .developer_board)
                                                            : CachedNetworkImage(
                                                                imageUrl:
                                                                    meetingPoint[
                                                                        'pic'],
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const CircularProgressIndicator(),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                        // Image.network(
                                                        //     meetingPoint[
                                                        //         'pic'],
                                                        //     fit: BoxFit
                                                        //         .fill,
                                                        //   )
                                                      ),
                                                    ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: SizedBox(
                                                  // color: Colors.amber,
                                                  width: meetingPoint.isEmpty
                                                      ? size.width * 0.8
                                                      : size.width * 0.5,
                                                  // alignment: Alignment.topLeft,
                                                  child: Column(
                                                    children:
                                                        meetingPoint.isEmpty
                                                            ? [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: const [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          'Please select your meeting point ',
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: Colors.red),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ]
                                                            : [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        meetingPoint[
                                                                            'name'],
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              primaryTextColor,
                                                                          fontSize:
                                                                              size.height * 0.018,
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
                                                                      child:
                                                                          Text(
                                                                        meetingPoint[
                                                                            'type'],
                                                                        style:
                                                                            TextStyle(
                                                                          // fontWeight: FontWeight.bold,
                                                                          color:
                                                                              primaryTextColor,
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
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '>',
                                  style:
                                      TextStyle(fontSize: size.height * 0.04),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Divider(
                        color: Colors.grey.withOpacity(0.4), thickness: 1.5),
                  ),
                  summary(size),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(children: [
                      SizedBox(
                        width: size.width * 0.15,
                        child: Checkbox(
                            checkColor: tertiaryColor,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isAccepedRefundPolicy,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context).unfocus();
                                isAccepedRefundPolicy =
                                    value ?? !isAccepedRefundPolicy;
                              });
                            }),
                      ),
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: "I have read and agree to our ",
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryTextColor,
                            ),
                          ),
                          TextSpan(
                            text: "Refund Policy",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                devtools.log("Go to RefundPolicyScreen");
                                Navigator.of(context).push(
                                    FadePageRoute(const RefundPolicyScreen()));
                              },
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              color: primaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ])),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    child: GooglePayButton(
                      paymentConfigurationAsset: JsonAssets.gpayAsset,
                      paymentItems: paymentItems,
                      onPaymentResult: onGooglePayResult,
                      // style: GooglePayButtonStyle.white,
                      margin: const EdgeInsets.only(top: 15.0),
                      width: double.maxFinite,
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 50),
                    child: Text(
                      "**If the booking status is Pendding, you can cancel and get a refund within 48 hours of booking.",
                      style: TextStyle(
                        // decoration: TextDecoration.underline,
                        fontSize: 16,
                        color: primaryTextColor,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            : SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: tertiaryColor,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    if (isAccepedRefundPolicy) {
      return primaryColor;
    }
    return Colors.red;
  }

  List<PaymentItem> get paymentItems {
    // """ for when get json API นะ """
    // String amount = total.toString();
    // final paymentItems = [
    //   PaymentItem(
    //     label: 'Total',
    //     amount: amount,
    //     status: PaymentItemStatus.final_price,
    //   ),
    // ];

    const paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: '0',
        status: PaymentItemStatus.final_price,
        // status: PaymentItemStatus.unknown,
      ),
    ];

    return paymentItems;
  }

  void onGooglePayResult(dynamic paymentResult) async {
    if (checkContactInfo && meetingPoint.isNotEmpty && isAccepedRefundPolicy) {
      setState(() {
        isLoading = true;
      });
      debugPrint(paymentResult.toString());
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference collectionRef = firestore.collection('users');
      User? user = FirebaseAuth.instance.currentUser;
      final userData = await collectionRef.doc(user!.uid).get();
      final mapUserData = userData.data() as Map<String, dynamic>;
      String userIDNO = '';
      if (mapUserData['passportID'] == '' ||
          mapUserData['passportID'] == null) {
        userIDNO = mapUserData['ThaiIDNumber'].toString();
      } else {
        userIDNO = mapUserData['passportID'].toString();
      }
      // devtools.log('userData ${userData.data()}');
      devtools.log(
          'userData ${mapUserData['firstName']} ${mapUserData['lastName']} ${mapUserData['national']} $userIDNO');
      final DateFormat format = DateFormat("EEEE, dd MMMM " 'yyyy');
      final DateFormat format2 = DateFormat("dd MMMM yyyy");
      int id = DateTime.now().millisecondsSinceEpoch; //ข้อมูลสมมุติ
      String today = format.format(DateTime.now());
      String date = format2.format(planDate);
      String tourOperatorName = 'Globle Guide'; //ข้อมูลสมมุติ
      String licenseNo = '1101893'; //ข้อมูลสมมุติ
      String tourGuideName =
          '${tourGuide["firstName"]} ${tourGuide["lastName"]}';
      String licensetourGuideNo = '${tourGuide["licenseCardNo"]}';
      int tourGuideFee = tourGuidePrice;
      int numAdults = numAdult;
      int numChilds = numChildren;
      List touristData = [];
      List attractionData = [];
      int count = 0;
      for (int i = 0; i < yourTeamInfo['adultsInfo'].length; i++) {
        List temp = [];
        count++;
        if (yourTeamInfo['adultsInfo'][i][0] == 'me') {
          temp.add('$count');
          temp.add('${mapUserData['firstName']} ${mapUserData['lastName']}');
          temp.add(userIDNO);
          temp.add('${mapUserData['national']}');
        } else {
          temp.add('$count');
          temp.add(
              "${yourTeamInfo['adultsInfo'][i][0]} ${yourTeamInfo['adultsInfo'][i][1]}");
          if (yourTeamInfo['adultsInfo'][i][3].length == 0) {
            temp.add("${yourTeamInfo['adultsInfo'][i][2]}");
          } else {
            temp.add("${yourTeamInfo['adultsInfo'][i][3]}");
          }
          temp.add("${yourTeamInfo['adultsInfo'][i][4]}");
        }
        touristData.add(temp);
      }
      for (int i = 0; i < yourTeamInfo['childrenInfo'].length; i++) {
        List temp = [];
        count++;
        if (yourTeamInfo['childrenInfo'][i][0] == 'me') {
          temp.add('$count');
          temp.add('${mapUserData['firstName']} ${mapUserData['lastName']}');
          temp.add('${mapUserData['national']}');
          temp.add(userIDNO);
        } else {
          temp.add('$count');
          temp.add(
              "${yourTeamInfo['childrenInfo'][i][0]} ${yourTeamInfo['childrenInfo'][i][1]}");
          if (yourTeamInfo['childrenInfo'][i][3].length == 0) {
            temp.add("${yourTeamInfo['childrenInfo'][i][2]}");
          } else {
            temp.add("${yourTeamInfo['childrenInfo'][i][3]}");
          }
          temp.add("${yourTeamInfo['childrenInfo'][i][4]}");
        }
        touristData.add(temp);
      }
      devtools.log('${attractions["attractionsSelected"]}');
      for (int i = 0; i < attractions["attractionsSelected"].length; i++) {
        List temp = [];
        temp.add(date);
        temp.add(attractions["attractionsSelected"][i]);
        attractionData.add(temp);
      }
      await _createPDF(
          id,
          today,
          tourOperatorName,
          licenseNo,
          tourGuideName,
          licensetourGuideNo,
          tourGuideFee,
          numAdults,
          numChilds,
          touristData,
          attractionData);
      String timeStamp = DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now());
      firestore
          .collection('users')
          .doc(user.uid)
          .collection('order')
          .doc('$id')
          .set({
        'jobOrderFileName': id.toString(),
        'jobOrderFile': link,
        'date': today,
        'datePlan': DateFormat("dd-MM-yyyy").format(planDate),
        'timePlan': timeSelected,
        'tourGuideInfo': tourGuide,
        'tourGuideFee': tourGuideFee.toString(),
        'numAdults': numAdults,
        'numChilds': numChilds,
        'sedanPrice': sedanPrice,
        'sedanCount': sedanCount,
        'vanPrice': vanPrice,
        'vanCount': vanCount,
        'attractions': attractions,
        'totalPayment': total,
        'touristData': jsonEncode(touristData),
        'status': 'Pending',
        'touristUid': user.uid,
        'contactData': contactData,
        'meetingPoint': meetingPoint,
        'paymentResult': paymentResult,
        'timeStamp': timeStamp
      }).then((value) {
        devtools.log("doc Tourist Added");
      });

      FirebaseApp tourGuideApp = await Firebase.initializeApp(
        name: 'touristApp', //note ผิดแน่ แต่ทำงานได้ งงอยู่
        options: DefaultFirebaseOptionsTourGuide.currentPlatform,
      );

      FirebaseFirestore tourGuideFirestore =
          FirebaseFirestore.instanceFor(app: tourGuideApp);

      tourGuideFirestore
          .collection('users')
          .doc('${tourGuide['tourGuideID']}')
          .collection('order')
          .doc('$id')
          .set({
        'jobOrderFileName': id.toString(),
        'jobOrderFile': link,
        'date': today,
        'datePlan': DateFormat("dd-MM-yyyy").format(planDate),
        'timePlan': timeSelected,
        'tourGuideInfo': tourGuide,
        'tourGuideFee': tourGuideFee.toString(),
        'numAdults': numAdults,
        'numChilds': numChilds,
        'sedanPrice': sedanPrice,
        'sedanCount': sedanCount,
        'vanPrice': vanPrice,
        'vanCount': vanCount,
        'attractions': attractions,
        'totalPayment': total,
        'touristData': jsonEncode(touristData),
        'status': 'Pending',
        'touristUid': user.uid,
        'contactData': contactData,
        'meetingPoint': meetingPoint,
        'paymentResult': paymentResult,
        'timeStamp': timeStamp
      }).then((value) {
        devtools.log("doc TourGuide Added");
      });
      List tourGuideWorkDay = tourGuide['workDay'];
      List tourGuideFreeDay = tourGuide['freeDay'];
      tourGuideWorkDay.add(DateFormat("yyyy-MM-dd").format(planDate));
      tourGuideFreeDay.remove(DateFormat("yyyy-MM-dd").format(planDate));
      tourGuideFirestore
          .collection('users')
          .doc('${tourGuide['tourGuideID']}')
          .update({
        'workDay': tourGuideWorkDay,
        'freeDay': tourGuideFreeDay,
      });

      finalDialog();
    } else if (!isAccepedRefundPolicy) {
      showPopupDialog(
          context,
          'Please read and check the check box to agree our Refund policy',
          'Check again', [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"))
      ]);
    } else {
      showPopupDialog(
          context,
          'Please double check your contact information and meeting point.',
          'Check again', [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"))
      ]);
    }
  }

  finalDialog() {
    showPopupDialog(
      context,
      'Thank you for booking!',
      'Successfull',
      [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                  FadePageRoute(MainScreen(index: 0)),
                  (Route<dynamic> route) => false);
            },
            child: const Text("OK"))
      ],
    );
  }

  Widget summary(Size size) {
    return Column(
      children: [
        // Container(
        //   // color: Colors.amber,
        //   width: size.width,
        //   alignment: Alignment.topLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.only(top: 20, left: 20, bottom: 2),
        //     child: Text(
        //       "Summary ",
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         color: primaryTextColor,
        //         fontSize: size.height * 0.025,
        //       ),
        //       textAlign: TextAlign.left,
        //     ),
        //   ),
        // ),
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
                padding: const EdgeInsets.only(left: 20),
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
                    child: ListView.builder(
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
                                                imageUrl:
                                                    picAttractionsSelected![
                                                        index],
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
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
                                      padding: const EdgeInsets.only(left: 5),
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
                                                    attractionsSelected![index],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                        fontSize:
                                                            size.height * 0.02),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '$sedanPrice',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.02),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
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
                                                        fontSize:
                                                            size.height * 0.02),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '$vanPrice',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.02),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
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
                                                      size.height * 0.020),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '$tourGuidePrice',
                                          style: TextStyle(
                                              fontSize: size.height * 0.020),
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
                                          '฿$total',
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
            font: PdfStandardFont(PdfFontFamily.helvetica, 10),
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
            page: page,
            bounds:
                Rect.fromLTWH(10, 95, pageSize.width - 20, pageSize.height))!;
    PdfTextElement(
            text: 'Tour operator name : $tourOperatorName',
            font: PdfStandardFont(PdfFontFamily.helvetica, 10),
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
            font: PdfStandardFont(PdfFontFamily.helvetica, 10),
            format: PdfStringFormat(
                alignment: PdfTextAlignment.left,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
            page: page,
            bounds:
                Rect.fromLTWH(10, 125, pageSize.width - 20, pageSize.height))!;
    PdfTextElement(
            text: 'Tour guide fee : $tourGuideFee',
            font: PdfStandardFont(PdfFontFamily.helvetica, 10),
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

    await saveAndLaunchFile(bytesList, '$id.pdf', id, tourGuide, planDate);
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

  Future saveAndLaunchFile(List<int> bytesList, String fileName, int id,
      Map tourGuide, DateTime planDate) async {
    final path = Platform.isAndroid
        ? (await getExternalStorageDirectory())?.path
        : (await getApplicationSupportDirectory()).path;

    final file = File('$path/$fileName');
    await file.writeAsBytes(bytesList, flush: true);
    // OpenFile.open('$path/$fileName');

//-------------------------add to firebase--------------------------------------------------
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child("jobOrder").child('$id').child(fileName);
    await fileRef.putFile(file).whenComplete(() => devtools.log('pdf added'));
    link = await fileRef.getDownloadURL();
  }
}
