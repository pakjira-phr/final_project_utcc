import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import '../../../../../constant.dart';

// ignore: must_be_immutable
class SelectAddBank extends StatefulWidget {
  SelectAddBank(
      {super.key, required this.bankNameList, required this.selectBankName});
  List bankNameList;
  String selectBankName;

  @override
  State<SelectAddBank> createState() =>
      // ignore: no_logic_in_create_state
      _SelectAddBankState(
          bankNameList: bankNameList, selectBankName: selectBankName);
}

class _SelectAddBankState extends State<SelectAddBank> {
  _SelectAddBankState(
      {required this.bankNameList, required this.selectBankName});
  List bankNameList;
  String selectBankName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: const Text("Select a bank"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: secondaryBackgroundColor),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop(selectBankName);
          },
        ),
      ),
      backgroundColor: primaryBackgroundColor,
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: bankNameList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              ListTile(
                title: Text('${bankNameList[index]}'),
                onTap: () {
                  devtools.log(bankNameList[index].toString());
                  Navigator.of(context).pop(bankNameList[index]);
                },
              ),
              Divider(
                color: secondaryBackgroundColor.withOpacity(0.4),
              ),
            ],
          );
        },
      ),
    );
  }
}
