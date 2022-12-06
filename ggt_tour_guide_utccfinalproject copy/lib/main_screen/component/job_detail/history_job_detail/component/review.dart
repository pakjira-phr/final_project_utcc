import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:developer' as devtools show log;

import 'package:ggt_tour_guide_utccfinalproject/constant.dart';



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

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     review = {
      //       'rating': rating,
      //       'comment': commentController?.text,
      //     };
      //     devtools.log('$review');
      //   },
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
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
                      ignoreGestures:  true,
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
                readOnly:  true,
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
}
