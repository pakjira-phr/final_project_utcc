import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/my_trip/component/review.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/custom_page_route.dart';
import 'dart:developer' as devtools show log;
import 'booking_detail.dart';
import 'booking_history.dart';

class MyTrips extends StatefulWidget {
  const MyTrips({super.key});

  @override
  State<MyTrips> createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {
  bool isFirebaseBug = false;
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map bookingAllData = {};
  List bookingData = [];
  List bookingId = [];
  List bookingIdSort = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference collectionRef = firestore.collection('users');
    Future getData() async {
      CollectionReference orderCollectionRef =
          collectionRef.doc(user!.uid).collection('order');
      QuerySnapshot querySnapshot = await orderCollectionRef.get();
      bookingData = querySnapshot.docs.map((doc) => doc.data()).toList();
      bookingId = querySnapshot.docs.map((doc) => doc.id).toList();
      for (int i = 0; i < bookingId.length; i++) {
        bookingAllData[bookingId[i]] = bookingData[i];
      }
      //------------sorting----------------
      // List tempDateList = [];
      // List tempDateIDList = [];
      // for (int i = 0; i < orderAllData.length; i++) {
      //   DateFormat format = DateFormat("EEEE, dd MMMM yyyy");
      //   var tempDate = format.parse(orderAllData[orderId[i]]['date']);
      //   tempDateList.add(tempDate);
      //   tempDateIDList.add([tempDate, orderId[i]]);
      // }
      // tempDateList.sort((a, b) => a.compareTo(b));
      // List tempOrderIdSort = [];
      // //เช็คเรียงวันตามวันที่
      // for (int i = 0; i < tempDateList.length; i++) {
      //   for (int j = 0; j < tempDateIDList.length; j++) {
      //     if (tempDateList[i] == tempDateIDList[j][0]) {
      //       tempOrderIdSort.add(tempDateIDList[j][1]);
      //       // break;
      //     }
      //   }
      // }

      bookingIdSort = bookingId;
      // orderIdSort.toSet().toList();
      bookingIdSort = bookingIdSort.reversed.toList();
    }

    return FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: secondaryBackgroundColor,
              // floatingActionButton: FloatingActionButton(onPressed: () {
              //   devtools.log('${bookingAllData[bookingId[0]]}');
              // }),
              appBar: AppBar(
                  elevation: 0,
                  backgroundColor: secondaryBackgroundColor,
                  title: Text(
                    'My Trips',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor),
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
                                  .push(FadePageRoute(BookingHistory(
                                bookingAllData: bookingAllData,
                              )));
                            },
                            child: Container(
                              height: size.height * 0.05,
                              decoration: BoxDecoration(
                                // color: Colors.amber,
                                color: primaryColor.withOpacity(0.2),
                                border: Border.all(
                                    color: primaryTextColor,
                                    width: size.width * 0.005),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                  // topRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.history,
                                        color: primaryTextColor),
                                    Text(
                                      'History',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: primaryTextColor,
                                          fontWeight: FontWeight.bold),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 10, top: 10),
                      child: Text(
                        'Recent Booking',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                    bookingIdSort.length == 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 100, left: 10, right: 10),
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: primaryTextColor,
                                    width: size.width * 0.005),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "You don't have any booking yet.",
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: bookingIdSort.length,
                            itemBuilder: (context, index) {
                              return Column(children: [
                                index == 0
                                    ? Divider(
                                        color:
                                            primaryTextColor.withOpacity(0.1),
                                        thickness: 10,
                                      )
                                    : const SizedBox(),
                                InkWell(
                                  onTap: () {
                                    devtools.log('${bookingIdSort[index]}');
                                    onLoadingBookingDetail(index, size);
                                    // devtools.log(
                                    //     bookingAllData[bookingIdSort[index]]
                                    //             ['replacer']
                                    //         .toString());
                                    // '${orderAllData[orderIdSort[index]]['meetingPoint']['name']}');
                                  },
                                  child: SizedBox(
                                    width: size.width,
                                    height: bookingAllData[bookingIdSort[index]]
                                                ['status'] ==
                                            'Finished'
                                        ? size.height * 0.33
                                        : size.height * 0.26,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text(
                                          //     '${orderAllData[orderIdSort[index]]['date']}'),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                    bookingAllData[bookingIdSort[
                                                                    index]]
                                                                ['replacer'] ==
                                                            null
                                                        ? '${bookingAllData[bookingIdSort[index]]['tourGuideInfo']['user_name']}'
                                                        : bookingAllData[bookingIdSort[
                                                                            index]]
                                                                        [
                                                                        'replacer']
                                                                    [
                                                                    'user_name'] ==
                                                                null
                                                            ? '${bookingAllData[bookingIdSort[index]]['replacer']['firstName']} (Replacer)'
                                                            : '${bookingAllData[bookingIdSort[index]]['replacer']['user_name']} (Replacer) ',
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '${bookingAllData[bookingIdSort[index]]['status']}',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.02,
                                                    color: secondaryColor),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Planned date',
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.02,
                                                  ),
                                                ),
                                                Text(
                                                  '${bookingAllData[bookingIdSort[index]]['datePlan']}',
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.02,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                  ),
                                                  child: Row(children: [
                                                    Card(
                                                      color: Colors.white
                                                          .withOpacity(0.1),
                                                      child: SizedBox(
                                                        width: size.width * 0.3,
                                                        height:
                                                            size.height * 0.1,
                                                        child: isFirebaseBug
                                                            ? const Icon(Icons
                                                                .developer_board)
                                                            : CachedNetworkImage(
                                                                imageUrl: bookingAllData[
                                                                        bookingIdSort[
                                                                            index]]
                                                                    [
                                                                    'meetingPoint']['pic'],
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const CircularProgressIndicator(),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                        // Image.network(
                                                        //     bookingAllData[
                                                        //             bookingIdSort[
                                                        //                 index]]
                                                        //         [
                                                        //         'meetingPoint']['pic'],
                                                        //     fit: BoxFit
                                                        //         .fill,
                                                        //   )
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: SizedBox(
                                                        // color: Colors.amber,
                                                        width:
                                                            size.width * 0.61,
                                                        // alignment: Alignment.topLeft,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Meeting Point',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    primaryTextColor,
                                                                fontSize:
                                                                    size.height *
                                                                        0.02,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              // overflow: TextOverflow.ellipsis,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    bookingAllData[bookingIdSort[index]]
                                                                            [
                                                                            'meetingPoint']
                                                                        [
                                                                        'name'],
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          primaryTextColor,
                                                                      fontSize:
                                                                          size.height *
                                                                              0.018,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    // overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    bookingAllData[bookingIdSort[index]]
                                                                            [
                                                                            'meetingPoint']
                                                                        [
                                                                        'type'],
                                                                    style:
                                                                        TextStyle(
                                                                      // fontWeight: FontWeight.bold,
                                                                      color:
                                                                          primaryTextColor,
                                                                      fontSize:
                                                                          size.height *
                                                                              0.015,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
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
                                            color: primaryTextColor
                                                .withOpacity(0.1),
                                            thickness: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                bookingAllData[bookingIdSort[
                                                                        index]][
                                                                    'attractions']
                                                                [
                                                                'attractionsSelected']
                                                            .length ==
                                                        1
                                                    ? '${bookingAllData[bookingIdSort[index]]['attractions']['attractionsSelected'].length} Attraction'
                                                    : '${bookingAllData[bookingIdSort[index]]['attractions']['attractionsSelected'].length} Attractions',
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
                                                      fontSize:
                                                          size.height * 0.025,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    "฿${bookingAllData[bookingIdSort[index]]['totalPayment']}",
                                                    style: TextStyle(
                                                      // fontWeight: FontWeight.bold,
                                                      color: secondaryColor,
                                                      fontSize:
                                                          size.height * 0.025,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          bookingAllData[bookingIdSort[index]]
                                                      ['status'] ==
                                                  'Finished'
                                              ? Column(
                                                  children: [
                                                    Divider(
                                                      color: primaryTextColor
                                                          .withOpacity(0.1),
                                                      thickness: 1,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 3),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              devtools.log(
                                                                  'go to Review');
                                                              bookingAllData[bookingIdSort[
                                                                              index]]
                                                                          [
                                                                          'review'] !=
                                                                      null
                                                                  ? onLoadingBookingDetail(
                                                                      index,
                                                                      size)
                                                                  : Navigator.of(
                                                                          context)
                                                                      .push(FadePageRoute(Review(
                                                                          detail:
                                                                              bookingAllData[bookingIdSort[index]])));
                                                            },
                                                            child: Container(
                                                              height:
                                                                  size.height *
                                                                      0.05,
                                                              width:
                                                                  size.width *
                                                                      0.3,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: bookingAllData[bookingIdSort[index]]
                                                                            [
                                                                            'review'] !=
                                                                        null
                                                                    ? Colors
                                                                        .grey
                                                                    : primaryColor,
                                                              ),
                                                              child: Center(
                                                                  child: Text(
                                                                bookingAllData[bookingIdSort[index]]
                                                                            [
                                                                            'review'] ==
                                                                        null
                                                                    ? 'Review'
                                                                    : 'Rated',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        primaryTextColor),
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
                            })
                  ],
                ),
              ),
            );
          }
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: secondaryBackgroundColor),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: tertiaryColor,
                ),
              ],
            ),
          );
        });
  }

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
    // ignore: use_build_context_synchronously
    Navigator.pop(context); //pop dialog
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .push(FadePageRoute(BookingDetail(
          detail: bookingAllData[bookingIdSort[index]],
          indexToBack: 1,
          bookingAllData: const {},
        )))
        .then((_) => setState(() {}));
  }
}
