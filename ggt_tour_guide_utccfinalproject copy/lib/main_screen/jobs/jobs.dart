import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/constant.dart';
import 'dart:developer' as devtools show log;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../utillties/custom_page_route.dart';

import '../../widget/popup_dialog.dart';
import '../component/job_detail/job_detail.dart';
import 'component/jobs_history.dart';
import 'component/kpi_info.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  bool loadingSuss = false;
  bool dataMap = false;

  Map orderAllData = {};
  List orderData = [];
  List orderId = [];
  List orderIdSort = [];

  getStringTime(Map job) {
    if (job['timePlan'] == 'All Day') {
      return "08:00 to 20:00";
    } else if (job['timePlan'] == 'Half Day') {
      return "12:00 to 18:00";
    } else {
      return "17:00 to 21:00";
    }
  }

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
      //------------sorting----------------
      List tempDateList = [];
      List tempDateIDList = [];
      for (int i = 0; i < orderAllData.length; i++) {
        DateFormat format = DateFormat("dd-MM-yyyy");
        var tempDate = format.parse(orderAllData[orderId[i]]['datePlan']);
        //check ไม่ให้งานของวันก่อนหน้าวันนี้ขึ้น หรือ งานที่เสร็จแล้ว
        if (!tempDate
                .isBefore(DateTime.now().subtract(const Duration(days: 1))) &&
            (orderAllData[orderId[i]]["status"] != 'Finished' &&
                orderAllData[orderId[i]]["status"] != 'Canceled' &&
                orderAllData[orderId[i]]["status"] != 'To Replacer')) {
          tempDateList.add(tempDate);
          tempDateIDList.add([tempDate, orderId[i]]);
        }
      }
      //เรียงวัน
      tempDateList.sort((a, b) => a.compareTo(b));
      List tempOrderIdSort = [];
      //เช็คเรียงวันตามวันที่
      for (int i = 0; i < tempDateList.length; i++) {
        for (int j = 0; j < tempDateIDList.length; j++) {
          if (tempDateList[i] == tempDateIDList[j][0]) {
            tempOrderIdSort.add(tempDateIDList[j][1]);
          }
        }
      }
      setState(() {
        orderIdSort = tempOrderIdSort;
      });
    }

    return FutureBuilder<DocumentSnapshot>(
      future: collectionRef.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if ((snapshot.connectionState == ConnectionState.done) || loadingSuss) {
          loadingSuss = true;
          if (!dataMap) {
            userData = snapshot.data!.data() as Map<String, dynamic>;
            dataMap = true;
            checkDataBase();
          }
          return Scaffold(
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     setState(() {});
            //     devtools.log('${userData?['kpi']['score']}');
            //   },
            // ),
            backgroundColor: primaryBackgroundColor,
            appBar: AppBar(
                backgroundColor: primaryBackgroundColor,
                title: const Text(
                  'Jobs',
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
                                .push(FadePageRoute(JobsHistory(
                              orderAllData: orderAllData,
                            )));
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(top: 8.0, right: 8),
                              //   child: Text(
                              //     'more >',
                              //     style: TextStyle(
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.bold),
                              //   ),
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, right: 8),
                                child: InkWell(
                                    onTap: () {
                                      showPopupDialog(
                                          context,
                                          "If you have star rating score less than 3. You wouldn't get any new job for 4 week.",
                                          'For your information', [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context)
                                                  .push(FadePageRoute(KPIInfo(
                                                kpiData: userData?['kpi'],
                                              )));
                                            },
                                            child: const Text("More info")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("OK")),
                                      ]);
                                    },
                                    child: const Icon(Icons.info)),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Star Rating Score',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              '${userData?['kpi']['score']}',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        'Upcoming Jobs',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    orderIdSort.isEmpty
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
                                "You don't have any upcoming jobs at this time.",
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: orderIdSort.length,
                            itemBuilder: (context, index) {
                              return Column(children: [
                                InkWell(
                                  onTap: () {
                                    devtools
                                        .log('tab job ${orderIdSort[index]}');
                                    Navigator.of(context)
                                        .push(FadePageRoute(JobDetail(
                                      detail: orderAllData[orderIdSort[index]],
                                      indexToBack: 2,
                                      orderAllData: const {},
                                    )));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: secondaryBackgroundColor
                                            .withOpacity(0.1),
                                      ),
                                      width: size.width,
                                      height: size.height * 0.15,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  orderAllData[orderIdSort[
                                                              index]]
                                                          ['jobOrderFileName']
                                                      .toString(),
                                                  textScaleFactor: 1.5,
                                                  style: TextStyle(
                                                      color: primaryTextColor),
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.calendar_month),
                                                    SizedBox(
                                                      width: size.width * 0.02,
                                                    ),
                                                    Text(
                                                      orderAllData[orderIdSort[
                                                                  index]]
                                                              ['datePlan']
                                                          .toString(),
                                                      textScaleFactor: 1.5,
                                                      style: TextStyle(
                                                          color:
                                                              primaryTextColor),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(Icons
                                                        .access_time_filled),
                                                    SizedBox(
                                                      width: size.width * 0.02,
                                                    ),
                                                    Text(
                                                      getStringTime(
                                                          orderAllData[
                                                              orderIdSort[
                                                                  index]]),
                                                      textScaleFactor: 1.5,
                                                      style: TextStyle(
                                                          color:
                                                              primaryTextColor),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: size.width * 0.1,
                                            height: size.height,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10.0),
                                                      bottomRight:
                                                          Radius.circular(
                                                              10.0)),
                                              color: orderAllData[orderIdSort[
                                                              index]]['status']
                                                          .toString() ==
                                                      'Pending'
                                                  ? primaryColor
                                                  : orderAllData[orderIdSort[
                                                                      index]]
                                                                  ['status']
                                                              .toString() ==
                                                          'Accepted'
                                                      ? secondaryColor
                                                      : orderAllData[orderIdSort[
                                                                          index]]
                                                                      ['status']
                                                                  .toString() ==
                                                              'In Progress'
                                                          ? Colors.grey
                                                          : secondaryBackgroundColor
                                                              .withOpacity(0.2),
                                            ),
                                            child: Center(
                                              child: RotatedBox(
                                                  quarterTurns: 3,
                                                  child: Text(
                                                    orderAllData[orderIdSort[
                                                            index]]['status']
                                                        .toString(),
                                                    textScaleFactor: 1.5,
                                                    style: TextStyle(
                                                      color: (orderAllData[orderIdSort[
                                                                              index]]
                                                                          [
                                                                          'status']
                                                                      .toString()) ==
                                                                  'Finished' ||
                                                              (orderAllData[orderIdSort[
                                                                              index]]
                                                                          [
                                                                          'status']
                                                                      .toString()) ==
                                                                  'Canceled'
                                                          ? Colors.white
                                                          : Colors.white,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                )
                              ]);
                            })
                  ],
                ),
              ),
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(color: primaryBackgroundColor),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
