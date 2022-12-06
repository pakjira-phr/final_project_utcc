import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ggt_tourist_utccfinalproject/constant.dart';

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
    void Function()? ontap,
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
      style: TextStyle(color: Colors.black.withOpacity(.8)),
      cursorColor: Colors.black,
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
        fillColor: Colors.black.withOpacity(.03),
        filled: false,
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.blueAccent),
          gapPadding: 10,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
        suffixIcon: isneedToggel
            ? suffixIcon
            : Icon(
                icon,
                color: primaryTextColor,
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

Widget textForm2(
    IconData? icon,
    String? hintText,
    bool isPassword,
    bool isEmail,
    TextEditingController? textEditingController,
    BuildContext context,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    String? labelText,
    void Function()? ontap,
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
      readOnly: true,
      validator: validator,
      style: TextStyle(color: Colors.black.withOpacity(.8)),
      cursorColor: Colors.black,
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
        fillColor: Colors.black.withOpacity(.03),
        filled: false,
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.blueAccent),
          gapPadding: 10,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
        suffixIcon: isneedToggel
            ? suffixIcon
            : Icon(
                icon,
                color: primaryTextColor,
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

Widget textFormPayNow(
    IconData? icon,
    String? hintText,
    bool isPassword,
    bool isEmail,
    TextEditingController? textEditingController,
    BuildContext context,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    String? labelText,
    void Function()? ontap,
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
      // readOnly: true,
      validator: validator,
      style: TextStyle(color: Colors.black.withOpacity(.8)),
      cursorColor: Colors.black,
      obscureText: isPassword,
      controller: textEditingController,
      enableSuggestions: isPassword ? false : true,
      // inputFormatters: isPhonenumber
      //     ? [
      //         FilteringTextInputFormatter.digitsOnly,
      //       ]
      //     : [],
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isPhonenumber
              ? TextInputType.phone
              : TextInputType.text,
      autocorrect: false,

      decoration: InputDecoration(
        fillColor: Colors.black.withOpacity(.03),
        filled: false,
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.blueAccent),
          gapPadding: 10,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 42, vertical: 17),
        suffixIcon: isneedToggel
            ? suffixIcon
            : Icon(
                icon,
                color: primaryTextColor,
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
