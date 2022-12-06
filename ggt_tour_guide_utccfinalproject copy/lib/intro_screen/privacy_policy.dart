import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;

import '../constant.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        toolbarHeight: size.height * 0.06,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: secondaryBackgroundColor),
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
                  "Privacy Policy",
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
                      "Last revised : 20 Sep 2022",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
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
                      '$appName recognizes the importance of the protection of your personal data. This Privacy Policy explains our practices regarding the collection, use or disclosure of personal data including other rights of the Data Subjects in accordance with the Personal Data Protection Laws.',
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
                      'If you choose to use $appName, your use and any dispute over privacy is subject to this Notice and our Terms of Use. If you have any concerns about privacy at $appName, please contact us with a thorough description, and we will try to resolve it. You also have the right to contact your local Data Protection Authority.',
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
                      'Collection of Personal Data',
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
                      'We will collect your personal data that receive directly from you as following:',
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
                      '\u2022 your account registration\n\t\t\t- user name\n\t\t\t- email address\n\t\t\t- password (encrypt)',
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
                      '\u2022 your personal information\n\t\t\t- name and sername\n\t\t\t- date of birth\n\t\t\t- Thai ID card No.\n\t\t\t- copy of Thai ID card\n\t\t\t- Tourist Guide Licenes No.\n\t\t\t- Tourist Guide Licenes type\n\t\t\t- copy of Tourist Guide Licenes',
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
                      '\u2022 your contact information\n\t\t\t- telephone number (+66)',
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
                      'Types of Data Collected',
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
                      child: RichText(
                    text: TextSpan(
                      text: '1. Personal data ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'such as name, surname, age, date of birth, nationality, identification card, passport, etc.',
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
                      text: '2. Contact information ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'such as telephone number, e-mail address, etc.',
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
                      text: '3. Account details ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'such as username, password, transactions history, etc.',
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
                      text: '4. Proof of identity ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'such as copy of Thai identification card, copy of Tourist Guide Licenes, etc.',
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
                      text: '5. Transaction and Financial information ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'such as purchase history, credit card details, bank account, etc.',
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
                      text: '6. Other ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                          text:
                              'such as photo, video, and other information that is considered personal data under the Personal Data Protection Laws.',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
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
                      'We may collect, use or disclose your sensitive data that is specially categorized by law when we have obtained explicit consent from you or where necessary for us as permissible under law. We may collect, use or disclose your sensitive personal data as following:',
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
                      child: RichText(
                    text: TextSpan(
                      text: '\u2022 racial ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                          text:
                              'Any data which may affect the data subject in the same manner, as prescribed by the Personal Data Protection Committee.',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
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
                      'Storage of Data',
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
                      'We store your personal data in our sever.',
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
                      'We store your personal data by using the following systems:',
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
                      '\u2022 Third-party server service providers outside of Thailand',
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
                      'Use of Data',
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
                      'We use the collected data for various purposes:',
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
                      '\u2022 To create and manage accounts',
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
                      '\u2022 To improve products, services, or user experiences',
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
                      '\u2022 To share and manage information within organization',
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
                      "\u2022 To gather user's feedback",
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
                      "\u2022 To process payments of products or services",
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
                      "\u2022 To comply with our Terms and Conditions",
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
                      "\u2022 To comply with laws, rules, and regulatory authorities",
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
                      'Disclosure of Personal Data',
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
                      "We may disclose your personal data to the following parties in certain circumstances:",
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
              SizedBox(height: size.height * 0.015),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Organization",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
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
                      "We may disclose your personal data within our organization to provide and develop our products or services. We may combine information internally across the different products or services covered by this Privacy Policy to help us be more relevant and useful to you and others.",
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
              SizedBox(height: size.height * 0.015),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Service Providers",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
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
                      "We may use service providers to help us provide our services such as payments, marketing and development of products or services. Please note that service providers have their own privacy policy.",
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
              SizedBox(height: size.height * 0.015),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Law Enforcement",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
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
                      "Under certain circumstances, we may be required to disclose your personal data if required to do so by law or in response to valid requests by government authority such as courts, government authorities.",
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
              SizedBox(height: size.height * 0.015),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Cross-Border Data Transfer",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
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
                      "We may disclose or transfer your personal data to third parties, organizations or servers located in foreign countries. We will take steps and measures to ensure that your personal data is securely transferred, and the receiving parties have an appropriate level of personal data protection standard or as allowed by laws.",
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
                      'Data Retention',
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
                      "We will retain your personal data for as long as necessary during the period you are a customer or under relationship with us, or for as long as necessary in connection with the purposes set out in this Privacy Policy, unless law requires or permits a longer retention period. We will erase, destroy or anonymize your personal data when it is no longer necessary or when the period lapses.",
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
                      'Data Subject Rights',
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
                      "Subject to the Personal Data Protection Laws thereof, you may exercise any of these rights in the following:",
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
              SizedBox(height: size.height * 0.015),
              Row(
                children: [
                  Expanded(
                      child: RichText(
                    text: TextSpan(
                      text: 'Withdrawal of consent: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'If you have given consent to us to collect, use or disclose your personal data whether before or after the effective date of the Personal Data Protection Laws, you have the right to withdraw such consent at any time throughout the period your personal data available to us, unless it is restricted by laws or you are still under beneficial contract.',
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
                      text: 'Data access: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'You have the right to access your personal data that is under our responsibility; to request us to make a copy of such data for you; and to request us to reveal as to how we obtain your personal data.',
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
                      text: 'Data portability: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'You have the right to obtain your personal data if we organize such personal data in automatic machine-readable or usable format and can be processed or disclosed by automatic means; to request us to send or transfer the personal data in such format directly to other data controllers if doable by automatic means; and to request to obtain the personal data in such format sent or transferred by us directly to other data controller unless not technically feasible.',
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
                      text: 'Objection: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'You have the right to object to collection, use or disclosure of your personal data at any time if such doing is conducted for legitimate interests of us, corporation or individual which is within your reasonable expectation; or for carrying out public tasks.',
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
                      text: 'Data erasure or destruction: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'You have the right to request us to erase, destroy or anonymize your personal data if you believe that the collection, use or disclosure of your personal data is against relevant laws; or retention of the data by us is no longer necessary in connection with related purposes under this Privacy Policy; or when you request to withdraw your consent or to object to the processing as earlier described.',
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
                      text: 'Suspension: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'You have the right to request us to suspend processing your personal data during the period where we examine your rectification or objection request; or when it is no longer necessary and we must erase or destroy your personal data pursuant to relevant laws but you instead request us to suspend the processing.',
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
                      text: 'Rectification: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'You have the right to rectify your personal data to be updated, complete and not misleading.',
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
                      text: 'Complaint lodging: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 15),
                      children: [
                        TextSpan(
                            text:
                                'You have the right to complain to competent authorities pursuant to relevant laws if you believe that the collection, use or disclosure of your personal data is violating or not in compliance with relevant laws.',
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
                    child: Text(
                      "You can exercise these rights as the Data Subject by contacting our Data Protection Officer as mentioned below. We will notify the result of your request within 30 days upon receipt of such request. If we deny the request, we will inform you of the reason via SMS, email address, telephone, registered mail (if applicable).",
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
                      'Data Security',
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
                      "We endeavor to protect your personal data by establishing security measures in accordance with the principles of confidentiality, integrity, and availability to prevent loss, unauthorized or unlawful access, destruction, use, alteration, or disclosure including administrative safeguard, technical safeguard, physical safeguard and access controls.",
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
                      'Data Breach Notification',
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
                      "We will notify the Office of the Personal Data Protection Committee without delay and, where feasible, within 72 hours after having become aware of it, unless such personal data breach is unlikely to result in a risk to the rights and freedoms of you. If the personal data breach is likely to result in a high risk to the rights and freedoms of you, we will also notify the personal data breach and the remedial measures to you without delay through our registered mail (if applicable).",
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
                      'Changes to this Privacy Policy',
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
                      "We may change this Privacy Policy from time to time. Any changes of this Privacy Policy, we encourage you to frequently check on our application.",
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
                      'Links to Other Sites',
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
                      "The purpose of this Privacy Policy is to offer products or services and use of our application. Any application or websites from other domains found on our site is subject to their privacy policy which is not related to us.",
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
                      'Contact Information',
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
                      "If you have any questions about this Privacy Policy or would like to exercise your rights, you can contact us by using the following details:",
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
              SizedBox(height: size.height * 0.015),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "supportggt@gmail.com",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
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
