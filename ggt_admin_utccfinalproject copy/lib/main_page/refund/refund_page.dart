import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ggt_admin_utccfinalproject/firebase_options_tourist.dart';
import 'package:ggt_admin_utccfinalproject/main_page/refund/refund_detail.dart';
import 'dart:developer' as devtools show log;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../constant.dart';
import '../../utillties/custom_page_route.dart';

class RefundPage extends StatefulWidget {
  const RefundPage({super.key});

  @override
  State<RefundPage> createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  bool isGetData = false;
  List refundData = [];
  List refundId = [];
  Map refundAllData = {};
  List refundIdPending = [];
  List refundIdInProgress = [];
  List refundIdFinished = [];
  List refundIdCanceled = [];
  List refundIdGpay = [];
  Future getDataBase() async {
    refundData = [];
    refundId = [];
    refundAllData = {};
    refundIdPending = [];
    refundIdInProgress = [];
    refundIdFinished = [];
    refundIdCanceled = [];
    refundIdGpay = [];
    FirebaseApp touristApp = await Firebase.initializeApp(
      name: 'touristApp',
      options: DefaultFirebaseOptionsTourist.currentPlatform,
    );
    FirebaseFirestore touristAppFirestore =
        FirebaseFirestore.instanceFor(app: touristApp);
    QuerySnapshot snapshot =
        await touristAppFirestore.collection('refund').get();
    refundData = snapshot.docs.map((doc) => doc.data()).toList();
    refundId = snapshot.docs.map((doc) => doc.id).toList();
    for (int i = 0; i < refundId.length; i++) {
      refundAllData[refundId[i]] = refundData[i];
      if (refundAllData[refundId[i]]['status'] == 'Pending') {
        refundIdPending.add(refundId[i]);
      } else if (refundAllData[refundId[i]]['status'] == 'In Progress') {
        refundIdInProgress.add(refundId[i]);
      } else if (refundAllData[refundId[i]]['status'] == 'Finished') {
        refundIdFinished.add(refundId[i]);
      } else if (refundAllData[refundId[i]]['status'] == 'Canceled') {
        refundIdCanceled.add(refundId[i]);
      } else {
        refundIdGpay.add(refundId[i]);
      }
    }
    refundIdInProgress = refundIdInProgress.reversed.toList();
    refundIdFinished = refundIdFinished.reversed.toList();
    refundIdCanceled = refundIdCanceled.reversed.toList();
    refundIdGpay = refundIdGpay.reversed.toList();

    isGetData = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getDataBase(),
        builder: ((context, snapshot) {
          if (isGetData) {
            return DefaultTabController(
                length: 5,
                child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: primaryColor,
                      toolbarHeight: 10,
                      bottom: TabBar(
                        isScrollable: true,
                        indicatorColor: primaryColor,
                        onTap: (int index) {
                          devtools.log('tap tab $index');
                        },
                        tabs: const [
                          Tab(
                            child: Text(
                              'Pending',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'In Progress',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Finished',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Cancelled',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'GPay',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(children: [
                      //                     List refundIdPending = [];
                      // List refundIdInProgress = [];
                      // List refundIdFinished = [];
                      // List refundIdCanceled = [];
                      // List refundIdGpay = [];
                      refundTabBody(size, refundIdPending),
                      refundTabBody(size, refundIdInProgress),
                      refundTabBody(size, refundIdFinished),
                      refundTabBody(size, refundIdCanceled),
                      refundTabBody(size, refundIdGpay),
                    ])));
          } else {
            return Container(
                decoration: const BoxDecoration(color: primaryBackgroundColor),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ));
          }
        }));
  }

  Widget refundTabBody(Size size, List list) {
    String dateFormat(String? stringDateInput, DateTime? dateInput) {
      DateFormat dateFormat = DateFormat("dd/MM/yyyy, HH:mm");
      DateFormat dateFormat2 = DateFormat("dd MMM yyyy, HH:mm");
      String strDateFormat = '';
      if (stringDateInput != null) {
        DateTime stringDateInputFormat = dateFormat.parse(stringDateInput);
        strDateFormat = dateFormat2.format(stringDateInputFormat);
      } else {
        strDateFormat = dateFormat2.format(dateInput!);
      }

      return strDateFormat;
    }

    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                list.isEmpty
                    ? Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white, width: size.width * 0.005),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Have not any refund request at this time.",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                  onTap: () async {
                                    devtools.log('tab ${list[index]}');
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
                                              children: const [
                                                CircularProgressIndicator(
                                                  color: primaryColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    Navigator.of(context).pop();
                                    if (list != refundIdGpay) {
                                      Navigator.of(context)
                                          .push(FadePageRoute(RefundDetail(
                                        detail: refundAllData[list[index]],
                                      )))
                                          .then((value) {
                                        setState(() {
                                          // getDataBase();
                                        });
                                      });
                                    }

                                    // showDialog(
                                    //   context: context,
                                    //   barrierDismissible: false,
                                    //   builder: (BuildContext context) {
                                    //     return Dialog(
                                    //       child: SizedBox(
                                    //         height: size.height * 0.1,
                                    //         child: Column(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.center,
                                    //           children: const [
                                    //             CircularProgressIndicator(
                                    //               color: primaryColor,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     );
                                    //   },
                                    // );
                                    // Navigator.of(context).pop();
                                    // Navigator.of(context)
                                    //     .push(FadePageRoute(WithdrawDetail(
                                    //   detail: withdrawAllData[list[index]],
                                    // )))
                                    //     .then((value) {
                                    //   setState(() {
                                    //     // getDataBase();
                                    //   });
                                    // });

                                    // // ignore: use_build_context_synchronously
                                    // Navigator.pop(context); //pop dialog
                                    // // ignore: use_build_context_synchronously
                                    // Navigator.of(context)
                                    //     .push(FadePageRoute(HistoryJobDetail(
                                    //   detail: orderAllData[
                                    //       transactions?[list[index]]
                                    //           ['orderID']],
                                    //   indexToBack: 3,
                                    //   orderAllData: orderAllData,
                                    // )));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: secondaryBackgroundColor
                                          .withOpacity(0.1),
                                    ),
                                    width: size.width,
                                    height: size.height * 0.2,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 20),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'order ID',
                                                style: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                    fontSize: 20),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                '${refundAllData[list[index]]['orderID']}',
                                                style: const TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                    fontSize: 20),
                                                textAlign: TextAlign.left,
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Status : ${refundAllData[list[index]]['status']}',
                                                style: const TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                    fontSize: 20),
                                                textAlign: TextAlign.left,
                                              ),
                                              // Text(
                                              //   withdrawAllData[list[index]]
                                              //               ['type'] ==
                                              //           'Earnings'
                                              //       ? '+${withdrawAllData[list[index]]['total']}'
                                              //       : '-${withdrawAllData[list[index]]['total']}',
                                              //   style: TextStyle(
                                              //       // fontWeight: FontWeight.bold,
                                              //       color: withdrawAllData[
                                              //                       list[index]]
                                              //                   ['type'] ==
                                              //               'Earnings'
                                              //           ? Colors.green
                                              //           : Colors.red,
                                              //       fontSize: 20),
                                              //   textAlign: TextAlign.left,
                                              // )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'uid : ${refundAllData[list[index]]['uid']}',
                                                style: const TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                    fontSize: 16),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Request Date : ${dateFormat(null, refundAllData[list[index]]['timeStamp'].toDate())}',
                                                style: const TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                    fontSize: 16),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ),
                                        list != refundIdGpay
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    top: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const SizedBox(),
                                                    Row(
                                                      children: const [
                                                        Text('Tap to see more'),
                                                        Icon(
                                                          Icons.arrow_right,
                                                          size: 30,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                height: size.height * 0.01,
                              )
                            ],
                          );
                        })
              ])),
    );
  }
}
