// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:ggt_tourist_utccfinalproject/firebase_options_tour_guide.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/plan/plan_1.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/calculate_age.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/custom_page_route.dart';
import 'dart:developer' as devtools show log;

import 'guide_info.dart';

// ignore: must_be_immutable
class SelectGuide extends StatefulWidget {
  SelectGuide({
    super.key,
    required this.attractions,
    required this.tourGuide,
    required this.attractionsAndCategory,
    required this.getFilter,
    required this.getFilterGender,
    required this.getFilterLanguages,
    required this.date,
    required this.timeSelected,
    required this.numAdult,
    required this.numChildren,
    required this.sedanPrice,
    required this.sedanCount,
    required this.vanPrice,
    required this.vanCount,
    required this.planDate,
    required this.yourTeamInfo,
    required this.durationCount,
    required this.meetingPoint,
    required this.contactData,
  });
  Map attractions;
  Map tourGuide;
  List attractionsAndCategory;
  List<String> getFilter;
  List<String> getFilterGender;
  List<String> getFilterLanguages;
  String date;

  String? timeSelected;
  int numAdult;
  int numChildren;
  DateTime planDate;
  int sedanPrice;
  int sedanCount;
  int vanPrice;
  int vanCount;
  Map yourTeamInfo;
  Duration durationCount;
  Map meetingPoint;
  Map contactData;

  @override
  State<SelectGuide> createState() =>
      // ignore: no_logic_in_create_state
      _SelectGuideState(
        attractionsAndCategory: attractionsAndCategory,
        attractions: attractions,
        tourGuide: tourGuide,
        getFilter: getFilter,
        date: date,
        numAdult: numAdult,
        numChildren: numChildren,
        planDate: planDate,
        sedanCount: sedanCount,
        sedanPrice: sedanPrice,
        timeSelected: timeSelected,
        vanCount: vanCount,
        vanPrice: vanPrice,
        yourTeamInfo: yourTeamInfo,
        getFilterGender: getFilterGender,
        getFilterLanguages: getFilterLanguages,
        durationCount: durationCount,
        meetingPoint: meetingPoint,
        contactData: contactData,
      );
}

class _SelectGuideState extends State<SelectGuide> {
  _SelectGuideState({
    required this.attractions,
    required this.tourGuide,
    required this.attractionsAndCategory,
    required this.getFilter,
    required this.getFilterGender,
    required this.getFilterLanguages,
    required this.date,
    required this.timeSelected,
    required this.numAdult,
    required this.numChildren,
    required this.sedanPrice,
    required this.sedanCount,
    required this.vanPrice,
    required this.vanCount,
    required this.planDate,
    required this.yourTeamInfo,
    required this.durationCount,
    required this.meetingPoint,
    required this.contactData,
  });
  Map attractions;
  Map tourGuide;
  List attractionsAndCategory;
  List<String> getFilter;
  List<String> getFilterGender;
  List<String> getFilterLanguages;
  String date;
  String? timeSelected;
  int numAdult;
  int numChildren;
  DateTime planDate;
  int sedanPrice;
  int sedanCount;
  int vanPrice;
  int vanCount;
  Map yourTeamInfo;
  Duration durationCount;
  Map meetingPoint;
  Map contactData;

  Map tourguideAllData = {};
  List tourguideDataId = [];
  List tourguideData = [];

  List tourGuideSelected = [];

  User? user;

  bool isFirebaseBug = false;

  // bool isLoading = false;
  // bool loadingSuss = false;
  bool dataMap = false;
  // list of string options
  List<String> attractionsOptions = [
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
  List<String> genderOptions = [
    'Male',
    'Female',
  ];
  List<String> languagesOptions = [
    'English',
    'Mandarin Chinese',
    'Hindi',
    'Spanish',
    'French',
    'Arabic',
    'Russian ',
    'Portuguese',
    'Japanese',
    'German',
    'Indonesian/Malaysian',
    'Korean',
  ];

  List<String> filters = [];
  List<String> filtersGender = [];
  List<String> filtersLanguages = [];
  List<String> filtersSave = [];
  List<String> attractionsType = [];
  List guideAvailable = [];
  Future? myFuture;
  @override
  void initState() {
    super.initState();
    myFuture = checkDatabase();
  }

  Future checkDatabase() async {
    FirebaseApp tourGuideApp = await Firebase.initializeApp(
      name: 'touristApp',
      options: DefaultFirebaseOptionsTourGuide.currentPlatform,
    );
    devtools.log('Initialized ');
    FirebaseFirestore tourGuideFirestore =
        FirebaseFirestore.instanceFor(app: tourGuideApp);

    CollectionReference collectionRef = tourGuideFirestore.collection('users');
    QuerySnapshot querySnapshot = await collectionRef.get();
    tourguideData = querySnapshot.docs.map((doc) => doc.data()).toList();
    tourguideDataId = querySnapshot.docs.map((doc) => doc.id).toList();
    for (int i = 0; i < tourguideDataId.length; i++) {
      tourguideAllData[tourguideDataId[i]] = tourguideData[i];
    }

    devtools.log(tourguideAllData.toString());
    filters = getFilter;
    filtersGender = getFilterGender;
    filtersLanguages = getFilterLanguages;
    List<String> tempFilter = [];
    devtools.log('filters ${filters.length}');
    for (int i = 0; i < getFilter.length; i++) {
      List temp = filters[i].split(', ');
      for (int j = 0; j < temp.length; j++) {
        tempFilter.add(temp[j]);
      }
    }
    devtools.log('test ${tempFilter.toSet().toList()}');
    filters = tempFilter.toSet().toList();
    // filtersSave = filters;

    guideAvailable = [];
    var temp = json.decode(tourguideAllData[tourguideDataId[0]]['aptitutes']);
    devtools.log('temp : ${temp.length}');
    List filters2 = filters;
    if (filters.isEmpty) {
      filters2 = attractionsOptions;
    }

    List tourguidefree = [];
    for (int i = 0; i < tourguideDataId.length; i++) {
      devtools.log(tourguideDataId[i].toString());
      for (int j = 0;
          j < tourguideAllData[tourguideDataId[i]]['freeDay'].length;
          j++) {
        if (tourguideAllData[tourguideDataId[i]]['freeDay'][j] == date) {
          var temp =
              json.decode(tourguideAllData[tourguideDataId[i]]['aptitutes']);
          for (int l = 0; l < filters2.length; l++) {
            if (temp.contains(filters2[l])) {
              devtools.log(temp.contains(filters2[l]).toString());
              devtools.log(tourguideAllData[tourguideDataId[i]]['freeDay'][j]);
              tourguidefree.add(tourguideDataId[i]);
              break;
            }
          }
        }
      }
    }
    tourguidefree = tourguidefree.toSet().toList();
    devtools.log('tourguidefree : $tourguidefree');

    List tourguideFilterTypesAttraction = [];
    for (int i = 0; i < tourguidefree.length; i++) {
      var temp = json.decode(tourguideAllData[tourguidefree[i]]['aptitutes']);
      for (int l = 0; l < filters2.length; l++) {
        if (temp.contains(filters2[l])) {
          tourguideFilterTypesAttraction.add(tourguidefree[i]);
          break;
        }
      }
    }
    devtools.log(
        'tourguideFilterTypesAttraction : $tourguideFilterTypesAttraction');

    List tourguideFilterGender = [];
    devtools.log(filtersGender.toString());
    if (filtersGender.isNotEmpty) {
      for (int i = 0; i < tourguideFilterTypesAttraction.length; i++) {
        if (filtersGender.contains(
            tourguideAllData[tourguideFilterTypesAttraction[i]]['gender'])) {
          devtools.log(tourguideAllData[tourguideFilterTypesAttraction[i]]
                  ['gender']
              .toString());
          tourguideFilterGender.add(tourguideFilterTypesAttraction[i]);
        }
      }
    } else {
      tourguideFilterGender = tourguideFilterTypesAttraction;
    }
    devtools.log('tourguideFilterGender : $tourguideFilterGender');

    List tourguideFilterLanguage = [];
    if (filtersLanguages.isNotEmpty) {
      for (int i = 0; i < tourguideFilterGender.length; i++) {
        for (int j = 0;
            j < tourguideAllData[tourguideFilterGender[i]]['language'].length;
            j++) {
          if (filtersLanguages.contains(
              tourguideAllData[tourguideFilterGender[i]]['language'][j])) {
            if (!tourguideFilterLanguage.contains(tourguideFilterGender[i])) {
              tourguideFilterLanguage.add(tourguideFilterGender[i]);
            }
          }
        }
      }
    } else {
      tourguideFilterLanguage = tourguideFilterGender;
    }

    guideAvailable = tourguideFilterLanguage;
    devtools.log('guideAvailable : $guideAvailable');
//--------------------------------------------
    for (int i = 0; i < tourguideDataId.length; i++) {
      if (tourguideAllData[tourguideDataId[i]]['email'] == tourGuide['email']) {
        tourGuideSelected.add(tourguideDataId[i]);
      }
    }
    dataMap = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: myFuture,
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              devtools.log(guideAvailable.toString());
              return Scaffold(
                // floatingActionButton: FloatingActionButton(
                //   onPressed: () {
                //     // devtools.log(
                //     //     tourguideAllData['JRuHKveaKXV4zlbfEIwNGGzBSGp1']
                //     //         .toString());
                //     // devtools.log(tourGuideSelected[0].length.toString());
                //     devtools.log(guideAvailable.toString());
                //     // [tourGuideSelected]
                //   },
                // ),
                backgroundColor: secondaryBackgroundColor,
                // floatingActionButton: FloatingActionButton(
                //   onPressed: () async {
                //     devtools.log('========================');
                //     devtools.log([tourguideDataId[0]].toString());
                //     devtools.log('========================');
                //   },
                // ),
                appBar: AppBar(
                  title: Text(
                    "Select Guide",
                    style: TextStyle(
                      color: tertiaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: primaryTextColor),
                    onPressed: () {
                      Map tempTourGuide = {};
                      if (tourGuideSelected.isNotEmpty) {
                        tempTourGuide =
                            tourguideAllData[tourGuideSelected[0].toString()];
                      }
                      Navigator.of(context).pushAndRemoveUntil(
                          FadePageRoute(Plan1(
                            attractions: attractions,
                            attractionsAndCategory: attractionsAndCategory,
                            tourGuide: tempTourGuide,
                            numAdult: numAdult,
                            numChildren: numChildren,
                            planDate: planDate,
                            sedanCount: sedanCount,
                            sedanPrice: sedanPrice,
                            timeSelected: timeSelected,
                            vanCount: vanCount,
                            vanPrice: vanPrice,
                            yourTeamInfo: yourTeamInfo,
                            meetingPoint: meetingPoint,
                            contactData: contactData,
                          )),
                          (Route<dynamic> route) => false);
                    },
                  ),
                  centerTitle: true,
                  backgroundColor: secondaryBackgroundColor,
                ),
                body: guideAvailable.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          filterBotton(size),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 150, bottom: 250, right: 30, left: 30),
                              child: Container(
                                  width: size.width * 0.9,
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
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                'There are no guides available at this time.',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryTextColor,
                                                  fontSize: size.height * 0.035,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                'Please select time again or select other attractions',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryTextColor,
                                                  fontSize: size.height * 0.03,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                            ],
                                          ),
                                        ]),
                                  ))),
                        ],
                      )
                    : SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              filterBotton(size),
                              // filterBotton(size),
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: guide(size)),
                            ]),
                      ),
              );
            default:
              return Container(
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   colors: [primaryColor, primaryTextColor, secondaryColor],
                    //   stops: const [0, 0.5, 1],
                    //   begin: const AlignmentDirectional(1, -1),
                    //   end: const AlignmentDirectional(-1, 1),
                    // ),
                    color: primaryBackgroundColor),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              );
          }
        }));
  }

  Widget guide(Size size) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: guideAvailable.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.of(context).push(FadePageRoute(GuideInfo(
                  guideData: tourguideAllData[guideAvailable[index]],
                )));
              },
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.white,
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: size.width * 0.33,
                          height: size.height * 0.15,
                          child: isFirebaseBug
                              ? const Icon(Icons.developer_board)
                              : CachedNetworkImage(
                                  imageUrl:
                                      tourguideAllData[guideAvailable[index]]
                                          ['photoProfileURL'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),

                          // Image.network(
                          //     tourguideAllData[guideAvailable[index]]['photoProfileURL'],
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    tourguideAllData[guideAvailable[index]]
                                        ['user_name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                        fontSize: size.width * 0.06),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    '(${tourguideAllData[guideAvailable[index]]['firstName']} ${tourguideAllData[tourguideDataId[index]]['lastName']})',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        // fontWeight:
                                        //     FontWeight
                                        //         .bold,
                                        color: primaryTextColor,
                                        fontSize: size.width * 0.035),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    'Gender: ${tourguideAllData[guideAvailable[index]]['gender']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        // fontWeight:
                                        //     FontWeight
                                        //         .bold,
                                        color: primaryTextColor,
                                        fontSize: size.width * 0.04),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    "Age: ${calculateAge(tourguideAllData[guideAvailable[index]]['birthDay'])}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        // fontWeight:
                                        //     FontWeight
                                        //         .bold,
                                        color: primaryTextColor,
                                        fontSize: size.width * 0.04),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        // color: Colors.amber,
                        width: size.width * 0.06,
                        height: size.height * 0.15,
                        child: Center(
                          child: Transform.scale(
                            scale: 1.3,
                            child: Checkbox(
                              checkColor: tertiaryColor,
                              activeColor: primaryColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              value: tourGuideSelected
                                  .contains(guideAvailable[index]),
                              onChanged: (inputValue) {
                                setState(() {
                                  if (tourGuideSelected
                                      .contains(guideAvailable[index])) {
                                    tourGuideSelected
                                        .remove(guideAvailable[index]);
                                  } else {
                                    tourGuideSelected = [guideAvailable[index]];
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      )
                    ],
                  ),
                ],
              ));
        });
  }

  Widget filterBotton(Size size) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10),
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.amber,
          // color: Colors.red,
          border: Border.all(
              color: Colors.grey.withOpacity(0.5), width: size.width * 0.005),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
            // topRight: Radius.circular(20),
          ),
        ),
        height: size.height * 0.05,
        width: size.width * 0.4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              devtools.log('Tap Filters');
              // attractionsType;
              _showCitiesDialog(size, attractionsType);
              //https://pub.dev/packages/filter_list
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.filter_list_rounded),
                Text(
                  'Filters \u2022 ${filters.length + filtersGender.length + filtersLanguages.length}',
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCitiesDialog(Size size, List list) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Filter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: size.width * 0.06),
                ),
              ),
              insetPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: SingleChildScrollView(
                child: SizedBox(
                    width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Types of Attractions',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                                fontSize: size.width * 0.04),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ChipsChoice<String>.multiple(
                            // padding: EdgeInsets.fromLTRB(0, -6, 0, -6),
                            value: filters,
                            onChanged: (val) {
                              setState(() => filters = val);
                            },
                            choiceItems: C2Choice.listFrom<String, String>(
                              source: attractionsOptions,
                              value: (i, v) => v,
                              label: (i, v) => v,
                            ),
                            choiceStyle: C2ChoiceStyle(
                              color: Colors.black,
                              borderColor: primaryTextColor,
                              labelStyle: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: size.width * 0.04),
                            ),
                            choiceActiveStyle: C2ChoiceStyle(
                              color: darkPrimaryColor,
                            ),
                            wrapped: true,
                            textDirection: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Gender',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                                fontSize: size.width * 0.04),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ChipsChoice<String>.multiple(
                            // padding: EdgeInsets.fromLTRB(0, -6, 0, -6),
                            value: filtersGender,
                            onChanged: (val) {
                              setState(() => filtersGender = val);
                            },
                            choiceItems: C2Choice.listFrom<String, String>(
                              source: genderOptions,
                              value: (i, v) => v,
                              label: (i, v) => v,
                            ),
                            choiceStyle: C2ChoiceStyle(
                              color: Colors.black,
                              borderColor: primaryTextColor,
                              labelStyle: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: size.width * 0.04),
                            ),
                            choiceActiveStyle: C2ChoiceStyle(
                              color: darkPrimaryColor,
                            ),
                            wrapped: true,
                            textDirection: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Languages',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                                fontSize: size.width * 0.04),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ChipsChoice<String>.multiple(
                            // padding: EdgeInsets.fromLTRB(0, -6, 0, -6),
                            value: filtersLanguages,
                            onChanged: (val) {
                              setState(() => filtersLanguages = val);
                            },
                            choiceItems: C2Choice.listFrom<String, String>(
                              source: languagesOptions,
                              value: (i, v) => v,
                              label: (i, v) => v,
                            ),
                            choiceStyle: C2ChoiceStyle(
                              color: Colors.black,
                              borderColor: primaryTextColor,
                              labelStyle: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  fontSize: size.width * 0.04),
                            ),
                            choiceActiveStyle: C2ChoiceStyle(
                              color: darkPrimaryColor,
                            ),
                            wrapped: true,
                            textDirection: null,
                          ),
                        ),
                      ],
                    )),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0, right: 10, left: 10, bottom: 20),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              filters = [];
                              filtersGender = [];
                              filtersLanguages = [];
                            });
                          },
                          child: SizedBox(
                            height: 58,
                            // width: size.width * 0.4,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(8 + 32 * (1)),
                            //   border: Border.all(color: tertiaryColor),
                            //   color: secondaryBackgroundColor,
                            // ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Clear filters',
                                  style: TextStyle(
                                    // color: secondaryColor,
                                    color: tertiaryColor,
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 20),
                      child: InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            devtools.log(filters.toString());
                            // Navigator.pop(context, true);
                            Navigator.of(context)
                                .push(FadePageRoute(SelectGuide(
                              attractionsAndCategory: attractionsAndCategory,
                              attractions: attractions,
                              tourGuide: tourGuide,
                              getFilter: filters,
                              date: date,
                              numAdult: numAdult,
                              numChildren: numChildren,
                              planDate: planDate,
                              sedanCount: sedanCount,
                              sedanPrice: sedanPrice,
                              timeSelected: timeSelected,
                              vanCount: vanCount,
                              vanPrice: vanPrice,
                              yourTeamInfo: yourTeamInfo,
                              getFilterGender: filtersGender,
                              getFilterLanguages: filtersLanguages,
                              durationCount: durationCount,
                              meetingPoint: meetingPoint,
                              contactData: contactData,
                            )));
                            //   Navigator.of(context).pushAndRemoveUntil(
                            //       FadePageRoute(SelectLocation(
                            //         attractionsSelected: attractionsSelectedCopy,
                            //         durationCount: durationCount,
                            //         selectedAttractions: selectedAttractions,
                            //         getFilter: filters,
                            //         tourGuide: tourGuide,
                            //         numAdult: numAdult,
                            //         numChildren: numChildren,
                            //         planDate: planDate,
                            //         sedanCount: sedanCount,
                            //         sedanPrice: sedanPrice,
                            //         timeSelected: timeSelected,
                            //         vanCount: vanCount,
                            //         vanPrice: vanPrice,
                            //         yourTeamInfo: yourTeamInfo,
                            //       )),
                            //       (Route<dynamic> route) => false);
                          });
                        },
                        child: Container(
                          height: 58,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8 + 32 * (1)),
                            color: primaryColor,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Apply',
                                  style: TextStyle(
                                    color: tertiaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }
}
