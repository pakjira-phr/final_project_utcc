import 'package:flutter/cupertino.dart';
import 'package:ggt_tour_guide_utccfinalproject/widget/setting_screen/settings_group.dart';
import 'package:ggt_tour_guide_utccfinalproject/widget/setting_screen/settings_item.dart';

import 'package:flutter/material.dart';

import '../../../../constant.dart';
import 'dart:developer' as devtools show log;

import '../../../../utillties/custom_page_route.dart';
import '../../../../widget/setting_screen/icon_style.dart';



import 'component/general_info.dart';
import 'component/id_card_info.dart';
import 'component/license_info.dart';

class PersonnalInfo extends StatefulWidget {
  const PersonnalInfo({super.key});


  @override
  State<PersonnalInfo> createState() => _PersonnalInfoState();
}

class _PersonnalInfoState extends State<PersonnalInfo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: size.height * 0.06,
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: secondaryBackgroundColor),
            onPressed: () {
              // FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            },
          ),
          elevation: 0,
        ),
        backgroundColor: primaryBackgroundColor,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 20, top: 20, bottom: 20),
              child: Text(
                "Personnal information",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontSize: 30),
                textAlign: TextAlign.left,
              ),
            ),
            SettingsGroup(items: [
              SettingsItem(
                onTap: () {
                  devtools.log("Go to GeneralInfo");
                  Navigator.of(context)
                      .push(FadePageRoute(const GeneralInfo()));
                },
                icons: CupertinoIcons.person_crop_circle_fill,
                title: "General information",
                subtitle: "Update your name, date of birth, etc.",
                iconStyle: IconStyle(
                  backgroundColor: primaryColor,
                ),
              ),
              SettingsItem(
                onTap: () {
                  devtools.log("Go to IDCardInfo");
                  Navigator.of(context).push(FadePageRoute(const IDCardInfo()));
                },
                icons: CupertinoIcons.creditcard,
                title: "Thai ID card information",
                subtitle: "Manage your Thai ID card information",
                iconStyle: IconStyle(
                  backgroundColor: primaryColor,
                ),
              ),
              SettingsItem(
                onTap: () {
                  devtools.log("Go to LicenseInfo");
                  Navigator.of(context)
                      .push(FadePageRoute(const LicenseInfo()));
                },
                icons: CupertinoIcons.creditcard,
                title: "Tourist Guide Licenes",
                subtitle: "Manage your Tourist Guide Licenes",
                iconStyle: IconStyle(
                  backgroundColor: primaryColor,
                ),
              ),
            ]),
          ],
        ));
  }
}
