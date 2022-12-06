import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/constant.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'dart:developer' as devtools show log;

import '../../utillties/custom_page_route.dart';
import '../component/job_detail/history_job_detail/history_job_detail.dart';
import '../component/job_detail/job_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  bool loadingSuss = false;
  bool dataMap = false;

  Map todayJob = {};
  Map orderAllData = {};
  List orderHaveNotAccept = [];
  List orderData = [];
  List orderId = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference collectionRef = firestore.collection('users');

    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Good Morning,';
      }
      if (hour < 17) {
        return 'Good Afternoon,';
      }
      return 'Good Evening,';
    }

    String greetingWord = greeting();

    getStringTime() {
      if (todayJob['timePlan'] == 'All Day') {
        return "08:00 to 20:00";
      } else if (todayJob['timePlan'] == 'Half Day') {
        return "12:00 to 18:00";
      } else {
        return "17:00 to 21:00";
      }
    }

    getStringTime2(Map job) {
      if (job['timePlan'] == 'All Day') {
        return "08:00 to 20:00";
      } else if (job['timePlan'] == 'Half Day') {
        return "12:00 to 18:00";
      } else {
        return "17:00 to 21:00";
      }
    }

    String time = getStringTime();

    Future checkDataBase() async {
      devtools.log('message');
      orderHaveNotAccept = [];
      CollectionReference orderCollectionRef =
          collectionRef.doc(user!.uid).collection('order');
      QuerySnapshot querySnapshot = await orderCollectionRef.get();
      orderData = querySnapshot.docs.map((doc) => doc.data()).toList();
      orderId = querySnapshot.docs.map((doc) => doc.id).toList();
      for (int i = 0; i < orderId.length; i++) {
        orderAllData[orderId[i]] = orderData[i];
      }
      // setState(() {
      for (int i = 0; i < orderId.length; i++) {
        //check งานวันนี้
        if (orderAllData[orderId[i]]['datePlan'] ==
            DateFormat("dd-MM-yyyy").format(DateTime.now())) {
          todayJob = orderAllData[orderId[i]];
        }
        //Check งานที่ยังไม่ได้กด accepted
        if (orderAllData[orderId[i]]['status'] == 'Pending') {
          devtools.log('orderId[i]');
          orderHaveNotAccept.add(orderId[i]);
        }
      }
      devtools.log('$orderHaveNotAccept orderHaveNotAccept');
      // });
      var userGetData = await collectionRef.doc(user!.uid).get();
      userData = userGetData.data() as Map<String, dynamic>;

      loadingSuss = true;
    }

    return FutureBuilder(
      future: checkDataBase().then((value) {
        // setState(() {});
      }),
      builder: (BuildContext context, snapshot) {
        if (loadingSuss) {
          loadingSuss = true;
          if (!dataMap) {
            checkDataBase().then((value) => {setState(() {})});
            // userData = snapshot.data!.data() as Map<String, dynamic>;
            dataMap = true;
          }
          return Scaffold(
            backgroundColor: primaryBackgroundColor,
            // floatingActionButton: FloatingActionButton(onPressed: () {
            //   devtools.log('${orderHaveNotAccept} todayJob.isNotEmpty');
            // }),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    greetingWidget(greetingWord, size, time),
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        "Jobs you haven't accepted",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    orderHaveNotAccept.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: orderHaveNotAccept.length,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      devtools.log(
                                          'tab job ${orderHaveNotAccept[index]}');

                                      Navigator.of(context).pushAndRemoveUntil(
                                          FadePageRoute(JobDetail(
                                            detail: orderAllData[
                                                orderHaveNotAccept[index]],
                                            indexToBack: 0,
                                            orderAllData: const {},
                                          )),
                                          (Route<dynamic> route) => false);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: secondaryBackgroundColor
                                            .withOpacity(0.1),
                                      ),
                                      width: size.width,
                                      height: size.height * 0.15,
                                      child: orderAllData[
                                                  orderHaveNotAccept[index]]
                                              .isNotEmpty
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        orderAllData[
                                                                    orderHaveNotAccept[
                                                                        index]][
                                                                'jobOrderFileName']
                                                            .toString(),
                                                        textScaleFactor: 1.5,
                                                        style: TextStyle(
                                                            color:
                                                                primaryTextColor),
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(Icons
                                                              .calendar_month),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Text(
                                                            orderAllData[orderHaveNotAccept[
                                                                        index]]
                                                                    ['datePlan']
                                                                .toString(),
                                                            textScaleFactor:
                                                                1.5,
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
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          Text(
                                                            getStringTime2(
                                                                orderAllData[
                                                                    orderHaveNotAccept[
                                                                        index]]),
                                                            textScaleFactor:
                                                                1.5,
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
                                                                Radius.circular(
                                                                    10.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10.0)),
                                                    color: orderAllData[orderHaveNotAccept[
                                                                        index]]
                                                                    ['status']
                                                                .toString() ==
                                                            'Pending'
                                                        ? primaryColor
                                                        : orderAllData[orderHaveNotAccept[
                                                                            index]]
                                                                        [
                                                                        'status']
                                                                    .toString() ==
                                                                'Accepted'
                                                            ? secondaryColor
                                                            : orderAllData[orderHaveNotAccept[index]]
                                                                            [
                                                                            'status']
                                                                        .toString() ==
                                                                    'In Progress'
                                                                ? Colors.white
                                                                : secondaryBackgroundColor
                                                                    .withOpacity(
                                                                        0.2),
                                                  ),
                                                  child: Center(
                                                    child: RotatedBox(
                                                        quarterTurns: 3,
                                                        child: Text(
                                                          orderAllData[orderHaveNotAccept[
                                                                      index]]
                                                                  ['status']
                                                              .toString(),
                                                          textScaleFactor: 1.5,
                                                          style: TextStyle(
                                                            color: (orderAllData[orderHaveNotAccept[index]]['status']
                                                                            .toString()) ==
                                                                        'Finished' ||
                                                                    (orderAllData[orderHaveNotAccept[index]]['status']
                                                                            .toString()) ==
                                                                        'Canceled'
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Center(
                                              child: Text(
                                              "somrthing wrong",
                                              textScaleFactor: 1.5,
                                            )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  )
                                ],
                              );
                            })
                        : Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white,
                                    width: size.width * 0.005),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Good job, you appected all work",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                    //const Center(
                    //     child: Text(
                    //     "Good job, you appected all work",
                    //     textScaleFactor: 1.5,
                    //   )),
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

  Widget greetingWidget(String greetingWord, Size size, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height * 0.02,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                '$greetingWord\n${user?.displayName ?? 'error'}!',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        const Text(
          "Today's job",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        InkWell(
          onTap: () {
            if (todayJob.isNotEmpty) {
              devtools.log('tab today job');
              if (todayJob['status'].toString() == 'Finished') {
                // HistoryJobDetail
                Navigator.of(context).push(FadePageRoute(HistoryJobDetail(
                  detail: todayJob,
                  indexToBack: 0,
                  orderAllData: orderAllData,
                )));
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    FadePageRoute(JobDetail(
                      detail: todayJob,
                      indexToBack: 0,
                      orderAllData: const {},
                    )),
                    (Route<dynamic> route) => false);
              }
              // Navigator.of(context).push(FadePageRoute(JobDetail(
              //   detail: todayJob,
              //   indexToBack: 0,
              //   orderAllData: const {},
              // )));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: secondaryBackgroundColor.withOpacity(0.1),
            ),
            width: size.width,
            height: size.height * 0.15,
            child: todayJob.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todayJob['jobOrderFileName'].toString(),
                              textScaleFactor: 2,
                              style: TextStyle(color: primaryTextColor),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time_filled),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Text(
                                  time,
                                  textScaleFactor: 1.5,
                                  style: TextStyle(color: primaryTextColor),
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
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0)),
                          color: todayJob['status'].toString() == 'Pending'
                              ? primaryColor
                              : todayJob['status'].toString() == 'Accepted'
                                  ? secondaryColor
                                  : todayJob['status'].toString() ==
                                          'In Progress'
                                      ? Colors.white
                                      : secondaryBackgroundColor
                                          .withOpacity(0.2),
                        ),
                        child: Center(
                          child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                todayJob['status'].toString(),
                                textScaleFactor: 1.5,
                                style: TextStyle(
                                  color: (todayJob['status'].toString()) ==
                                              'Finished' ||
                                          (todayJob['status'].toString()) ==
                                              'Canceled'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              )),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text(
                    "You don't have any work today",
                    textScaleFactor: 1.5,
                  )),
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
      ],
    );
  }
}
