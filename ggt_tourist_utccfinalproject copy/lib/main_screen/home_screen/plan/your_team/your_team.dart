import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/plan/plan_1.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/plan/your_team/component/add_adult_info.dart';
import 'package:ggt_tourist_utccfinalproject/widget/circle_button.dart';
import 'dart:developer' as devtools show log;
// import '../../../constant.dart';
import '../../../../utillties/custom_page_route.dart';
import '../../../../widget/animated_toggle_switch/src/widgets/animated_toggle_switch.dart';
import 'component/add_child_info.dart';
import 'component/personnal_info.dart';

// ignore: must_be_immutable
class YourTeam extends StatefulWidget {
  // const YourTeam({super.key});
  YourTeam({
    super.key,
    required this.attractions,
    required this.attractionsAndCategory,
    required this.durationCount,
    required this.tourGuide,
    required this.timeSelected,
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
  Map attractions;
  List attractionsAndCategory;
  Duration durationCount;
  Map tourGuide;

  DateTime planDate;
  String? timeSelected;

  int numAdult;
  int numChildren;

  int sedanPrice;
  int sedanCount;
  int vanPrice;
  int vanCount;

  Map yourTeamInfo;
  Map meetingPoint;
  Map contactData;

  @override
  // ignore: no_logic_in_create_state
  State<YourTeam> createState() => _YourTeamState(
        attractions: attractions,
        attractionsAndCategory: attractionsAndCategory,
        numAdult: numAdult,
        numChildren: numChildren,
        planDate: planDate,
        sedanCount: sedanCount,
        sedanPrice: sedanPrice,
        timeSelected: timeSelected,
        tourGuide: tourGuide,
        vanCount: vanCount,
        vanPrice: vanPrice,
        yourTeamInfo: yourTeamInfo,
        durationCount: durationCount,
        meetingPoint: meetingPoint,
        contactData: contactData,
      );
}

class _YourTeamState extends State<YourTeam>
    with SingleTickerProviderStateMixin {
  _YourTeamState({
    required this.attractions,
    required this.attractionsAndCategory,
    required this.durationCount,
    required this.tourGuide,
    required this.timeSelected,
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
  Map attractions;
  List attractionsAndCategory;
  Duration durationCount;
  Map tourGuide;

  DateTime planDate;
  String? timeSelected;

  int numAdult;
  int numChildren;

  int sedanPrice;
  int sedanCount;
  int vanPrice;
  int vanCount;

  Map yourTeamInfo;
  Map meetingPoint;
  Map contactData;

  TabController? tabController;

  List adultsInfo = [];
  List childrenInfo = [];

  int value = 0;
  bool positive = false;

  @override
  void initState() {
    devtools.log('yourTeamInfo : $yourTeamInfo');
    if (yourTeamInfo.isEmpty) {
      adultsInfo = [];
      childrenInfo = [];
      devtools.log('yourTeamInfo.isEmpty');
    } else {
      if (yourTeamInfo['adultsInfo'].isEmpty) {
        adultsInfo = [];
      } else {
        adultsInfo = yourTeamInfo['adultsInfo'];
        if (adultsInfo[0].length > 0) {
          if (adultsInfo[0][0] == 'me') {
            positive = true;
          }
        }
      }
      if (yourTeamInfo['childrenInfo'].isEmpty) {
        childrenInfo = [];
      } else {
        childrenInfo = yourTeamInfo['childrenInfo'];
      }
    }

    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  bool isFirebaseBug = false;

  @override
  Widget build(BuildContext context) {
    Map teamInfo = yourTeamInfo;
    // if (numAdult > 0) {
    //   devtools.log('$yourTeamInfo');
    // } else {
    //   adultsInfo = yourTeamInfo[adultsInfo];
    //   childrenInfo = yourTeamInfo[childrenInfo];
    // }

    // if (teamInfo.isEmpty) {
    //   adultsInfo = [];
    //   childrenInfo = [];
    // } else {
    //   adultsInfo = yourTeamInfo[adultsInfo];
    //   childrenInfo = yourTeamInfo[childrenInfo];
    // }

    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     teamInfo = {
            //       'adultsInfo': adultsInfo,
            //       'childrenInfo': childrenInfo,
            //     };
            //     devtools.log(teamInfo.toString());
            //   },
            // ),
            backgroundColor: secondaryBackgroundColor,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: secondaryBackgroundColor,
              elevation: 0,
              title: Text(
                "Your Information",
                style: TextStyle(
                  color: tertiaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: primaryTextColor),
                  onPressed: () {
                    // FocusScope.of(context).unfocus();

                    teamInfo = {
                      'adultsInfo': adultsInfo,
                      'childrenInfo': childrenInfo,
                    };

                    Navigator.of(context).pushAndRemoveUntil(
                        FadePageRoute(Plan1(
                          attractions: attractions,
                          attractionsAndCategory: attractionsAndCategory,
                          numAdult: numAdult,
                          numChildren: numChildren,
                          planDate: planDate,
                          sedanCount: sedanCount,
                          sedanPrice: sedanPrice,
                          timeSelected: timeSelected,
                          tourGuide: tourGuide,
                          vanCount: vanCount,
                          vanPrice: vanPrice,
                          yourTeamInfo: teamInfo,
                          meetingPoint: meetingPoint,
                          contactData: contactData,
                        )),
                        (Route<dynamic> route) => false);
                  }),
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
                    text: 'Adults',
                  ),
                  Tab(
                    text: 'Children',
                  ),
                ],
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
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 30, left: 30, top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Do you go with us?',
                                style: TextStyle(fontSize: size.height * 0.022),
                              ),
                              AnimatedToggleSwitch<bool>.dual(
                                current: positive,
                                first: false,
                                second: true,
                                dif: 10,
                                borderColor: Colors.transparent,
                                borderWidth: 5.0,
                                height: size.height * 0.04,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 1.5),
                                  ),
                                ],
                                // onChanged: (b) => setState(() => positive = b),
                                onChanged: (b) {
                                  setState(() {
                                    positive = b;
                                    if (positive) {
                                      numAdult++;
                                      adultsInfo.insert(0, []);
                                      adultsInfo[0].add('me');
                                    } else {
                                      adultsInfo.remove(adultsInfo[0]);
                                      numAdult--;
                                    }
                                  });
                                },
                                colorBuilder: (b) =>
                                    !b ? Colors.red : primaryColor,
                                iconBuilder: (value) => !value
                                    ? const Icon(Icons.no_backpack)
                                    : const Icon(Icons.tag_faces_rounded),
                                textBuilder: (value) => !value
                                    ? const Center(child: Text('No...'))
                                    : const Center(child: Text('Yes :)')),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: size.width * 0.3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        devtools.log('tap -adults');

                                        setState(() {
                                          if (numAdult != 0) {
                                            adultsInfo.remove(adultsInfo[
                                                adultsInfo.length - 1]);
                                            numAdult--;
                                          }
                                          if (numAdult == 0) {
                                            positive = false;
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: size.height * 0.04,
                                        width: size.width * 0.09,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          // border:
                                          //     Border.all(color: tertiaryColor.withOpacity(0.2)),
                                          color: numAdult == 0
                                              ? secondaryTextColor
                                              : primaryColor,
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: tertiaryColor,
                                        ),
                                      ),
                                    ),
                                    Text(numAdult.toString()),
                                    InkWell(
                                      onTap: () {
                                        devtools.log('tap +adults');

                                        if (numChildren + numAdult < 15) {
                                          setState(() {
                                            adultsInfo.add([]);
                                            numAdult++;
                                          });
                                        }
                                        devtools.log('$adultsInfo');
                                      },
                                      child: Container(
                                        height: size.height * 0.04,
                                        width: size.width * 0.09,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          // border:
                                          //     Border.all(color: tertiaryColor.withOpacity(0.2)),
                                          color: numChildren + numAdult >= 15
                                              ? secondaryTextColor
                                              : primaryColor,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: tertiaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: adultsInfo.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        color: primaryBackgroundColor,
                                        border: Border.all(
                                            color:
                                                tertiaryColor.withOpacity(0.2)),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 10),
                                        child: adultsInfo[index].isEmpty
                                            ? InkWell(
                                                onTap: () {
                                                  devtools.log('Tap Add Info');
                                                  teamInfo = {
                                                    'adultsInfo': adultsInfo,
                                                    'childrenInfo':
                                                        childrenInfo,
                                                  };
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          FadePageRoute(
                                                              AddAdultInfo(
                                                            attractions:
                                                                attractions,
                                                            attractionsAndCategory:
                                                                attractionsAndCategory,
                                                            numAdult: numAdult,
                                                            numChildren:
                                                                numChildren,
                                                            planDate: planDate,
                                                            sedanCount:
                                                                sedanCount,
                                                            sedanPrice:
                                                                sedanPrice,
                                                            timeSelected:
                                                                timeSelected,
                                                            tourGuide:
                                                                tourGuide,
                                                            vanCount: vanCount,
                                                            vanPrice: vanPrice,
                                                            yourTeamInfo:
                                                                teamInfo,
                                                            thisInfo:
                                                                adultsInfo[
                                                                    index],
                                                            index: index,
                                                            durationCount:
                                                                durationCount,
                                                            meetingPoint:
                                                                meetingPoint,
                                                            contactData:
                                                                contactData,
                                                          )),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add,
                                                      size: size.height * 0.1,
                                                    ),
                                                    Text(
                                                      'Add Infomation',
                                                      style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.03),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : adultsInfo[index][0] == 'me'
                                                ? InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(FadePageRoute(
                                                              PersonnalInfo(
                                                        attractions:
                                                            attractions,
                                                        attractionsAndCategory:
                                                            attractionsAndCategory,
                                                        numAdult: numAdult,
                                                        numChildren:
                                                            numChildren,
                                                        planDate: planDate,
                                                        sedanCount: sedanCount,
                                                        sedanPrice: sedanPrice,
                                                        timeSelected:
                                                            timeSelected,
                                                        tourGuide: tourGuide,
                                                        vanCount: vanCount,
                                                        vanPrice: vanPrice,
                                                        yourTeamInfo:
                                                            yourTeamInfo,
                                                        durationCount:
                                                            durationCount,
                                                        meetingPoint:
                                                            meetingPoint,
                                                        contactData:
                                                            contactData,
                                                      )));
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 100),
                                                          child: Text(
                                                            'Yourself',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    size.height *
                                                                        0.03),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5),
                                                          child: CircleButton(
                                                              onTap: () {
                                                                devtools.log(
                                                                    "Cool");
                                                                setState(() {
                                                                  adultsInfo.remove(
                                                                      adultsInfo[
                                                                          index]);
                                                                  positive =
                                                                      false;
                                                                  numAdult--;
                                                                });
                                                              },
                                                              iconData:
                                                                  Icons.delete),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      teamInfo = {
                                                        'adultsInfo':
                                                            adultsInfo,
                                                        'childrenInfo':
                                                            childrenInfo,
                                                      };
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                              FadePageRoute(
                                                                  AddAdultInfo(
                                                                attractions:
                                                                    attractions,
                                                                attractionsAndCategory:
                                                                    attractionsAndCategory,
                                                                numAdult:
                                                                    numAdult,
                                                                numChildren:
                                                                    numChildren,
                                                                planDate:
                                                                    planDate,
                                                                sedanCount:
                                                                    sedanCount,
                                                                sedanPrice:
                                                                    sedanPrice,
                                                                timeSelected:
                                                                    timeSelected,
                                                                tourGuide:
                                                                    tourGuide,
                                                                vanCount:
                                                                    vanCount,
                                                                vanPrice:
                                                                    vanPrice,
                                                                yourTeamInfo:
                                                                    teamInfo,
                                                                thisInfo:
                                                                    adultsInfo[
                                                                        index],
                                                                index: index,
                                                                durationCount:
                                                                    durationCount,
                                                                meetingPoint:
                                                                    meetingPoint,
                                                                contactData:
                                                                    contactData,
                                                              )),
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                                radius:
                                                                    size.height *
                                                                        0.04,
                                                                backgroundColor: index ==
                                                                        0
                                                                    ? const Color
                                                                            .fromARGB(
                                                                        37,
                                                                        76,
                                                                        175,
                                                                        79)
                                                                    : Colors.green[
                                                                        (index *
                                                                            100)],
                                                                child: Text(
                                                                  (index + 1)
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          size.width *
                                                                              0.1,
                                                                      color:
                                                                          primaryTextColor),
                                                                )
                                                                // Icon(
                                                                //   Icons
                                                                //       .account_circle,
                                                                //   color:
                                                                //       tertiaryColor,
                                                                //   size: size.width *
                                                                //       0.2,
                                                                // ),
                                                                ),
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.02,
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  adultsInfo[index][0]
                                                                              .length <=
                                                                          10
                                                                      ? 'Name : ${adultsInfo[index][0]}'
                                                                      : 'Name : ${adultsInfo[index][0].substring(0, 10)}...',
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          size.height *
                                                                              0.022),
                                                                ),
                                                                Text(
                                                                  adultsInfo[index][1]
                                                                              .length <=
                                                                          7
                                                                      ? 'Sername : ${adultsInfo[index][1]}'
                                                                      : 'Sername : ${adultsInfo[index][1].substring(0, 7)}...',
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          size.height *
                                                                              0.022),
                                                                ),
                                                                Text(
                                                                  adultsInfo[index]
                                                                              [
                                                                              2] !=
                                                                          ''
                                                                      ? adultsInfo[index][2].length <=
                                                                              11
                                                                          ? 'ID : ${adultsInfo[index][2]}'
                                                                          : 'ID : ${adultsInfo[index][2].substring(0, 11)}...'
                                                                      : adultsInfo[index][3].length <=
                                                                              11
                                                                          ? 'ID : ${adultsInfo[index][3]}'
                                                                          : 'ID : ${adultsInfo[index][3].substring(0, 11)}...',
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          size.height *
                                                                              0.022),
                                                                ),
                                                                Text(
                                                                  adultsInfo[index][4]
                                                                              .length <=
                                                                          8
                                                                      ? 'Country : ${adultsInfo[index][4]}'
                                                                      : 'Country : ${adultsInfo[index][4].substring(0, 8)}...',
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          size.height *
                                                                              0.022),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          child: CircleButton(
                                                              onTap: () {
                                                                devtools.log(
                                                                    "Cool");
                                                                setState(() {
                                                                  adultsInfo.remove(
                                                                      adultsInfo[
                                                                          index]);

                                                                  numAdult--;
                                                                });
                                                              },
                                                              iconData:
                                                                  Icons.delete),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                      )),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            devtools.log('tap -Children');
                                            setState(() {
                                              if (numChildren != 0) {
                                                numChildren--;
                                                childrenInfo.remove(
                                                    childrenInfo[
                                                        childrenInfo.length -
                                                            1]);
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: size.height * 0.04,
                                            width: size.width * 0.09,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // border:
                                              //     Border.all(color: tertiaryColor.withOpacity(0.2)),
                                              color: numChildren == 0
                                                  ? secondaryTextColor
                                                  : primaryColor,
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              color: tertiaryColor,
                                            ),
                                          ),
                                        ),
                                        Text(numChildren.toString()),
                                        InkWell(
                                          onTap: () {
                                            devtools.log('tap +Children');
                                            setState(() {
                                              if (numChildren + numAdult < 15) {
                                                numChildren++;
                                                childrenInfo.add([]);
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: size.height * 0.04,
                                            width: size.width * 0.09,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // border:
                                              //     Border.all(color: tertiaryColor.withOpacity(0.2)),
                                              color:
                                                  numChildren + numAdult >= 15
                                                      ? secondaryTextColor
                                                      : primaryColor,
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: tertiaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: childrenInfo.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            color: primaryBackgroundColor,
                                            border: Border.all(
                                                color: tertiaryColor
                                                    .withOpacity(0.2)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 10),
                                            child: childrenInfo[index].isEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      devtools
                                                          .log('Tap Add Info');
                                                      teamInfo = {
                                                        'adultsInfo':
                                                            adultsInfo,
                                                        'childrenInfo':
                                                            childrenInfo,
                                                      };
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                              FadePageRoute(
                                                                  AddChildrenInfo(
                                                                attractions:
                                                                    attractions,
                                                                attractionsAndCategory:
                                                                    attractionsAndCategory,
                                                                numAdult:
                                                                    numAdult,
                                                                numChildren:
                                                                    numChildren,
                                                                planDate:
                                                                    planDate,
                                                                sedanCount:
                                                                    sedanCount,
                                                                sedanPrice:
                                                                    sedanPrice,
                                                                timeSelected:
                                                                    timeSelected,
                                                                tourGuide:
                                                                    tourGuide,
                                                                vanCount:
                                                                    vanCount,
                                                                vanPrice:
                                                                    vanPrice,
                                                                yourTeamInfo:
                                                                    teamInfo,
                                                                thisInfo:
                                                                    childrenInfo[
                                                                        index],
                                                                index: index,
                                                                durationCount:
                                                                    durationCount,
                                                                meetingPoint:
                                                                    meetingPoint,
                                                                contactData:
                                                                    contactData,
                                                              )),
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.add,
                                                          size:
                                                              size.height * 0.1,
                                                        ),
                                                        Text(
                                                          'Add Infomation',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.03),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      teamInfo = {
                                                        'adultsInfo':
                                                            adultsInfo,
                                                        'childrenInfo':
                                                            childrenInfo,
                                                      };
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                              FadePageRoute(
                                                                  AddChildrenInfo(
                                                                attractions:
                                                                    attractions,
                                                                attractionsAndCategory:
                                                                    attractionsAndCategory,
                                                                numAdult:
                                                                    numAdult,
                                                                numChildren:
                                                                    numChildren,
                                                                planDate:
                                                                    planDate,
                                                                sedanCount:
                                                                    sedanCount,
                                                                sedanPrice:
                                                                    sedanPrice,
                                                                timeSelected:
                                                                    timeSelected,
                                                                tourGuide:
                                                                    tourGuide,
                                                                vanCount:
                                                                    vanCount,
                                                                vanPrice:
                                                                    vanPrice,
                                                                yourTeamInfo:
                                                                    teamInfo,
                                                                thisInfo:
                                                                    childrenInfo[
                                                                        index],
                                                                index: index,
                                                                durationCount:
                                                                    durationCount,
                                                                meetingPoint:
                                                                    meetingPoint,
                                                                contactData:
                                                                    contactData,
                                                              )),
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                                radius:
                                                                    size.height *
                                                                        0.04,
                                                                backgroundColor: index ==
                                                                        0
                                                                    ? Color.fromARGB(36, 76, 175, 79)
                                                                    : Colors.green[
                                                                        (index *
                                                                            100)],
                                                                child: Text(
                                                                  (index + 1)
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          size.width *
                                                                              0.1,
                                                                      color:
                                                                          primaryTextColor),
                                                                )),
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.03,
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  childrenInfo[index][0]
                                                                              .length <=
                                                                          10
                                                                      ? 'Name : ${childrenInfo[index][0]}'
                                                                      : 'Name : ${childrenInfo[index][0].substring(0, 10)}...',
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          size.height *
                                                                              0.022),
                                                                ),
                                                                Text(
                                                                  childrenInfo[index][1]
                                                                              .length <=
                                                                          7
                                                                      ? 'Sername : ${childrenInfo[index][1]}'
                                                                      : 'Sername : ${childrenInfo[index][1].substring(0, 7)}...',
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          size.height *
                                                                              0.022),
                                                                ),
                                                                Text(
                                                                  childrenInfo[index]
                                                                              [
                                                                              2] !=
                                                                          ''
                                                                      ? childrenInfo[index][2].length <=
                                                                              12
                                                                          ? 'ID : ${childrenInfo[index][2]}'
                                                                          : 'ID : ${childrenInfo[index][2].substring(0, 12)}...'
                                                                      : childrenInfo[index][3].length <=
                                                                              12
                                                                          ? 'ID : ${childrenInfo[index][3]}'
                                                                          : 'ID : ${childrenInfo[index][3].substring(0, 12)}...',
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          size.height *
                                                                              0.022),
                                                                ),
                                                                Text(
                                                                  childrenInfo[index][4]
                                                                              .length <=
                                                                          9
                                                                      ? 'Country : ${childrenInfo[index][4]}'
                                                                      : 'Country : ${childrenInfo[index][4].substring(0, 9)}...',
                                                                  style: TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          size.height *
                                                                              0.022),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          child: CircleButton(
                                                              onTap: () {
                                                                devtools.log(
                                                                    "Cool");
                                                                setState(() {
                                                                  childrenInfo.remove(
                                                                      childrenInfo[
                                                                          index]);

                                                                  numChildren--;
                                                                });
                                                              },
                                                              iconData:
                                                                  Icons.delete),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          )),
                                    );
                                  }),
                            )
                          ])),
                ])));
  }
}
