import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ggt_admin_utccfinalproject/constant.dart';

import '../../firebase_options_tour_guide.dart';
import 'dart:developer' as devtools show log;

import '../../utillties/custom_page_route.dart';
import 'account_detail.dart';

class BannedAccount extends StatefulWidget {
  const BannedAccount({super.key});

  @override
  State<BannedAccount> createState() => _BannedAccountState();
}

class _BannedAccountState extends State<BannedAccount> {
  List userId = [];
  List userData = [];
  Map tourguideAllData = {};

  List kpiLow = [];
  List bannedUser = [];
  bool isGetData = false;
  bool isFirebaseBug = false;

  Future getDatabaseData() async {
    userId = [];
    userData = [];
    tourguideAllData = {};
    kpiLow = [];
    bannedUser = [];
    FirebaseApp tourGuideApp = await Firebase.initializeApp(
      name: 'tourGuideApp',
      options: DefaultFirebaseOptionsTourGuide.currentPlatform,
    );
    FirebaseFirestore tourGuideFirestore =
        FirebaseFirestore.instanceFor(app: tourGuideApp);
    var snapshot = await tourGuideFirestore.collection('users').get();
    userData = snapshot.docs.map((doc) => doc.data()).toList();
    userId = snapshot.docs.map((doc) => doc.id).toList();
    for (int i = 0; i < userId.length; i++) {
      tourguideAllData[userId[i]] = userData[i];
      if (userData[i]['banned'] == true) {
        bannedUser.add(userId[i]);
      } else if (double.parse(userData[i]['kpi']['score']) < 3.0) {
        kpiLow.add(userId[i]);
      }
    }
    devtools.log('kpiLow : $kpiLow');
    devtools.log('bannedUser : $bannedUser');
    isGetData = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getDatabaseData(),
        builder: ((context, snapshot) {
          if (isGetData) {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                  // floatingActionButton: FloatingActionButton(
                  //   onPressed: () {
                  //     getDatabaseData();
                  //   },
                  // ),
                  appBar: AppBar(
                    backgroundColor: primaryColor,
                    toolbarHeight: 10,
                    bottom: TabBar(
                      isScrollable: true,
                      indicatorColor: primaryColor,
                      onTap: (int index) {
                        devtools.log('tap tab $index');
                      },
                      tabs: const [
                        Tab(
                          child: Text(
                            'All User',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Low KPI User',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Banned User',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(children: [
                    guideTabBody(size, userId, false),
                    guideTabBody(size, kpiLow, false),
                    guideTabBody(size, bannedUser, true),
                  ])),
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

  Widget guideTabBody(Size size, List list, bool isBanned) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
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
                        "Have not any account at this time.",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () async {
                            devtools.log('tab ${list[index]}');
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
                                          color: primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            FirebaseApp tourGuideApp =
                                await Firebase.initializeApp(
                              name: 'tourGuideApp',
                              options: DefaultFirebaseOptionsTourGuide
                                  .currentPlatform,
                            );
                            FirebaseFirestore tourGuideFirestore =
                                FirebaseFirestore.instanceFor(
                                    app: tourGuideApp);
                            devtools.log('initialize tourGuideApp');
                            QuerySnapshot querySnapshot =
                                await tourGuideFirestore
                                    .collection('users')
                                    .doc(list[index].toString())
                                    .collection('order')
                                    .get();
                            List orderData = querySnapshot.docs
                                .map((doc) => doc.data())
                                .toList();
                            List orderId = querySnapshot.docs
                                .map((doc) => doc.id)
                                .toList();
                            Map orderAllData = {};
                            for (int i = 0; i < orderId.length; i++) {
                              orderAllData[orderId[i]] = orderData[i];
                            }
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                            // ignore: use_build_context_synchronously
                            Navigator.of(context)
                                .push(FadePageRoute(BannedDetail(
                                    userId: list[index].toString(),
                                    guideData: tourguideAllData[list[index]],
                                    orderAllData: orderAllData,
                                    isBanned: isBanned)))
                                .then((value) {
                              setState(() {
                                // getDataBase();
                              });
                            });
                            // Navigator.of(context).push(FadePageRoute(GuideInfo(
                            //   guideData: tourguideAllData[guideAvailable[index]],
                            // )));
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      color: Colors.white,
                                      semanticContainer: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(10),
                                      child: SizedBox(
                                        width: size.width * 0.33,
                                        height: size.height * 0.15,
                                        child: isFirebaseBug
                                            ? const Icon(Icons.developer_board)
                                            : CachedNetworkImage(
                                                imageUrl: tourguideAllData[
                                                        list[index]]
                                                    ['photoProfileURL'],
                                                placeholder: (context, url) =>
                                                    const Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                        // Image.network(
                                        // tourguideAllData[list[index]]
                                        //     ['photoProfileURL'],
                                        //     fit: BoxFit.fill,
                                        //   )
                                      ),
                                    ),
                                    SizedBox(
                                      // color: Colors.amber,
                                      width: size.width - (size.width * 0.5),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Container(
                                          // height: size.height * 0.12,
                                          alignment: Alignment.topLeft,
                                          // color: Colors.amber,
                                          child: Column(
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0),
                                                child: Text(
                                                  tourguideAllData[list[index]]
                                                      ['user_name'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryTextColor,
                                                      fontSize:
                                                          size.width * 0.06),
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Text(
                                                  '(${tourguideAllData[list[index]]['firstName']} ${tourguideAllData[list[index]]['lastName']})',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      // fontWeight:
                                                      //     FontWeight
                                                      //         .bold,
                                                      color: primaryTextColor,
                                                      fontSize:
                                                          size.width * 0.035),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0),
                                                child: Text(
                                                  'Gender: ${tourguideAllData[list[index]]['gender']}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      // fontWeight:
                                                      //     FontWeight
                                                      //         .bold,
                                                      color: primaryTextColor,
                                                      fontSize:
                                                          size.width * 0.04),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0),
                                                child: Text(
                                                  "KPI: ${tourguideAllData[list[index]]['kpi']['score']}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      // fontWeight:
                                                      //     FontWeight
                                                      //         .bold,
                                                      color: primaryTextColor,
                                                      fontSize:
                                                          size.width * 0.04),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    '(${list[index]})',
                                  ),
                                )
                              ],
                            ),
                          ));
                    }),
          ],
        ),
      ),
    );
  }
}
