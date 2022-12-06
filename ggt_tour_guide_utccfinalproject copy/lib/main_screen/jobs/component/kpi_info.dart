import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:developer' as devtools show log;

import '../../../constant.dart';

// ignore: must_be_immutable
class KPIInfo extends StatefulWidget {
  KPIInfo({super.key, required this.kpiData});
  Map kpiData;

  @override
  // ignore: no_logic_in_create_state
  State<KPIInfo> createState() => _KPIInfoState(kpiData: kpiData);
}

class _KPIInfoState extends State<KPIInfo> with SingleTickerProviderStateMixin {
  _KPIInfoState({required this.kpiData});
  Map kpiData;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     setState(() {});
          //     devtools.log('$kpiData');
          //   },
          // ),
          backgroundColor: primaryBackgroundColor,
          appBar: AppBar(
            title: const Text('More KPI Info'),
            centerTitle: true,
            bottom: TabBar(
              // isScrollable: true,
              indicatorColor: primaryColor,
              onTap: (int index) {
                devtools.log('tap tab $index');
              },
              tabs: const [
                Tab(
                  child: Text(
                    'Your Info',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Tab(
                  child: Text(
                    'KPI Info',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
            toolbarHeight: size.height * 0.06,
            backgroundColor: primaryColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: secondaryBackgroundColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0,
          ),
          body: TabBarView(children: [
            kpiData.isNotEmpty ? kpiDetail(size) : const SizedBox(),
            SingleChildScrollView(
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 20, bottom: 50),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: Text(
                              "KPI Information",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: 30),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Last revised : 12 Nov 2022",
                                  style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                      fontSize: 16),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Global Guide always considers the highest quality and safety in order to maintain a standard and acceptable level of service. We therefore set the service standards or star rating of the service more than 3 for any Tour Guide',
                                  style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                      fontSize: 15),
                                  textAlign: TextAlign.left,
                                  // textAlign: TextAlign.justify
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.03),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Star Rating Score',
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                  // textAlign: TextAlign.justify
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "The service quality standard indicator or star rating is the level of service users' satisfaction with the service of the tour guide, which tourists will evaluate after using the service. The rating is 5 stars: 1-5 stars from dissatisfied to very satisfied",
                                  style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                      fontSize: 15),
                                  textAlign: TextAlign.left,
                                  // textAlign: TextAlign.justify
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.03),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'How to calculate star rating',
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                  // textAlign: TextAlign.justify
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "The star rating displayed will update automatically. Calculated from all users of the service rating.",
                                  style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                      fontSize: 15),
                                  textAlign: TextAlign.left,
                                  // textAlign: TextAlign.justify
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Star Rating Score will calculated from the weighted average star rating with the following formula :',
                                  style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                      fontSize: 15),
                                  textAlign: TextAlign.left,
                                  // textAlign: TextAlign.justify
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Star Rating Score =\n[(Number of tourist rated 5 stars x 5) + (Number of tourist rated 4 stars x 4) + (Number of tourist rated 3 stars x 3) + (Number of tourist rated 2 stars x 2) +(Number of tourist 1 star rating x 1)] ÷ Total number of tourist rated',
                                      style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          color: primaryTextColor,
                                          fontSize: 15),
                                      textAlign: TextAlign.left,
                                      // textAlign: TextAlign.justify
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]))),
          ])),
    );
  }

  Widget kpiDetail(Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 20, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Text(
                "Your KPI Information",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: 30),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: size.height * 0.02),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            SizedBox(height: size.height * 0.02),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'You have ${kpiData['ratingsCount']} people who give you a star rating as follows.',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: 18),
                    textAlign: TextAlign.left,
                    // textAlign: TextAlign.justify
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingBar.builder(
                  ignoreGestures: true,
                  updateOnDrag: true,
                  initialRating: 5,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (ratingUpdate) {},
                ),
                Text(
                  '${kpiData['5star']}',
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                const SizedBox()
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingBar.builder(
                  ignoreGestures: true,
                  updateOnDrag: true,
                  initialRating: 4,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (ratingUpdate) {},
                ),
                Text(
                  '${kpiData['4star']}',
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                const SizedBox()
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingBar.builder(
                  ignoreGestures: true,
                  updateOnDrag: true,
                  initialRating: 3,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (ratingUpdate) {},
                ),
                Text(
                  '${kpiData['3star']}',
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                const SizedBox()
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingBar.builder(
                  ignoreGestures: true,
                  updateOnDrag: true,
                  initialRating: 2,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (ratingUpdate) {},
                ),
                Text(
                  '${kpiData['2star']}',
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                const SizedBox()
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingBar.builder(
                  ignoreGestures: true,
                  updateOnDrag: true,
                  initialRating: 1,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (ratingUpdate) {},
                ),
                Text(
                  '${kpiData['1star']}',
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                const SizedBox()
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'P.S. If you have total number of tourist rated = 0, we will give your Star Rating Score = 5.0',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: 18),
                    textAlign: TextAlign.left,
                    // textAlign: TextAlign.justify
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              children: const [
                Expanded(
                  child: Text(
                    "If you have total number of tourist rated more than 5 people and star rating score less than 3, your account wouldn't get any new job for 4 week and we will contact you by email for more information.",
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 18),
                    textAlign: TextAlign.left,
                    // textAlign: TextAlign.justify
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
