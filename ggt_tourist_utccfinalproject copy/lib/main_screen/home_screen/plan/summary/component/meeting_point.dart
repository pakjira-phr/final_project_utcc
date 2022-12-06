import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/home_screen/plan/summary/summary.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/custom_page_route.dart';
import 'dart:developer' as devtools show log;

// ignore: must_be_immutable
class MeetingPoint extends StatefulWidget {
  // const MeetingPoint({super.key});
  MeetingPoint({
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
    required this.contactData,
    required this.meetingPoint,
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
  Map contactData;
  Map meetingPoint;

  @override
  // ignore: no_logic_in_create_state
  State<MeetingPoint> createState() => _MeetingPointState(
      attractions: attractions,
      attractionsAndCategory: attractionsAndCategory,
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
      durationCount: durationCount,
      contactData: contactData,
      meetingPoint: meetingPoint);
}

class _MeetingPointState extends State<MeetingPoint> {
  _MeetingPointState({
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
    required this.contactData,
    required this.meetingPoint,
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
  Map contactData;
  Map meetingPoint;
  bool isFirebaseBug = false;
  List tempList = [];
  Map meetingPointTemp = {};
  @override
  void initState() {
    if (meetingPoint.isNotEmpty) {
      tempList.add(meetingPoint['name']);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: secondaryBackgroundColor,
      appBar: AppBar(
        toolbarHeight: size.height * 0.06,
        backgroundColor: secondaryBackgroundColor,
        // title: Text(
        //   'Meeting Point',
        //   style: TextStyle(color: primaryTextColor),
        // ),
        // centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor),
          onPressed: () {
            // FocusScope.of(context).unfocus();
            // Navigator.of(context).pop();
            Navigator.of(context).pushAndRemoveUntil(
                FadePageRoute(Summary(
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
                  contactData: contactData,
                  meetingPoint: meetingPoint,
                )),
                (Route<dynamic> route) => false);
          },
        ),
        elevation: 0,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     devtools.log(meetingPoint.toString());
      //   },
      // ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 20, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Meeting Point",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: 30),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Please select the attraction you want to meet your tour guide",
                          style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: deactivatedText,
                              fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: attractions['attractionsSelected'].length,
                  itemBuilder: (context, index) {
                    return Padding(
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
                                    width: size.width * 0.3,
                                    height: size.height * 0.14,
                                    child: isFirebaseBug
                                        ? const Icon(Icons.developer_board)
                                        : CachedNetworkImage(
                                                imageUrl:
                                                    attractions[
                                                    'picAttractionsSelected']
                                                [index],
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                        // Image.network(
                                        //     attractions[
                                        //             'picAttractionsSelected']
                                        //         [index],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Text(
                                            attractions['attractionsSelected']
                                                [index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: primaryTextColor,
                                                fontSize: size.width * 0.04),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0),
                                          child: Text(
                                            attractionsAndCategory[index][1]
                                                .join(", "),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      value: tempList.contains(
                                          attractions['attractionsSelected']
                                              [index]),
                                      onChanged: (inputValue) {
                                        setState(() {
                                          devtools.log(
                                              'attractionsName ${attractions['attractionsSelected'][index]}');
                                          //ยังพังอยู่
                                          if (tempList.contains(
                                              attractions['attractionsSelected']
                                                  [index])) {
                                            tempList = [];
                                          } else {
                                            tempList = [];
                                            tempList.add(attractions[
                                                'attractionsSelected'][index]);
                                            meetingPointTemp = {
                                              'pic':
                                                  '${attractions['picAttractionsSelected'][index]}',
                                              'name':
                                                  '${attractions['attractionsSelected'][index]}',
                                              'type':
                                                  '${attractionsAndCategory[index][1].join(", ")}',
                                            };
                                          }
                                          // Map temp2 = attractionsData![
                                          //         attractionsSelectedCopy[
                                          //             index]]
                                          //     ['suggestedDuration'];
                                          // int hours = temp2['hours'];
                                          // int minutes = temp2['minutes'];
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
                    );
                  },
                )),
            Padding(
              padding: const EdgeInsets.only(top: 25.0, left: 20, right: 20),
              child: InkWell(
                onTap: () async {
                  Navigator.of(context).pushAndRemoveUntil(
                      FadePageRoute(Summary(
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
                        contactData: contactData,
                        meetingPoint: meetingPointTemp,
                      )),
                      (Route<dynamic> route) => false);
                },
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8 + 32 * (1)),
                    color: primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Confirm',
                          style: TextStyle(
                            color: tertiaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // devtools.log((timeSelect?.inHours).toString());
          ],
        ),
      ),
    );
  }
}
