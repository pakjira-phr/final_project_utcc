
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/constant.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/earnings/component/transactions_history/transactions_history.dart';
import 'dart:developer' as devtools show log;

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../utillties/custom_page_route.dart';
import '../component/job_detail/history_job_detail/history_job_detail.dart';
import 'component/withdraw/withdraw.dart';
import 'component/withdraw_detail.dart';

class Earnings extends StatefulWidget {
  const Earnings({super.key});

  @override
  State<Earnings> createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  Map? transactions;
  List? transactionsID;
  List transactionsID10recent = [];
  bool isGetData = false;

  // List bankName = [];
  Future getUserData() async {
    devtools.log('in getUserData()');
    final documentUserSnapshot =
        await firestore.collection('users').doc(user?.uid).get();
    userData = documentUserSnapshot.data();
    transactions = userData?['transactions'];
    if (transactions != null) {
      transactionsID = [];
      transactionsID10recent = [];
      List? transactionsDataTemp = transactions?.keys.toList();
      List<int>? templistIntTransactionsID =
          transactionsDataTemp?.map((data) => int.parse(data)).toList();
      templistIntTransactionsID?.sort((a, b) => a.compareTo(b));
      transactionsID =
          templistIntTransactionsID?.map((data) => (data.toString())).toList();
      // transactionsID = transactions?.keys.toList();
      transactionsID = transactionsID?.reversed.toList();
      int count = 10;
      if (transactionsID!.length <= 10) {
        count = transactionsID!.length;
      }
      // transactionsID = transactionsID?.reversed.toList();
      for (int i = 0; i < count; i++) {
        // devtools.log(i.toString());
        transactionsID10recent.add(transactionsID?[i]);
      }
    }

    isGetData = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setState(() {
      devtools.log('setState');
    });
    return FutureBuilder(
        future: getUserData(),
        builder: ((context, snapshot) {
          if (isGetData) {
            return Scaffold(
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () async {
              //     // CollectionReference collectionRef =
              //     //     firestore.collection('users');
              //     // CollectionReference orderCollectionRef =
              //     //     collectionRef.doc(user!.uid).collection('order');
              //     // QuerySnapshot querySnapshot = await orderCollectionRef.get();
              //     // Map orderAllData = {};
              //     // List orderData =
              //     //     querySnapshot.docs.map((doc) => doc.data()).toList();
              //     // List orderId =
              //     //     querySnapshot.docs.map((doc) => doc.id).toList();
              //     // for (int i = 0; i < orderId.length; i++) {
              //     //   orderAllData[orderId[i]] = orderData[i];
              //     // }

              //     // var timestamp =
              //     //     DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now());
              //     // devtools.log('${orderAllData} ');
              //     Map test = {};
              //     test['123'] = {
              //       'total': 'earnings.toString()',
              //       'timeStamp': 'timeStamp',
              //       'type': 'Earnings',
              //       'orderID': 'deta'
              //     };
              //     devtools.log('${test} ');
              //     devtools.log('${transactionsID10recent} ');
              //   },
              // ),
              backgroundColor: primaryBackgroundColor,
              appBar: AppBar(
                  backgroundColor: primaryBackgroundColor,
                  title: const Text(
                    'Earnings',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  centerTitle: false,
                  // elevation: 1,
                  toolbarHeight: size.height * 0.09,
                  actions: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () {
                              devtools.log('tap History');
                              Navigator.of(context)
                                  .push(FadePageRoute(const TransactionsHistory()))
                                  .then((res) async {
                                await getUserData();
                              });
                            },
                            child: Container(
                              height: size.height * 0.05,
                              decoration: BoxDecoration(
                                // color: Colors.amber,
                                // color: secondaryColor,
                                border: Border.all(
                                    color: Colors.white,
                                    width: size.width * 0.005),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                  // topRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: const [
                                    Icon(Icons.history),
                                    Text(
                                      'History',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: secondaryBackgroundColor.withOpacity(0.1),
                        ),
                        width: size.width,
                        height: size.height * 0.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Your Earning',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                '฿${userData?['earnings'] ?? '0'}',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              devtools.log('tap Withdraw');
                              isGetData = false;
                              Navigator.of(context)
                                  .push(FadePageRoute(const Withdraw()))
                                  .then((res) async {
                                await getUserData();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: secondaryColor,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    top: 16, bottom: 16, left: 20, right: 20),
                                child: Text(
                                  'Withdraw',
                                  style: TextStyle(
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          'Transactions',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "10 recent transactions",
                              style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: 16),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      transactionsID10recent.isEmpty
                          ? Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white,
                                    width: size.width * 0.005),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "You don't have any transactions at this time.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: transactionsID10recent.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          devtools.log(
                                              'tab ${transactionsID10recent[index]} ');
                                          if (transactions?[
                                                      transactionsID?[index]]
                                                  ['type'] ==
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
                                                          MainAxisAlignment
                                                              .center,
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
                                            CollectionReference
                                                orderCollectionRef =
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
                                            for (int i = 0;
                                                i < orderId.length;
                                                i++) {
                                              orderAllData[orderId[i]] =
                                                  orderData[i];
                                            }
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context); //pop dialog
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).push(
                                                FadePageRoute(HistoryJobDetail(
                                              detail: orderAllData[
                                                  transactions?[
                                                      transactionsID10recent[
                                                          index]]['orderID']],
                                              indexToBack: 3,
                                              orderAllData: orderAllData,
                                            )));
                                          } else {
                                            Navigator.of(context).push(
                                                FadePageRoute(WithdrawDetail(
                                              detail: transactions?[
                                                  transactionsID10recent[
                                                      index]],
                                            )));
                                            // WithdrawDetail
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: secondaryBackgroundColor
                                                .withOpacity(0.1),
                                          ),
                                          width: size.width,
                                          height: size.height * 0.15,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    top: 20),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${transactions?[transactionsID10recent[index]]['type']}',
                                                      style: TextStyle(
                                                          // fontWeight: FontWeight.bold,
                                                          color:
                                                              primaryTextColor,
                                                          fontSize: 20),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      transactions?[transactionsID?[
                                                                      index]]
                                                                  ['type'] ==
                                                              'Earnings'
                                                          ? '+฿${transactions?[transactionsID10recent[index]]['total']}'
                                                          : '-฿${transactions?[transactionsID10recent[index]]['total']}',
                                                      style: TextStyle(
                                                          // fontWeight: FontWeight.bold,
                                                          color: transactions?[
                                                                          transactionsID?[
                                                                              index]]
                                                                      [
                                                                      'type'] ==
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
                                                    left: 20,
                                                    right: 20,
                                                    top: 5),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    transactions?[transactionsID?[
                                                                    index]]
                                                                ['type'] ==
                                                            'Earnings'
                                                        ? const SizedBox()
                                                        : Text(
                                                            'Status : ${transactions?[transactionsID10recent[index]]['status']}',
                                                            style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                color:
                                                                    primaryTextColor,
                                                                fontSize: 16),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                    Text(
                                                      dateFormat(transactions?[
                                                              transactionsID?[
                                                                  index]]
                                                          ['timeStamp']),
                                                      style: TextStyle(
                                                          // fontWeight: FontWeight.bold,
                                                          color:
                                                              primaryTextColor,
                                                          fontSize: 16),
                                                      textAlign: TextAlign.left,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
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
                                                      children: const[
                                                         Text(
                                                            'Tap to see more'),
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
                    ],
                  ),
                ),
              ),
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

  String dateFormat(String stringDateInput) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy, HH:mm");
    DateFormat dateFormat2 = DateFormat("dd MMM - HH:mm");
    DateTime stringDateInputFormat = dateFormat.parse(stringDateInput);
    String strDateFormat = dateFormat2.format(stringDateInputFormat);
    return strDateFormat;
  }
}
