import 'package:flutter/material.dart';

// var
const appName = 'Globle Guide (tour guide)';

// colors
Color secondaryColor = HexColor('#f45e29');
Color primaryColor = HexColor('#006da5');
Color primaryColorIcon = const Color.fromARGB(255, 21, 111, 185);
// Color primaryColor = Colors.pink;
// Color secondaryColor = const Color.fromARGB(255, 232, 144, 61);
// Color primaryColor = const Color.fromARGB(255, 21, 131, 80);
// Color secondaryColor = const Color.fromARGB(255, 232, 144, 61);
// Color tertiaryColor = Colors.orange;
// Color primaryColor = const Color.fromARGB(255, 12, 29, 58);

// Color primaryColor = HexColor('#FB836B');
// Color secondaryColor = HexColor('#7F6698');
// Color tertiaryColor = Colors.orange;
// Color alternateColor = HexColor('#EBDBCE');
Color primaryBackgroundColor = HexColor('#1c2021');
Color secondaryBackgroundColor = Colors.white;
Color primaryTextColor = Colors.white;
// Color secondaryTextColor = HexColor('#8B9BA8');
Color secondaryTextColor = Colors.grey;
Color tertiaryTextColor = Colors.black;
Color deactivatedText = const Color.fromARGB(255, 157, 155, 155);

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
