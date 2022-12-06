import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;

  const CircleButton({Key? key, required this.onTap, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 30.0;

    return InkResponse(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}
