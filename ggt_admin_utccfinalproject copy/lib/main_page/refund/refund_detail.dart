import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:ggt_admin_utccfinalproject/constant.dart';
import 'package:ggt_admin_utccfinalproject/firebase_options_tourist.dart';

import '../../widget/popup_dialog.dart';
import '../../widget/show_error_dialog.dart';

// ignore: must_be_immutable
class RefundDetail extends StatefulWidget {
  // const RefundDetail({super.key});
  RefundDetail({super.key, required this.detail});
  Map detail;

  @override
  // ignore: no_logic_in_create_state
  State<RefundDetail> createState() => _RefundDetailState(detail: detail);
}

class _RefundDetailState extends State<RefundDetail> {
  _RefundDetailState({required this.detail});
  Map detail;
  final storageRef = FirebaseStorage.instance.ref();
  User? user = FirebaseAuth.instance.currentUser;
  Icon statusIcon = const Icon(Icons.error);
  bool isLoading = false;
  String? receiptPicURL;

  getStatusIcon() {
    String status = detail['status'];
    setState(() {
      if (status == 'Pending') {
        statusIcon = const Icon(Icons.pending);
        // } else if (status == 'Accepted') {
        //   statusIcon = const Icon(Icons.play_circle_sharp);
      } else if (status == 'In Progress') {
        statusIcon = const Icon(Icons.incomplete_circle_sharp);
      } else if (status == 'Finished') {
        statusIcon = const Icon(Icons.check_circle_rounded);
      } else {
        statusIcon = const Icon(Icons.error);
      }
    });
  }

  bool isChangePhotoLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    getStatusIcon();
    String status = detail['status'];
    receiptPicURL = detail['receiptPicURL'];
    return Scaffold(
        floatingActionButton: status == 'Finished' || status == 'Canceled'
            ? const SizedBox()
            : SizedBox(
                height: size.height * 0.07,
                width: size.width * 0.8,
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: primaryColor,
                  onPressed: () {
                    // devtools.log('$detail');
                    isLoading = true;
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: const Text('Are you sure'),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Are you sure to change status'),
                                    status == 'Pending'
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                                receiptPicURL == null
                                                    ? const SizedBox()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.network(
                                                          receiptPicURL!,
                                                          width: size.width,
                                                          height:
                                                              size.height * 0.5,
                                                        ),
                                                      ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: InkWell(
                                                          onTap: () async {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();

                                                            setState(() {
                                                              isChangePhotoLoading =
                                                                  true;
                                                            });
                                                            devtools.log(
                                                                'tap Change Photo');
                                                            XFile? pickedFile =
                                                                await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.gallery);
                                                            devtools
                                                                .log('Photo');
                                                            try {
                                                              File image = File(
                                                                  pickedFile!
                                                                      .path);
                                                              devtools.log(image
                                                                  .toString());

                                                              final pictureRef = storageRef
                                                                  .child(
                                                                      "photo")
                                                                  .child(
                                                                      '${user?.uid}')
                                                                  .child(
                                                                      'refundReceipt')
                                                                  .child(
                                                                      "${detail['orderID']}");
                                                              await pictureRef
                                                                  .putFile(
                                                                      image)
                                                                  .whenComplete(() =>
                                                                      devtools.log(
                                                                          'image added'));
                                                              String link =
                                                                  await pictureRef
                                                                      .getDownloadURL();
                                                              devtools.log(
                                                                  'Uploaded');
                                                              // user?.updatePhotoURL(link);
                                                              devtools.log(
                                                                  'link : $link');
                                                              receiptPicURL =
                                                                  link;
                                                              // firestore
                                                              //     .collection('users')
                                                              //     .doc('${user?.uid}')
                                                              //     .update(
                                                              //         {'thaiIdCardPic': link});
                                                              // devtools
                                                              //     .log('data added to firestore');
                                                              setState(() {
                                                                // idCardPicURL = link;
                                                                isChangePhotoLoading =
                                                                    false;
                                                              });
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              showPopupDialog(
                                                                  context,
                                                                  'Uplode Photo Successfully',
                                                                  'Success',
                                                                  [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            // idCardPicURL = link;
                                                                            isChangePhotoLoading =
                                                                                false;
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            "OK"))
                                                                  ]);
                                                            } catch (e) {
                                                              setState(() {
                                                                // idCardPicURL = link;
                                                                isChangePhotoLoading =
                                                                    false;
                                                              });
                                                              devtools.log(
                                                                  e.toString());
                                                              if (e.toString() ==
                                                                  'Null check operator used on a null value') {
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                showErrorDialog(
                                                                    context,
                                                                    'You did not choose any image');
                                                              } else {
                                                                setState(() {
                                                                  // idCardPicURL = link;
                                                                  isChangePhotoLoading =
                                                                      false;
                                                                });
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                showErrorDialog(
                                                                    context,
                                                                    e.toString());
                                                              }

                                                              setState(() {
                                                                isChangePhotoLoading =
                                                                    false;
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                              height:
                                                                  size.height *
                                                                      0.05,
                                                              width: size.width *
                                                                  0.4,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5),
                                                                      spreadRadius:
                                                                          1,
                                                                      blurRadius:
                                                                          7,
                                                                      offset: const Offset(
                                                                          0,
                                                                          3), // changes position of shadow
                                                                    ),
                                                                  ]),
                                                              child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          16.0,
                                                                      right:
                                                                          16.0),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        isChangePhotoLoading
                                                                            ? Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: const [
                                                                                  CircularProgressIndicator(
                                                                                    color: Colors.black,
                                                                                  )
                                                                                ],
                                                                              )
                                                                            : const Text(
                                                                                'Uplode receipt',
                                                                                style: TextStyle(
                                                                                  color: primaryColor,
                                                                                  fontSize: 17,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                      ]))))),
                                                ),
                                              ])
                                        : const SizedBox()
                                  ]),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () async {
                                      if (receiptPicURL == null) {
                                        showErrorDialog(
                                            context, 'Uplode receipt please');
                                      } else {
                                        setState(() {
                                          if (status == 'Pending') {
                                            status = 'In Progress';
                                          } else if (status == 'In Progress') {
                                            status = 'Finished';
                                          }
                                        });
                                        FirebaseApp touristApp =
                                            await Firebase.initializeApp(
                                          name: 'touristApp',
                                          options: DefaultFirebaseOptionsTourist
                                              .currentPlatform,
                                        );
                                        FirebaseFirestore touristAppFirestore =
                                            FirebaseFirestore.instanceFor(
                                                app: touristApp);

                                        touristAppFirestore
                                            .collection('refund')
                                            .doc(detail['orderID'])
                                            .update({
                                          'status': status,
                                          'receiptPicURL': receiptPicURL
                                        });

                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context)
                                          ..pop(true)
                                          ..pop(true);
                                      }
                                    },
                                    child: const Text("OK"))
                              ],
                            );
                          });
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(
                                color: Colors.white,
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                status == 'Pending'
                                    ? 'In Progress'
                                    : 'Finished',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          actions: status == 'Pending'
              ? [
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                          child: const Icon(
                            Icons.cancel_rounded,
                            color: primaryTextColor,
                          ),
                          onTap: () {
                            TextEditingController textFieldController =
                                TextEditingController();
                            final formKey = GlobalKey<FormState>();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title:
                                        const Text('Are you sure to cancel?'),
                                    content: Form(
                                      key: formKey,
                                      child: TextFormField(
                                        controller: textFieldController,
                                        decoration: const InputDecoration(
                                            hintText: "Enter note"),
                                        validator: RequiredValidator(
                                            errorText: 'note is required'),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                status = 'Canceled';
                                              });
                                              FirebaseApp touristApp =
                                                  await Firebase.initializeApp(
                                                name: 'touristApp',
                                                options:
                                                    DefaultFirebaseOptionsTourist
                                                        .currentPlatform,
                                              );
                                              FirebaseFirestore
                                                  touristAppFirestore =
                                                  FirebaseFirestore.instanceFor(
                                                      app: touristApp);

                                              touristAppFirestore
                                                  .collection('refund')
                                                  .doc(detail['orderID'])
                                                  .update({
                                                'status': status,
                                                'note': textFieldController.text
                                              });
if (!mounted) {
                                                                return;
                                                              }
                                              Navigator.of(context)
                                                ..pop(true)
                                                ..pop(true);
                                            }
                                          },
                                          child: const Text("OK"))
                                    ]);
                              },
                            );
                          })),
                ]
              : [],
          backgroundColor: primaryBackgroundColor,
          title: const Text(
            "Refund Detail",
            style: TextStyle(color: primaryTextColor),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: secondaryBackgroundColor),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop(true);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Order ID'),
                        Text('${detail['orderID']}')
                      ],
                    ),
                  ),
                  Container(
                    // height: size.height * 0.06,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: secondaryBackgroundColor.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.description,
                                size: 30,
                              ),
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              const Text('Detail',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.date_range,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.03,
                                  ),
                                  const Text('Request date',
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                              Text(
                                  DateFormat('dd MMM yyyy, HH:mm').format(detail['timeStamp'].toDate()),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                          Divider(
                              color: secondaryBackgroundColor.withOpacity(0.5)),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  statusIcon,
                                  SizedBox(
                                    width: size.width * 0.03,
                                  ),
                                  const Text('Status',
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                              Text('${detail['status']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                          Divider(
                              color: secondaryBackgroundColor.withOpacity(0.5)),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.receipt),
                                  SizedBox(
                                    width: size.width * 0.03,
                                  ),
                                  const Text('Refund Amount',
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                              Text('${detail['refund']['amount']} THB',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                          Divider(
                              color: secondaryBackgroundColor.withOpacity(0.5)),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          detail['note'] == null
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.note_rounded),
                                            SizedBox(
                                              width: size.width * 0.03,
                                            ),
                                            const Text('Note',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10),
                                      child: Text('${detail['note']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          )),
                                    ),
                                    Divider(
                                        color: secondaryBackgroundColor
                                            .withOpacity(0.5)),
                                    SizedBox(
                                      height: size.height * 0.03,
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
//

                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                    // height: size.height * 0.06,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: secondaryBackgroundColor.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.home,
                                size: 30,
                              ),
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              const Text('Contact Address',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.edit_road_sharp,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.03,
                                  ),
                                  const Text('Address',
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                                '${detail['refund']['contactAddress']['address']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                )),
                          ),
                          Divider(
                              color: secondaryBackgroundColor.withOpacity(0.5)),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_city),
                                  SizedBox(
                                    width: size.width * 0.03,
                                  ),
                                  const Text('City',
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                                '${detail['refund']['contactAddress']['city']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                )),
                          ),
                          Divider(
                              color: secondaryBackgroundColor.withOpacity(0.5)),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.local_post_office_rounded),
                                  SizedBox(
                                    width: size.width * 0.03,
                                  ),
                                  const Text('Post Code',
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                                '${detail['refund']['contactAddress']['postCode']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                )),
                          ),
                          Divider(
                              color: secondaryBackgroundColor.withOpacity(0.5)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                    // height: size.height * 0.06,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: secondaryBackgroundColor.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.account_balance,
                                size: 30,
                              ),
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              const Text('Info to Refund',
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          const Text('Country',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: SizedBox(
                              child: Text(
                                  '${detail['refund']['bankAccountInfo']['country']}',
                                  // overflow: TextOverflow.ellipsis,
                                  // textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  )),
                            ),
                          ),
                          Divider(
                              color: secondaryBackgroundColor.withOpacity(0.5)),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          const Text('Refund Option',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: SizedBox(
                              child: Text(
                                  '${detail['refund']['bankAccountInfo']['refundOption']}',
                                  // overflow: TextOverflow.ellipsis,
                                  // textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  )),
                            ),
                          ),
                          Divider(
                              color: secondaryBackgroundColor.withOpacity(0.5)),

                          detail['refund']['bankAccountInfo']['refundOption'] ==
                                  'SWITH Code'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.03,
                                    ),
                                    const Text('Swift Code',
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10),
                                      child: SizedBox(
                                        child: Text(
                                            '${detail['refund']['bankAccountInfo']['swiftCode']}',
                                            // overflow: TextOverflow.ellipsis,
                                            // textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                      ),
                                    ),
                                    Divider(
                                        color: secondaryBackgroundColor
                                            .withOpacity(0.5)),
                                  ],
                                )
                              : detail['refund']['bankAccountInfo']
                                          ['refundOption'] ==
                                      'Bank Account Detail'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: size.height * 0.03,
                                        ),
                                        const Text('Bank Name',
                                            style: TextStyle(
                                              fontSize: 16,
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10),
                                          child: SizedBox(
                                            child: Text(
                                                '${detail['refund']['bankAccountInfo']['bankName']}',
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                )),
                                          ),
                                        ),
                                        Divider(
                                            color: secondaryBackgroundColor
                                                .withOpacity(0.5)),
                                        SizedBox(
                                          height: size.height * 0.03,
                                        ),
                                        const Text('Account number',
                                            style: TextStyle(
                                              fontSize: 16,
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10),
                                          child: SizedBox(
                                            child: Text(
                                                '${detail['refund']['bankAccountInfo']['accountNumber']}',
                                                // overflow: TextOverflow.ellipsis,
                                                // textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                )),
                                          ),
                                        ),
                                        Divider(
                                            color: secondaryBackgroundColor
                                                .withOpacity(0.5)),
                                      ],
                                    )
                                  : detail['refund']['bankAccountInfo']
                                              ['refundOption'] ==
                                          'Prompt Pay'
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: size.height * 0.03,
                                            ),
                                            const Text('Prompt Pay',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 10),
                                              child: SizedBox(
                                                child: Text(
                                                    '${detail['refund']['bankAccountInfo']['payNow']}',
                                                    // overflow: TextOverflow.ellipsis,
                                                    // textAlign: TextAlign.right,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    )),
                                              ),
                                            ),
                                            Divider(
                                                color: secondaryBackgroundColor
                                                    .withOpacity(0.5)),
                                          ],
                                        )
                                      : const SizedBox(),
                          // SizedBox(
                          //   height: size.height * 0.03,
                          // ),
                          // const Text('Account Name',
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //     )),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 10, left: 10),
                          //   child: SizedBox(
                          //     child:
                          //         Text('${detail['bankDetail']['accountName']}',
                          //             overflow: TextOverflow.ellipsis,
                          //             textAlign: TextAlign.right,
                          //             style: const TextStyle(
                          //               fontSize: 16,
                          //             )),
                          //   ),
                          // ),
                          // Divider(
                          //     color: secondaryBackgroundColor.withOpacity(0.5)),

                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          receiptPicURL == null
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.start,
                                    children: [
                                      const Text('Receipt',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      // Image.network(
                                      //   receiptPicURL!,
                                      //   width: size.width,
                                      //   height: size.height * 0.5,
                                      // ),
                                      SizedBox(
                                        width: size.width,
                                        child: CachedNetworkImage(
                                          imageUrl: receiptPicURL!,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          // receiptPicURL == null ? SizedBox() : SizedBox()
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  ),
//
                ]))));
  }
}
