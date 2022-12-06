import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:developer' as devtools show log;

import '../../../firebase_options_tour_guide.dart';
import '../../../utillties/custom_page_route.dart';
import '../../../utillties/get_message.dart';
import '../../../widget/show_error_dialog.dart';
import '../../main_screen.dart';

// ignore: must_be_immutable
class Review extends StatefulWidget {
  // const Review({super.key});
  Review({
    super.key,
    required this.detail,
  });
  Map detail;

  @override
  // ignore: no_logic_in_create_state
  State<Review> createState() => _ReviewState(detail: detail);
}

class _ReviewState extends State<Review> {
  _ReviewState({
    required this.detail,
  });
  Map detail;

  Map<String, dynamic>? tourguideData;

  Map? review;

  double rating = 5.0;
  String ratingText = 'Amazing';
  TextEditingController? commentController;
  @override
  void initState() {
    commentController = TextEditingController();

    review = detail['review'];
    if (review != null) {
      rating = review?['rating'];
      commentController?.text = review?['comment'];
      switch (rating.toString()) {
        case ('1.0'):
          ratingText = 'Terrible';
          break;
        case ('2.0'):
          ratingText = 'Poor';
          break;
        case ('3.0'):
          ratingText = 'Fair';
          break;
        case ('4.0'):
          ratingText = 'Good';
          break;
        case ('5.0'):
          ratingText = 'Amazing';
          break;
        default:
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    commentController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future getTourGuideData() async {
      FirebaseApp tourGuideApp = await Firebase.initializeApp(
        name: 'tourGuideApp',
        options: DefaultFirebaseOptionsTourGuide.currentPlatform,
      );
      devtools.log('Initialized tourGuideApp');
      FirebaseFirestore tourGuideFirestore =
          FirebaseFirestore.instanceFor(app: tourGuideApp);
      final collectionRef = tourGuideFirestore
          .collection('users')
          .doc(detail['tourGuideInfo']['tourGuideID']);
      final querySnapshot = await collectionRef.get();
      tourguideData = querySnapshot.data();
      devtools.log('$tourguideData');
    }

    return Scaffold(
      backgroundColor: secondaryBackgroundColor,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     devtools.log('${detail['tourGuideInfo']['tourGuideID']}');
      //     await getTourGuideData();
      //     devtools.log('${tourguideData?['kpi']}');
      //     Map kpi = tourguideData?['kpi'];
      //     int kpi1star = int.parse(kpi['1star']);
      //     int kpi2star = int.parse(kpi['2star']);
      //     int kpi3star = int.parse(kpi['3star']);
      //     int kpi4star = int.parse(kpi['4star']);
      //     int kpi5star = int.parse(kpi['5star']);
      //     int kpiRatingsCount = int.parse(kpi['ratingsCount']) + 1;
      //     switch (rating.toString()) {
      //       case '1.0':
      //         kpi1star = kpi1star + 1;
      //         break;
      //       case '2.0':
      //         kpi2star = kpi2star + 1;
      //         break;
      //       case '3.0':
      //         kpi3star = kpi3star + 1;
      //         break;
      //       case '4.0':
      //         kpi4star = kpi4star + 1;
      //         break;
      //       case '5.0':
      //         kpi5star = kpi5star + 1;
      //         break;
      //       default:
      //     }
      //     double kpiScore = ((kpi5star * 5) +
      //             (kpi4star * 4) +
      //             (kpi3star * 3) +
      //             (kpi2star * 2) +
      //             (kpi1star * 1)) /
      //         kpiRatingsCount;
      //     devtools.log('kpiScore $kpiScore');
      //   },
      // ),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: Text(
          'Review',
          style: TextStyle(color: primaryTextColor),
        ),
        backgroundColor: secondaryBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          review == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        devtools.log('Submit');
                        review = {
                          'rating': rating,
                          'comment': commentController?.text,
                        };
                        try {
                          FirebaseFirestore firestore =
                              FirebaseFirestore.instance;
                          User? user = FirebaseAuth.instance.currentUser;
                          firestore
                              .collection('users')
                              .doc(user?.uid)
                              .collection('order')
                              .doc('${detail['jobOrderFileName']}')
                              .update({
                            'review': review,
                          }).then((value) => () {
                                    setState(() {
                                      devtools
                                          .log("doc touristApp update status");
                                    });
                                  });
                          FirebaseApp tourGuideApp =
                              await Firebase.initializeApp(
                            name: 'touristApp',
                            options:
                                DefaultFirebaseOptionsTourGuide.currentPlatform,
                          );
                          devtools.log('Initialized tourGuideApp');
                          FirebaseFirestore tourGuideFirestore =
                              FirebaseFirestore.instanceFor(app: tourGuideApp);
                          await getTourGuideData();
                          Map kpi = tourguideData?['kpi'];
                          int kpi1star = int.parse(kpi['1star']);
                          int kpi2star = int.parse(kpi['2star']);
                          int kpi3star = int.parse(kpi['3star']);
                          int kpi4star = int.parse(kpi['4star']);
                          int kpi5star = int.parse(kpi['5star']);
                          int kpiRatingsCount =
                              int.parse(kpi['ratingsCount']) + 1;
                          switch (rating.toString()) {
                            case '1.0':
                              kpi1star = kpi1star + 1;
                              break;
                            case '2.0':
                              kpi2star = kpi2star + 1;
                              break;
                            case '3.0':
                              kpi3star = kpi3star + 1;
                              break;
                            case '4.0':
                              kpi4star = kpi4star + 1;
                              break;
                            case '5.0':
                              kpi5star = kpi5star + 1;
                              break;
                            default:
                          }
                          double kpiScore = ((kpi5star * 5) +
                                  (kpi4star * 4) +
                                  (kpi3star * 3) +
                                  (kpi2star * 2) +
                                  (kpi1star * 1)) /
                              kpiRatingsCount;
                          Map kpiChange = {
                            'score': '$kpiScore',
                            'ratingsCount': '$kpiRatingsCount',
                            '1star': '$kpi1star',
                            '2star': '$kpi2star',
                            '3star': '$kpi3star',
                            '4star': '$kpi4star',
                            '5star': '$kpi5star',
                          };
                          tourGuideFirestore
                              .collection('users')
                              .doc(detail['tourGuideInfo']['tourGuideID'])
                              .update({'kpi': kpiChange});

                          tourGuideFirestore
                              .collection('users')
                              .doc(detail['tourGuideInfo']['tourGuideID'])
                              .collection('order')
                              .doc('${detail['jobOrderFileName']}')
                              .update({
                            'review': review,
                          }).then((value) {
                            setState(() {
                              devtools.log("doc TourGuide update status");
                            });
                            devtools.log('update sussces');
                            Navigator.of(context).pushAndRemoveUntil(
                                FadePageRoute(MainScreen(index: 1)),
                                (Route<dynamic> route) => false);
                          });
                        } on FirebaseAuthException catch (e) {
                          devtools.log(e.toString());
                          devtools.log(getMessageFromErrorCode(e.code));
                          showErrorDialog(context,
                              getMessageFromErrorCode(e.code).toString());
                        } catch (e) {
                          devtools.log(e.toString());
                          showErrorDialog(context, e.toString());
                        }
                        devtools.log('update sussces');
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: secondaryColor),
                      ),
                    ),
                  ],
                )
              : const SizedBox()
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              tourguide(size),
              const Divider(
                thickness: 1,
              ),
              review == null
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 8, left: 10, right: 10),
                      child: Text(
                        'Please rate your satisfaction with our tour guide service.',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Rating',
                      style: TextStyle(fontSize: size.width * 0.05),
                    ),
                    SizedBox(
                      width: size.width * 0.03,
                    ),
                    RatingBar.builder(
                      ignoreGestures: review == null ? false : true,
                      updateOnDrag: true,
                      initialRating: rating,
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (ratingUpdate) {
                        if (review == null) {
                          setState(() {
                            rating = ratingUpdate;
                            switch (rating.toString()) {
                              case ('1.0'):
                                ratingText = 'Terrible';
                                break;
                              case ('2.0'):
                                ratingText = 'Poor';
                                break;
                              case ('3.0'):
                                ratingText = 'Fair';
                                break;
                              case ('4.0'):
                                ratingText = 'Good';
                                break;
                              case ('5.0'):
                                ratingText = 'Amazing';
                                break;
                              default:
                            }
                          });
                        } else {
                          setState(() {
                            rating = rating;
                          });
                        }

                        devtools.log('$ratingUpdate $ratingText');
                      },
                    ),
                    SizedBox(
                      width: size.width * 0.03,
                    ),
                    Text(
                      ratingText,
                      style: TextStyle(
                          color: const Color.fromARGB(255, 198, 151, 9),
                          fontSize: size.width * 0.04),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              TextFormField(
                // maxLength: 300,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(300),
                ],
                controller: commentController,
                // initialValue: commentController?.text ?? '',
                readOnly: review == null ? false : true,
                keyboardType: TextInputType.multiline,
                minLines: 7,
                maxLines: 7,
                onChanged: (value) {
                  setState(() {
                    commentController?.text = value;
                    commentController?.selection = TextSelection.fromPosition(
                        TextPosition(offset: commentController!.text.length));
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Comment',
                    hintText: 'Enter Comment',
                    labelStyle:
                        TextStyle(fontSize: 25, color: primaryTextColor),
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 17),
                    // maxLines: 3,
                    // Display the number of entered characters
                    counterText:
                        '${commentController?.text.length.toString()} / 300 character(s)'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tourguide(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: secondaryBackgroundColor,
          ),
          height: size.height * 0.12,
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: CircleAvatar(
                      radius: size.height * 0.05,
                      backgroundImage: NetworkImage(
                          detail['tourGuideInfo']['photoProfileURL']),
                      //  NetworkImage(tourGuide['photoProfileURL'])
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.6,
                    // color: Colors.amber,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${detail['tourGuideInfo']['user_name']}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: primaryTextColor,
                          ),
                        ),
                        Text(
                          '(${detail['tourGuideInfo']['firstName']} ${detail['tourGuideInfo']['lastName']})',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: primaryTextColor,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.005,
                        ),
                        Flexible(
                          child: Text(
                            'Email : ${detail['tourGuideInfo']['email']}',
                            overflow: TextOverflow.ellipsis,
                            // maxLines: 1,
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: primaryTextColor,
                            ),
                          ),
                        ),
                        Text(
                          'Phone number : ${detail['tourGuideInfo']['phoneNumber']}',
                          overflow: TextOverflow.ellipsis,
                          // maxLines: 1,
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  '',
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
