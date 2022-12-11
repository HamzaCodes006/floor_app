
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../values/values.dart';

class CustomToast {
  static failToast(
      {Color? bgcolor, Color? textColor, String? msg, len, gravity}) {
    return Fluttertoast.showToast(
      backgroundColor: bgcolor ?? MyColors.red500,
      textColor: textColor ?? MyColors.white,
      msg: msg!,
      toastLength: len ?? Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.BOTTOM, // location// duration
    );
  }

  static successToast(
      {Color? bgcolor, Color? textColor, String? msg, len, gravity}) {
    return Fluttertoast.showToast(
      backgroundColor: bgcolor ?? MyColors.green300,
      textColor: textColor ?? MyColors.white,
      msg: msg!,
      toastLength: len ?? Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.BOTTOM, // location// duration
    );
  }
}
