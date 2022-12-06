import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String content) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Error"),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"))
        ],
      );
    },
  );
}
