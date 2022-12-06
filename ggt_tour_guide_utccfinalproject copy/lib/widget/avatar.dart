import 'package:flutter/material.dart';

import '../constant.dart';


class Avatar extends StatelessWidget {
  final String? avatarUrl;
  final void Function()? onTap;

  const Avatar({super.key, required this.avatarUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: (avatarUrl == null)
            ? CircleAvatar(
                radius: size.height * 0.08,
                backgroundColor: secondaryColor,
                child: Icon(
                  Icons.person,
                  size: size.height * 0.07,
                  color: Colors.white,
                ),
              )
            : CircleAvatar(
                radius: size.height * 0.08,
                backgroundImage: NetworkImage(avatarUrl!),
              ),
      ),
    );
  }
}
