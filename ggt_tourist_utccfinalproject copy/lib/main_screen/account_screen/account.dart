import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:ggt_tourist_utccfinalproject/intro_screen/privacy_policy.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/account_screen/component/address_info.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/account_screen/component/contact_info.dart';
import 'package:ggt_tourist_utccfinalproject/main_screen/account_screen/component/edit_profile.dart';
import 'package:ggt_tourist_utccfinalproject/widget/popup_dialog.dart';
import 'dart:developer' as devtools show log;
import '../../intro_screen/intro_auth.dart';
import '../../intro_screen/terms_of_service.dart';
import '../../utillties/custom_page_route.dart';
import '../../widget/setting_screen/icon_style.dart';
import '../../widget/setting_screen/settings_group.dart';
import '../../widget/setting_screen/settings_item.dart';
import '../../widget/setting_screen/small_user_card.dart';
import 'component/change_password.dart';
import 'component/personnal_info.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  User? user;
  String? profileURL;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future getUser() async {
    user = FirebaseAuth.instance.currentUser;
    profileURL = user!.photoURL.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: secondaryBackgroundColor,
      body: FutureBuilder(
        future: getUser(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // devtools.log('user : $user');
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(children: [
                  SmallUserCardd(
                    userName: user?.displayName ?? 'error',
                    userMoreInfo: const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Edit Profile >",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    userProfilePic: user?.photoURL == null
                        ? null
                        : NetworkImage(profileURL!),
                    // : AssetImage(user!.photoURL.toString()),
                    cardColor: tertiaryColor,
                    onTap: () {
                      devtools.log("tap");
                      Navigator.of(context)
                          .push(FadePageRoute(const EditProfile()))
                          .then((value) {
                        setState(() {
                          user = FirebaseAuth.instance.currentUser;
                          profileURL = user!.photoURL.toString();
                        });
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Personnal  information",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SettingsGroup(items: [
                    SettingsItem(
                      onTap: () {
                        devtools.log("Go to PersonnalInfo");
                        // const page = ChangePassword();
                        Navigator.of(context)
                            .push(FadePageRoute(const PersonnalInfo()));
                      },
                      icons: CupertinoIcons.person_crop_circle_fill,
                      title: "Personnal information",
                      subtitle: "Update your passpot information",
                      iconStyle: IconStyle(
                          backgroundColor: primaryColor,
                          iconsColor: tertiaryColor),
                    ),
                    SettingsItem(
                      onTap: () {
                        devtools.log("Go to ContactInfo");
                        // const page = ChangePassword();
                        Navigator.of(context)
                            .push(FadePageRoute(const ContactInfo()));
                      },
                      icons: CupertinoIcons.phone_fill,
                      title: "Contact information",
                      subtitle: "Manage your phone number and email",
                      iconStyle: IconStyle(
                          backgroundColor: primaryColor,
                          iconsColor: tertiaryColor),
                    ),
                    SettingsItem(
                      onTap: () {
                        devtools.log("Go to AddressInfo");
                        // const page = ChangePassword();
                        Navigator.of(context).push(FadePageRoute(AddressInfo(
                          isFromAccountScreen: true,
                        )));
                      },
                      icons: Icons.home_filled,
                      title: "Address information",
                      subtitle: "Update your contract address information",
                      iconStyle: IconStyle(
                          backgroundColor: primaryColor,
                          iconsColor: tertiaryColor),
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Legal information",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SettingsGroup(
                    items: [
                      SettingsItem(
                        onTap: () {
                          devtools.log("Go to TermsOfServiceScreen");
                          Navigator.of(context).push(
                              FadePageRoute(const TermsOfServiceScreen()));
                        },
                        icons: Icons.info,
                        iconStyle: IconStyle(
                            backgroundColor: primaryColor,
                            iconsColor: tertiaryColor),
                        title: 'Terms of Service',
                        subtitle: "Our Terms of Service",
                      ),
                      SettingsItem(
                        onTap: () {
                          devtools.log("Go to PrivacyPolicyScreen");
                          Navigator.of(context)
                              .push(FadePageRoute(const PrivacyPolicyScreen()));
                        },
                        icons: Icons.info,
                        iconStyle: IconStyle(
                            backgroundColor: primaryColor,
                            iconsColor: tertiaryColor),
                        title: 'Privacy Policy',
                        subtitle: "Our Privacy Policy",
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Account Settings",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SettingsGroup(items: [
                    SettingsItem(
                      onTap: () {
                        devtools.log("Go to ChangePassword");
                        // const page = ChangePassword();
                        Navigator.of(context)
                            .push(FadePageRoute(const ChangePassword()));
                      },
                      icons: CupertinoIcons.repeat,
                      title: "Change Password",
                      subtitle: "Edit your password",
                      iconStyle: IconStyle(
                          backgroundColor: primaryColor,
                          iconsColor: tertiaryColor),
                    ),
                    // SettingsItem(
                    //   onTap: () {
                    //     showPopupDialog(
                    //         context, 'Are you sure?', 'Delete Account', [
                    //       TextButton(
                    //           onPressed: () async {
                    //             try {
                    //               firestore
                    //                   .collection("users")
                    //                   .doc(user?.uid)
                    //                   .delete()
                    //                   .then((_) {});

                    //               final storageRef = FirebaseStorage.instance
                    //                   .ref()
                    //                   .child("photo/${user?.uid}");
                    //               // final userStorageRef =
                    //               //     storageRef);
                    //               final listResult = await storageRef.listAll();
                    //               for (var item in listResult.items) {
                    //                 devtools
                    //                     .log("$item in ${listResult.items}");
                    //                 FirebaseStorage.instance
                    //                     .ref(item.fullPath)
                    //                     .delete();
                    //               }

                    //               await user?.delete();

                    //               devtools.log('delete user');
                    //               if (!mounted) return;
                    //               showPopupDialog(context, 'Delete Sucsses!',
                    //                   'Delete Sucsses', [
                    //                 TextButton(
                    //                     onPressed: () {
                    //                       Navigator.of(context)
                    //                           .pushAndRemoveUntil(
                    //                               FadePageRoute(
                    //                                   const IntroAuthScreen()),
                    //                               (Route<dynamic> route) =>
                    //                                   false);
                    //                     },
                    //                     child: const Text("OK"))
                    //               ]);

                    //               Navigator.of(context).push(
                    //                   FadePageRoute(const IntroAuthScreen()));
                    //             } on FirebaseAuthException catch (e) {
                    //               devtools.log(e.toString());
                    //               devtools.log(getMessageFromErrorCode(e.code));
                    //               showErrorDialog(
                    //                   context,
                    //                   getMessageFromErrorCode(e.code)
                    //                       .toString());
                    //             } catch (e) {
                    //               devtools.log(e.toString());
                    //               showErrorDialog(
                    //                   context,
                    //                   getMessageFromErrorCode(e.toString())
                    //                       .toString());
                    //               setState(() {});
                    //             }
                    //           },
                    //           child: const Text("Delete")),
                    //       TextButton(
                    //           onPressed: () {
                    //             Navigator.of(context).pop();
                    //           },
                    //           child: const Text("Cancel"))
                    //     ]);
                    //   },
                    //   icons: CupertinoIcons.delete_simple,
                    //   title: "Delete Account",
                    //   subtitle: "Delete account and all information",
                    //   iconStyle: IconStyle(
                    //     backgroundColor: tertiaryColor,
                    //   ),
                    // ),
                    SettingsItem(
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
                                        FadePageRoute(const IntroAuthScreen()),
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
                      icons: Icons.exit_to_app,
                      iconStyle: IconStyle(
                          backgroundColor: primaryColor,
                          iconsColor: tertiaryColor),
                      title: "Sign Out",
                      subtitle: "Good bye",
                    ),
                  ]),
                ]),
              );

            default:
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(color: primaryBackgroundColor),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ],
                ),
              );
          }
        }),
      ),
    );
  }
}
