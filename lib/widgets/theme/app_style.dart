import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AppStyle {
  static TextStyle? fontWeight_w400_Normal({
    required BuildContext context,
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    double? fontSize,
  }) {
    return TextStyle(
        color: color!,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        fontSize: fontSize);
  }

  static void getDate({String? name, Color? color, int? a}) {}
}
