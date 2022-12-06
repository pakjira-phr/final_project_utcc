import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/earnings/component/withdraw/component/select_add_bank.dart';
import 'package:ggt_tour_guide_utccfinalproject/widget/text_form.dart';
import 'dart:developer' as devtools show log;

import '../../../../../constant.dart';
import '../../../../../utillties/custom_page_route.dart';

// ignore: must_be_immutable
class AddBankAccount extends StatefulWidget {
  AddBankAccount({super.key, required this.selectBankName});
  String selectBankName;
  @override
  State<AddBankAccount> createState() =>
      // ignore: no_logic_in_create_state
      _AddBankAccountState(selectBankName: selectBankName);
}

class _AddBankAccountState extends State<AddBankAccount> {
  _AddBankAccountState({required this.selectBankName});
  String selectBankName;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? bankName;
  List? bankNameList;
  Map? bankDetail;
  bool isGetData = false;
  final formKey = GlobalKey<FormState>();

  List? allBankDetail;
  Map<String, dynamic>? userData;
  Future getBankNameList() async {
    devtools.log('getUserData()');
    final documentBankSnapshot =
        await firestore.collection('bank').doc('thaiBankAccount').get();
    bankName = documentBankSnapshot.data();
    bankNameList = bankName?.values.toList();

    if (selectBankName == '') {
      selectBankName = bankNameList?[0];
    }
    final documentUserSnapshot =
        await firestore.collection('users').doc(user?.uid).get();
    userData = documentUserSnapshot.data();
    allBankDetail = userData?['bankDetail'] ?? [];
    isGetData = true;
  }

  TextEditingController? accountNameController;
  TextEditingController? accountNumberController;

  @override
  void initState() {
    accountNameController = TextEditingController();
    accountNumberController = TextEditingController();

    accountNameController?.text = '';
    accountNumberController?.text = '';
    super.initState();
  }

  @override
  void dispose() {
    accountNameController?.dispose();
    accountNumberController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: getBankNameList(),
        builder: ((context, snapshot) {
          if (isGetData) {
            return Scaffold(
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {
              //     devtools.log('tap floatingActionButton');
              //     try {
              //       setState(() {});
              //       getBankNameList();
              //       devtools.log('bankName : $bankNameList}');
              //     } catch (e) {
              //       devtools.log('e : $e');
              //     }
              //   },
              // ),
              backgroundColor: primaryBackgroundColor,
              appBar: AppBar(
                backgroundColor: primaryBackgroundColor,
                title: const Text("Add Bank Account"),
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
                child: Container(
                  // height: size.height * 0.5,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                            onTap: () async {
                              devtools.log('tap Selecet Bank');

                              Navigator.of(context)
                                  .push(FadePageRoute(SelectAddBank(
                                bankNameList: bankNameList ?? [],
                                selectBankName: selectBankName,
                              )))
                                  .then((value) {
                                setState(() {
                                  selectBankName = value;
                                });
                              });
                            },
                            child: Container(
                                height: size.height * 0.08,
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
                                        Row(children: [
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
                                                  children: [
                                                    Text(
                                                      selectBankName,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    )
                                                  ]))
                                        ]),
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          size: 30,
                                        ),
                                      ]),
                                ))),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        const Text('Account Infomation',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        SizedBox(
                          height: size.height * 0.025,
                        ),
                        Form(
                            key: formKey,
                            child: Column(
                              //                       accountNameController?.text = '';
                              // accountNumberController?.text = '';
                              children: [
                                textForm(
                                    null,
                                    'Account Name',
                                    false,
                                    false,
                                    accountNameController,
                                    context,
                                    null,
                                    RequiredValidator(
                                        errorText: 'Account Name is required'),
                                    'Account Name',
                                    null,
                                    false,
                                    false),
                                SizedBox(
                                  height: size.height * 0.025,
                                ),
                                textForm(
                                    null,
                                    'Account Number',
                                    false,
                                    false,
                                    accountNumberController,
                                    context,
                                    null,
                                    RequiredValidator(
                                        errorText:
                                            'Account Number is required'),
                                    'Account Number',
                                    null,
                                    true,
                                    false),
                              ],
                            )),
                        SizedBox(
                          height: size.height * 0.025,
                        ),
                        InkWell(
                          onTap: () {
                            devtools.log('tap Submit');
                            if (formKey.currentState!.validate()) {
                              Map bankDetail = {
                                "bankName": selectBankName,
                                // 'branchName': 'test branchName',
                                'accountName': accountNameController?.text,
                                'accountNumber': accountNumberController?.text
                              };
                              allBankDetail?.add(bankDetail);
                              firestore
                                  .collection('users')
                                  .doc(user?.uid)
                                  .update({
                                'bankDetail': allBankDetail,
                              });
                              Navigator.of(context).pop(true);
                            }
                          },
                          child: Container(
                            height: size.height * 0.08,
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: primaryColor.withOpacity(0.9),
                            ),
                            child: const Center(
                                child: Text('Submit',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ))),
                          ),
                        )
                      ],
                    ),
                  ),
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
}
