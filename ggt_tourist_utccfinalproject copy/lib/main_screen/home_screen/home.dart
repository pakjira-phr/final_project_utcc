import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/coming_soon.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/plan/plan_1.dart';
import 'dart:developer' as devtools show log;
import 'dart:math';

import '../../constant.dart';
import '../../utillties/custom_page_route.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PageController? pageViewController;
  List<Widget> tempWid = [];
  bool isFirebaseBug = false;

  List<String> options = [
    'Sights & Landmarks',
    'Religious Sites',
    'Historic Sites',
    'Shopping',
    'Architectural Buildings',
    'Observation Decks & Towers',
    'Arenas & Stadiums',
    'Museums',
    'Nature & Parks',
    'Water & Amusement Parks',
    'Zoos & Aquariums',
  ];

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    pageViewController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageViewController?.dispose();
    super.dispose();
  }

  Map categoryDataMap = {};
  Map typesOfAttractions = {};

  Map locationInfoDataMap = {};
  List locationInfoKey = [];

  Future getData() async {
    CollectionReference collectionRef = firestore.collection('locations');
    //categoryData
    DocumentSnapshot<Object?> categoryData =
        await collectionRef.doc('category').get();
    categoryDataMap = categoryData.data() as Map<String, dynamic>;
    typesOfAttractions = categoryDataMap[' Types of Attractions'];
    //locationInfoData
    DocumentSnapshot<Object?> locationInfoData =
        await collectionRef.doc('locationInfo').get();
    locationInfoDataMap = locationInfoData.data() as Map<String, dynamic>;
    // for (int i = 0; i < locationInfoDataMap.length; i++) {
    //   // locationInfoKey.add(locationInfoDataMap.keys);
    // }
    locationInfoKey = locationInfoDataMap.keys.toList();
    // devtools.log(typesOfAttractions['Shopping'].toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List randomIndex = [];
          // var rng = Random();
          Set<int> setOfInts = {};
          for (var i = 0; setOfInts.length < 10; i++) {
            setOfInts.add(Random().nextInt(locationInfoDataMap.length));
          }
          randomIndex = setOfInts.toList();
          // devtools.log("randomIndex$randomIndex");
          return Scaffold(
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     // setOfInts.add(Random().nextInt(45));
            //     // setOfInts.add(Random().nextInt(45));
            //     // setOfInts.add(Random().nextInt(45));
            //     devtools.log("${randomIndex}");
            //   },
            // ),
            backgroundColor: primaryTextColor,
            appBar: AppBar(
              toolbarHeight: size.height * 0.01,
              backgroundColor: primaryTextColor,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Stack(
                // alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    height: size.height + size.height + size.height * 0.05,
                    width: size.width,
                    decoration: BoxDecoration(
                      // border:
                      //     Border.all(color: primaryBackgroundColor.withOpacity(0.9)),
                      color: secondaryBackgroundColor,
                      // borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(children: [
                      SizedBox(
                        height: size.height * 0.3,
                      ),
                      Container(
                        // color: Colors.amber,
                        width: size.width,
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 30, left: 30, bottom: 20),
                          child: Text(
                            "Get inspired",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                              fontSize: size.height * 0.035,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(FadePageRoute(const ComingSoonPage()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: tertiaryColor.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/promotion.jpg',
                              width: size.width * 0.8,
                              height: size.height * 0.35,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            // color: Colors.amber,
                            width: size.width,
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 30,
                              ),
                              child: Text(
                                "You might like this",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: size.height * 0.025,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.amber,
                            width: size.width,
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, left: 30),
                              child: Text(
                                "More places to go",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: size.height * 0.02,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: SizedBox(
                              // color: Colors.amber,
                              height: size.height * 0.37,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: randomIndex.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        devtools
                                            .log("tap ${randomIndex[index]}");
                                        Navigator.of(context).push(
                                            FadePageRoute(
                                                const ComingSoonPage()));
                                      },
                                      child: Column(
                                        children: [
                                          Card(
                                            color: Colors.white,
                                            child: SizedBox(
                                              width: size.width * 0.6,
                                              height: size.height * 0.25,
                                              child: isFirebaseBug
                                                  ? const Icon(
                                                      Icons.developer_board)
                                                  : CachedNetworkImage(
                                                      imageUrl: locationInfoDataMap[
                                                              locationInfoKey[
                                                                  randomIndex[
                                                                      index]]]
                                                          ['pic'],
                                                      placeholder: (context,
                                                              url) =>
                                                          const CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                              // Image.network(
                                              //     locationInfoDataMap[
                                              //             locationInfoKey[
                                              //                 randomIndex[
                                              //                     index]]]
                                              //         ['pic'],
                                              //     fit: BoxFit.fill,
                                              //   ),
                                            ),
                                          ),
                                          SizedBox(
                                            // color: Colors.amber,
                                            width: size.width * 0.6,
                                            // alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${locationInfoKey[randomIndex[index]]}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryTextColor,
                                                      fontSize:
                                                          size.height * 0.018,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: SizedBox(
                                              // color: Colors.amber,
                                              width: size.width * 0.6,
                                              // alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "${locationInfoDataMap[locationInfoKey[randomIndex[index]]]['category'].join(", ")}",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        color: primaryTextColor,
                                                        fontSize:
                                                            size.height * 0.018,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            // color: Colors.amber,
                            width: size.width,
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 30,
                              ),
                              child: Text(
                                "Types of Attractions",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: size.height * 0.025,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.amber,
                            width: size.width,
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, left: 30),
                              child: Text(
                                "Explore by types",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: size.height * 0.02,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: SizedBox(
                                // color: Colors.red,
                                height: size.height * 0.33,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: options.length,
                                    // prototypeItem: ListTile(
                                    //   title: Text(options.first),
                                    // ),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          devtools.log("tap $index");
                                          Navigator.of(context).push(
                                              FadePageRoute(
                                                  const ComingSoonPage()));
                                        },
                                        child: Column(
                                          children: [
                                            Card(
                                              color: Colors.white,
                                              child: SizedBox(
                                                width: size.width * 0.6,
                                                height: size.height * 0.25,
                                                child: isFirebaseBug
                                                    ? const Icon(
                                                        Icons.developer_board)
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            typesOfAttractions[
                                                                options[index]],
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),

                                                // Image.network(
                                                //     typesOfAttractions[
                                                //         options[index]],
                                                //     fit: BoxFit.fill,
                                                //   ),
                                              ),
                                            ),
                                            SizedBox(
                                              // color: Colors.amber,
                                              width: size.width * 0.6,
                                              // alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      options[index],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: primaryTextColor,
                                                        fontSize:
                                                            size.height * 0.018,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          width: size.width * 0.8,
                          height: size.height * 0.3,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              border: Border.all(
                                  color: primaryColor.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.2),
                                  spreadRadius: 4,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Discover more in Bangkok',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                      fontSize: size.height * 0.035,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 20, 30, 2),
                                child: InkWell(
                                  onTap: () async {
                                    devtools.log("tap Expoloring");
                                    Navigator.of(context).push(
                                        FadePageRoute(const ComingSoonPage()));
                                  },
                                  child: Container(
                                    height: size.height * 0.07,
                                    width: size.width * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: tertiaryColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Expoloring',
                                          style: TextStyle(
                                            color: secondaryBackgroundColor,
                                            fontSize: size.height * 0.023,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: size.height * 0.2,
                      width: size.width,
                      decoration: BoxDecoration(
                        // border:
                        //     Border.all(color: primaryBackgroundColor.withOpacity(0.9)),
                        color: primaryTextColor,
                        // borderRadius: BorderRadius.circular(28),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 20, top: 10),
                        child: Text(
                          "Hi, ${user?.displayName ?? 'error'}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 36),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: size.height * 0.1,
                      left: size.width * 0.05,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: size.height * 0.2,
                          width: size.width * 0.901,
                          decoration: BoxDecoration(
                            color: secondaryBackgroundColor,
                            border: Border.all(
                                color: primaryColor.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      devtools.log('tap 1');
                                      Navigator.of(context)
                                          .push(FadePageRoute(Plan1(
                                        attractions: const {
                                          'attractionsSelected': <String>[],
                                          'typeAttractionsSelected': <String>[],
                                          'picAttractionsSelected': <String>[]
                                        },
                                        attractionsAndCategory: const [],
                                        tourGuide: const {},
                                        timeSelected: null,
                                        numAdult: 0,
                                        numChildren: 0,
                                        sedanCount: 0,
                                        sedanPrice: 0,
                                        vanCount: 0,
                                        vanPrice: 0,
                                        planDate: DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day + 4),
                                        yourTeamInfo: const {},
                                        meetingPoint: const {},
                                        contactData: const {},
                                      )));
                                    },
                                    child: Container(
                                      height:
                                          size.height * 0.2 - size.height * 0.1,
                                      width: size.width * 0.9 -
                                          ((size.width * 0.905) / 2),
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.2)),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          // topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // const Icon(
                                          //   Icons.map_outlined,
                                          //   color: Colors.black,
                                          //   size: 30,
                                          // ),
                                          // const SizedBox(
                                          //   width: 5,
                                          // ),
                                          Text(
                                            "Plan &\nBooking Guide",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: primaryTextColor,
                                                fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      devtools.log('tap 2');
                                      Navigator.of(context).push(FadePageRoute(
                                          const ComingSoonPage()));
                                    },
                                    child: Container(
                                      height:
                                          size.height * 0.2 - size.height * 0.1,
                                      width: size.width * 0.9 -
                                          ((size.width * 0.905) / 2),
                                      decoration: BoxDecoration(
                                        // color: Colors.amber,
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.2)),
                                        borderRadius: const BorderRadius.only(
                                          // topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(children: [
                                                // const Icon(
                                                //   Icons.local_see,
                                                //   color: Colors.black,
                                                //   size: 30,
                                                // ),
                                                // const SizedBox(
                                                //   width: 10,
                                                // ),
                                                Text(
                                                  "Tour &",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryTextColor,
                                                      fontSize: 20),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                              Text(
                                                "must-see",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                    fontSize: 20),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      devtools.log('tap 3');
                                      Navigator.of(context).push(FadePageRoute(
                                          const ComingSoonPage()));
                                    },
                                    child: Container(
                                      height: size.height * 0.2 -
                                          size.height * 0.1025,
                                      width: size.width * 0.9 -
                                          ((size.width * 0.905) / 2),
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.2)),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          // topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // const Icon(
                                          //   Icons.location_pin,
                                          //   color: Colors.black,
                                          //   size: 30,
                                          // ),
                                          // const SizedBox(
                                          //   width: 5,
                                          // ),
                                          Text(
                                            "Attractions",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: primaryTextColor,
                                                fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      devtools.log('tap 4');
                                      Navigator.of(context).push(FadePageRoute(
                                          const ComingSoonPage()));
                                    },
                                    child: Container(
                                      height: size.height * 0.2 -
                                          size.height * 0.1025,
                                      width: size.width * 0.9 -
                                          ((size.width * 0.905) / 2),
                                      decoration: BoxDecoration(
                                        // color: Colors.amber,
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.2)),
                                        borderRadius: const BorderRadius.only(
                                          // topLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // const Icon(
                                          //   Icons.local_activity,
                                          //   color: Colors.black,
                                          //   size: 30,
                                          // ),
                                          // const SizedBox(
                                          //   width: 5,
                                          // ),
                                          Text(
                                            "Things to do",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: primaryTextColor,
                                                fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          );
        }
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [primaryColor, primaryTextColor, secondaryColor],
              //   stops: const [0, 0.5, 1],
              //   begin: const AlignmentDirectional(1, -1),
              //   end: const AlignmentDirectional(-1, 1),
              // ),
              color: secondaryBackgroundColor),
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
      },
    );
  }
}
