import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ggt_admin_utccfinalproject/constant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ggt_admin_utccfinalproject/firebase_options_tour_guide.dart';
import 'package:ggt_admin_utccfinalproject/main_page/banned/review_detail.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'dart:developer' as devtools show log;

import 'package:ggt_admin_utccfinalproject/utillties/custom_page_route.dart';

// ignore: must_be_immutable
class BannedDetail extends StatefulWidget {
  BannedDetail({
    super.key,
    required this.userId,
    required this.guideData,
    required this.orderAllData,
    required this.isBanned,
  });
  String userId;
  Map guideData;
  Map orderAllData;
  bool isBanned;

  @override
  // ignore: no_logic_in_create_state
  State<BannedDetail> createState() => _BannedDetailState(
      userId: userId,
      guideData: guideData,
      orderAllData: orderAllData,
      isBanned: isBanned);
}

class _BannedDetailState extends State<BannedDetail> {
  _BannedDetailState(
      {required this.userId,
      required this.guideData,
      required this.orderAllData,
      required this.isBanned});
  String userId;
  Map guideData;
  Map orderAllData;
  bool isBanned;

  bool isLoading = false;

  String ratingText = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List reviewList = [];
    List orderID = orderAllData.keys.toList();
    for (var i = 0; i < orderID.length; i++) {
      // devtools.log(orderID[i]);
      Map? review = orderAllData['${orderID[i]}']?['review'];
      // devtools.log('review : $review');
      if (review != null) {
        devtools.log('review : $review');
        review['orderID'] = orderID[i];
        review['touristUid'] = orderAllData['${orderID[i]}']?['touristUid'];
        reviewList.add(review);
      }
    }
    devtools.log('reviewList : $reviewList');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: SizedBox(
          height: size.height * 0.07,
          width: size.width * 0.8,
          child: FloatingActionButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              devtools.log('reviewList : $reviewList');
              FirebaseApp tourGuideApp = await Firebase.initializeApp(
                name: 'tourGuideApp',
                options: DefaultFirebaseOptionsTourGuide.currentPlatform,
              );
              FirebaseFirestore tourGuideFirestore =
                  FirebaseFirestore.instanceFor(app: tourGuideApp);
              if (!isBanned) {
                DateTime timestampBaned = DateTime.now();
                String unbannedDate = DateFormat('dd/MM/yyyy')
                    .format(timestampBaned.add(const Duration(
                  days: 28,
                )));
                devtools.log('unbannedDate : $unbannedDate');
                int bannedCount = 0;
                if (guideData['bannedCount'] != null) {
                  bannedCount =
                      int.parse(guideData['bannedCount'].toString()) + 1;
                } else {
                  bannedCount++;
                }
                devtools.log('bannedCount $bannedCount');
                tourGuideFirestore.collection('users').doc(userId).update({
                  'banned': true,
                  'bannedUntil': unbannedDate,
                  'bannedCount': bannedCount,
                });
              } else {
                tourGuideFirestore.collection('users').doc(userId).update({
                  'banned': false,
                  'bannedUntil': '',
                  'kpi': {
                    'score': '5.0',
                    'ratingsCount': '0',
                    '1star': '0',
                    '2star': '0',
                    '3star': '0',
                    '4star': '0',
                    '5star': '0',
                  },
                  'unbannedTimeStamp': DateTime.now(),
                });
              }
              setState(() {
                isLoading = false;
                isBanned = !isBanned;
              });
              if (!mounted) {
                return;
              }
              Navigator.of(context).pop(true);
              // ..pop(true);
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          color: Colors.white,
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isBanned ? 'Unbanned' : 'Banned',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          backgroundColor: primaryColor,
          // toolbarHeight: 10,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: primaryColor,
            onTap: (int index) {
              devtools.log('tap tab $index');
            },
            tabs: const [
              Tab(
                child: Text(
                  'Overview',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Tab(
                child: Text(
                  'Review',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
          title: const Text(
            "Account Detail",
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop(true);
            },
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [const Text('Tour Guide ID'), Text(userId)],
                    ),
                    kpiDetail(size, guideData['kpi']),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // height: size.height * 0.06,
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: secondaryBackgroundColor.withOpacity(0.1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.account_box_rounded,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: size.width * 0.03,
                                      ),
                                      Text(
                                          '${guideData['firstName']} ${guideData['lastName']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                  Divider(
                                      color: secondaryBackgroundColor
                                          .withOpacity(0.5)),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      guideData['gender'] == 'Male'
                                          ? const Icon(Icons.male)
                                          : guideData['gender'] == 'Female'
                                              ? const Icon(Icons.female)
                                              : const Icon(Icons.transgender),
                                      SizedBox(
                                        width: size.width * 0.03,
                                      ),
                                      Text('${guideData['gender']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                  Divider(
                                      color: secondaryBackgroundColor
                                          .withOpacity(0.5)),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.cake),
                                      SizedBox(
                                        width: size.width * 0.03,
                                      ),
                                      Text('${guideData['birthDay']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                  Divider(
                                      color: secondaryBackgroundColor
                                          .withOpacity(0.5)),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.description),
                                      SizedBox(
                                        width: size.width * 0.03,
                                      ),
                                      Text('${orderAllData.length}\t\tjob',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                  Divider(
                                      color: secondaryBackgroundColor
                                          .withOpacity(0.5)),
                                  isBanned
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: size.height * 0.01,
                                            ),
                                            Text(
                                                'Banned Count : ${guideData['bannedCount']}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                )),
                                            Text(
                                                'Banned Until : ${guideData['bannedUntil']}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                )),
                                            Divider(
                                                color: secondaryBackgroundColor
                                                    .withOpacity(0.5)),
                                          ],
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: reviewList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(FadePageRoute(
                              ReviewDetail(reviewList: reviewList[index])));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 10, left: 10, top: 10),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Id : ${reviewList[index]['orderID']}',
                                  style: TextStyle(fontSize: size.width * 0.05),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 5, left: 10, top: 10, bottom: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Rating',
                                            style: TextStyle(
                                                fontSize: size.width * 0.04),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          RatingBar.builder(
                                            itemSize: 35,
                                            ignoreGestures: true,
                                            updateOnDrag: true,
                                            initialRating: double.parse(
                                                reviewList[index]['rating']
                                                    .toString()),
                                            itemCount: 5,
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (ratingUpdate) {},
                                          ),
                                          SizedBox(
                                            width: size.width * 0.03,
                                          ),
                                          Text(
                                            reviewList[index]['rating']
                                                .toString(),
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 198, 151, 9),
                                                fontSize: size.width * 0.05),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Comment : ',
                                            style: TextStyle(
                                                fontSize: size.width * 0.04),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.5,
                                            child: Text(
                                              reviewList[index]['comment']
                                                          .length >
                                                      26
                                                  ? '${reviewList[index]['comment'].substring(0, 25)}...'
                                                  : '${reviewList[index]['comment']}',
                                              // overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: size.width * 0.04),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: SizedBox(
                                    width: size.width,
                                    child: Text(
                                      'review by : ${reviewList[index]['touristUid']}',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget kpiDetail(Size size, Map kpiData) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                height: size.height * 0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Star Rating Score',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        '${kpiData['score']}',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ]));
  }
}
