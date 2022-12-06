import 'package:flutter/material.dart';

import 'settings_item.dart';
import 'settings_screen_utils.dart';

/// This component group the Settings items
// ignore: must_be_immutable
class SettingsGroup extends StatelessWidget {
  String? settingsGroupTitle;
  TextStyle? settingsGroupTitleStyle;
  List<SettingsItem> items;
  // Icons size
  double? iconItemSize;

  SettingsGroup(
      {super.key,
      this.settingsGroupTitle,
      this.settingsGroupTitleStyle,
      required this.items,
      this.iconItemSize = 25});

  @override
  Widget build(BuildContext context) {
    if (iconItemSize != null) {
      SettingsScreenUtils.settingsGroupIconSize = iconItemSize;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The title
          (settingsGroupTitle != null)
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    settingsGroupTitle!,
                    style: (settingsGroupTitleStyle == null)
                        ? const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)
                        : settingsGroupTitleStyle,
                  ),
                )
              : Container(),
          // The SettingsGroup sections
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.withOpacity(0.2))),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.grey,
                );
              },
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return items[index];
              },
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const ScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
