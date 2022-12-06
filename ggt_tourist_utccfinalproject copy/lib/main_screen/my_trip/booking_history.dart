import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constant.dart';
import '../../utillties/custom_page_route.dart';
import 'booking_detail.dart';
import 'dart:developer' as devtools show log;

import 'component/review.dart';

// ignore: must_be_immutable
class BookingHistory extends StatefulWidget {
  BookingHistory({super.key, required this.bookingAllData});
  Map bookingAllData;

  @override
  State<BookingHistory> createState() =>
      // ignore: no_logic_in_create_state
      _BookingHistoryState(bookingAllData: bookingAllData);
}

class _BookingHistoryState extends State<BookingHistory>
    with TickerProviderStateMixin {
  _BookingHistoryState({required this.bookingAllData});
  Map bookingAllData;
  List pendingBookingKeyList = [];
  List acceptedBookingKeyList = [];
  List inProgressBookingKeyList = [];
  List finishedBookingKeyList = [];
  List canceledBookingKeyList = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  bool isFirebaseBug = false;
  String tapName = 'Pending';

  getStringTime(Map job) {
    if (job['timePlan'] == 'All Day') {
      return "08:00 to 20:00";
    } else if (job['timePlan'] == 'Half Day') {
      return "12:00 to 18:00";
    } else {
      return "17:00 to 21:00";
    }
  }

  getListData() {
    setState(() {
      List tempOrderKey = bookingAllData.keys.toList();
      finishedBookingKeyList = [];
      canceledBookingKeyList = [];
      pendingBookingKeyList = [];
      acceptedBookingKeyList = [];
      for (int i = 0; i < tempOrderKey.length; i++) {
        if (bookingAllData[tempOrderKey[i]]['status'] == 'Finished') {
          finishedBookingKeyList.add(tempOrderKey[i]);
        } else if (bookingAllData[tempOrderKey[i]]['status'] == 'Canceled') {
          canceledBookingKeyList.add(tempOrderKey[i]);
        } else if (bookingAllData[tempOrderKey[i]]['status'] == 'Pending') {
          pendingBookingKeyList.add(tempOrderKey[i]);
        } else if (bookingAllData[tempOrderKey[i]]['status'] == 'Accepted') {
          acceptedBookingKeyList.add(tempOrderKey[i]);
        } else {
          inProgressBookingKeyList.add(tempOrderKey[i]);
        }
      }

      finishedBookingKeyList =
          finishedBookingKeyList.reversed.toList().toSet().toList();
      canceledBookingKeyList =
          canceledBookingKeyList.reversed.toList().toSet().toList();
      pendingBookingKeyList =
          pendingBookingKeyList.reversed.toList().toSet().toList();
      acceptedBookingKeyList =
          acceptedBookingKeyList.reversed.toList().toSet().toList();
      inProgressBookingKeyList =
          inProgressBookingKeyList.reversed.toList().toSet().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    getListData();
    return DefaultTabController(
        length: 5,
        child: Scaffold(
            backgroundColor: secondaryBackgroundColor,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: primaryTextColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: primaryColor,
                onTap: (int index) {
                  devtools.log('$index');

                  if (index == 0) {
                    setState(() {
                      tapName = 'Pending';
                    });
                  } else if (index == 1) {
                    setState(() {
                      tapName = 'Accepted';
                    });
                  } else if (index == 2) {
                    setState(() {
                      tapName = 'In Progress';
                    });
                  } else if (index == 3) {
                    setState(() {
                      tapName = 'Finished';
                    });
                  } else if (index == 4) {
                    setState(() {
                      tapName = 'Cancelled';
                    });
                  }

                  devtools.log(tapName);
                },
                tabs: [
                  Tab(
                    child: Text(
                      'Pending',
                      style: TextStyle(fontSize: 16, color: primaryTextColor),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Accepted',
                      style: TextStyle(fontSize: 16, color: primaryTextColor),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'In Progress',
                      style: TextStyle(fontSize: 16, color: primaryTextColor),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Finished',
                      style: TextStyle(fontSize: 16, color: primaryTextColor),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Cancelled',
                      style: TextStyle(fontSize: 16, color: primaryTextColor),
                    ),
                  ),
                ],
              ),
              backgroundColor: secondaryBackgroundColor,
              title: Text(
                'Booking History',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor),
              ),
            ),
            body: TabBarView(
              children: [
                listViewBooking(pendingBookingKeyList, size),
                listViewBooking(acceptedBookingKeyList, size),
                listViewBooking(inProgressBookingKeyList, size),
                listViewBooking(finishedBookingKeyList, size),
                listViewBooking(canceledBookingKeyList, size),
              ],
            )));
  }

  Widget listViewBooking(List idList, Size size) {
    void onLoadingBookingDetail(int index, size) async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: size.height * 0.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          );
        },
      );
      // devtools.log('tab attraction (${attractionsSelected![index]})');
      // var document = firestore.collection('locations').doc('locationInfo');
      // var data = await document.get();
      // Map<String, dynamic> attractionData = data.data() ?? {};
      // Map attractionsSelect = attractionData['${idList[index]}'];
      // ignore: use_build_context_synchronously
      Navigator.pop(context); //pop dialog
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .push(FadePageRoute(BookingDetail(
            detail: bookingAllData[idList[index]],
            indexToBack: 1,
            bookingAllData: bookingAllData,
          )))
          .then((_) => setState(() {}));
    }

    Widget noBookingYet() {
      return FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 1)),
          builder: (c, s) => s.connectionState != ConnectionState.done
              ? Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(color: secondaryBackgroundColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: tertiaryColor,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: primaryTextColor, width: size.width * 0.005),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "No $tapName Booking Yet.",
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ));
    }

    devtools.log('${idList.isEmpty}');
    return SingleChildScrollView(
      child: idList.isEmpty
          ? noBookingYet()
          : ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: idList.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  index == 0
                      ? Divider(
                          color: primaryTextColor.withOpacity(0.1),
                          thickness: 10,
                        )
                      : const SizedBox(),
                  InkWell(
                    onTap: () {
                      devtools.log('${idList[index]}');
                      onLoadingBookingDetail(index, size);
                    },
                    child: SizedBox(
                      width: size.width,
                      height:
                          bookingAllData[idList[index]]['status'] == 'Finished'
                              ? size.height * 0.33
                              : size.height * 0.26,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_box,
                                      size: size.height * 0.03,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Text(
                                      bookingAllData[idList[index]]
                                                  ['replacer'] ==
                                              null
                                          ? '${bookingAllData[idList[index]]['tourGuideInfo']['user_name']}'
                                          : bookingAllData[idList[index]]
                                                          ['replacer']
                                                      ['user_name'] ==
                                                  null
                                              ? '${bookingAllData[idList[index]]['replacer']['firstName']} (Replacer)'
                                              : '${bookingAllData[idList[index]]['replacer']['user_name']} (Replacer) ',
                                      style: TextStyle(
                                          fontSize: size.height * 0.02,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${bookingAllData[idList[index]]['status']}',
                                  style: TextStyle(
                                      fontSize: size.height * 0.02,
                                      color: secondaryColor),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Planned date',
                                    style: TextStyle(
                                      fontSize: size.height * 0.02,
                                    ),
                                  ),
                                  Text(
                                    '${bookingAllData[idList[index]]['datePlan']}',
                                    style: TextStyle(
                                      fontSize: size.height * 0.02,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          height: size.height * 0.1,
                                          child: isFirebaseBug
                                              ? const Icon(
                                                  Icons.developer_board)
                                              : CachedNetworkImage(
                                                  imageUrl: bookingAllData[
                                                          idList[index]]
                                                      ['meetingPoint']['pic'],
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                          // Image.network(
                                          //     bookingAllData[
                                          //             idList[index]]
                                          //         ['meetingPoint']['pic'],
                                          //     fit: BoxFit.fill,
                                          //   )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: SizedBox(
                                          // color: Colors.amber,
                                          width: size.width * 0.61,
                                          // alignment: Alignment.topLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Meeting Point',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryTextColor,
                                                  fontSize: size.height * 0.02,
                                                ),
                                                textAlign: TextAlign.left,
                                                // overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      bookingAllData[
                                                                  idList[index]]
                                                              ['meetingPoint']
                                                          ['name'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: primaryTextColor,
                                                        fontSize:
                                                            size.height * 0.018,
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
                                                      bookingAllData[
                                                                  idList[index]]
                                                              ['meetingPoint']
                                                          ['type'],
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        color: primaryTextColor,
                                                        fontSize:
                                                            size.height * 0.015,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                ],
                              ),
                            ),
                            Divider(
                              color: primaryTextColor.withOpacity(0.1),
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  bookingAllData[idList[index]]['attractions']
                                                  ['attractionsSelected']
                                              .length ==
                                          1
                                      ? '${bookingAllData[idList[index]]['attractions']['attractionsSelected'].length} Attraction'
                                      : '${bookingAllData[idList[index]]['attractions']['attractionsSelected'].length} Attractions',
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                    fontSize: size.height * 0.018,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Total : ",
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                        fontSize: size.height * 0.025,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "฿${bookingAllData[idList[index]]['totalPayment']}",
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        color: secondaryColor,
                                        fontSize: size.height * 0.025,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            bookingAllData[idList[index]]['status'] ==
                                    'Finished'
                                ? Column(
                                    children: [
                                      Divider(
                                        color:
                                            primaryTextColor.withOpacity(0.1),
                                        thickness: 1,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                devtools.log('go to Review');
                                                bookingAllData[idList[index]]
                                                            ['review'] !=
                                                        null
                                                    ? onLoadingBookingDetail(
                                                        index, size)
                                                    : Navigator.of(context)
                                                        .push(FadePageRoute(Review(
                                                            detail:
                                                                bookingAllData[
                                                                    idList[
                                                                        index]])))
                                                        .then((_) =>
                                                            setState(() {}));
                                              },
                                              child: Container(
                                                height: size.height * 0.05,
                                                width: size.width * 0.3,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: bookingAllData[
                                                                  idList[index]]
                                                              ['review'] !=
                                                          null
                                                      ? Colors.grey
                                                      : primaryColor,
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  bookingAllData[idList[index]]
                                                              ['review'] ==
                                                          null
                                                      ? 'Review'
                                                      : 'Rated',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryTextColor),
                                                )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox()
                            //-------------
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: primaryTextColor.withOpacity(0.1),
                    thickness: 10,
                  )
                ]);
              }),
    );
  }
}
