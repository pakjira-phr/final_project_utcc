import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/main_screen/component/job_detail/replacer/inside_replacer/inside_replacer.dart';

import '../../../../constant.dart';
import '../../../../utillties/custom_page_route.dart';
import '../../../../widget/setting_screen/icon_style.dart';
import '../../../../widget/setting_screen/settings_group.dart';
import '../../../../widget/setting_screen/settings_item.dart';
import 'dart:developer' as devtools show log;

import 'outside_replacer.dart';

// ignore: must_be_immutable
class ReplacerScreen extends StatefulWidget {
  ReplacerScreen(
      {super.key,
      required this.detail,
      required this.indexToBack,
      required this.orderAllData});
  Map detail;
  int indexToBack;
  Map orderAllData;

  @override
  // ignore: no_logic_in_create_state
  State<ReplacerScreen> createState() => _ReplacerScreenState(
      detail: detail, indexToBack: indexToBack, orderAllData: orderAllData);
}

class _ReplacerScreenState extends State<ReplacerScreen> {
  _ReplacerScreenState(
      {required this.detail,
      required this.indexToBack,
      required this.orderAllData});
  Map detail;
  int indexToBack;
  Map orderAllData;
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
            padding:
                const EdgeInsets.only(left: 30, right: 20, top: 20, bottom: 20),
            child: Text(
              "Select Replacer",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                  fontSize: 30),
              textAlign: TextAlign.left,
            ),
          ),
          detail['isReplacerJob'] == true
              ? SettingsGroup(items: [
                  SettingsItem(
                    onTap: () {
                      devtools.log("Go to Outsider");
                      Navigator.of(context).push(FadePageRoute(OutsideReplacer(
                          detail: detail,
                          indexToBack: indexToBack,
                          orderAllData: orderAllData)));
                    },
                    icons: CupertinoIcons.person_crop_circle_fill,
                    title: "Select from Outsider",
                    subtitle: "For replacer who don't have an account",
                    iconStyle: IconStyle(
                      backgroundColor: primaryColor,
                    ),
                  ),
                ])
              : SettingsGroup(items: [
                  SettingsItem(
                    onTap: () {
                      devtools.log("Go to Insider");
                      // Navigator.of(context).push(FadePageRoute(const IDCardInfo()));
                      Navigator.of(context).push(FadePageRoute(InsideReplacer(
                        detail: detail,
                        indexToBack: indexToBack,
                        orderAllData: orderAllData,
                        getFilter: const [],
                        getFilterGender: const [],
                        getFilterLanguages: const [],
                      )));
                    },
                    icons: CupertinoIcons.creditcard,
                    title: "Select from Insider",
                    subtitle: "For select tour guide in our application",
                    iconStyle: IconStyle(
                      backgroundColor: primaryColor,
                    ),
                  ),
                  SettingsItem(
                    onTap: () {
                      devtools.log("Go to Outsider");
                      Navigator.of(context).push(FadePageRoute(OutsideReplacer(
                          detail: detail,
                          indexToBack: indexToBack,
                          orderAllData: orderAllData)));
                    },
                    icons: CupertinoIcons.person_crop_circle_fill,
                    title: "Select from Outsider",
                    subtitle: "For replacer who don't have an account",
                    iconStyle: IconStyle(
                      backgroundColor: primaryColor,
                    ),
                  ),
                ]),
        ],
      ),
    );
  }
}
