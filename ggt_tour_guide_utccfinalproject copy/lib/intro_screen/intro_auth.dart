import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:developer' as devtools show log;

import '../constant.dart';
import '../utillties/custom_page_route.dart';
import 'login.dart';
import 'register.dart';

class IntroAuthScreen extends StatefulWidget {
  const IntroAuthScreen({super.key});

  @override
  State<IntroAuthScreen> createState() => _IntroAuthScreenState();
}

class _IntroAuthScreenState extends State<IntroAuthScreen> {
  PageController? pageViewController;
  @override
  void initState() {
    pageViewController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        toolbarHeight: size.height * 0.09,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/logo/TourGuideLogo2.png',
              width: size.width * 0.1,
            ),
            SizedBox(
              width: size.width * 0.03,
            ),
            Text(
              appName,
              style: TextStyle(fontSize: 20, color: primaryTextColor),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {},
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  // height: size.height * 0.5,
                  //height: 500
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                        child: PageView(
                          controller: pageViewController,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 12, 12, 12),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.14,
                                  ),
                                  Image.asset(
                                    'assets/images/intro_auth_guide1.png',
                                    width: size.width * 0.5,
                                    height: size.height * 0.23,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.058,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 2, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Earn More',
                                            style: TextStyle(
                                                fontSize: 27,
                                                color: primaryTextColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 10, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "With more tourist on Global Guide, the opportunities to earn are endless",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: primaryTextColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 12, 12, 12),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.04,
                                  ),
                                  Image.asset(
                                    'assets/images/intro_auth_guide2.png',
                                    width: size.width * 0.6,
                                    height: size.height * 0.253,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.09,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 30, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Safety',
                                            style: TextStyle(
                                                fontSize: 27,
                                                color: primaryTextColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 10, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Be your own boss by select day you want to work though our secure network',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: primaryTextColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 12, 12, 12),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.06,
                                  ),
                                  Image.asset(
                                    'assets/images/intro_auth_guide3.png',
                                    width: size.width * 0.75,
                                    height: size.height * 0.35,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 30, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Community',
                                            style: TextStyle(
                                                fontSize: 27,
                                                color: primaryTextColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 10, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Be part of Global Guide Thailand community',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: primaryTextColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 1),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                          child: SmoothPageIndicator(
                            controller: pageViewController ??=
                                PageController(initialPage: 0),
                            count: 3,
                            axisDirection: Axis.horizontal,
                            onDotClicked: (i) {
                              pageViewController!.animateToPage(
                                i,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            effect: ExpandingDotsEffect(
                              expansionFactor: 2,
                              spacing: 8,
                              radius: 16,
                              dotWidth: 16,
                              dotHeight: 4,
                              dotColor: secondaryTextColor,
                              activeDotColor: secondaryColor,
                              paintStyle: PaintingStyle.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 16),
                child: InkWell(
                  onTap: () async {
                    devtools.log("go to LoginScreen");
                    Navigator.of(context)
                        .push(FadePageRoute(const LoginScreen()));
                  },
                  child: Container(
                    height: size.height * 0.07,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondaryBackgroundColor,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     spreadRadius: 2,
                      //     blurRadius: 7,
                      //     offset:
                      //         const Offset(0, 3), // changes position of shadow
                      //   ),
                      // ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: size.height * 0.023,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                child: InkWell(
                  onTap: () async {
                    devtools.log("Go to RegisterScreen");
                    Navigator.of(context)
                        .push(FadePageRoute(const RegisterScreen()));
                  },
                  child: Container(
                    height: size.height * 0.07,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     spreadRadius: 2,
                      //     blurRadius: 7,
                      //     offset:
                      //         const Offset(0, 3), // changes position of shadow
                      //   ),
                      // ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(
                            color: secondaryBackgroundColor,
                            fontSize: size.height * 0.023,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
