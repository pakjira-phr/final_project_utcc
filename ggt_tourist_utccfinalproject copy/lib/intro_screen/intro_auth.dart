import 'package:flutter/material.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:ggt_tourist_utccfinalproject/intro_screen/login.dart';
import 'package:ggt_tourist_utccfinalproject/intro_screen/register_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:developer' as devtools show log;

import '../utillties/custom_page_route.dart';

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
        automaticallyImplyLeading: false,
        title: Text(
          'Welcome',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: size.height * 0.045,
          ),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/intro_auth_1.png',
                                    width: size.width * 0.8,
                                    height: size.height * 0.35,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 8, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: const [
                                        Expanded(
                                          child: Text(
                                            'Welcome to $appName',
                                            style: TextStyle(fontSize: 27),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 8, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: const [
                                        Expanded(
                                          child: Text(
                                            "Your goals are our goals. Let $appName help you realize them",
                                            style: TextStyle(fontSize: 15),
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
                                  Image.asset(
                                    'assets/images/intro_auth_2.png',
                                    width: size.width * 0.8,
                                    height: size.height * 0.35,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 8, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: const [
                                        Expanded(
                                          child: Text(
                                            'Become Yourself in the Best Version',
                                            style: TextStyle(fontSize: 27),
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
                                      children: const [
                                        Expanded(
                                          child: Text(
                                            'Discover yourself and manage your trip plan in a way that suits you the most.',
                                            style: TextStyle(fontSize: 15),
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
                                  Image.asset(
                                    'assets/images/intro_auth_3.png',
                                    width: size.width * 0.8,
                                    height: size.height * 0.35,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 10, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: const [
                                        Expanded(
                                          child: Text(
                                            'Stay tuned for More Products and Services',
                                            style: TextStyle(fontSize: 27),
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
                                      children: const [
                                        Expanded(
                                          child: Text(
                                            'Stay tuned for many more travel and tour products or services to come',
                                            style: TextStyle(fontSize: 15),
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
                              activeDotColor: primaryColor,
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
                      color: tertiaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            color: secondaryBackgroundColor,
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(
                            color: tertiaryColor,
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
