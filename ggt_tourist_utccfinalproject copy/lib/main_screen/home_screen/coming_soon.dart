import 'package:flutter/material.dart';

import '../../constant.dart';

class ComingSoonPage extends StatefulWidget {
  const ComingSoonPage({super.key});

  @override
  State<ComingSoonPage> createState() => _ComingSoonPageState();
}

class _ComingSoonPageState extends State<ComingSoonPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        toolbarHeight: size.height * 0.05,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: primaryBackgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/TouristLogo2.png',
              width: size.width * 0.5,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
              child: Text(
                'Coming soon',
                style: TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: tertiaryColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 120),
              child: Text(
                'Stay tuned for More Products and Services',
                style: TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: tertiaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // CircularProgressIndicator(
            //   color: tertiaryColor,
            // ),
          ],
        ),
      ),
    );
    
  }
}
