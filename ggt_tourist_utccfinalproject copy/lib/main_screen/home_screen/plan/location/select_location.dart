import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/plan/plan_1.dart';
import 'package:ggt_tourist_utccfinalproject/widget/popup_dialog.dart';
import 'dart:developer' as devtools show log;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import '../../../../constant.dart';
import '../../../../utillties/custom_page_route.dart';

import 'location_info.dart';
import 'search_location.dart';

// ignore: must_be_immutable
class SelectLocation extends StatefulWidget {
  // const SelectLocation({super.key});
  SelectLocation({
    super.key,
    required this.attractionsSelected,
    required this.selectedAttractions,
    required this.getFilter,
    required this.timeSelected,
    required this.tourGuide,
    required this.numAdult,
    required this.numChildren,
    required this.sedanPrice,
    required this.sedanCount,
    required this.vanPrice,
    required this.vanCount,
    required this.planDate,
    required this.yourTeamInfo,
    required this.meetingPoint,
     required this.contactData,
  });
  List attractionsSelected;
  Map selectedAttractions;
  List<String> getFilter;
  Map tourGuide;
  String? timeSelected;
  int numAdult;
  int numChildren;
  DateTime planDate;
  int sedanPrice;
  int sedanCount;
  int vanPrice;
  int vanCount;
  Map yourTeamInfo;
  Map meetingPoint;
   Map contactData;

  @override
  // ignore: no_logic_in_create_state
  State<SelectLocation> createState() => _SelectLocationState(
      tourGuide: tourGuide,
      timeSelected: timeSelected,
      numAdult: numAdult,
      numChildren: numChildren,
      sedanCount: sedanCount,
      sedanPrice: sedanPrice,
      vanCount: vanCount,
      vanPrice: vanPrice,
      planDate: planDate,
      yourTeamInfo: yourTeamInfo,
      attractionsSelected: attractionsSelected,
      getFilter: getFilter,
      selectedAttractions: selectedAttractions,
      meetingPoint: meetingPoint,contactData: contactData,);
}

class _SelectLocationState extends State<SelectLocation>
    with SingleTickerProviderStateMixin {
  _SelectLocationState({
    required this.attractionsSelected,
    required this.selectedAttractions,
    required this.getFilter,
    required this.timeSelected,
    required this.tourGuide,
    required this.numAdult,
    required this.numChildren,
    required this.sedanPrice,
    required this.sedanCount,
    required this.vanPrice,
    required this.vanCount,
    required this.planDate,
    required this.yourTeamInfo,
    required this.meetingPoint,
     required this.contactData,
  });
  List attractionsSelected;
  Map selectedAttractions;
  List<String> getFilter;
  Map tourGuide;
  String? timeSelected;
  int numAdult;
  int numChildren;
  DateTime planDate;
  int sedanPrice;
  int sedanCount;
  int vanPrice;
  int vanCount;

  Map yourTeamInfo;
  Map meetingPoint;
   Map contactData;

  List attractionsSelectedCopy = [];

  List<String> filters = [];
  // List attractionsSelected = [];
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  bool loadingSuss = false;
  bool dataMap = false;
  Map<String, dynamic>? attractionsData;
  List attractionsName = [];
  List attractionsNameByFilters = [];
  List<String> attractionsType = [];
  Duration durationCount = const Duration(minutes: 0);

  TabController? tabController;

  @override
  void initState() {
    attractionsSelectedCopy = attractionsSelected.toList();
    filters = getFilter.toList();

    super.initState();
    tabController = TabController(
        vsync: this,
        length:
            2); // This would best not to be hard coded, but I saw that you had two tabs...
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  bool isFirebaseBug = false;
  Duration? timeSelect;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference collectionRef = firestore.collection('locations');
    switch (timeSelected) {
      case 'All Day':
        timeSelect = DateFormat("HH:mm")
            .parse("20:00")
            .difference(DateFormat("HH:mm").parse("08:00"));
        break;
      case 'Half Day':
        timeSelect = DateFormat("HH:mm")
            .parse("18:00")
            .difference(DateFormat("HH:mm").parse("12:00"));
        break;
      case 'Night':
        timeSelect = DateFormat("HH:mm")
            .parse("21:00")
            .difference(DateFormat("HH:mm").parse("17:00"));
        break;
      default:
    }

    return FutureBuilder<DocumentSnapshot>(
      future: collectionRef.doc('locationInfo').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done || loadingSuss) {
          loadingSuss = true;
          if (!dataMap) {
            attractionsData = snapshot.data!.data() as Map<String, dynamic>;
            dataMap = true;
            devtools.log(attractionsData.toString());
            attractionsName = attractionsData?.keys.toList() ?? [];
            attractionsName.sort((a, b) => a.compareTo(b));
            devtools.log(attractionsName[0].toString());
            devtools.log('${attractionsData?.keys}');

            attractionsNameByFilters = [];
            if (filters.isNotEmpty) {
              for (int i = 0; i < attractionsName.length; i++) {
                for (int j = 0; j < filters.length; j++) {
                  if (attractionsData![attractionsName[i]]['category']
                      .contains(filters[j])) {
                    devtools.log(attractionsData![attractionsName[i]]
                            ['category']
                        .toString());
                    if (attractionsNameByFilters.contains(attractionsName[i])) {
                      devtools.log(attractionsName[i].toString());
                    } else {
                      attractionsNameByFilters
                          .add(attractionsName[i].toString());
                    }
                  }
                }
              }
            } else {
              attractionsNameByFilters = attractionsName.toList();
            }

            devtools.log(attractionsNameByFilters.toString());

            List<String> temp = [];
            for (int i = 0; i < attractionsName.length; i++) {
              for (int j = 0;
                  j < attractionsData![attractionsName[i]]['category'].length;
                  j++) {
                if (temp.contains(
                        attractionsData![attractionsName[i]]['category'][j]) ==
                    false) {
                  temp.add(attractionsData![attractionsName[i]]['category'][j]);
                }
              }
            }
            temp.toSet().toList();

            attractionsType = temp;
            temp = [];
            devtools.log(attractionsType.toString());

            // devtools.log((timeSelect?.inHours).toString());
            for (int i = 0; i < attractionsSelectedCopy.length; i++) {
              Map temp2 = attractionsData![attractionsSelectedCopy[i]]
                  ['suggestedDuration'];
              // String sugTime2 =
              //     '${temp2['hours']}.${temp2['minutes']}';
              // devtools.log(
              //     '${temp2['hours']}.${temp2['minutes']}');
              int hours = temp2['hours'].runtimeType == String
                  ? int.parse(temp2['hours'])
                  : temp2['hours'];
              int minutes = temp2['minutes'].runtimeType == String
                  ? int.parse(temp2['minutes'])
                  : temp2['minutes'];
              devtools.log('$hours : $minutes');
              durationCount = Duration(
                  minutes: durationCount.inMinutes + (hours * 60) + minutes);
            }
            devtools.log('durationCount $durationCount');
          }
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {},
              // ),
              backgroundColor: secondaryBackgroundColor,
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      attractionsSelected = attractionsSelectedCopy;
                      attractionsNameByFilters = [];
                      Navigator.of(context).push(FadePageRoute(SearchLocation(
                        attractionsData: attractionsData ?? {},
                        attractionsName: attractionsName,
                        attractionsSelected: attractionsSelected,
                        durationCount: durationCount,
                        selectedAttractions: selectedAttractions,
                        tourGuide: tourGuide,
                        numAdult: numAdult,
                        numChildren: numChildren,
                        planDate: planDate,
                        sedanCount: sedanCount,
                        sedanPrice: sedanPrice,
                        timeSelected: timeSelected,
                        vanCount: vanCount,
                        vanPrice: vanPrice,
                        yourTeamInfo: yourTeamInfo, meetingPoint: meetingPoint, contactData: contactData,
                      )));
                    },
                    icon: Icon(
                      Icons.search,
                      color: primaryTextColor,
                    ),
                  )
                ],
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: primaryTextColor),
                  onPressed: () {
                    attractionsSelected = attractionsSelectedCopy;
                    Map valueMap = {
                      'attractionsSelected': <String>[],
                      'typeAttractionsSelected': <String>[],
                      'picAttractionsSelected': <String>[]
                    };
                    // valueMap =
                    //     json.decode(json.encode(selectedAttractions));
                    attractionsSelectedCopy.sort((a, b) => a.compareTo(b));

                    for (int i = 0; i < attractionsSelectedCopy.length; i++) {
                      valueMap['attractionsSelected']
                          .add(attractionsSelectedCopy[i].toString());
                      valueMap['typeAttractionsSelected'].add(
                          attractionsData![attractionsSelectedCopy[i]]
                                  ['category']
                              .join(", ")
                              .toString());
                      valueMap['picAttractionsSelected'].add(
                          attractionsData![attractionsSelectedCopy[i]]['pic']);
                    }

                    // FocusScope.of(context).unfocus();

                    selectedAttractions = valueMap;
                    devtools.log('============1233456===================');
                    devtools.log(selectedAttractions.toString());

                    List tempAttractionsAndCategory = [];
                    for (int i = 0; i < attractionsSelectedCopy.length; i++) {
                      tempAttractionsAndCategory.add([
                        attractionsSelectedCopy[i],
                        attractionsData![attractionsSelectedCopy[i]]['category']
                      ]);
                    }

                    Navigator.of(context).pushAndRemoveUntil(
                        FadePageRoute(Plan1(
                          attractions: selectedAttractions,
                          attractionsAndCategory: tempAttractionsAndCategory,
                          tourGuide: tourGuide,
                          numAdult: numAdult,
                          numChildren: numChildren,
                          planDate: planDate,
                          sedanCount: sedanCount,
                          sedanPrice: sedanPrice,
                          timeSelected: timeSelected,
                          vanCount: vanCount,
                          vanPrice: vanPrice,
                          yourTeamInfo: yourTeamInfo,
                          meetingPoint: meetingPoint,contactData: contactData,
                        )),
                        (Route<dynamic> route) => false);
                  },
                ),
                centerTitle: true,
                bottom: TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: primaryTextColor,
                  unselectedLabelColor: secondaryTextColor,
                  indicatorColor: primaryColor,

                  labelStyle: const TextStyle(
                    // color: tertiaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  // isScrollable: true,
                  tabs: const [
                    Tab(
                      text: 'Attractions',
                    ),
                    Tab(
                      text: 'Your Plan',
                    ),
                  ],
                ),
                backgroundColor: secondaryBackgroundColor,
                elevation: 0,
                title: Text(
                  "Select Attraction",
                  style: TextStyle(
                    color: tertiaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        filterBotton(size),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: location(size),
                        ),
                      ],
                    ),
                  ),
                  attractionsSelectedCopy.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 150, bottom: 250, right: 30, left: 30),
                          child: Container(
                              width: size.width * 0.8,
                              height: size.height * 0.1,
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
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 20, 30, 2),
                                      child: InkWell(
                                        onTap: () async {
                                          devtools.log("View attractions");
                                          tabController?.animateTo(0);
                                          // Navigator.of(context)
                                          //     .push(FadePageRoute(const ComingSoonPage()));
                                        },
                                        child: Container(
                                          height: size.height * 0.07,
                                          width: size.width * 0.9,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: tertiaryColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
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
                                                'View attractions',
                                                style: TextStyle(
                                                  color:
                                                      secondaryBackgroundColor,
                                                  fontSize: size.height * 0.023,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ])))
                      : SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        // color: Colors.amber,
                                        // color: Colors.red,
                                        border: Border.all(
                                            color: Colors.grey.withOpacity(0.5),
                                            width: size.width * 0.005),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                          // topRight: Radius.circular(20),
                                        ),
                                      ),
                                      height: size.height * 0.05,
                                      width: size.width * 0.4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              durationCount ==
                                                      const Duration(
                                                          hours: 0, minutes: 0)
                                                  ? 'Duration 0 hr'
                                                  : 'Duration ${durationCount.inHours}.${durationCount.inMinutes % 60} hr',
                                              // : 'Duration ${durationToString(durationCount.inMinutes)} hr',
                                              style: TextStyle(
                                                fontSize: size.width * 0.04,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              attractionsSelectedCopy = [];
                                              durationCount =
                                                  const Duration(minutes: 0);
                                            });
                                          },
                                          child: Text(
                                            'Clear',
                                            style: TextStyle(
                                              fontSize: size.width * 0.04,
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              // devtools.log((timeSelect?.inHours).toString());
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: timeSelect == null
                                      ? []
                                      : [
                                          Text(
                                            'You have ${timeSelect?.inHours} hour',
                                            style: TextStyle(
                                              fontSize: size.width * 0.04,
                                              color: tertiaryColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.01,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                showPopupDialog(
                                                    context,
                                                    "You have ${timeSelect?.inHours} hour.\nif you choose more attractions than your time. You probably won't be able to go to the attractions of your chose. But tour guide will help you to complete the plan as much as possible.",
                                                    'For your information', [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text("OK"))
                                                ]);
                                              },
                                              child: const Icon(Icons.info)),
                                        ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: yourPlan(size),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          );
        }

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
      },
    );
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
        width: size.width * 0.3,
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
                  'Filters \u2022 ${filters.length}',
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

  Widget location(Size size) {
    Map temp = {};
    String sugTime = '';
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: attractionsNameByFilters.length,
      itemBuilder: (context, index) {
        attractionsName.isEmpty
            ? temp = {}
            : temp =
                attractionsData![attractionsName[index]]['suggestedDuration'];
        sugTime = temp['minutes'].toString() == '0'
            ? temp['hours'].toString()
            : '${temp['hours']}.${temp['minutes']}';
        // devtools.log('${attractionsName[index]} $sugTime');

        return InkWell(
            onTap: () {
              setState(() {
                devtools.log(attractionsData![attractionsNameByFilters[index]]
                    .toString());
                devtools.log(attractionsNameByFilters[index].toString());

                String attractionName =
                    attractionsNameByFilters[index].toString();
                String pathPic =
                    attractionsData![attractionsNameByFilters[index]]['pic'];
                String category =
                    attractionsData![attractionsNameByFilters[index]]
                            ['category']
                        .join(", ")
                        .toString();
                String about = attractionsData![attractionsNameByFilters[index]]
                        ['about']
                    .toString();
                String suggestedDuration = sugTime;
                String address =
                    attractionsData![attractionsNameByFilters[index]]
                            ['location']
                        .toString();
                String urlGMap =
                    attractionsData![attractionsNameByFilters[index]]
                            ['location(googleMap)']
                        .toString();
                String openingTime =
                    attractionsData![attractionsNameByFilters[index]]
                            ['openingTime']
                        .toString();
                String closingTime =
                    attractionsData![attractionsNameByFilters[index]]
                            ['closingTime']
                        .toString();
                String urlWebsite =
                    attractionsData![attractionsNameByFilters[index]]
                            ['visitWebsite']
                        .toString();
                String ticketPrice =
                    attractionsData![attractionsNameByFilters[index]]
                            ['ticketPrice']
                        .toString();

                devtools.log(ticketPrice);

                devtools.log('======================================');

                Navigator.of(context).push(FadePageRoute(LocationInfo(
                  about: about,
                  address: address,
                  attractionName: attractionName,
                  category: category,
                  closingTime: closingTime,
                  openingTime: openingTime,
                  pathPic: pathPic,
                  suggestedDuration: suggestedDuration,
                  urlGMap: urlGMap,
                  urlWebsite: urlWebsite,
                  ticketPrice: ticketPrice,
                )));
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
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
                                       attractionsData![
                                        attractionsNameByFilters[index]]['pic'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                // Image.network(
                                //     attractionsData![
                                //         attractionsNameByFilters[index]]['pic'],
                                //     fit: BoxFit.fill,
                                //   )
                                  ),
                      ),
                      Expanded(
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
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    attractionsNameByFilters[index],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                        fontSize: size.width * 0.04),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    attractionsData![
                                                attractionsNameByFilters[index]]
                                            ['category']
                                        .join(", "),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    "suggestedDuration: $sugTime hr",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.005,
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
                              value: attractionsSelectedCopy
                                  .contains(attractionsNameByFilters[index]),
                              onChanged: (inputValue) {
                                setState(() {
                                  Map temp2 = attractionsData![
                                          attractionsNameByFilters[index]]
                                      ['suggestedDuration'];
                                  // String sugTime2 =
                                  //     '${temp2['hours']}.${temp2['minutes']}';
                                  // devtools.log(
                                  //     '${temp2['hours']}.${temp2['minutes']}');
                                  int hours =
                                      temp2['hours'].runtimeType == String
                                          ? int.parse(temp2['hours'])
                                          : temp2['hours'];
                                  int minutes =
                                      temp2['minutes'].runtimeType == String
                                          ? int.parse(temp2['minutes'])
                                          : temp2['minutes'];
                                  devtools.log('$hours : $minutes');
                                  Duration test =
                                      Duration(hours: hours, minutes: minutes);
                                  devtools.log('test $test');
                                  devtools.log('durationCount $durationCount');

                                  if (attractionsSelectedCopy.contains(
                                      attractionsNameByFilters[index])) {
                                    attractionsSelectedCopy.remove(
                                        attractionsNameByFilters[index]);
                                    devtools.log(
                                        'minus ${durationCount.inMinutes} - ${hours * 60} - $minutes');
                                    // durationCount = Duration(
                                    //     hours: durationCount.inHours - hours,
                                    //     minutes:
                                    //         durationCount.inHours - minutes);
                                    durationCount = Duration(
                                        minutes: durationCount.inMinutes -
                                            (hours * 60) -
                                            minutes);
                                    // durationCount - double.parse(sugTime2);
                                    devtools
                                        .log('durationCount $durationCount');
                                  } else {
                                    devtools.log(
                                        'add ${durationCount.inMinutes} + ${hours * 60} + $minutes');
                                    attractionsSelectedCopy.add(
                                        attractionsNameByFilters[index]
                                            .toString());
                                    durationCount = Duration(
                                        minutes: durationCount.inMinutes +
                                            (hours * 60) +
                                            minutes);

                                    // durationCount + double.parse(sugTime2);
                                    // devtools.log(
                                    //     '$sugTime2 = ${double.parse(sugTime2)}');
                                  }
                                  devtools.log('durationCount $durationCount');
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
                  const Divider(
                    color: Colors.grey,
                  )
                ],
              ),
            ));
      },
    );
  }

  Widget yourPlan(Size size) {
    Map temp = {};
    String sugTime = '';
    // attractionsSelected.sort((a, b) => a.compareTo(b));
    // for (int i = 0; i < attractionsSelected.length; i++) {
    //   Map tempMap =
    //       attractionsData![attractionsSelected[i]]['suggestedDuration'];
    //   String tempString = tempMap['minutes'].toString() == '0'
    //       ? tempMap['hours'].toString()
    //       : '${tempMap['hours']}.${tempMap['minutes']}';
    //   durationCount = durationCount + double.parse(tempString);
    //   devtools
    //       .log('durationCount = durationCount + ${double.parse(tempString)};');
    // }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: attractionsSelectedCopy.length,
      itemBuilder: (context, index) {
        temp = attractionsData![attractionsSelectedCopy[index]]
            ['suggestedDuration'];
        sugTime = temp['minutes'].toString() == '0'
            ? temp['hours'].toString()
            : '${temp['hours']}.${temp['minutes']}';
        devtools.log('$attractionsSelectedCopy');

        return InkWell(
            onTap: () {
              devtools.log(
                  attractionsData![attractionsSelectedCopy[index]].toString());
              temp = attractionsData![attractionsSelectedCopy[index]]
                  ['suggestedDuration'];
              devtools.log(temp['hours'].toString());
              devtools.log(temp['minutes'].toString());
              setState(() {
                devtools.log(attractionsData![attractionsSelectedCopy[index]]
                    .toString());
                devtools.log(attractionsSelectedCopy[index].toString());

                String attractionName =
                    attractionsSelectedCopy[index].toString();
                String pathPic =
                    attractionsData![attractionsSelectedCopy[index]]['pic'];
                String category =
                    attractionsData![attractionsSelectedCopy[index]]['category']
                        .join(", ")
                        .toString();
                String about = attractionsData![attractionsSelectedCopy[index]]
                        ['about']
                    .toString();
                String suggestedDuration = sugTime;
                String address =
                    attractionsData![attractionsSelectedCopy[index]]['location']
                        .toString();
                String urlGMap =
                    attractionsData![attractionsSelectedCopy[index]]
                            ['location(googleMap)']
                        .toString();
                String openingTime =
                    attractionsData![attractionsSelectedCopy[index]]
                            ['openingTime']
                        .toString();
                String closingTime =
                    attractionsData![attractionsSelectedCopy[index]]
                            ['closingTime']
                        .toString();
                String urlWebsite =
                    attractionsData![attractionsSelectedCopy[index]]
                            ['visitWebsite']
                        .toString();
                String ticketPrice =
                    attractionsData![attractionsSelectedCopy[index]]
                            ['ticketPrice']
                        .toString();

                devtools.log(
                    '$attractionName\n$pathPic\n$category\n$about\n$suggestedDuration\n$address\n$urlGMap\n$openingTime\n$closingTime\n$urlWebsite');

                devtools.log('======================================');

                Navigator.of(context).push(FadePageRoute(LocationInfo(
                  about: about,
                  address: address,
                  attractionName: attractionName,
                  category: category,
                  closingTime: closingTime,
                  openingTime: openingTime,
                  pathPic: pathPic,
                  suggestedDuration: suggestedDuration,
                  urlGMap: urlGMap,
                  urlWebsite: urlWebsite,
                  ticketPrice: ticketPrice,
                )));
              });
              devtools.log(
                  'attractionsSelected.contains(${attractionsSelectedCopy[index]}) = ${attractionsSelectedCopy.contains(attractionsName[index])}');
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
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
                                       attractionsData![
                                        attractionsSelectedCopy[index]]['pic'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                // Image.network(
                                //     attractionsData![
                                //         attractionsSelectedCopy[index]]['pic'],
                                //     fit: BoxFit.fill,
                                //   )
                                  ),
                      ),
                      Expanded(
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
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    attractionsSelectedCopy[index],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                        fontSize: size.width * 0.04),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    attractionsData![
                                                attractionsSelectedCopy[index]]
                                            ['category']
                                        .join(", "),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    "suggestedDuration: $sugTime hr",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
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
                              value: attractionsSelectedCopy
                                  .contains(attractionsSelectedCopy[index]),
                              onChanged: (inputValue) {
                                setState(() {
                                  Map temp2 = attractionsData![
                                          attractionsSelectedCopy[index]]
                                      ['suggestedDuration'];
                                  // String sugTime2 =
                                  //     '${temp2['hours']}.${temp2['minutes']}';
                                  // devtools.log(
                                  //     '${temp2['hours']}.${temp2['minutes']}');
                                  int hours = temp2['hours'];
                                  int minutes = temp2['minutes'];
                                  devtools
                                      .log('${attractionsSelectedCopy[index]}');
                                  attractionsSelectedCopy
                                      .remove(attractionsSelectedCopy[index]);
                                  // // durationCount = Duration(
                                  // //     hours: durationCount.inHours - hours,
                                  // //     minutes: durationCount.inHours - minutes);
                                  // // durationCount = ((hours*60)+minutes);
                                  // durationCount = Duration(
                                  //     hours: durationCount.inHours - hours,
                                  //     minutes:
                                  //         durationCount.inMinutes - minutes);
                                  // devtools
                                  //     .log(attractionsSelectedCopy.toString());
                                  devtools.log(
                                      'minus ${durationCount.inMinutes} - ${hours * 60} - $minutes');
                                  // durationCount = Duration(
                                  //     hours: durationCount.inHours - hours,
                                  //     minutes:
                                  //         durationCount.inHours - minutes);
                                  durationCount = Duration(
                                      minutes: durationCount.inMinutes -
                                          (hours * 60) -
                                          minutes);
                                  // durationCount - double.parse(sugTime2);
                                  devtools.log('durationCount $durationCount');
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: size.height * 0.15,
                      //   child: Center(
                      //     child: GFCheckbox(
                      //       activeIcon: Icon(Icons.check,
                      //           size: 20, color: tertiaryColor),
                      //       size: GFSize.SMALL,
                      //       activeBgColor: primaryColor,
                      //       type: GFCheckboxType.circle,
                      //       onChanged: (value) {
                      // setState(() {
                      //   attractionsSelected
                      //       .remove(attractionsName[index]);
                      //   devtools.log(attractionsSelected.toString());
                      // });
                      //       },
                      //       value: attractionsSelected
                      //           .contains(attractionsName[index]),
                      //       inactiveIcon: null,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        width: size.width * 0.01,
                      )
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                  )
                ],
              ),
            ));
      },
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
              content: SizedBox(
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
                            source: attractionsType,
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
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, right: 10, left: 10, bottom: 20),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              filters = [];
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
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            devtools.log(filters.toString());
                            // Navigator.pop(context, true);

                            Navigator.of(context).pushAndRemoveUntil(
                                FadePageRoute(SelectLocation(
                                  attractionsSelected: attractionsSelectedCopy,
                                  selectedAttractions: selectedAttractions,
                                  getFilter: filters,
                                  tourGuide: tourGuide,
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

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }
  // List<String> newDataList = List.from(mainDataList);
  // List<String> newDataList = [];
  // void filterSearchResults(String query,List list) {
  //   setState(() {
  //     newDataList = list
  //         .where((string) => string.toLowerCase().contains(query.toLowerCase()))
  //         .toList();

  //     debugPrint("Checking Fruit Name ${newDataList.toString()}");
  //     isLoading = false;
  //   });
  // }

  // onSelectedValue(int index) {
  //   setState(() {
  //     print("Slected dialog value is....${newDataList[index]}");
  //     Navigator.pop(context, newDataList[index]);
  //     txt = newDataList[index];
  //   });
  // }
}
