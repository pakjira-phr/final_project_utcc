import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ggt_tour_guide_utccfinalproject/constant.dart';
// import 'dart:developer' as devtools show log;

// ignore: must_be_immutable
class WithdrawDetail extends StatefulWidget {
  WithdrawDetail({super.key, required this.detail});
  Map detail;

  @override
  // ignore: no_logic_in_create_state
  State<WithdrawDetail> createState() => _WithdrawDetailState(detail: detail);
}

class _WithdrawDetailState extends State<WithdrawDetail> {
  _WithdrawDetailState({required this.detail});

  Map detail;

  Icon statusIcon = const Icon(Icons.error);
  String? receiptPicURL;

  int getHoursBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours);
  }

  getStatusIcon() {
    String status = detail['status'];
    setState(() {
      if (status == 'Pending') {
        statusIcon = const Icon(Icons.pending);
      } else if (status == 'Accepted') {
        statusIcon = const Icon(Icons.play_circle_sharp);
      } else if (status == 'In Progress') {
        statusIcon = const Icon(Icons.incomplete_circle_sharp);
      } else if (status == 'Finished') {
        statusIcon = const Icon(Icons.check_circle_rounded);
      } else {
        statusIcon = const Icon(Icons.error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    receiptPicURL = detail['receiptPicURL'];
    getStatusIcon();
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     devtools.log('$detail');
        //   },
        // ),
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: primaryBackgroundColor,
          title: const Text("Withdraw Detail"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
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
                        const Text('transactions ID'),
                        Text('${detail['transactionsID']}')
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
                              Text('${detail['timeStamp']}',
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
                                  const Text('Receive Amount',
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                              Text('${detail['total']} THB',
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
                              const Text('Bank Account',
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
                              const Text('Account number',
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),
                              SizedBox(
                                width: size.width * 0.4,
                                child: Text(
                                    '${detail['bankDetail']['accountNumber']}',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    )),
                              ),
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
                              const Text('Account Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),
                              SizedBox(
                                width: size.width * 0.4,
                                child: Text(
                                    '${detail['bankDetail']['accountName']}',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    )),
                              ),
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
                              const Text('Bank Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                  )),
                              SizedBox(
                                width: size.width * 0.4,
                                child:
                                    Text('${detail['bankDetail']['bankName']}',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        )),
                              ),
                            ],
                          ),
                          Divider(
                              color: secondaryBackgroundColor.withOpacity(0.5)),
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
                                        height: size.height * 0.7,
                                        child: CachedNetworkImage(
                                          imageUrl: receiptPicURL!,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ]))));
  }
}
