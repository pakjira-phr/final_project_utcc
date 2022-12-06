import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/constant.dart';
import 'dart:developer' as devtools show log;

import '../../../utillties/custom_page_route.dart';
import '../../component/job_detail/history_job_detail/history_job_detail.dart';
import '../../component/job_detail/job_detail.dart';

// ignore: must_be_immutable
class JobsHistory extends StatefulWidget {
  JobsHistory({super.key, required this.orderAllData});
  Map orderAllData;

  @override
  // ignore: no_logic_in_create_state
  State<JobsHistory> createState() =>
      // ignore: no_logic_in_create_state
      _JobsHistoryState(orderAllData: orderAllData);
}

class _JobsHistoryState extends State<JobsHistory> {
  _JobsHistoryState({required this.orderAllData});
  Map orderAllData;
  List finishedOrderKeyList = [];
  List canceledOrderKeyList = [];
  List toReplacerOrderKeyList = [];

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

    List tempOrderKey = orderAllData.keys.toList();
    finishedOrderKeyList = [];
    canceledOrderKeyList = [];
    toReplacerOrderKeyList = [];
    for (int i = 0; i < tempOrderKey.length; i++) {
      if (orderAllData[tempOrderKey[i]]['status'] == 'Finished') {
        finishedOrderKeyList.add(tempOrderKey[i]);
      } else if (orderAllData[tempOrderKey[i]]['status'] == 'Canceled') {
        canceledOrderKeyList.add(tempOrderKey[i]);
      } else if (orderAllData[tempOrderKey[i]]['status'] == 'To Replacer') {
        toReplacerOrderKeyList.add(tempOrderKey[i]);
      }
    }
    finishedOrderKeyList = finishedOrderKeyList.reversed.toList();
    canceledOrderKeyList = canceledOrderKeyList.reversed.toList();
    toReplacerOrderKeyList = toReplacerOrderKeyList.reversed.toList();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     setState(() {});
          //     devtools.log('${canceledOrderKeyList.isEmpty}');
          //   },
          // ),
          backgroundColor: primaryBackgroundColor,
          appBar: AppBar(
            bottom: TabBar(
              // isScrollable: true,
              indicatorColor: primaryColor,
              onTap: (int index) {},
              tabs: const [
                Tab(
                  child: Text(
                    'Finished',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Tab(
                  child: Text(
                    'Canceled',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Tab(
                  child: Text(
                    'To Replacer',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
            backgroundColor: primaryBackgroundColor,
            title: const Text('Jobs History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              finishedOrder(size),
              canceledOrder(size),
              toReplacerOrder(size),
            ],
          )),
    );
  }

  Widget finishedOrder(Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Finished Jobs',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            finishedOrderKeyList.isEmpty
                ? Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white, width: size.width * 0.005),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "You don't have any finished jobs at this time.",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: finishedOrderKeyList.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        InkWell(
                          onTap: () {
                            devtools
                                .log('tab job ${finishedOrderKeyList[index]}');
                            Navigator.of(context)
                                .push(FadePageRoute(HistoryJobDetail(
                              detail: orderAllData[finishedOrderKeyList[index]],
                              indexToBack: 2,
                              orderAllData: orderAllData,
                            )));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color:
                                    secondaryBackgroundColor.withOpacity(0.1),
                              ),
                              width: size.width,
                              height: size.height * 0.15,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          orderAllData[finishedOrderKeyList[
                                                  index]]['jobOrderFileName']
                                              .toString(),
                                          textScaleFactor: 1.5,
                                          style: TextStyle(
                                              color: primaryTextColor),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_month),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            Text(
                                              orderAllData[finishedOrderKeyList[
                                                      index]]['datePlan']
                                                  .toString(),
                                              textScaleFactor: 1.5,
                                              style: TextStyle(
                                                  color: primaryTextColor),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.access_time_filled),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            Text(
                                              getStringTime(orderAllData[
                                                  finishedOrderKeyList[index]]),
                                              textScaleFactor: 1.5,
                                              style: TextStyle(
                                                  color: primaryTextColor),
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
                                      color: orderAllData[finishedOrderKeyList[
                                                      index]]['status']
                                                  .toString() ==
                                              'Pending'
                                          ? primaryColor
                                          : orderAllData[finishedOrderKeyList[
                                                          index]]['status']
                                                      .toString() ==
                                                  'Accepted'
                                              ? secondaryColor
                                              : orderAllData[finishedOrderKeyList[
                                                              index]]['status']
                                                          .toString() ==
                                                      'In Progress'
                                                  ? Colors.white
                                                  : secondaryBackgroundColor
                                                      .withOpacity(0.2),
                                    ),
                                    child: Center(
                                      child: RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            orderAllData[finishedOrderKeyList[
                                                    index]]['status']
                                                .toString(),
                                            textScaleFactor: 1.5,
                                            style: TextStyle(
                                              color: (orderAllData[finishedOrderKeyList[
                                                                      index]]
                                                                  ['status']
                                                              .toString()) ==
                                                          'Finished' ||
                                                      (orderAllData[finishedOrderKeyList[
                                                                          index]]
                                                                      ['status']
                                                                  ['status']
                                                              .toString()) ==
                                                          'Canceled'
                                                  ? Colors.white
                                                  : Colors.black,
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
    );
  }

  Widget canceledOrder(Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Canceled Jobs',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            canceledOrderKeyList.isEmpty
                ? Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white, width: size.width * 0.005),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "You don't have any canceled jobs at this time.",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: canceledOrderKeyList.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        InkWell(
                          onTap: () {
                            devtools
                                .log('tab job ${canceledOrderKeyList[index]}');
                            Navigator.of(context).push(FadePageRoute(JobDetail(
                              detail: orderAllData[canceledOrderKeyList[index]],
                              indexToBack: 2,
                              orderAllData: orderAllData,
                            )));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color:
                                    secondaryBackgroundColor.withOpacity(0.1),
                              ),
                              width: size.width,
                              height: size.height * 0.15,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          orderAllData[canceledOrderKeyList[
                                                  index]]['jobOrderFileName']
                                              .toString(),
                                          textScaleFactor: 1.5,
                                          style: TextStyle(
                                              color: primaryTextColor),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_month),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            Text(
                                              orderAllData[canceledOrderKeyList[
                                                      index]]['datePlan']
                                                  .toString(),
                                              textScaleFactor: 1.5,
                                              style: TextStyle(
                                                  color: primaryTextColor),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.access_time_filled),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            Text(
                                              getStringTime(orderAllData[
                                                  canceledOrderKeyList[index]]),
                                              textScaleFactor: 1.5,
                                              style: TextStyle(
                                                  color: primaryTextColor),
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
                                      color: orderAllData[canceledOrderKeyList[
                                                      index]]['status']
                                                  .toString() ==
                                              'Pending'
                                          ? primaryColor
                                          : orderAllData[canceledOrderKeyList[
                                                          index]]['status']
                                                      .toString() ==
                                                  'Accepted'
                                              ? secondaryColor
                                              : orderAllData[canceledOrderKeyList[
                                                              index]]['status']
                                                          .toString() ==
                                                      'In Progress'
                                                  ? Colors.white
                                                  : secondaryBackgroundColor
                                                      .withOpacity(0.2),
                                    ),
                                    child: Center(
                                      child: RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            orderAllData[canceledOrderKeyList[
                                                    index]]['status']
                                                .toString(),
                                            textScaleFactor: 1.5,
                                            style: TextStyle(
                                              color: (orderAllData[canceledOrderKeyList[
                                                                      index]]
                                                                  ['status']
                                                              .toString()) ==
                                                          'Finished' ||
                                                      (orderAllData[canceledOrderKeyList[
                                                                      index]]
                                                                  ['status']
                                                              .toString()) ==
                                                          'Canceled'
                                                  ? Colors.white
                                                  : Colors.black,
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
    );
  }

  Widget toReplacerOrder(Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jobs to Replacer',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            toReplacerOrderKeyList.isEmpty
                ? Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white, width: size.width * 0.005),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "You don't have any jobs to replacer at this time.",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: toReplacerOrderKeyList.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        InkWell(
                          onTap: () {
                            devtools.log(
                                'tab job ${toReplacerOrderKeyList[index]}');
                            Navigator.of(context).push(FadePageRoute(JobDetail(
                              detail:
                                  orderAllData[toReplacerOrderKeyList[index]],
                              indexToBack: 2,
                              orderAllData: orderAllData,
                            )));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color:
                                    secondaryBackgroundColor.withOpacity(0.1),
                              ),
                              width: size.width,
                              height: size.height * 0.15,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          orderAllData[toReplacerOrderKeyList[
                                                  index]]['jobOrderFileName']
                                              .toString(),
                                          textScaleFactor: 1.5,
                                          style: TextStyle(
                                              color: primaryTextColor),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_month),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            Text(
                                              orderAllData[
                                                      toReplacerOrderKeyList[
                                                          index]]['datePlan']
                                                  .toString(),
                                              textScaleFactor: 1.5,
                                              style: TextStyle(
                                                  color: primaryTextColor),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.access_time_filled),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            Text(
                                              getStringTime(orderAllData[
                                                  toReplacerOrderKeyList[
                                                      index]]),
                                              textScaleFactor: 1.5,
                                              style: TextStyle(
                                                  color: primaryTextColor),
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
                                      color: orderAllData[
                                                      toReplacerOrderKeyList[
                                                          index]]['status']
                                                  .toString() ==
                                              'Pending'
                                          ? primaryColor
                                          : orderAllData[toReplacerOrderKeyList[
                                                          index]]['status']
                                                      .toString() ==
                                                  'Accepted'
                                              ? secondaryColor
                                              : orderAllData[toReplacerOrderKeyList[
                                                              index]]['status']
                                                          .toString() ==
                                                      'In Progress'
                                                  ? Colors.white
                                                  : secondaryBackgroundColor
                                                      .withOpacity(0.2),
                                    ),
                                    child: Center(
                                      child: RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            orderAllData[toReplacerOrderKeyList[
                                                    index]]['status']
                                                .toString(),
                                            textScaleFactor: 1.5,
                                            style: TextStyle(
                                              color: (orderAllData[toReplacerOrderKeyList[
                                                                      index]]
                                                                  ['status']
                                                              .toString()) ==
                                                          'Finished' ||
                                                      (orderAllData[toReplacerOrderKeyList[
                                                                      index]]
                                                                  ['status']
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
    );
  }
}
