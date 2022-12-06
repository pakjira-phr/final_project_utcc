import 'package:flutter/cupertino.dart';


void showSheet(
  BuildContext context, {
  required Widget child,
  required VoidCallback onClicked,
}) =>
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          child,
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: onClicked,
          child: const Text('Done'),
        ),
      ),
    );
