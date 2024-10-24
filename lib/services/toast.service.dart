import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:midnightcity/constants/app_colors.dart';

class ToastService {
  //show toast
  static toastSuccessful(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 5,
      backgroundColor: AppColor.midnightCityLightBlue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static toastError(String msg, {Toast? length}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: length ?? Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
