import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/component/job_detail/job_detail.dart';
import 'package:ggt_tour_guide_utccfinalproject/widget/popup_dialog.dart';

import '../../../constant.dart';
import 'dart:developer' as devtools show log;

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../../utillties/custom_page_route.dart';
import '../../../utillties/get_message.dart';
import '../../../widget/show_error_dialog.dart';

import '../../main_screen.dart';

// ignore: must_be_immutable
class EventDetails extends StatefulWidget {
  // const EventDetail({super.key});
  EventDetails({
    super.key,
    required this.isWork,
    required this.date,
  });
  bool isWork;
  DateTime? date;

  @override
  State<EventDetails> createState() =>
      // ignore: no_logic_in_create_state
      _EventDetailsState(isWork: isWork, date: date);
}

class _EventDetailsState extends State<EventDetails> {
  _EventDetailsState({
    required this.isWork,
    required this.date,
  });
  bool isWork;
  DateTime? date;

  List free = [];

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  bool loadingSuss = false;
  bool dataMap = false;

  Map orderAllData = {};
  List orderData = [];
  List orderId = [];
  Map detail = {};
  List? attractionsSelected;
  List? typeAttractionsSelected;
  List? picAttractionsSelected;
  String status = '';
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
        statusIcon = Icon(
          Icons.pending,
          color: primaryBackgroundColor,
        );
      } else if (status == 'Accepted') {
        statusIcon = Icon(
          Icons.play_circle_sharp,
          color: primaryBackgroundColor,
        );
      } else if (status == 'In Progress') {
        statusIcon = Icon(
          Icons.incomplete_circle_sharp,
          color: primaryBackgroundColor,
        );
      } else if (status == 'Finished') {
        statusIcon = Icon(
          Icons.check_circle_rounded,
          color: primaryBackgroundColor,
        );
      } else {
        statusIcon = Icon(
          Icons.error,
          color: primaryBackgroundColor,
        );
      }
    });
  }

  // getData(Size size) {
  //   status = detail['status'];
  //   getStringTime();
  //   getStatusIcon();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference collectionRef = firestore.collection('users');
    Future checkDataBase() async {
      CollectionReference orderCollectionRef =
          collectionRef.doc(user!.uid).collection('order');
      QuerySnapshot querySnapshot = await orderCollectionRef.get();
      orderData = querySnapshot.docs.map((doc) => doc.data()).toList();
      orderId = querySnapshot.docs.map((doc) => doc.id).toList();
      for (int i = 0; i < orderId.length; i++) {
        orderAllData[orderId[i]] = orderData[i];
      }
      for (int i = 0; i < orderId.length; i++) {
        //check งานวันนี้
        if (orderAllData[orderId[i]]['datePlan'] ==
            DateFormat("dd-MM-yyyy").format(date!)) {
          setState(() {
            detail = orderAllData[orderId[i]];
          });
        }
      }

      //----------------------------------
      // getData(size);// for test เฉยๆ
      status = detail['status'];
      getStringTime();
      getStatusIcon();
    }

    return FutureBuilder<DocumentSnapshot>(
      future: collectionRef.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done || loadingSuss) {
          loadingSuss = true;
          if (!dataMap) {
            userData = snapshot.data!.data() as Map<String, dynamic>;
            dataMap = true;
            free = userData!['freeDay'];

            //detail
            if (isWork) {
              checkDataBase();
            }
          }
          return Scaffold(
            // floatingActionButton: FloatingActionButton(onPressed: () {
            //   devtools.log('$detail');
            // }),
            backgroundColor: primaryBackgroundColor,
            appBar: AppBar(
              toolbarHeight: size.height * 0.06,
              backgroundColor: primaryBackgroundColor,
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(Icons.close, color: secondaryBackgroundColor),
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        FadePageRoute(MainScreen(index: 1)),
                        (Route<dynamic> route) => false),
                  ),
                )
              ],
              elevation: 0,
            ),
            body: Column(
              children: [
                SizedBox(
                  height: size.height * 0.03,
                ),
                Center(
                  child: Container(
                    height: size.height - (size.height * 0.3),
                    width: size.width - (size.width * 0.1),
                    decoration: BoxDecoration(
                      // border:
                      //     Border.all(color: primaryBackgroundColor.withOpacity(0.9)),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: size.height * 0.2,
                          width: size.width - (size.width * 0.1),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.2)),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(28),
                                  topRight: Radius.circular(28)),
                              color: isWork ? secondaryColor : primaryColor),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                Text(
                                  isWork ? "Work Day" : "Free Day",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                      fontSize: 50),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Text(
                                  DateFormat("EEEE, d MMM " 'yyyy')
                                      .format(DateTime.parse(date.toString()))
                                      .toString(),
                                  style: TextStyle(
                                      color: primaryTextColor, fontSize: 20),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 20, top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: isWork
                                ? [
                                    Text(
                                      "Event details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryBackgroundColor,
                                          fontSize: 23),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    Text(
                                      "Job order NO. ${detail['jobOrderFileName']}",
                                      style: TextStyle(
                                          color: primaryBackgroundColor,
                                          fontSize: 18),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_filled,
                                          color: primaryBackgroundColor,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.02,
                                        ),
                                        Text(
                                          time,
                                          style: TextStyle(
                                              color: primaryBackgroundColor,
                                              fontSize: 18),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Row(
                                      children: [
                                        statusIcon ??
                                            Icon(
                                              Icons.error,
                                              color: primaryBackgroundColor,
                                            ),
                                        SizedBox(
                                          width: size.width * 0.02,
                                        ),
                                        Text(
                                          "Status : $status",
                                          style: TextStyle(
                                              color: primaryBackgroundColor,
                                              fontSize: 18),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.attach_money_rounded,
                                          color: primaryBackgroundColor,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.02,
                                        ),
                                        Text(
                                          "Earnings : ${detail['tourGuideFee']}",
                                          style: TextStyle(
                                              color: primaryBackgroundColor,
                                              fontSize: 18),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.15,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        devtools.log("Go to JobDetail");
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                FadePageRoute(JobDetail(
                                                  detail: detail,
                                                  indexToBack: 1, orderAllData: const {},
                                                )),
                                                (Route<dynamic> route) =>
                                                    false);
                                      },
                                      child: Container(
                                        height: size.height * 0.07,
                                        width: size.width * 0.9,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: primaryColor,
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     color: Colors.grey.withOpacity(0.5),
                                          //     spreadRadius: 2,
                                          //     blurRadius: 7,
                                          //     offset:
                                          //         const Offset(0, 3), // changes position of shadow
                                          //   ),
                                          // ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'More detail',
                                              style: TextStyle(
                                                color: secondaryBackgroundColor,
                                                fontSize: size.height * 0.023,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]
                                : [
                                    Text(
                                      "Event details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryBackgroundColor,
                                          fontSize: 23),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Text(
                                      "Free day means the day you alrady to work. This details will be update when it a work day",
                                      style: TextStyle(
                                          color: primaryBackgroundColor,
                                          fontSize: 18),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Container(
                  child: isWork
                      ? const Text('')
                      : ElevatedButton(
                          onPressed: () {
                            devtools.log("delete");
                            showPopupDialog(
                                context, "Are you sure to delete.", 'Delete', [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () {
                                    var temp = DateFormat("yyyy-MM-dd")
                                        .format(DateTime.parse(date.toString()))
                                        .toString();
                                    free.remove(temp);
                                    try {
                                      firestore
                                          .collection('users')
                                          .doc(user?.uid)
                                          .update({
                                        'freeDay': free,
                                      });

                                      devtools.log('update sussces');
                                      Navigator.of(context).pushAndRemoveUntil(
                                          FadePageRoute(MainScreen(index: 1)),
                                          (Route<dynamic> route) => false);
                                    } on FirebaseAuthException catch (e) {
                                      devtools.log(e.toString());
                                      devtools
                                          .log(getMessageFromErrorCode(e.code));
                                      showErrorDialog(
                                          context,
                                          getMessageFromErrorCode(e.code)
                                              .toString());

                                      // handle if reauthenticatation was not successful
                                    } catch (e) {
                                      devtools.log(e.toString());
                                      showErrorDialog(context, e.toString());
                                    }
                                  },
                                  child: const Text("Delete"))
                            ]);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(14),
                              primary: secondaryColor),
                          child: Icon(
                            Icons.delete_rounded,
                            size: 30,
                            color: primaryTextColor,
                          ),
                        ),
                )
              ],
            ),
          );
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
      },
    );
  }

  Widget head(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
}
