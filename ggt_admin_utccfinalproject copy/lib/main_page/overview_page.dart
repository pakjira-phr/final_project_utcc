import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ggt_admin_utccfinalproject/constant.dart';
// import 'dart:developer' as devtools show log;

import '../firebase_options_tour_guide.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../firebase_options_tourist.dart';

class OverViewPage extends StatefulWidget {
  const OverViewPage({super.key});
  @override
  State<OverViewPage> createState() => _OverViewPageState();
}

class _OverViewPageState extends State<OverViewPage> {
  User? user = FirebaseAuth.instance.currentUser;
  int needWithdrawCount = 0;
  int kpiLowCount = 0;
  bool isGetData = false;
  List needUnbannedId = [];
  List refundIdPending = [];
  Future getDataBase() async {
    List withdrawData = [];
    List withdrawId = [];
    Map withdrawAllData = {};
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
    needWithdrawCount = 0;
    for (int i = 0; i < withdrawId.length; i++) {
      withdrawAllData[withdrawId[i]] = withdrawData[i];
      if (withdrawAllData[withdrawId[i]]['status'] == 'Pending') {
        needWithdrawCount++;
      }
    }
    // devtools.log(needWithdrawCount.toString());
    List userId = [];
    List userData = [];
    Map tourguideAllData = {};
    var snapshot2 = await tourGuideFirestore.collection('users').get();
    userData = snapshot2.docs.map((doc) => doc.data()).toList();
    userId = snapshot2.docs.map((doc) => doc.id).toList();
    kpiLowCount = 0;
    needUnbannedId = [];
    for (int i = 0; i < userId.length; i++) {
      tourguideAllData[userId[i]] = userData[i];
      if (double.parse(userData[i]['kpi']['score']) < 3.0 &&
          !(userData[i]['banned'] == true)) {
        kpiLowCount++;
      } else if (userData[i]['banned'] == true) {
        if (DateFormat('dd/MM/yyyy')
            .parse(userData[i]['bannedUntil'])
            .isBefore(DateTime.now())) {
          needUnbannedId.add(userId[i]);
        }
      }
    }
    List refundData = [];
    List refundId = [];
    Map refundAllData = {};
    refundIdPending = [];

    FirebaseApp touristApp = await Firebase.initializeApp(
      name: 'touristApp',
      options: DefaultFirebaseOptionsTourist.currentPlatform,
    );
    FirebaseFirestore touristAppFirestore =
        FirebaseFirestore.instanceFor(app: touristApp);
    QuerySnapshot snapshot3 =
        await touristAppFirestore.collection('refund').get();
    refundData = snapshot3.docs.map((doc) => doc.data()).toList();
    refundId = snapshot3.docs.map((doc) => doc.id).toList();
    for (int i = 0; i < refundId.length; i++) {
      refundAllData[refundId[i]] = refundData[i];
      if (refundAllData[refundId[i]]['status'] == 'Pending') {
        refundIdPending.add(refundId[i]);
      }
    }
    isGetData = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getDataBase(),
        builder: ((context, snapshot) {
          if (isGetData) {
            return Scaffold(
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {
              //     getDataBase();
              //   },
              //   child: const Icon(Icons.add),
              // ),
              body: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color: primaryColor,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 20, bottom: 20, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "GGT Admin",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryBackgroundColor,
                                  fontSize: 35,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    user?.email ?? 'error',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: primaryBackgroundColor
                                        // fontWeight: FontWeight.bold,
                                        ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: Card(
                              color: Colors.grey.shade300,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "Tour Guide",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryTextColor,
                                          fontSize: 25,
                                        ),
                                        // textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Card(
                                        // color: Colors.purple.withOpacity(0.1),
                                        child: SizedBox(
                                      width: size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            left: 10,
                                            right: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Withdraw : $needWithdrawCount',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: size.height * 0.01,
                                            // ),
                                            // Center(
                                            //   child: Text(
                                            //     needWithdrawCount == 0
                                            //         ? 'No one need withdraw now'
                                            //         : needWithdrawCount > 1
                                            //             ? 'Need Withdraw $needWithdrawCount people'
                                            //             : 'Need Withdraw $needWithdrawCount person',
                                            //     style: TextStyle(fontSize: 20),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    )),
                                    Card(
                                        // color: Colors.purple.withOpacity(0.1),
                                        child: SizedBox(
                                      width: size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            left: 10,
                                            right: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Need to Check Account : $kpiLowCount',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: size.height * 0.01,
                                            // ),
                                            // Center(
                                            //   child: Text(
                                            //       kpiLowCount == 0
                                            //           ? 'No one need to check for banned now'
                                            //           : kpiLowCount > 1
                                            //               ? 'Need Check to banned $kpiLowCount people'
                                            //               : 'Need Check to banned $kpiLowCount person',
                                            //       style: TextStyle(fontSize: 20)),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    )),
                                    Card(
                                        // color: Colors.purple.withOpacity(0.1),
                                        child: SizedBox(
                                      width: size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            left: 10,
                                            right: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Need to Unbanned Account : ${needUnbannedId.length}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: size.height * 0.01,
                                            // ),
                                            // Center(
                                            //   child: Text(
                                            //       needUnbannedId.length == 0
                                            //           ? 'No one need to check for unbanned now'
                                            //           : needUnbannedId.length > 1
                                            //               ? 'Need Check to unbanned ${needUnbannedId.length} people'
                                            //               : 'Need Check to unbanned ${needUnbannedId.length} person',
                                            //       style: TextStyle(fontSize: 20)),
                                            // ),
                                            // Divider();
                                            ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    needUnbannedId.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      ListTile(
                                                        leading: Text(
                                                            (index + 1)
                                                                .toString()),
                                                        title: Text(
                                                            needUnbannedId[
                                                                index]),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  );
                                                })
                                          ],
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Card(
                              color: Colors.grey.shade300,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "Tourist",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryTextColor,
                                          fontSize: 25,
                                        ),
                                        // textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Card(
                                        // color: Colors.purple.withOpacity(0.1),
                                        child: SizedBox(
                                      width: size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            left: 10,
                                            right: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Refund Pending : ${refundIdPending.length}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
}
