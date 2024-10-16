import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:velocity_x/velocity_x.dart';

class HtmlTextView extends StatelessWidget {
  const HtmlTextView(this.htmlContent, {Key? key}) : super(key: key);

  final String htmlContent;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      htmlContent,
      textStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontFamily: "Poppins",
          fontStyle: FontStyle.normal,
          fontSize: 12.0),
    ).px20();
  }
}
