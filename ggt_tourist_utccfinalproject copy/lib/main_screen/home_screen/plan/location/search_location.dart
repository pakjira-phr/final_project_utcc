import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';

import 'dart:developer' as devtools show log;

import '../../../../utillties/custom_page_route.dart';
import 'location_info.dart';
import 'select_location.dart';

// ignore: must_be_immutable
class SearchLocation extends StatefulWidget {
  SearchLocation({
    super.key,
    required this.attractionsSelected,
    required this.attractionsData,
    required this.attractionsName,
    required this.durationCount,
    required this.selectedAttractions,
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
  List attractionsSelected;
  Map attractionsData;
  List attractionsName;
  Duration durationCount;
  Map selectedAttractions;
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
  State<SearchLocation> createState() => _SearchLocationState(
      attractionsData: attractionsData,
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
      yourTeamInfo: yourTeamInfo,
      meetingPoint: meetingPoint,contactData: contactData,);
}

class _SearchLocationState extends State<SearchLocation> {
  _SearchLocationState({
    required this.attractionsSelected,
    required this.attractionsData,
    required this.attractionsName,
    required this.durationCount,
    required this.selectedAttractions,
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
  Map attractionsData;
  List attractionsName;
  Duration durationCount;
  Map selectedAttractions;
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

  List data = [];

  TextEditingController? textController;

  static List mainDataList = [];
  List<String> newDataList = [];
  bool isFirebaseBug = false;
  @override
  initState() {
    attractionsSelectedCopy = attractionsSelected.toList();
    textController = TextEditingController();
    data = attractionsName;
    mainDataList = data;
    mainDataList = mainDataList
      ..sort((a, b) => a.toString().compareTo(b.toString()));
    newDataList = List.from(mainDataList);
    super.initState();
    devtools.log("in initState");
    devtools.log(newDataList.toString());
  }

  onItemChanged(String value) {
    setState(() {
      newDataList = mainDataList
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList()
          .cast<String>();
    });
  }

  bool menuShow = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // setStart();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Search Attraction",
          style: TextStyle(color: Colors.black),
        ),

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor),
          onPressed: () {
            attractionsSelected = attractionsSelectedCopy;
            // FocusScope.of(context).unfocus();
            Navigator.of(context).pushAndRemoveUntil(
                FadePageRoute(SelectLocation(
                    attractionsSelected: attractionsSelected,
                    selectedAttractions: selectedAttractions,
                    getFilter: const [],
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
                    meetingPoint: meetingPoint,contactData: contactData,)),
                (Route<dynamic> route) => false);
          },
        ),
        backgroundColor: secondaryBackgroundColor,
        elevation: 0, //ทำให้ไม่มีเงาด้านล่าง appbar
      ),
      body: Column(
        children: <Widget>[
          // Text(mainDataList.toString()),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: TextField(
              controller: textController,
              // readOnly: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: tertiaryColor,
                ),
                // labelText: "e.g., Headache",
                hintText: "Search . . .",
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(
                    color: tertiaryColor.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
              onTap: () {
                setState(() {
                  menuShow = !menuShow;
                  if (menuShow == true) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    textController?.clear();
                  }
                });
              },
              onChanged: onItemChanged,
            ),
          ),
          showMenu(size),
        ],
      ),
    );
  }

  Widget showMenu(Size size) {
    // devtools.log("data in showMenu\n$data");
    // devtools.log("newDataList in showMenu\n$newDataList");
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(12.0),
        children: newDataList.map((data) {
          return
              // location(size);

              ListTile(
            // title: Text(data),
            title: location(size, data),
            onTap: () {
              devtools.log(data);
              attractionsSelectedCopy.add(data);
              // int count = 0;
              // Navigator.of(context).popUntil((_) => count++ >= 2);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget location(Size size, String data) {
    Map temp = {};
    String sugTime = '';
    attractionsName.isEmpty
        ? temp = {}
        : temp = attractionsData[data]['suggestedDuration'];
    sugTime = temp['minutes'].toString() == '0'
        ? temp['hours'].toString()
        : '${temp['hours']}:${temp['minutes']}';
    return
        // ListView.builder(
        //   physics: const NeverScrollableScrollPhysics(),
        //   shrinkWrap: true,
        //   itemCount: attractionsName.length,
        //   itemBuilder: (context, index) {

        //     // devtools.log('${attractionsName[index]} $sugTime');

        //     return
        InkWell(
            onTap: () {
              String attractionName = data;
              String pathPic = attractionsData[data]['pic'].toString();
              String category =
                  attractionsData[data]['category'].join(", ").toString();
              String about = attractionsData[data]['about'].toString();
              String suggestedDuration = sugTime;
              String address = attractionsData[data]['location'].toString();
              String urlGMap =
                  attractionsData[data]['location(googleMap)'].toString();
              String openingTime =
                  attractionsData[data]['openingTime'].toString();
              String closingTime =
                  attractionsData[data]['closingTime'].toString();
              String urlWebsite =
                  attractionsData[data]['visitWebsite'].toString();
              String ticketPrice =
                  attractionsData[data]['ticketPrice'].toString();

              devtools.log(
                  '$attractionName\n$pathPic\n$category\n$about\n$suggestedDuration\n$address\n$urlGMap\n$openingTime\n$closingTime\n$urlWebsite');

              devtools.log('======================================');

              setState(() {
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
                // Navigator.of(context).pushAndRemoveUntil(
                //     FadePageRoute(const SelectLocation()),
                //     (Route<dynamic> route) => false);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 0,
                right: 0,
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
                                       attractionsData[data]['pic'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                // Image.network(
                                //     attractionsData[data]['pic'],
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
                                    data,
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
                                    attractionsData[data]['category']
                                        .join(", "),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    "$sugTime hr",
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
                              value: attractionsSelectedCopy.contains(data),
                              onChanged: (inputValue) {
                                setState(() {
                                  Map temp2 = attractionsData[data]
                                      ['suggestedDuration'];
                                  // String sugTime2 =
                                  //     '${temp2['hours']}.${temp2['minutes']}';
                                  // devtools.log(
                                  //     '${temp2['hours']}.${temp2['minutes']}');
                                  int hours = temp2['hours'];
                                  int minutes = temp2['minutes'];

                                  if (attractionsSelectedCopy.contains(data)) {
                                    attractionsSelectedCopy.remove(data);

                                    durationCount = Duration(
                                        hours: durationCount.inHours - hours,
                                        minutes:
                                            durationCount.inHours - minutes);
                                    // durationCount - double.parse(sugTime2);
                                  } else {
                                    attractionsSelectedCopy.add(data);
                                    durationCount = Duration(
                                        hours: durationCount.inHours + hours,
                                        minutes:
                                            durationCount.inHours + minutes);
                                    // durationCount + double.parse(sugTime2);
                                    // devtools.log(
                                    //     '$sugTime2 = ${double.parse(sugTime2)}');
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
                  const Divider(
                    color: Colors.grey,
                  )
                ],
              ),
            ));
    //   },
    // );
  }
}
