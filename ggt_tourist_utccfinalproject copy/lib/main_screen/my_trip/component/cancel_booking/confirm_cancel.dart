import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:ggt_tourist_utccfinalproject/firebase_options_tour_guide.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/conutry_picker/country_picker.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/show_sheet_picker.dart';
import 'package:ggt_tourist_utccfinalproject/utillties/validator.dart';
import 'package:ggt_tourist_utccfinalproject/widget/show_error_dialog.dart';
import 'package:ggt_tourist_utccfinalproject/widget/text_form.dart';
import 'dart:developer' as devtools show log;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import '../../../../utillties/custom_page_route.dart';
import '../../../../widget/popup_dialog.dart';
import '../../../account_screen/component/address_info.dart';
import '../../../home_screen/plan/summary/refund_policy.dart';

// ignore: must_be_immutable
class ConfirmCancel extends StatefulWidget {
  // const ConfirmCancel({super.key});
  ConfirmCancel(
      {super.key,
      required this.detail,
      required this.indexToBack,
      required this.bookingAllData});
  Map detail;
  int indexToBack;
  Map bookingAllData;

  @override
  // ignore: no_logic_in_create_state
  State<ConfirmCancel> createState() => _ConfirmCancelState(
      detail: detail, indexToBack: indexToBack, bookingAllData: bookingAllData);
}

class _ConfirmCancelState extends State<ConfirmCancel> {
  _ConfirmCancelState(
      {required this.detail,
      required this.indexToBack,
      required this.bookingAllData});
  Map detail;
  int indexToBack;
  Map bookingAllData;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Map<String, dynamic>? userData;
  bool isGetData = false;
  final formKey = GlobalKey<FormState>();
  Map? contactAddress;
  // List bankName = [];
  Future getUserData() async {
    final documentUserSnapshot =
        await firestore.collection('users').doc(user?.uid).get();
    userData = documentUserSnapshot.data();

    isGetData = true;
  }

  bool isNotValidate = false;

  List<DropdownMenuItem> items = [];

  String? countryCode;
  String? selectedBankName;
  String? showSelectedBankName;
  TextEditingController? countryController;
  TextEditingController? refundOptionController;
  TextEditingController? swiftCodeController;
  TextEditingController? payNowController;
  TextEditingController? bankNameController;
  TextEditingController? accountNumberController;

  // Refund Option
  @override
  void initState() {
    countryController = TextEditingController();
    refundOptionController = TextEditingController();
    swiftCodeController = TextEditingController();
    payNowController = TextEditingController();
    bankNameController = TextEditingController();
    accountNumberController = TextEditingController();

    countryController?.text = '';
    refundOptionController?.text = '';
    swiftCodeController?.text = '';
    payNowController?.text = '';
    bankNameController?.text = '';
    accountNumberController?.text = '';
    super.initState();
  }

  @override
  void dispose() {
    countryController?.dispose();
    refundOptionController?.dispose();
    swiftCodeController?.dispose();
    payNowController?.dispose();
    bankNameController?.dispose();
    accountNumberController?.dispose();

    super.dispose();
  }

  bool isAccepedRefundPolicy = false;
  Color getColor(Set<MaterialState> states) {
    if (isAccepedRefundPolicy) {
      return primaryColor;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getUserData(),
        builder: ((context, snapshot) {
          if (isGetData) {
            contactAddress = userData?['contactAddress'];
            if (contactAddress != null) {
              isNotValidate = false;
            }
            return Scaffold(
              backgroundColor: secondaryBackgroundColor,
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () async {
              //     try {
              //       devtools.log(detail['totalPayment'].toString());
              //       // totalPayment
              //     } catch (e) {
              //       devtools.log('e : $e');
              //     }
              //   },
              // ),
              appBar: AppBar(
                elevation: 2,
                centerTitle: true,
                title: Text(
                  'Confirm Cancellation',
                  style: TextStyle(color: primaryTextColor),
                ),
                backgroundColor: primaryBackgroundColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: primaryTextColor),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.only(
                    right: 10, bottom: 10, left: 10, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(FadePageRoute(AddressInfo(
                          isFromAccountScreen: false,
                        )))
                            .then((value) {
                          setState(() {
                            // refresh state of Page
                          });
                        });
                      },
                      child: Card(
                          color: Colors.white,
                          child: SizedBox(
                              width: size.width,
                              // height: size.height * 0.2,
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: contactAddress == null
                                              ? [
                                                  Text(
                                                    'Contact address',
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.03,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Please complete the information.',
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.023,
                                                      // fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ]
                                              : [
                                                  Text(
                                                    'Contact address',
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.03,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Address : ${contactAddress?['address']}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.023,
                                                      // fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  Text(
                                                    'City : ${contactAddress?['city']}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.023,
                                                      // fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  Text(
                                                    'Post code : ${contactAddress?['postCode']}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.023,
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ]),
                                      Text(
                                        '>',
                                        style: TextStyle(
                                            fontSize: size.height * 0.04),
                                      ),
                                    ],
                                  )))),
                    ),
                    isNotValidate
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(
                                  'Complete Contact Address Please',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    bankAccountInfo(size),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Card(
                        child: SizedBox(
                          width: size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Refund',
                                  style: TextStyle(
                                      fontSize: size.height * 0.03,
                                      fontWeight: FontWeight.bold),
                                ),
                                Card(
                                  color: Colors.white,
                                  child: SizedBox(
                                    width: size.width,
                                    // height: size.height * 0.2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Icon(
                                              //   Icons.add,
                                              //   size: size.height * 0.1,
                                              // ),
                                              detail['sedanCount'] != 0
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12,
                                                              right: 20,
                                                              left: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              2),
                                                                  // color: Colors.amber,
                                                                  border: Border.all(
                                                                      color:
                                                                          primaryColor,
                                                                      width:
                                                                          1.5),
                                                                ),
                                                                height:
                                                                    size.height *
                                                                        0.04,
                                                                width:
                                                                    size.width *
                                                                        0.08,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        '${detail['sedanCount']}'
                                                                        'x'),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    size.width *
                                                                        0.05,
                                                              ),
                                                              Text(
                                                                'Sedan',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        size.height *
                                                                            0.02),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            '${detail['sedanPrice']}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.02),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              detail['vanCount'] != 0
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12,
                                                              right: 20,
                                                              left: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              2),
                                                                  // color: Colors.amber,
                                                                  border: Border.all(
                                                                      color:
                                                                          primaryColor,
                                                                      width:
                                                                          1.5),
                                                                ),
                                                                height:
                                                                    size.height *
                                                                        0.04,
                                                                width:
                                                                    size.width *
                                                                        0.08,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        '${detail['vanCount']}'
                                                                        'x'),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    size.width *
                                                                        0.05,
                                                              ),
                                                              Text(
                                                                'Van',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        size.height *
                                                                            0.02),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            '${detail['vanPrice']}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.02),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12,
                                                    right: 20,
                                                    left: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2),
                                                            // color: Colors.amber,
                                                            border: Border.all(
                                                                color:
                                                                    primaryColor,
                                                                width: 1.5),
                                                          ),
                                                          height: size.height *
                                                              0.04,
                                                          width:
                                                              size.width * 0.08,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              Text('1'
                                                                  'x'),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.05,
                                                        ),
                                                        Text(
                                                          'Tour Guide',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.020),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      '${detail['tourGuideFee']}',
                                                      style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.020),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Divider(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12,
                                                    right: 20,
                                                    left: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Refund Fee',
                                                      style: TextStyle(
                                                          // fontWeight:
                                                          //     FontWeight.bold,
                                                          fontSize:
                                                              size.height *
                                                                  0.02),
                                                    ),
                                                    Text(
                                                      (countryController
                                                                      ?.text ??
                                                                  '') ==
                                                              'Japan'
                                                          ? '-1500'
                                                          : '-500',
                                                      style: TextStyle(
                                                          // fontWeight:
                                                          //     FontWeight.bold,
                                                          fontSize:
                                                              size.height *
                                                                  0.02),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12,
                                                    right: 20,
                                                    left: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Total',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              size.height *
                                                                  0.022),
                                                    ),
                                                    Text(
                                                      (countryController
                                                                      ?.text ??
                                                                  '') ==
                                                              'Japan'
                                                          ? '฿${int.parse(detail['totalPayment'].toString()) - 1500}'
                                                          : '฿${int.parse(detail['totalPayment'].toString()) - 500}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              size.height *
                                                                  0.022),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Text(
                                                  (countryController?.text ??
                                                              '') ==
                                                          'Japan'
                                                      ? int.parse(detail['totalPayment']
                                                                      .toString()) -
                                                                  1500 <=
                                                              0
                                                          ? 'You can get refund becase total payment = 0 bath'
                                                          : ''
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(children: [
                        Checkbox(
                            checkColor: tertiaryColor,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isAccepedRefundPolicy,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context).unfocus();
                                isAccepedRefundPolicy =
                                    value ?? !isAccepedRefundPolicy;
                              });
                            }),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: "I have read and agree to our ",
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryTextColor,
                            ),
                          ),
                          TextSpan(
                            text: "Refund Policy",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                devtools.log("Go to RefundPolicyScreen");
                                Navigator.of(context).push(
                                    FadePageRoute(const RefundPolicyScreen()));
                              },
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              color: primaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ])),
                      ]),
                    ),
                    cancelBotton(size),
                  ],
                ),
              )),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: [primaryColor, primaryTextColor, secondaryColor],
                  //   stops: const [0, 0.5, 1],
                  //   begin: const AlignmentDirectional(1, -1),
                  //   end: const AlignmentDirectional(-1, 1),
                  // ),
                  color: primaryBackgroundColor),
              child: Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            );
          }
        }));
  }

  Widget bankAccountInfo(Size size) {
    return Card(
      color: Colors.white,
      child: SizedBox(
        width: size.width,
        // height: size.height * 0.2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bank Account Information',
                style: TextStyle(
                    fontSize: size.height * 0.03, fontWeight: FontWeight.bold),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      textFormCountry(
                        null,
                        'Select Country',
                        false,
                        false,
                        countryController,
                        context,
                        Icon(
                          Icons.arrow_drop_down_circle,
                          color: primaryTextColor,
                        ),
                        RequiredValidator(errorText: 'Country is required'),
                        'Country',
                        null,
                        false,
                        true,
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      countryController?.text == ''
                          ? const SizedBox()
                          : textFormRefundOption(
                              null,
                              'Select Refund Option',
                              false,
                              false,
                              refundOptionController,
                              context,
                              Icon(
                                Icons.arrow_drop_down_circle,
                                color: primaryTextColor,
                              ),
                              RequiredValidator(
                                  errorText: 'Refund Option is required'),
                              'Refund Option',
                              null,
                              false,
                              true,
                            ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      refundOptionController?.text == 'SWITH Code'
                          ? textForm(
                              null,
                              'Enter SWIFT Code',
                              false,
                              false,
                              swiftCodeController,
                              context,
                              null,
                              swiftCodeValidator,
                              'SWIFT Code',
                              null,
                              false,
                              false)
                          : refundOptionController?.text == 'Prompt Pay'
                              ? textForm(
                                  null, /////////////////////////ทำตรงนี้
                                  '0812345678',
                                  false,
                                  false,
                                  payNowController,
                                  context,
                                  null,
                                  promptPayValidator,
                                  'Prompt Pay',
                                  null,
                                  true,
                                  false)
                              : refundOptionController?.text ==
                                      'Bank Account Detail'
                                  ? Container(
                                      decoration: BoxDecoration(
                                        // borderRadius:
                                        //     const BorderRadius
                                        //             .all(
                                        //         Radius.circular(
                                        //             28)),
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(.3)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SearchChoices.single(
                                              label: Text(
                                                'Bank Name',
                                                style: TextStyle(
                                                  fontSize: size.height * 0.02,
                                                  // fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              icon: Icon(
                                                Icons.arrow_drop_down_circle,
                                                color: primaryTextColor,
                                              ),
                                              // displayClearIcon: false,
                                              fieldDecoration: BoxDecoration(
                                                // borderRadius:
                                                //     const BorderRadius.all(
                                                //         Radius.circular(28)),

                                                border: Border(
                                                  bottom: BorderSide(
                                                      width: 1.5,
                                                      color: Colors.black
                                                          .withOpacity(.3)),
                                                ),
                                              ),
                                              items: items,
                                              value: selectedBankName,
                                              hint: "Select Bank",
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedBankName = value;

                                                  showSelectedBankName =
                                                      '$selectedBankName';
                                                  bankNameController?.text =
                                                      selectedBankName ?? '';
                                                });
                                              },
                                              isExpanded: true,
                                            ),
                                            SizedBox(
                                              height: size.height * 0.01,
                                            ),
                                            Text('Account Number',
                                                style: TextStyle(
                                                  fontSize: size.height * 0.02,
                                                  // fontWeight: FontWeight.bold
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 10, right: 10),
                                              child: TextFormField(
                                                  validator: RequiredValidator(
                                                      errorText:
                                                          'Account Number is required'),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  controller:
                                                      accountNumberController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Enter Account Number",
                                                    // labelText: "Email",
                                                  )),
                                            ),
                                            // Padding(
                                            //   padding: const EdgeInsets.only(
                                            //       left: 8.0, top: 10),
                                            //   child: textForm(
                                            //       null,
                                            //       'Enter Account Number',
                                            //       false,
                                            //       false,
                                            //       accountNumberController,
                                            //       context,
                                            //       null,
                                            //       RequiredValidator(
                                            //           errorText:
                                            //               'Account Number is required'),
                                            //       null,
                                            //       null,
                                            //       true,
                                            //       false),
                                            // ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox()
                      // SizedBox(
                      //   height: size.height * 0.02,
                      // ),
                      // textFormBankName(
                      //   null,
                      //   'Enter Account Number',
                      //   false,
                      //   false,
                      //   accountNumberController,
                      //   context,
                      //   Icon(
                      //     Icons.arrow_drop_down_circle,
                      //     color: primaryTextColor,
                      //   ),
                      //   RequiredValidator(
                      //       errorText:
                      //           'Account Number is required'),
                      //   'Account Number',
                      //   null,
                      //   false,
                      //   true,
                      // ),
                      // SizedBox(
                      //   height: size.height * 0.02,
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFormCountry(
      IconData? icon,
      String? hintText,
      bool isPassword,
      bool isEmail,
      TextEditingController? textEditingController,
      BuildContext context,
      Widget? suffixIcon,
      String? Function(String?)? validator,
      String? labelText,
      void Function()? ontap,
      bool isPhonenumber,
      bool isneedToggel) {
    Size size = MediaQuery.of(context).size;

    return Container(
      // height: size.width / 6,
      // width: size.width / 1.2,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        right: size.width / 30,
      ),
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        readOnly: true,
        validator: validator,
        style: TextStyle(color: Colors.black.withOpacity(.8)),
        cursorColor: Colors.black,
        obscureText: isPassword,
        controller: textEditingController,
        enableSuggestions: isPassword ? false : true,
        inputFormatters: isPhonenumber
            ? [
                FilteringTextInputFormatter.digitsOnly,
              ]
            : [],
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : isPhonenumber
                ? TextInputType.phone
                : TextInputType.text,
        autocorrect: false,
        decoration: InputDecoration(
          fillColor: Colors.black.withOpacity(.03),
          filled: false,
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.blueAccent),
            gapPadding: 10,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
          suffixIcon: isneedToggel
              ? suffixIcon
              : Icon(
                  icon,
                  color: primaryTextColor,
                ),
        ),
        onTap: () {
          showCountryPicker(
            context: context,
            onSelect: (Country country) {
              devtools.log('Select country: ${country.name}');
              devtools.log('CountryCode: ${country.countryCode}');
              setState(() {
                countryController?.text = country.name;
                countryCode = country.countryCode;
                refundOptionController?.text = '';
              });
            },
          );
        },
      ),
    );
  }

  Widget textFormRefundOption(
      IconData? icon,
      String? hintText,
      bool isPassword,
      bool isEmail,
      TextEditingController? textEditingController,
      BuildContext context,
      Widget? suffixIcon,
      String? Function(String?)? validator,
      String? labelText,
      void Function()? ontap,
      bool isPhonenumber,
      bool isneedToggel) {
    Size size = MediaQuery.of(context).size;
    Widget buildRefundOptionPicker() => SizedBox(
        height: 180,
        child: CupertinoPicker(
            itemExtent: 30,
            scrollController: FixedExtentScrollController(initialItem: 2),
            children: countryCode == 'TH'
                ? const [Text('Bank Account Detail'), Text('Prompt Pay')]
                : const [
                    Text('SWITH Code'),
                    Text('Bank Account Detail'),
                    // Text('Prompt Pay International'),
                  ],
            onSelectedItemChanged: (value) {
              setState(() {
                devtools.log(value.toString());
                if (countryCode == 'TH') {
                  if (value == 1) {
                    setState(() {
                      refundOptionController?.text = 'Prompt Pay';
                    });
                  } else {
                    setState(() {
                      refundOptionController?.text = 'Bank Account Detail';
                    });
                  }
                } else {
                  if (value == 1) {
                    setState(() {
                      refundOptionController?.text = 'Bank Account Detail';
                    });
                    // } else if (value == 2) {
                    //   setState(() {
                    //     refundOptionController?.text = 'Prompt Pay International';
                    //   });
                  } else {
                    setState(() {
                      refundOptionController?.text = 'SWITH Code';
                    });
                  }
                }
              });
            }));
    return Container(
      // height: size.width / 6,
      // width: size.width / 1.2,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        right: size.width / 30,
      ),
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        readOnly: true,
        validator: validator,
        style: TextStyle(color: Colors.black.withOpacity(.8)),
        cursorColor: Colors.black,
        obscureText: isPassword,
        controller: textEditingController,
        enableSuggestions: isPassword ? false : true,
        inputFormatters: isPhonenumber
            ? [
                FilteringTextInputFormatter.digitsOnly,
              ]
            : [],
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : isPhonenumber
                ? TextInputType.phone
                : TextInputType.text,
        autocorrect: false,
        decoration: InputDecoration(
          fillColor: Colors.black.withOpacity(.03),
          filled: false,
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.blueAccent),
            gapPadding: 10,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
          suffixIcon: isneedToggel
              ? suffixIcon
              : Icon(
                  icon,
                  color: primaryTextColor,
                ),
        ),
        onTap: () {
          showSheet(
            context,
            child: buildRefundOptionPicker(),
            onClicked: () async {
              // final value = Stext; // เก็บค่าอยู่ในนี้
              // setStext(value);
              try {
                var response = await rootBundle.loadString(
                    'assets/json/bankAllCountries/$countryCode.json');
                Map<String, dynamic> data = await json.decode(response);
                devtools.log(data['list'][0]['bank'].toString());
                List bankName = [];
                items.clear();
                setState(() {
                  for (int i = 0; i < data['list'].length; i++) {
                    if (bankName.contains(data['list'][i]['bank'])) {
                      devtools.log('ซำ้');
                    } else {
                      bankName.add(data['list'][i]['bank']);
                      items.add(DropdownMenuItem(
                        value: data['list'][i]['bank'],
                        child: Text(data['list'][i]['bank']),
                      ));
                    }
                    // items.add(DropdownMenuItem(
                    //   value: data['list'][i]['bank'],
                    //   child: Text(data['list'][i]['bank']),
                    // ));
                  }
                  // items.toSet().toList();
                });

                devtools.log(items.toString());
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              } catch (e) {
                devtools.log('e : $e');
                if (e.toString() ==
                    'Unable to load asset: assets/json/bankAllCountries/$countryCode.json') {
                  devtools.log('yes');
                  showErrorDialog(
                      context, 'Please select other option or other country');
                }
              }

              // print(value);
            },
          );
        },
      ),
    );
  }

  // Widget textFormBankName(
  //     IconData? icon,
  //     String? hintText,
  //     bool isPassword,
  //     bool isEmail,
  //     TextEditingController? textEditingController,
  //     BuildContext context,
  //     Widget? suffixIcon,
  //     String? Function(String?)? validator,
  //     String? labelText,
  //     void Function()? ontap,
  //     bool isPhonenumber,
  //     bool isneedToggel) {
  //   Size size = MediaQuery.of(context).size;

  //   return Container(
  //     // height: size.width / 6,
  //     // width: size.width / 1.2,
  //     alignment: Alignment.center,
  //     padding: EdgeInsets.only(
  //       right: size.width / 30,
  //     ),
  //     decoration: BoxDecoration(
  //       // color: Colors.white.withOpacity(.4),
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: TextFormField(
  //       readOnly: true,
  //       validator: validator,
  //       style: TextStyle(color: Colors.black.withOpacity(.8)),
  //       cursorColor: Colors.black,
  //       obscureText: isPassword,
  //       controller: textEditingController,
  //       enableSuggestions: isPassword ? false : true,
  //       inputFormatters: isPhonenumber
  //           ? [
  //               FilteringTextInputFormatter.digitsOnly,
  //             ]
  //           : [],
  //       keyboardType: isEmail
  //           ? TextInputType.emailAddress
  //           : isPhonenumber
  //               ? TextInputType.phone
  //               : TextInputType.text,
  //       autocorrect: false,
  //       decoration: InputDecoration(
  //         fillColor: Colors.black.withOpacity(.03),
  //         filled: false,
  //         labelText: labelText,
  //         hintText: hintText,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(28),
  //           borderSide: const BorderSide(color: Colors.blueAccent),
  //           gapPadding: 10,
  //         ),
  //         floatingLabelBehavior: FloatingLabelBehavior.always,
  //         contentPadding:
  //             const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
  //         suffixIcon: isneedToggel
  //             ? suffixIcon
  //             : Icon(
  //                 icon,
  //                 color: primaryTextColor,
  //               ),
  //       ),
  //       onTap: () {
  //         devtools.log('message');
  //         // showErrorDialog(context, 'content');
  //         showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: SearchChoices.single(
  //                 items: items,
  //                 value: selectedBankName,
  //                 hint: "Select one",
  //                 searchHint: "Select one",
  //                 onChanged: (value) {
  //                   setState(() {
  //                     selectedBankName = value;
  //                   });
  //                 },
  //                 isExpanded: true,
  //               ),
  //               content: SearchChoices.single(
  //                 fieldDecoration: const BoxDecoration(
  //                     // borderRadius: BorderRadius.all(Radius.circular(28)),
  //                     // border: Border.all(color: Colors.black.withOpacity(.3)),
  //                     ),
  //                 items: items,
  //                 value: selectedBankName,
  //                 hint: "Select one",
  //                 searchHint: "Select one",
  //                 onChanged: (value) {
  //                   setState(() {
  //                     selectedBankName = value;
  //                   });
  //                 },
  //                 isExpanded: true,
  //                 dialogBox: true,
  //                 // isExpanded: true,
  //                 // menuConstraints:
  //                 //     BoxConstraints.tight(const Size.fromHeight(350)),
  //               ),
  //               // actions: [],
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget cancelBotton(Size size) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: InkWell(
        onTap: () async {
          devtools.log('Cancel Booking');
          if (formKey.currentState!.validate() && contactAddress != null) {
            showPopupDialog(
                context,
                'Are you sure you want to cancel booking.\nCancellations will be refund in 3 - 7 business days.',
                'Cancel Booking', [
              TextButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: SizedBox(
                            height: size.height * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    isNotValidate = false;
                    bool isCanRefund = true;
                    int amount = int.parse(detail['totalPayment'].toString());
                    if ((countryController?.text ?? '') == 'Japan') {
                      if (int.parse(detail['totalPayment'].toString()) - 1500 <=
                          0) {
                        isCanRefund = false;
                        amount = amount - 1500;
                      } else {
                        amount = amount - 1500;
                      }
                    } else {
                      amount = amount - 500;
                    }
                    if (isCanRefund && isAccepedRefundPolicy) {
                      Map refund = {
                        'contactAddress': contactAddress,
                        'amount': amount,
                        'bankAccountInfo': {
                          'country': countryController?.text,
                          'refundOption': refundOptionController?.text,
                          'swiftCode': swiftCodeController?.text,
                          'payNow': payNowController?.text,
                          'bankName': bankNameController?.text,
                          'accountNumber': accountNumberController?.text,
                        }
                      };

                      firestore
                          .collection('refund')
                          .doc(detail['jobOrderFileName'])
                          .set({
                        'refund': refund,
                        'uid': user?.uid,
                        'orderID': '${detail['jobOrderFileName']}',
                        'status': 'Pending',
                        'timeStamp': DateTime.now(),
                      });

                      detail['status'] = 'Canceled';
                      firestore
                          .collection('users')
                          .doc(user?.uid)
                          .collection('order')
                          .doc('${detail['jobOrderFileName']}')
                          .update({
                        'status': detail['status'],
                        'refund': refund,
                      }).then((value) => () {
                                setState(() {
                                  devtools.log("doc Toursit update status");
                                });
                              });

                      // final documentUserSnapshot =
                      //     await firestore.collection('user').doc(user?.uid).get();
                      // final userData = documentUserSnapshot.data();
                      FirebaseApp tourGuideApp = await Firebase.initializeApp(
                        name: 'tourGuideApp', //note ผิดแน่ แต่ทำงานได้ งงอยู่
                        options:
                            DefaultFirebaseOptionsTourGuide.currentPlatform,
                      );
                      FirebaseFirestore tourGuideAppFirestore =
                          FirebaseFirestore.instanceFor(app: tourGuideApp);
                      String tourguideID =
                          detail['tourGuideInfo']['tourGuideID'];
                      if (detail['replacer'] != null) {
                        if (detail['replacer']['tourGuideID'] != null) {
                          tourguideID = detail['replacer']['tourGuideID'];
                        }
                      }

                      final collectionRef = tourGuideAppFirestore
                          .collection('users')
                          .doc(tourguideID);
                      final querySnapshot = await collectionRef.get();
                      final tourGuideData = querySnapshot.data();
                      List tourGuideWorkDay = tourGuideData?['workDay'];
                      List tourGuideFreeDay = tourGuideData?['freeDay'];
                      DateTime datePlan =
                          DateFormat("dd-MM-yyyy").parse(detail['datePlan']);
                      tourGuideWorkDay
                          .remove(DateFormat("yyyy-MM-dd").format(datePlan));
                      tourGuideFreeDay
                          .add(DateFormat("yyyy-MM-dd").format(datePlan));
                      tourGuideAppFirestore
                          .collection('users')
                          .doc(tourguideID)
                          .update({
                        'workDay': tourGuideWorkDay,
                        'freeDay': tourGuideFreeDay
                      });
                      tourGuideAppFirestore
                          .collection('users')
                          .doc(tourguideID)
                          .collection('order')
                          .doc('${detail['jobOrderFileName']}')
                          .update({
                        'status': detail['status'],
                      }).then((value) {
                        setState(() {
                          devtools.log("doc tourGuideApp update status");
                          Navigator.of(context)
                            ..pop()
                            ..pop()
                            ..pop()
                            ..pop()
                            ..pop();
                        });
                      });
                    } else if (!isAccepedRefundPolicy) {
                      showPopupDialog(
                          context,
                          'Please read and check the check box to agree our Refund policy',
                          'Check again', [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                ..pop()
                                ..pop();
                            },
                            child: const Text("OK"))
                      ]);
                    } else {
                      showPopupDialog(
                          context,
                          "You can't get refund because total refund = $amount",
                          "Can't Refund", [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                ..pop()
                                ..pop();
                            },
                            child: const Text("OK"))
                      ]);
                    }
                  },
                  child: const Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
            ]);
            // FocusScope.of(context).unfocus();
            // final email = emailController!.text;
            // devtools.log(email);
            // if (formKey.currentState!.validate()) {
            //   formKey.currentState!.save();
            //   resetPassword();
            //   devtools.log('sent resetPassword email');
            //   check
            //       ? ScaffoldMessenger.of(context)
            //           .showSnackBar(snackBar)
            //       : null;
            // } else {
            //   devtools.log('not validate');
            // }
          } else {
            setState(() {
              if (contactAddress == null) {
                isNotValidate = true;
              } else {
                isNotValidate = false;
              }
            });
          }
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
