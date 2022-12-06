import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SmallUserCardd extends StatelessWidget {
  Color? cardColor;
  double? cardRadius;
  Color? backgroundMotifColor;
  VoidCallback? onTap;
  String? userName;
  Widget? userMoreInfo;
  ImageProvider? userProfilePic;

  SmallUserCardd({
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

    userMoreInfo ??= Container();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: mediaQueryHeight / 6,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.9),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: cardColor,
          borderRadius:
              BorderRadius.circular(double.parse(cardRadius!.toString())),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: backgroundMotifColor!.withOpacity(.1),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 400,
                backgroundColor: backgroundMotifColor!.withOpacity(.05),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: Align(
                        child: CircleAvatar(
                          radius: mediaQueryHeight / 18,
                          backgroundImage: userProfilePic ??
                              const AssetImage('assets/logo/logo_temp.png'),
                        ),
                      )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              userName!,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Colors.white,
                              ),
                            ),
                            userMoreInfo!,
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
