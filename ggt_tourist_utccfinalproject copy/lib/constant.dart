import 'package:flutter/material.dart';

// var
const appName = 'Globle Guide';

// colors
Color secondaryColor = const Color.fromARGB(255, 23, 123, 250);
Color primaryColor = const Color.fromARGB(255, 62, 230, 121);
Color darkPrimaryColor = const Color.fromARGB(255, 45, 169, 89);
Color tertiaryColor = Colors.black;
Color alternateColor = const Color.fromARGB(255, 230, 251, 145);
Color primaryBackgroundColor = Colors.white;
Color secondaryBackgroundColor = const Color.fromARGB(255, 245, 246, 252);

// Color secondaryColor = const Color.fromARGB(255, 232, 144, 61);
// Color primaryColor = const Color.fromARGB(255, 12, 29, 58);
// Color primaryColor = Colors.pink;
// Color primaryColor = const Color.fromARGB(255, 18, 45, 87);
// Color tertiaryColor = Colors.orange;
// Color primaryColor = HexColor('#FB836B');
// Color secondaryColor = HexColor('#7F6698');
// Color tertiaryColor = Colors.orange;
// Color alternateColor = HexColor('#EBDBCE');
// Color primaryBackgroundColor = const Color(0xFFF2F3F8);
// Color secondaryBackgroundColor = Colors.white;
Color primaryTextColor = HexColor('#0E151B');
// Color secondaryTextColor = HexColor('#8B9BA8');
Color secondaryTextColor = Colors.grey;
// Color secondaryTextColor = Colors.grey;
Color deactivatedText = const Color.fromARGB(255, 107, 107, 107);

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
