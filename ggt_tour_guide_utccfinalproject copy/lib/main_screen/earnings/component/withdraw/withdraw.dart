import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/earnings/component/withdraw/component/select_bank.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/main_screen.dart';
import 'package:ggt_tour_guide_utccfinalproject/widget/show_error_dialog.dart';
import 'package:ggt_tour_guide_utccfinalproject/widget/text_form.dart';
import 'dart:developer' as devtools show log;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../../../constant.dart';
import '../../../../utillties/custom_page_route.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({super.key});

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  Map? transactions;
  List? allBankDetail;
  Map? bankDetail;
  bool isGetData = false;
  String earnings = '0';
  int available = 0;
  final formKey = GlobalKey<FormState>();

  TextEditingController? amountController;

  @override
  void initState() {
    amountController = TextEditingController();

    amountController?.text = '';
    super.initState();
  }

  @override
  void dispose() {
    amountController?.dispose();
    super.dispose();
  }

  // List bankName = [];
  Future getUserData() async {
    devtools.log('in getUserData()');
    final documentUserSnapshot =
        await firestore.collection('users').doc(user?.uid).get();
    userData = documentUserSnapshot.data();
    transactions = userData?['transactions'];
    if (userData?['earnings'] == null) {
      earnings = '0';
    } else {
      earnings = userData?['earnings'].toString() ?? '0';
    }
    // earnings = userData?['earnings'].toString() ?? '0';
    available = int.parse(earnings);
    allBankDetail = userData?['bankDetail'];
    if (allBankDetail != null) {
      bankDetail = allBankDetail?[0];
    }
    isGetData = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getUserData(),
        builder: ((context, snapshot) {
          if (isGetData) {
            return Scaffold(
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {
              //     devtools.log('tap floatingActionButton');
              //     try {
              //       // setState(() {
              //       //   bankDetail = {
              //       //     "bankName": 'test bankName',
              //       //     // 'branchName': 'test branchName',
              //       //     'accountName': 'test accountName',
              //       //     'accountNumber': 'test accountNumber'
              //       //   };
              //       // });
              //       String tempStr = transactions?.length.toString() ?? '';
              //       int tempInt = int.parse(tempStr);
              //       int countId = tempInt + 1;
              //       devtools.log('${countId}');
              //     } catch (e) {
              //       devtools.log('e : $e');
              //     }
              //   },
              // ),
              backgroundColor: primaryBackgroundColor,
              appBar: AppBar(
                backgroundColor: primaryBackgroundColor,
                title: const Text("Withdraw"),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: secondaryBackgroundColor),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
              body: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: secondaryBackgroundColor.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.account_balance_wallet),
                            Text('Available: $available THB',
                                style: const TextStyle(
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: secondaryBackgroundColor.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Select Bank',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            InkWell(
                              onTap: () {
                                devtools.log('tap Selecet Bank');
                                Navigator.of(context)
                                    .push(FadePageRoute(const SelectBank()))
                                    .then((res) {
                                  setState(() {
                                    getUserData();
                                  });
                                });
                              },
                              child: Container(
                                height: size.height * 0.1,
                                width: size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      secondaryBackgroundColor.withOpacity(0.1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.account_balance,
                                            size: 30,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.1,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: bankDetail == null
                                                  ? [
                                                      const Text(
                                                        'Add your bank account',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      )
                                                    ]
                                                  : [
                                                      Text(
                                                        '${bankDetail?['bankName']}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${bankDetail?['accountName']}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${bankDetail?['accountNumber']}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.025,
                            ),
                            const Text('Withdraw Amount',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            Form(
                              key: formKey,
                              child: textForm(
                                  null,
                                  'THB',
                                  false,
                                  false,
                                  amountController,
                                  context,
                                  null,
                                  RequiredValidator(
                                      errorText: 'Amount is required'),
                                  'Amount',
                                  null,
                                  true,
                                  false),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: secondaryBackgroundColor.withOpacity(0.1),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Summarry',
                                      style: TextStyle(
                                        fontSize: 20,
                                      )),
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Account number',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: Text(
                                            bankDetail == null
                                                ? ''
                                                : '${bankDetail?['accountNumber']}',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                      color: secondaryBackgroundColor
                                          .withOpacity(0.5)),
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Account Name',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: Text(
                                            bankDetail == null
                                                ? ''
                                                : '${bankDetail?['accountName']}',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                      color: secondaryBackgroundColor
                                          .withOpacity(0.5)),
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Bank Name',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: Text(
                                            bankDetail == null
                                                ? ''
                                                : '${bankDetail?['bankName']}',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                      color: secondaryBackgroundColor
                                          .withOpacity(0.5)),
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Receive Amount',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: Text(
                                            '${amountController?.text} THB',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                      color: secondaryBackgroundColor
                                          .withOpacity(0.5)),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                ]))),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                      child: InkWell(
                        onTap: () async {
                          devtools.log("tap Check details before withdraw");
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState!.validate()) {
                            if (int.parse(amountController?.text ?? '0') >
                                available) {
                              showErrorDialog(context,
                                  'You enter more amount than you have.');
                            } else if (bankDetail == null) {
                              showErrorDialog(context, 'Please select bank');
                            } else if (int.parse(
                                    amountController?.text ?? '0') ==
                                0) {
                              showErrorDialog(
                                  context, 'You can not withdraw 0 THB');
                            } else {
                              int earnings = available -
                                  int.parse(amountController?.text ?? '0');
                              // transactions = userData?['transactions'];
                              String timeStamp = DateFormat('dd/MM/yyyy, HH:mm')
                                  .format(DateTime.now());
                              String tempStr =
                                  transactions?.length.toString() ?? '0';
                              int tempInt = int.parse(tempStr);
                              int countId = tempInt + 1;
                              // devtools.log('${countId}');
                              String transactionsID = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              transactions?['$countId'] = {
                                'total': amountController?.text,
                                'timeStamp': timeStamp,
                                'type': 'Withdraw',
                                'status': 'Pending',
                                'bankDetail': bankDetail,
                                'transactionsID': transactionsID,
                              };
                              firestore
                                  .collection('users')
                                  .doc(user?.uid)
                                  .update({
                                'earnings': earnings,
                                'transactions': transactions
                              });

                              firestore
                                  .collection('withdraw')
                                  .doc(transactionsID)
                                  .set({
                                'total': amountController?.text,
                                'timeStamp': timeStamp,
                                'type': 'Withdraw',
                                'status': 'Pending',
                                'bankDetail': bankDetail,
                                'transactionsID': transactionsID,
                                'uid': user?.uid
                              });

                              // Navigator.of(context).pop(true);
                              Navigator.of(context).pushAndRemoveUntil(
                                  FadePageRoute(MainScreen(index: 3)),
                                  (Route<dynamic> route) => false);
                            }
                          }
                          // Navigator.of(context)
                          //     .push(FadePageRoute(const RegisterScreen()));
                        },
                        child: Container(
                          height: size.height * 0.07,
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: primaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Check details before withdraw',
                                style: TextStyle(
                                  color: secondaryBackgroundColor,
                                  fontSize: size.height * 0.023,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }
        }));
  }
}
