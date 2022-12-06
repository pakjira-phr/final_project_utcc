// import 'dart:io';

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ggt_tour_guide_utccfinalproject/constant.dart';
import 'package:ggt_tour_guide_utccfinalproject/firebase_options_tourist.dart';

import 'dart:developer' as devtools show log;
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:url_launcher/url_launcher.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../../../utillties/calculate_age.dart';
import '../../../../utillties/custom_page_route.dart';
import '../../location_info.dart';

// import '../../utillties/custom_page_route.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_pdf_viewer/flutter_pdf_viewer.dart';

// ignore: must_be_immutable
class HistoryJobDetail extends StatefulWidget {
  HistoryJobDetail(
      {super.key,
      required this.detail,
      required this.indexToBack,
      required this.orderAllData});
  Map detail;
  int indexToBack;
  Map orderAllData;

  @override
  // ignore: no_logic_in_create_state
  State<HistoryJobDetail> createState() =>
      // ignore: no_logic_in_create_state
      _HistoryJobDetailState(
          detail: detail, indexToBack: indexToBack, orderAllData: orderAllData);
}

class _HistoryJobDetailState extends State<HistoryJobDetail> {
  _HistoryJobDetailState(
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
  String status = '';
  Map? replacer;

  Map? review;
  double rating = 5.0;
  String ratingText = 'Amazing';
  TextEditingController? commentController;

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
    getStringTime();
    getStatusIcon();
    commentController = TextEditingController();

    review = detail['review'];
    if (review != null) {
      rating = review?['rating'];
      commentController?.text = review?['comment'];
      switch (rating.toString()) {
        case ('1.0'):
          ratingText = 'Terrible';
          break;
        case ('2.0'):
          ratingText = 'Poor';
          break;
        case ('3.0'):
          ratingText = 'Fair';
          break;
        case ('4.0'):
          ratingText = 'Good';
          break;
        case ('5.0'):
          ratingText = 'Amazing';
          break;
        default:
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: primaryBackgroundColor,
          // floatingActionButton: FloatingActionButton(onPressed: () async {
          //   try {
          //     devtools.log('${detail['review']}');
          //   } catch (e) {
          //     devtools.log('e $e');
          //   }
          // }),
          appBar: AppBar(
            backgroundColor: primaryBackgroundColor,
            title: const Text("Job Detail",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                Navigator.of(context).pop();
              },
            ),
            bottom: TabBar(
              // isScrollable: true,
              indicatorColor: primaryColor,
              onTap: (int index) {},
              tabs: const [
                Tab(
                  child: Text(
                    'Detail',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Tab(
                  child: Text(
                    'Comment',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              detailTab(size),
              commentTab(size),
            ],
          )),
    );
  }

  Widget detailTab(Size size) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          head(size),
          replacerInfo(size),
          attrations(size),
          tourists(size),
          SizedBox(
            height: size.height * 0.1,
          )
        ],
      ),
    ));
  }

  Widget commentTab(Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Tourist Comment",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.035),
                textAlign: TextAlign.left,
              ),
            ),
            detail['review'] == null
                ? Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white, width: size.width * 0.005),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Tourists haven't rated their service satisfaction.",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Rating',
                              style: TextStyle(fontSize: size.width * 0.05),
                            ),
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            RatingBar.builder(
                              ignoreGestures: true,
                              updateOnDrag: true,
                              initialRating: rating,
                              itemCount: 5,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (ratingUpdate) {
                                if (review == null) {
                                  setState(() {
                                    rating = ratingUpdate;
                                    switch (rating.toString()) {
                                      case ('1.0'):
                                        ratingText = 'Terrible';
                                        break;
                                      case ('2.0'):
                                        ratingText = 'Poor';
                                        break;
                                      case ('3.0'):
                                        ratingText = 'Fair';
                                        break;
                                      case ('4.0'):
                                        ratingText = 'Good';
                                        break;
                                      case ('5.0'):
                                        ratingText = 'Amazing';
                                        break;
                                      default:
                                    }
                                  });
                                } else {
                                  setState(() {
                                    rating = rating;
                                  });
                                }

                                devtools.log('$ratingUpdate $ratingText');
                              },
                            ),
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            Text(
                              ratingText,
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 198, 151, 9),
                                  fontSize: size.width * 0.04),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextFormField(
                          // maxLength: 300,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(300),
                          ],
                          controller: commentController,
                          // initialValue: commentController?.text ?? '',
                          readOnly: true,
                          keyboardType: TextInputType.multiline,
                          minLines: 7,
                          maxLines: 7,
                          onChanged: (value) {
                            setState(() {
                              commentController?.text = value;
                              commentController?.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: commentController!.text.length));
                            });
                          },
                          decoration: InputDecoration(
                              labelText: 'Comment',
                              hintText: 'Enter Comment',
                              labelStyle: TextStyle(
                                  fontSize: 25, color: primaryTextColor),
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: const OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 17),
                              // maxLines: 3,
                              // Display the number of entered characters
                              counterText:
                                  '${commentController?.text.length.toString()} / 300 character(s)'),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
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
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.of(context).push(FadePageRoute(
                    //         OutsideReplacer(
                    //             detail: detail,
                    //             indexToBack: indexToBack,
                    //             orderAllData: orderAllData)));
                    //   },
                    //   child: Text(
                    //     "Edit >",
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       color: secondaryColor,
                    //       fontSize: size.height * 0.02,
                    //     ),
                    //     textAlign: TextAlign.left,
                    //   ),
                    // ),
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
}
