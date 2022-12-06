import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant.dart';

Widget textForm(
    IconData? icon,
    String? hintText,
    bool isPassword,
    bool isEmail,
    TextEditingController? textEditingController,
    BuildContext context,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    String? labelText,
    Function? ontap,
    bool isPhonenumber,
    bool isneedToggel) {
  Size size = MediaQuery.of(context).size;

  return Container(
    // height: size.width / 6,
    // width: size.width / 1.2,
    alignment: Alignment.center,
    padding: EdgeInsets.only(
      right: size.width / 30,
    ),
    decoration: BoxDecoration(
      // color: Colors.white.withOpacity(.4),
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextFormField(
      readOnly: ontap == null ? false : true,
      validator: validator,

      style: TextStyle(color: secondaryBackgroundColor),
      cursorColor: secondaryBackgroundColor,
      obscureText: isPassword,
      controller: textEditingController,
      enableSuggestions: isPassword ? false : true,
      inputFormatters: isPhonenumber
          ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
          : [],
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isPhonenumber
              ? TextInputType.phone
              : TextInputType.text,
      autocorrect: false,

      decoration: InputDecoration(
        hintStyle: TextStyle(color: secondaryBackgroundColor.withOpacity(0.6)),
        labelStyle: TextStyle(color: secondaryBackgroundColor),
        focusColor: secondaryColor,
        fillColor: secondaryBackgroundColor,
        filled: false,
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: secondaryColor),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: primaryColor,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: secondaryBackgroundColor,
            width: 2.0,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
        suffixIcon: isneedToggel
            ? suffixIcon
            : Icon(
                icon,
                color: secondaryBackgroundColor,
              ),
      ),
      onTap: () {
        ontap;
      },

      // decoration: InputDecoration(
      //     prefixIcon: Icon(
      //       icon,
      //       color: Colors.black.withOpacity(.7),
      //     ),
      //     fillColor: Colors.black.withOpacity(.05),
      //     border: InputBorder.none,
      //     hintMaxLines: 1,
      //     hintText: hintText,
      //     hintStyle:
      //         TextStyle(fontSize: 14, color: Colors.black.withOpacity(.5)),
      //     suffixIcon: suffixIcon),
    ),
  );
}
