import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/earnings/component/withdraw/component/add_bank_account.dart';
import 'dart:developer' as devtools show log;

import '../../../../../constant.dart';
import '../../../../../utillties/custom_page_route.dart';

class SelectBank extends StatefulWidget {
  const SelectBank({super.key});

  @override
  State<SelectBank> createState() => _SelectBankState();
}

class _SelectBankState extends State<SelectBank> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  List? allBankDetail;
  Map? bankDetail;
  bool isGetData = false;

  Future getUserData() async {
    devtools.log('getUserData()');
    final documentUserSnapshot =
        await firestore.collection('users').doc(user?.uid).get();
    userData = documentUserSnapshot.data();
    allBankDetail = userData?['bankDetail'] ?? [];
    if (allBankDetail != null && allBankDetail!.isNotEmpty) {
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
              //       setState(() {
              //         bankDetail = {
              //           "bankName": 'test bankName',
              //           // 'branchName': 'test branchName',
              //           'accountName': 'test accountName',
              //           'accountNumber': 'test accountNumber'
              //         };
              //         allBankDetail?.add(bankDetail);
              //       });
              //       devtools.log('$allBankDetail');
              //     } catch (e) {
              //       devtools.log('e : $e');
              //     }
              //   },
              // ),
              backgroundColor: primaryBackgroundColor,
              appBar: AppBar(
                backgroundColor: primaryBackgroundColor,
                title: const Text("Select Bank Account"),
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
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    allBankDetail == null
                        ? const SizedBox()
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allBankDetail?.length,
                            itemBuilder: (context, index) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        devtools.log(
                                            'tap Selecet ${allBankDetail?[index]}');
                                        bankDetail = allBankDetail?[index];
                                        allBankDetail?.remove(bankDetail);
                                        allBankDetail?.insert(0, bankDetail);
                                        firestore
                                            .collection('users')
                                            .doc(user?.uid)
                                            .update({
                                          'bankDetail': allBankDetail,
                                        });
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Container(
                                        height: size.height * 0.1,
                                        width: size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: secondaryBackgroundColor
                                              .withOpacity(0.1),
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
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: bankDetail ==
                                                              null
                                                          ? [
                                                              const Text(
                                                                'Add your bank account',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              )
                                                            ]
                                                          : [
                                                              Text(
                                                                '${allBankDetail?[index]['bankName']}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              Text(
                                                                '${allBankDetail?[index]['accountName']}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              Text(
                                                                '${allBankDetail?[index]['accountNumber']}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // const Icon(
                                              //   Icons.arrow_drop_down,
                                              //   size: 30,
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    )
                                  ]);
                            }),
                    InkWell(
                      onTap: () {
                        devtools.log('tap Add Bank Account');
                        Navigator.of(context)
                            .push(FadePageRoute(AddBankAccount(
                          selectBankName: '',
                        )))
                            .then((res) {
                          setState(() {
                            getUserData();
                          });
                        });
                      },
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: secondaryBackgroundColor.withOpacity(0.1),
                        ),
                        child: const Center(
                            child: Text('+ Add Bank Account',
                                style: TextStyle(
                                  fontSize: 18,
                                ))),
                      ),
                    )
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
}
