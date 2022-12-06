import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/constant.dart';
import 'dart:developer' as devtools show log;

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../../../utillties/custom_page_route.dart';
import '../../../component/job_detail/history_job_detail/history_job_detail.dart';
import '../withdraw_detail.dart';

class TransactionsHistory extends StatefulWidget {
  const TransactionsHistory({super.key});

  @override
  State<TransactionsHistory> createState() => _TransactionsHistoryState();
}

class _TransactionsHistoryState extends State<TransactionsHistory> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  Map? transactions;
  List? transactionsID;
  List earningsTransactionsKey = [];
  List withdrawTransactionsKey = [];
  bool isGetData = false;

  // List bankName = [];
  Future getUserData() async {
    devtools.log('in getUserData()');
    final documentUserSnapshot =
        await firestore.collection('users').doc(user?.uid).get();
    userData = documentUserSnapshot.data();
    transactions = userData?['transactions'];
    if (transactions != null) {
      // transactionsID = [];
      earningsTransactionsKey = [];
      withdrawTransactionsKey = [];
      transactionsID = transactions?.keys.toList();
      transactionsID = transactionsID?.reversed.toList();
      for (int i = 0; i < transactionsID!.length; i++) {
        if (transactions?['${transactionsID?[i]}']['type'] == 'Withdraw') {
          withdrawTransactionsKey.add(int.parse(transactionsID?[i]));
        } else {
          earningsTransactionsKey.add(int.parse(transactionsID?[i]));
        }
      }
      withdrawTransactionsKey.sort((a, b) => a.compareTo(b));
      earningsTransactionsKey.sort((a, b) => a.compareTo(b));
      withdrawTransactionsKey = withdrawTransactionsKey.reversed.toList();
      earningsTransactionsKey = earningsTransactionsKey.reversed.toList();
      withdrawTransactionsKey =
          withdrawTransactionsKey.map((data) => (data.toString())).toList();
      earningsTransactionsKey =
          earningsTransactionsKey.map((data) => (data.toString())).toList();
      // int count = 10;
      // if (transactionsID!.length <= 10) {
      //   count = transactionsID!.length;
      // }
      // // transactionsID = transactionsID?.reversed.toList();
      // for (int i = 0; i < count; i++) {
      //   // devtools.log(i.toString());
      //   transactionsID10recent.add(transactionsID?[count - i]);
      // }
    }

    isGetData = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getUserData(),
        builder: ((context, snapshot) {
          if (isGetData) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                  backgroundColor: primaryBackgroundColor,
                  // floatingActionButton: FloatingActionButton(onPressed: () {
                  //   // withdrawTransactionsKey.sort((a, b) => a.compareTo(b));
                  //   devtools.log('${withdrawTransactionsKey}');
                  // }),
                  appBar: AppBar(
                    bottom: TabBar(
                      // isScrollable: true,
                      indicatorColor: primaryColor,
                      onTap: (int index) {
                        devtools.log('tap tab $index');
                      },
                      tabs: const [
                        Tab(
                          child: Text(
                            'Earnings',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Withdraw',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: primaryBackgroundColor,
                    title: const Text('Transactions History',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: secondaryBackgroundColor),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      tranTabBody(size, earningsTransactionsKey),
                      tranTabBody(size, withdrawTransactionsKey),
                    ],
                  )),
            );
          } else {
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
          }
        }));
  }

  Widget tranTabBody(Size size, List list) {
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
                            "You don't have any earnings transactions at this time.",
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
                                    if (transactions?[list[index]]['type'] ==
                                        'Earnings') {
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
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                      CollectionReference collectionRef =
                                          firestore.collection('users');
                                      CollectionReference orderCollectionRef =
                                          collectionRef
                                              .doc(user!.uid)
                                              .collection('order');
                                      QuerySnapshot querySnapshot =
                                          await orderCollectionRef.get();
                                      Map orderAllData = {};
                                      List orderData = querySnapshot.docs
                                          .map((doc) => doc.data())
                                          .toList();
                                      List orderId = querySnapshot.docs
                                          .map((doc) => doc.id)
                                          .toList();
                                      for (int i = 0; i < orderId.length; i++) {
                                        orderAllData[orderId[i]] = orderData[i];
                                      }
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context); //pop dialog
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context)
                                          .push(FadePageRoute(HistoryJobDetail(
                                        detail: orderAllData[
                                            transactions?[list[index]]
                                                ['orderID']],
                                        indexToBack: 3,
                                        orderAllData: orderAllData,
                                      )));
                                    } else {
                                      Navigator.of(context)
                                          .push(FadePageRoute(WithdrawDetail(
                                        detail: transactions?[list[index]],
                                      )));
                                      // WithdrawDetail
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: secondaryBackgroundColor
                                          .withOpacity(0.1),
                                    ),
                                    width: size.width,
                                    height: size.height * 0.15,
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
                                              Text(
                                                '${transactions?[list[index]]['type']}',
                                                style: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                    fontSize: 20),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                transactions?[list[index]]
                                                            ['type'] ==
                                                        'Earnings'
                                                    ? '+${transactions?[list[index]]['total']}'
                                                    : '-${transactions?[list[index]]['total']}',
                                                style: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: transactions?[
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
                                              transactions?[list[index]]
                                                          ['type'] ==
                                                      'Earnings'
                                                  ? const SizedBox()
                                                  : Text(
                                                      'Status : ${transactions?[list[index]]['status']}',
                                                      style: TextStyle(
                                                          // fontWeight: FontWeight.bold,
                                                          color:
                                                              primaryTextColor,
                                                          fontSize: 16),
                                                      textAlign: TextAlign.left,
                                                    ),
                                              Text(
                                                dateFormat(
                                                    transactions?[list[index]]
                                                        ['timeStamp']),
                                                style: TextStyle(
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
                                                children: const[
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
