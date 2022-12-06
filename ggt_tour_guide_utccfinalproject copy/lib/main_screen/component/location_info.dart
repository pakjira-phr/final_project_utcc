import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as devtools show log;

import '../../../../constant.dart';

// ignore: must_be_immutable
class LocationInfo extends StatefulWidget {
  // const LocationInfo({super.key});
  LocationInfo({
    super.key,
    required this.attractionsSelect,
    required this.name,
    required this.category,
  });
  Map attractionsSelect;
  String name;
  String category;

  @override
  // ignore: no_logic_in_create_state
  State<LocationInfo> createState() => _LocationInfoState(
        attractionsSelect: attractionsSelect,
        name: name,
        category: category,
      );
}

class _LocationInfoState extends State<LocationInfo> {
  _LocationInfoState({
    required this.attractionsSelect,
    required this.name,
    required this.category,
  });
  Map attractionsSelect;
  String name;
  String category;

  String attractionName = '';
  String pathPic = '';
  String about = '';
  String suggestedDuration = '';
  String address = '';
  String urlGMap = '';
  String openingTime = '';
  String closingTime = '';
  String urlWebsite = '';
  String ticketPrice = '';
  bool isFirebaseBug = false;

  @override
  void initState() {
    attractionName = name;
    pathPic = attractionsSelect['pic'];
    about = attractionsSelect['about'];
    Map temp = attractionsSelect['suggestedDuration'];
    suggestedDuration = '${temp['hours']}.${temp['minutes']}';
    address = attractionsSelect['location'];
    urlGMap = attractionsSelect['location(googleMap)'];
    openingTime = attractionsSelect['openingTime'];
    closingTime = attractionsSelect['closingTime'];
    urlWebsite = attractionsSelect['visitWebsite'];
    ticketPrice = attractionsSelect['ticketPrice'].toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Uri urlAddress = Uri.parse(urlGMap);
    Uri urlWeb = Uri.parse(urlWebsite);

    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _launchUrl(Uri url) async {
      if (!await launchUrl(url)) {
        throw 'Could not launch $url';
      }
    }

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Attraction Infomation',
          style: TextStyle(
            // color: tertiaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor),
          onPressed: () {
            // FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: primaryBackgroundColor,
        elevation: 1, //ทำให้ไม่มีเงาด้านล่าง appbar
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            // color: Colors.amber,
            width: size.width,
            height: size.height * 0.3,
            child: pathPic == '' || isFirebaseBug
                ? const Icon(Icons.developer_board)
                : CachedNetworkImage(
                    imageUrl: pathPic,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),

            // Image.network(
            //     pathPic,
            //     fit: BoxFit.fill,
            //   )
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width,
                  // color: Colors.blue,
                  child: Text(
                    attractionName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: size.width,
                    // color: Colors.blue,
                    child: Text(
                      category,
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                // ignore: unrelated_type_equality_checks
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        // width: size.width,
                        // color: Colors.blue,
                        child: Text(
                          'Ticket price :',
                          style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                              // decoration: TextDecoration.underline,
                              fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        // width: size.width,
                        // color: Colors.blue,
                        child: Text(
                          ticketPrice == '0'
                              ? ' Free Admission'
                              : ' $ticketPrice฿',
                          style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                              // decoration: TextDecoration.underline,
                              fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.1,
                    ),
                  ],
                ),
                urlWebsite == ''
                    ? const Text('')
                    : Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: InkWell(
                          onTap: () async {
                            _launchUrl(urlWeb);
                          },
                          child: SizedBox(
                            // width: size.width,
                            // color: Colors.blue,
                            child: Text(
                              'Visit website',
                              style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: size.width,
                    // color: Colors.blue,
                    child: Text(
                      getOpenStatus(openingTime, closingTime)
                          ? 'Open now'
                          : 'Close now',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: size.width,
                    // color: Colors.blue,
                    child: Text(
                      '$openingTime - $closingTime',
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: size.width,
                    // color: Colors.blue,
                    child: Text(
                      'About',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 24),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: size.width,
                    // color: Colors.blue,
                    child: Text(
                      about,
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: size.width,
                    // color: Colors.blue,
                    child: Text(
                      'Suggested duration',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: size.width,
                    // color: Colors.blue,
                    child: Text(
                      '$suggestedDuration hours',
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: size.width,
                    // color: Colors.blue,
                    child: Text(
                      'Address',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () async {
                      _launchUrl(urlAddress);
                    },
                    child: SizedBox(
                      width: size.width,
                      // color: Colors.blue,
                      child: Text(
                        address,
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                            decoration: TextDecoration.underline,
                            fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.1,
          )
        ],
      )),
    );
  }

  bool getOpenStatus(String openTime, String closeTime) {
    bool result = false;

    DateTime now = DateTime.now();
    int nowHour = now.hour;
    int nowMin = now.minute;

    devtools.log('Now: H$nowHour M$nowMin');

    var openTimes = openTime.split(":");
    int openHour = int.parse(openTimes[0]);
    int openMin = int.parse(openTimes[1]);

    devtools.log('OpenTimes: H$openHour M$openMin');

    var closeTimes = closeTime.split(":");
    int closeHour = int.parse(closeTimes[0]);
    int closeMin = int.parse(closeTimes[1]);

    devtools.log('CloseTimes: H$closeHour M$closeMin');

    if (nowHour >= openHour && nowHour <= closeHour) {
      if (nowMin > openMin && nowMin < closeMin) result = true;
    }

    return result;
  }
}
