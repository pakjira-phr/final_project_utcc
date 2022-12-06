import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ggt_admin_utccfinalproject/constant.dart';
import 'package:ggt_admin_utccfinalproject/main_page/withdraw/withdraw_detail.dart';
import 'package:ggt_admin_utccfinalproject/utillties/custom_page_route.dart';
import 'dart:developer' as devtools show log;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../firebase_options_tour_guide.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  bool isGetData = false;

  List withdrawData = [];
  List withdrawId = [];
  Map withdrawAllData = {};
  List withdrawIdPending = [];
  List withdrawIdCanceled = [];
  List withdrawIdFinished = [];

  Future getDataBase() async {
    withdrawData = [];
    withdrawId = [];
    withdrawAllData = {};
    withdrawIdPending = [];
    withdrawIdCanceled = [];
    withdrawIdFinished = [];
    FirebaseApp tourGuideApp = await Firebase.initializeApp(
      name: 'tourGuideApp',
      options: DefaultFirebaseOptionsTourGuide.currentPlatform,
    );
    FirebaseFirestore tourGuideFirestore =
        FirebaseFirestore.instanceFor(app: tourGuideApp);
    QuerySnapshot snapshot =
        await tourGuideFirestore.collection('withdraw').get();
    withdrawData = snapshot.docs.map((doc) => doc.data()).toList();
    withdrawId = snapshot.docs.map((doc) => doc.id).toList();
    for (int i = 0; i < withdrawId.length; i++) {
      withdrawAllData[withdrawId[i]] = withdrawData[i];
      if (withdrawAllData[withdrawId[i]]['status'] == 'Pending') {
        withdrawIdPending.add(withdrawId[i]);
      } else if (withdrawAllData[withdrawId[i]]['status'] == 'Canceled') {
        withdrawIdCanceled.add(withdrawId[i]);
      } else {
        withdrawIdFinished.add(withdrawId[i]);
      }
    }
    // withdrawIdPending = withdrawIdPending.reversed.toList();
    withdrawIdCanceled = withdrawIdCanceled.reversed.toList();
    withdrawIdFinished = withdrawIdFinished.reversed.toList();
    // devtools.log(withdrawIdPending.toString());
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
              length: 3,
              child: Scaffold(
                  // floatingActionButton: FloatingActionButton(
                  //   onPressed: () {
                  //     getDataBase();
                  //   },
                  // ),
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
                      ],
                    ),
                  ),
                  body: TabBarView(children: [
                    withdrawTabBody(size, withdrawIdPending),
                    withdrawTabBody(size, withdrawIdFinished),
                    withdrawTabBody(size, withdrawIdCanceled),
                  ])),
            );
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

  Widget withdrawTabBody(Size size, List list) {
    String dateFormat(String stringDateInput) {
      DateFormat dateFormat = DateFormat("dd/MM/yyyy, HH:mm");
      DateFormat dateFormat2 = DateFormat("dd MMM - HH:mm");
      DateTime stringDateInputFormat = dateFormat.parse(stringDateInput);
      String strDateFormat = dateFormat2.format(stringDateInputFormat);
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
                            "Have not any withdraw transactions at this time.",
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
                                    Navigator.of(context)
                                        .push(FadePageRoute(WithdrawDetail(
                                      detail: withdrawAllData[list[index]],
                                    )))
                                        .then((value) {
                                      setState(() {
                                        // getDataBase();
                                      });
                                    });
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
                                                'Transactions ID',
                                                style: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                    fontSize: 20),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                '${withdrawAllData[list[index]]['transactionsID']}',
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
                                                '${withdrawAllData[list[index]]['type']}',
                                                style: const TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                    fontSize: 20),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                withdrawAllData[list[index]]
                                                            ['type'] ==
                                                        'Earnings'
                                                    ? '+${withdrawAllData[list[index]]['total']}'
                                                    : '-${withdrawAllData[list[index]]['total']}',
                                                style: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: withdrawAllData[
                                                                    list[index]]
                                                                ['type'] ==
                                                            'Earnings'
                                                        ? Colors.green
                                                        : Colors.red,
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
                                              withdrawAllData[list[index]]
                                                          ['type'] ==
                                                      'Earnings'
                                                  ? const SizedBox()
                                                  : Text(
                                                      'Status : ${withdrawAllData[list[index]]['status']}',
                                                      style: const TextStyle(
                                                          // fontWeight: FontWeight.bold,
                                                          color:
                                                              primaryTextColor,
                                                          fontSize: 16),
                                                      textAlign: TextAlign.left,
                                                    ),
                                              Text(
                                                dateFormat(
                                                    withdrawAllData[list[index]]
                                                        ['timeStamp']),
                                                style: const TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                    fontSize: 16),
                                                textAlign: TextAlign.left,
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                        ),
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
