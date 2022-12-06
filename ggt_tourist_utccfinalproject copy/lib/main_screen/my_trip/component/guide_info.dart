import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import '../../../../../../constant.dart';
import '../../../../../../utillties/calculate_age.dart';


// ignore: must_be_immutable
class GuideInfo extends StatefulWidget {
  // const GuideInfo({super.key});
  GuideInfo({
    super.key,
    required this.guideData,
  });
  Map guideData;

  @override
  // ignore: no_logic_in_create_state
  State<GuideInfo> createState() => _GuideInfoState(guideData: guideData);
}

class _GuideInfoState extends State<GuideInfo> {
  _GuideInfoState({
    required this.guideData,
  });
  Map guideData;

  bool isFirebaseBug = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // devtools.log(guideData.toString());

    // devtools.log(json.decode(guideData['aptitutes']).runtimeType.toString());

    List aptitutes = [];
    if (guideData['aptitutes'] != null) {
      aptitutes = json.decode(guideData['aptitutes']);
    }
    String getTypeOfAtt = '';
    for (int i = 0; i < aptitutes.length; i++) {
      if (getTypeOfAtt == '') {
        getTypeOfAtt = aptitutes[i].toString();
      }
      getTypeOfAtt = '$getTypeOfAtt, ${aptitutes[i]}';
    }
    devtools.log(getTypeOfAtt);

    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     devtools.log(guideData['language'].toString());
        //     devtools.log(
        //       guideData['language']
        //           .toString()
        //           .substring(1, guideData['language'].toString().length - 1),
        //     );
        //     // devtools.log(
        //     //   guideData['language']
        //     //       .substring(1, guideData['language'].length() - 1)
        //     //       .toString(),
        //     // );
        //   },
        // ),
        appBar: AppBar(
          title: Text(
            '${guideData['user_name'] ?? guideData['firstName']} Infomation',
            style: TextStyle(
              color: primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          leading: IconButton(
            icon:
                Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor),
            onPressed: () {
              // FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: primaryBackgroundColor,
          elevation: 1, //ทำให้ไม่มีเงาด้านล่าง appbar
        ),
        backgroundColor: primaryBackgroundColor,
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: guideData['photoProfileURL'] == null ||
                      guideData['photoProfileURL'] == '' ||
                      isFirebaseBug
                  ? CircleAvatar(
                      radius: size.height * 0.1,
                      backgroundColor: primaryColor,
                      child: Icon(
                        Icons.person,
                        size: size.height * 0.1,
                        color: primaryTextColor,
                      ),
                    )
                  : Container(
                      width: size.height * 0.2,
                      height: size.height * 0.2,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: NetworkImage(guideData['photoProfileURL']),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                        // borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        border: Border.all(
                          color: primaryTextColor.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                    ),

              // CircleAvatar(
              //     radius: size.height * 0.1,
              //     backgroundImage:
              //         NetworkImage(guideData['photoProfileURL']),
              //   )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  guideData['user_name'] ?? guideData['firstName'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.03,
                  ),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
            child: SizedBox(
              // color: Colors.amber,
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    '(${guideData['firstName']} ${guideData['lastName']})',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: size.height * 0.025,
                    ),
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Email : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: size.height * 0.020,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Expanded(
                      child: Text(
                    '${guideData['email']}',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: size.height * 0.020,
                    ),
                    textAlign: TextAlign.start,
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Phone Number : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: size.height * 0.020,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Expanded(
                      child: Text(
                    '${guideData['phoneNumber']}',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: size.height * 0.020,
                    ),
                    textAlign: TextAlign.start,
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: SizedBox(
              // color: Colors.amber,
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Age : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: size.height * 0.020,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Expanded(
                      child: Text(
                    '${calculateAge(guideData['birthDay'])}',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: size.height * 0.020,
                    ),
                    textAlign: TextAlign.start,
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: SizedBox(
              // color: Colors.amber,
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Gender : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: size.height * 0.020,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Expanded(
                      child: Text(
                    '${guideData['gender']}',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: size.height * 0.020,
                    ),
                    textAlign: TextAlign.start,
                  )),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          //   child: SizedBox(
          //     // color: Colors.amber,
          //     width: size.width,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Text(
          //           'Number of job (with us) : ',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             color: primaryTextColor,
          //             fontSize: size.height * 0.020,
          //           ),
          //           textAlign: TextAlign.start,
          //         ),
          //         Expanded(
          //             child: Text(
          //           'test data',
          //           style: TextStyle(
          //             // fontWeight: FontWeight.bold,
          //             color: primaryTextColor,
          //             fontSize: size.height * 0.020,
          //           ),
          //           textAlign: TextAlign.start,
          //         )),
          //       ],
          //     ),
          //   ),
          // ),
          // guideData['aptitutes']!=null?[]:
          ///---------------------------------
          guideData['aptitutes'] == null
              ? const SizedBox()
              : aptitutesAndLanguge(size, getTypeOfAtt),

          ///---------------------------------
        ])));
  }

  Widget aptitutesAndLanguge(Size size, String getTypeOfAtt) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: SizedBox(
            // color: Colors.amber,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  'Good at (Type of attraction)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.020,
                  ),
                  textAlign: TextAlign.start,
                )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Container(
            // color: Colors.amber,
            decoration: BoxDecoration(
              // color: primaryColor,
              border: Border.all(color: primaryTextColor.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(10),
            ),
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, right: 10, left: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    getTypeOfAtt,
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: size.height * 0.018,
                    ),
                    textAlign: TextAlign.start,
                  )),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: SizedBox(
            // color: Colors.amber,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  'Language',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: size.height * 0.020,
                  ),
                  textAlign: TextAlign.start,
                )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Container(
            // color: Colors.amber,
            decoration: BoxDecoration(
              // color: primaryColor,
              border: Border.all(color: primaryTextColor.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(10),
            ),
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, right: 10, left: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    guideData['language'].toString().substring(
                        1, guideData['language'].toString().length - 1),
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: size.height * 0.018,
                    ),
                    textAlign: TextAlign.start,
                  )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> showAptitutes(List aptitutes, Size size) {
    List<Widget> a = [];
    for (int i = 0; i < aptitutes.length; i++) {
      a.add(Text(
        aptitutes[i].toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
          fontSize: size.height * 0.020,
        ),
        textAlign: TextAlign.start,
      ));
    }
    return a;
  }
}
