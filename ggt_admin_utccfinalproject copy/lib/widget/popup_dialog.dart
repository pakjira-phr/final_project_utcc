import 'package:flutter/material.dart';

Future<void> showPopupDialog(
    BuildContext context, String content, String title, List<Widget>? actions) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions,
      );
    },
  );
}
