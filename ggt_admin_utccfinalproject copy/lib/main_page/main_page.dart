import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ggt_admin_utccfinalproject/constant.dart';
import 'package:ggt_admin_utccfinalproject/login.dart';
import 'package:ggt_admin_utccfinalproject/main_page/banned/banned_account_page.dart';
import 'package:ggt_admin_utccfinalproject/main_page/overview_page.dart';
import 'package:ggt_admin_utccfinalproject/main_page/refund/refund_page.dart';
import 'package:ggt_admin_utccfinalproject/main_page/withdraw/withdraw_page.dart';
import 'package:ggt_admin_utccfinalproject/widget/popup_dialog.dart';
import 'dart:developer' as devtools show log;

import '../utillties/custom_page_route.dart';

// ignore: must_be_immutable
class MainPage extends StatefulWidget {
  MainPage({super.key, required this.index});
  int index;

  @override
  // ignore: no_logic_in_create_state
  State<MainPage> createState() => _MainPageState(index: index);
}

class _MainPageState extends State<MainPage> {
  _MainPageState({required this.index});
  int index;
  List page = [
    const OverViewPage(),
    const WithdrawPage(),
    const BannedAccount(),
    const RefundPage(),
  ];
  List titleName = [
    'Overview',
    'Withdraw',
    'Disable Account',
    'Refund'
  ];
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          title: Text(titleName[index]),
        ),
        drawer: Drawer(
          backgroundColor: secondaryColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Image.asset(
                        'assets/logo/logo.png',
                      ),
                      title: const Text('GGT Admin',
                          style: TextStyle(color: Colors.white, fontSize: 26)),
                    ),
                    Divider(color: Colors.white.withOpacity(0.5)),
                    ListTile(
                      leading: Icon(
                        Icons.home,
                        color: index == 0 ? primaryColor : Colors.white,
                      ),
                      title: Text('Overview',
                          style: TextStyle(
                              color: index == 0 ? primaryColor : Colors.white)),
                      onTap: () {
                        setState(() {
                          index = 0;
                        });
                        Navigator.pop(context);
                        // Navigator.of(context).pushAndRemoveUntil(
                        //     FadePageRoute(const OverViewPage()),
                        //     (Route<dynamic> route) => false);
                      },
                    ),
                    Divider(color: Colors.white.withOpacity(0.5)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 15),
                      child: Text('Tour Guide',
                          style: TextStyle(color: Colors.grey)),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.account_balance_rounded,
                        color: index == 1 ? primaryColor : Colors.white,
                      ),
                      title: Text('Withdraw',
                          style: TextStyle(
                              color: index == 1 ? primaryColor : Colors.white)),
                      onTap: () {
                        setState(() {
                          index = 1;
                        });

                        Navigator.pop(context);
                      },
                    ),
                    // Divider(color: Colors.white.withOpacity(0.5)),
                    ListTile(
                      leading: Icon(Icons.train,
                          color: index == 2 ? primaryColor : Colors.white),
                      title: Text('Disable account',
                          style: TextStyle(
                              color: index == 2 ? primaryColor : Colors.white)),
                      onTap: () {
                        setState(() {
                          index = 2;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    Divider(color: Colors.white.withOpacity(0.5)),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 15),
                      child:
                          Text('Tourist', style: TextStyle(color: Colors.grey)),
                    ),
                    ListTile(
                      leading: Icon(Icons.money_off_csred_rounded,
                          color: index == 3 ? primaryColor : Colors.white),
                      title: Text('Refund',
                          style: TextStyle(
                              color: index == 3 ? primaryColor : Colors.white)),
                      onTap: () {
                        setState(() {
                          index = 3;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white.withOpacity(0.5)),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: const Text('Logout',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    showPopupDialog(context, 'Are you sure?', 'Logout', [
                      TextButton(
                          onPressed: () async {
                            devtools.log('tap logout');
                            devtools.log('logout');
                            try {
                              await FirebaseAuth.instance
                                  .signOut()
                                  .then((value) {
                                devtools.log('logout สำเร็จ');
                                Navigator.of(context).pushAndRemoveUntil(
                                    FadePageRoute(const LoginScreen()),
                                    (Route<dynamic> route) => false);
                              });
                            } catch (error) {
                              devtools.log("ERROR : $error");
                            }
                          },
                          child: const Text("Yes")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"))
                    ]);
                  },
                ),
              ),
            ],
          ),
        ),
        body: page[index]);
  }
}
