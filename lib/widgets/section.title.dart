import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {Key? key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return "$title"
        .text
        .lg
        .medium
        .black
        .fontWeight(FontWeight.w500)
        .fontFamily("Poppins")
        .size(20)
        .make();
  }
}
