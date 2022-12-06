import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'dart:developer' as devtools show log;

class RefundPolicyScreen extends StatefulWidget {
  const RefundPolicyScreen({super.key});

  @override
  State<RefundPolicyScreen> createState() => _RefundPolicyScreenState();
}

class _RefundPolicyScreenState extends State<RefundPolicyScreen> {
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        toolbarHeight: size.height * 0.06,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                  "Refund Policy",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: 36),
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Last revised : 22 Nov 2022",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: deactivatedText,
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
                      '1. Within 48 hours and Status is Pending: You may be able to get a refund depending on the details of the purchase. There are 2 methods:',
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
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: RichText(
                  text: TextSpan(
                    text: '1.1 Follow ',
                    style: TextStyle(color: primaryTextColor, fontSize: 15),
                    children: [
                      TextSpan(
                        text: "these instructions ",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: primaryTextColor,
                            fontSize: 15),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchUrl(Uri.parse(
                                'https://support.google.com/googleplay/answer/7205930'));
                          },
                      ),
                      TextSpan(
                        text: 'to direct request refund to Google.',
                        style: TextStyle(color: primaryTextColor, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 5),
                child: Text(
                  '1.2 Get refund with us by : account number or SWIFT Code.',
                  style: TextStyle(color: primaryTextColor, fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  '***Except Yen currency***',
                  style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5),
                child: Text(
                  '- If You want to get refund by account number or SWIFT Code you will be charged a fee of 500 baht from your refund. ',
                  style: TextStyle(color: primaryTextColor, fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5),
                child: Text(
                  "- for Yen currency, we can't refund if you payment less than 1500 baht because refund fee is 1500 baht. We recommend you to request a refund via Google Pay as mentioned above (1).",
                  style: TextStyle(color: primaryTextColor, fontSize: 15),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '2. After 48 hours or Status is not Pending: No Refund.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      textAlign: TextAlign.left,
                      // textAlign: TextAlign.justify
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
