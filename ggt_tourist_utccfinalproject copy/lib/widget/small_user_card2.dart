import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';

// ignore: must_be_immutable
class SmallUserCardd2 extends StatelessWidget {
  Color? cardColor;
  double? cardRadius;
  Color? backgroundMotifColor;
  VoidCallback? onTap;
  String? userName;
  Widget? userMoreInfo;
  ImageProvider? userProfilePic;

  SmallUserCardd2({
    super.key,
    required this.cardColor,
    required this.userName,
    required this.userProfilePic,
    required this.onTap,
    this.cardRadius = 30,
    this.backgroundMotifColor = Colors.white,
    this.userMoreInfo,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    var mediaQueryWidth = MediaQuery.of(context).size.width;

    userMoreInfo ??= Container();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: mediaQueryHeight * 0.13,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: cardColor,
          borderRadius:
              BorderRadius.circular(double.parse(cardRadius!.toString())),
        ),
        child: Container(
          margin: const EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: userProfilePic == null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: mediaQueryHeight / 18,
                    backgroundImage: userProfilePic,
                    child: userProfilePic == null
                        ? Icon(
                            Icons.account_circle,
                            size: mediaQueryHeight * 0.1,
                            color: tertiaryColor,
                          )
                        : null),
              ),
              SizedBox(
                width: userProfilePic == null
                    ? mediaQueryWidth * 0.59
                    : mediaQueryWidth * 0.53,
                // color: Colors.red,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 80, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName!,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: primaryTextColor,
                            ),
                          ),
                          userMoreInfo!,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userProfilePic == null
                      ? const SizedBox()
                      : Text(
                          '',
                          style: TextStyle(fontSize: mediaQueryWidth * 0.1),
                        ),
                  userProfilePic == null
                      ? const SizedBox()
                      : SizedBox(
                          width: mediaQueryWidth * 0.005,
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
