import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;

import '../constant.dart';
import '../main_screen/home_screen/plan/summary/refund_policy.dart';
import '../utillties/custom_page_route.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({super.key});

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
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
                  "Terms of Use",
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
                      "Last revised : 27 Nov 2022",
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
                      'These $appName Trems of Use is entered into between you (hereinafter referred to as "you" or "your") and Globle Guide operators (as defined below). By accessing, downloading, using or clicking "I agree" to accept any Globle Guide Service (as defined below) provided by Globle Guide (as defined below), you agree that you have read, understood and accepted all of the terms and conditions stipulated in there Terms of Use (hereinafter referred to as "these Terms") as well as our Privacy Policy. In addition, when using some features of the Service, you may be subject to specific additionl terms and conditions applicable to those features',
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
              Row(
                children: [
                  Expanded(
                      child: RichText(
                    text: TextSpan(
                      text:
                          'Please read the terms carefully as they govern your use of Globle Guide Services. ',
                      style: TextStyle(color: primaryTextColor, fontSize: 15),
                      children: const [
                        TextSpan(
                            text: 'THESE TERMS CONTAIN IMPORTANT PROVISIONS',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'By accessing, using or attempting to use Globle Guide Services in any capacity, you acknowledge that you accept and agree to be bound by these Terms. If you do not agree, do not access $appName or utilize Globle Guide services.',
                      style: TextStyle(color: primaryTextColor, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'I. Definitions',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                      // textAlign: TextAlign.justify
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Expanded(
                      child: RichText(
                    text: TextSpan(
                      text: '1. Globle Guide ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'refers to an ecosystem comprising Globle Guide websites (future development) , mobile applications and other applications that are developed to offer Globle Guide Services. In case of any inconsistency between relevant terms of use of the above platforms and the contents of these Terms, the respective applicable terms of such platforms shall prevail. ',
                            style: TextStyle(
                              color: primaryTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            )),
                      ],
                    ),
                  )),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Expanded(
                      child: RichText(
                    text: TextSpan(
                      text: '2. Globle Guide Operators ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'refer to all parties that run $appName including but not limited to legal persons , unincorporated organizations and teams that provide Globle Guide Services and are responsible for such services. For convenience, unless otherwise stated, references to “Globle Guide” and “we” in these Terms specifically mean Globle Guide Operators. ',
                            style: TextStyle(
                              color: primaryTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            )),
                        TextSpan(
                          text:
                              "UNDER THESE TERMS, GLOBLE GUIDE OPERATORS MAY CHANGE AS GLOBLE GUIDE'S BUSINESS ADJUSTS, IN WHICH CASE, THE CHANGED OPERATORS SHALL PERFORM THEIR OBLIGATIONS UNDER THESE TERMS WITH YOU AND PROVIDE SERVICES TO YOU, AND SUCH CHANGE DOES NOT AFFECT YOUR RIGHTS AND INTERESTS UNDER THESE TERMS. ADDITIONALLY, THE SCOPE OF Globle Guide OPERATORS MAY BE EXPANDED DUE TO THE PROVISION OF NEW GLOBLE GUIDE SERVICES, IN WHICH CASE, IF YOU CONTINUE TO USE GLOBLE GUIDE SERVICES, IT IS DEEMED THAT YOU HAVE AGREED TO JOINTLY EXECUTE THESE TERMS WITH THE NEWLY ADDED GLOBLE GUIDE OPERATORS. IN CASE OF A DISPUTE, YOU SHALL DETERMINE THE ENTITIES BY WHICH THESE TERMS ARE PERFORMED WITH YOU AND THE COUNTERPARTIES OF THE DISPUTE, DEPENDING ON THE SPECIFIC SERVICES YOU USE AND THE PARTICULAR ACTIONS THAT AFFECT YOUR RIGHTS OR INTERESTS.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Expanded(
                      child: RichText(
                    text: TextSpan(
                      text: '3. Globle Guide Services ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'refer to various services provided to you by Globle Guide that are based on Internet and offered via Globle Guide websites, mobile applications, clients and other forms (including new ones enabled by future technological development).',
                            style: TextStyle(
                              color: primaryTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            )),
                      ],
                    ),
                  )),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'II. Restriction',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                      // textAlign: TextAlign.justify
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'When you use Globle Guide Services, you agree and undertake to comply with the following provisions: ',
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
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '1. During the use of Globle Guide Services, all activities you carry out should comply with the requirements of applicable laws and regulations, these Terms, and various guidelines of Globle Guide',
                      style: TextStyle(color: primaryTextColor, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '2. Your use of Globle Guide Services should not violate public interests, public morals, or the legitimate interests of others, including any actions that would interfere with, disrupt, negatively affect, or prohibit other Users from using Globle Guide Services',
                      style: TextStyle(color: primaryTextColor, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '3. Without written consent from Globle Guide,  commercial uses of $appName data are prohibited',
                      style: TextStyle(color: primaryTextColor, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '4. Without prior written consent from Globle Guide, you may not modify, replicate, duplicate, copy, download, store, further transmit, disseminate, transfer, disassemble, broadcast, publish, remove or alter any copyright statement or label, or license, sub-license, sell, mirror, design, rent, lease, private label, grant security interests in the properties or any part of the properties, or create their derivative works or otherwise take advantage of any part of the properties.',
                      style: TextStyle(color: primaryTextColor, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '5. You may not (i) use any deep linking, web crawlers, bots, spiders or other automatic devices, programs, scripts, algorithms or methods, or any similar or equivalent manual processes to access, obtain, copy or monitor any part of the properties, or replicate or bypass the navigational structure or presentation of Globle Guide Services in any way, in order to obtain or attempt to obtain any materials, documents or information in any manner not purposely provided through Globle Guide Services; (ii) attempt to access any part or function of the properties without authorization, or connect to Globle Guide Services or any Globle Guide servers or any other systems or networks of any Globle Guide Services provided through the services by hacking, password mining or any other unlawful or prohibited means; (iii) probe, scan or test the vulnerabilities of Globle Guide Services or any network connected to the properties, or violate any security or authentication measures on Globle Guide Services or any network connected to Globle Guide Services; (iv) reverse look-up, track or seek to track any information of any other Users or visitors of Globle Guide Services; (v) take any actions that imposes an unreasonable or disproportionately large load on the infrastructure of systems or networks of Globle Guide Services or $appName, or the infrastructure of any systems or networks connected to Globle Guide services; (vi) use any devices, software or routine programs to interfere with the normal operation of Globle Guide Services or any transactions on Globle Guide Services, or any other person’s use of Globle Guide Services; (vii) forge headers, impersonate, or otherwise manipulate identification, to disguise your identity or the origin of any messages or transmissions you send to $appName, or (viii) use Globle Guide Services in an illegal way.',
                      style: TextStyle(color: primaryTextColor, fontSize: 15),
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
                      'By accessing Globle Guide Services, you agree that Globle Guide has the right to investigate any violation of these Terms, unilaterally determine whether you have violated these Terms, and take actions under relevant regulations without your consent or prior notice. Examples of such actions include, but are not limited to:',
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
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Text(
                    '\u2022 ',
                    style: TextStyle(color: primaryTextColor, fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                      'Blocking and closing order requests.',
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
              Row(
                children: [
                  Text(
                    '\u2022 ',
                    style: TextStyle(color: primaryTextColor, fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                      'Freezing your account.',
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
              Row(
                children: [
                  Text(
                    '\u2022 ',
                    style: TextStyle(color: primaryTextColor, fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                      'Reporting the incident to the authorities',
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
              Row(
                children: [
                  Text(
                    '\u2022 ',
                    style: TextStyle(color: primaryTextColor, fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                      'Publishing the alleged violations and actions that have been taken.',
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
              Row(
                children: [
                  Text(
                    '\u2022 ',
                    style: TextStyle(color: primaryTextColor, fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                      'Deleting any information you published that are found to be violations.',
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
              SizedBox(height: size.height * 0.03),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'III. Refund Policy',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                      // textAlign: TextAlign.justify
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Some of our services are charged and can be canceled. We have a preliminary refund agreement as follows:',
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
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '1. Within 48 hours can request a refund.',
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
              SizedBox(height: size.height * 0.005),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '2. After 48 hours can not request a refund in any case',
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
              SizedBox(height: size.height * 0.01),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "For more information ",
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryTextColor,
                  ),
                ),
                TextSpan(
                  text: "read here.",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context)
                          .push(FadePageRoute(const RefundPolicyScreen()));
                    },
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                    color: primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ])),
              SizedBox(height: size.height * 0.03),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'IV. Patment Method',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                      // textAlign: TextAlign.justify
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Some of our services are paid for by us using Google Pay payments, making the service unavailable to users of certain countries where Google Pay is not available.',
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
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'You can use Google Wallet for payments in:',
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
              SizedBox(height: size.height * 0.01),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('\u2022 Armenia'),
                              Text('\u2022 Australia'),
                              Text('\u2022 Austria'),
                              Text('\u2022 Azerbaijan'),
                              Text('\u2022 Belgium'),
                              Text('\u2022 Brazil'),
                              Text('\u2022 Bulgaria'),
                              Text('\u2022 Canada'),
                              Text('\u2022 Chile'),
                              Text('\u2022 Croatia'),
                              Text('\u2022 Cyprus'),
                              Text('\u2022 Czech Republic'),
                              Text('\u2022 Denmark'),
                              Text('\u2022 Estonia'),
                              Text('\u2022 Finland'),
                              Text('\u2022 France'),
                              Text('\u2022 Georgia'),
                              Text('\u2022 Germany'),
                              Text('\u2022 Greece'),
                              Text('\u2022 Hong Kong'),
                              Text('\u2022 Hungary'),
                              Text('\u2022 Iceland'),
                              Text('\u2022 Ireland'),
                              Text('\u2022 Israel'),
                              Text('\u2022 Italy'),
                              Text('\u2022 Kazakhstan'),
                              Text('\u2022 Kyrgyzstan'),
                              Text('\u2022 Latvia'),
                              Text('\u2022 Liechtenstein'),
                              Text('\u2022 Lithuania'),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.black,
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('\u2022 Luxembourg'),
                              Text('\u2022 Malaysia'),
                              Text('\u2022 Malta'),
                              Text('\u2022 Mexico'),
                              Text('\u2022 Moldova'),
                              Text('\u2022 Netherlands'),
                              Text('\u2022 New Zealand'),
                              Text('\u2022 Norway'),
                              Text('\u2022 Poland'),
                              Text('\u2022 Portugal'),
                              Text('\u2022 Qatar'),
                              Text('\u2022 Romania'),
                              Text('\u2022 Serbia'),
                              Text('\u2022 Singapore'),
                              Text('\u2022 Slovakia'),
                              Text('\u2022 Slovenia'),
                              Text('\u2022 South Africa'),
                              Text('\u2022 Spain'),
                              Text('\u2022 Sweden'),
                              Text('\u2022 Switzerland'),
                              Text('\u2022 Taiwan'),
                              Text('\u2022 Thailand'),
                              Text('\u2022 Ukraine'),
                              Text('\u2022 United Arab Emirates'),
                              Text(
                                  '\u2022 United Kingdom and\n\t\toutlying territories'),
                              Text(
                                  '\u2022 United States and\n\t\toutlying territories'),
                              Text('\u2022 Vietnam'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'V. Conditions of Use, Notices and Revisions',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                      // textAlign: TextAlign.justify
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'If you choose to use Globle Guide Services, your use and any dispute over privacy is subject to this Notice and our Terms of Use. If you have any concerns about privacy at $appName, please contact us with a thorough description, and we will try to resolve it. You also have the right to contact your local Data Protection Authority.',
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Our business changes constantly, and our Privacy Notice will change also. You should check our websites frequently to see recent changes. If you do not agree with the revised content, you shall stop accessing $appName immediately. When an updated version of the Privacy Policy is released, your continued access to $appName means that you agree to the updated content and agree to abide by the updated Privacy Notice. Unless stated otherwise, our current Privacy Notice applies to all information that we have about you and your account.',
                      style: TextStyle(color: primaryTextColor, fontSize: 15),
                      textAlign: TextAlign.left,
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
