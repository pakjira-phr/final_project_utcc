import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ggt_admin_utccfinalproject/constant.dart';

// ignore: must_be_immutable
class ReviewDetail extends StatefulWidget {
  ReviewDetail({super.key, required this.reviewList});
  Map reviewList;

  @override
  State<ReviewDetail> createState() =>
      // ignore: no_logic_in_create_state
      _ReviewDetailState(reviewList: reviewList);
}

class _ReviewDetailState extends State<ReviewDetail> {
  _ReviewDetailState({required this.reviewList});
  Map reviewList;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Review Detail',
          style: TextStyle(color: primaryBackgroundColor),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: primaryBackgroundColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  'Order Id : ${reviewList['orderID']}',
                  style: TextStyle(
                      fontSize: size.width * 0.05, fontWeight: FontWeight.bold),
                  // textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  'review by : ${reviewList['touristUid']}',
                  style: TextStyle(fontSize: size.width * 0.04),
                  // textAlign: TextAlign.left,
                ),
              ),
              Divider(
                color: primaryTextColor.withOpacity(0.5),
              ),
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
                      // itemSize: 35,
                      ignoreGestures: true,
                      updateOnDrag: true,
                      initialRating:
                          double.parse(reviewList['rating'].toString()),
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (ratingUpdate) {},
                    ),
                    SizedBox(
                      width: size.width * 0.03,
                    ),
                    Text(
                      reviewList['rating'].toString(),
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
                // controller: commentController,
                initialValue: reviewList['comment'].toString(),
                readOnly: true,
                keyboardType: TextInputType.multiline,
                minLines: 7,
                maxLines: 7,

                decoration: InputDecoration(
                    labelText: 'Comment',
                    hintText: 'Enter Comment',
                    labelStyle:
                        const TextStyle(fontSize: 25, color: primaryTextColor),
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 17),
                    // maxLines: 3,
                    // Display the number of entered characters
                    counterText:
                        '${reviewList['comment'].toString().length.toString()} / 300 character(s)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
