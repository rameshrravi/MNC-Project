import 'package:flutter/material.dart';
import 'package:midnightcity/utils/utils.dart';

class ArrowIndicator extends StatelessWidget {
  const ArrowIndicator(this.size, {Key? key}) : super(key: key);

  final double size;
  @override
  Widget build(BuildContext context) {
    return Icon(
      Utils.isArabic ? Icons.import_contacts : Icons.import_contacts,
      size: size ?? 32,
    );

    // return Icon(
    //   Utils.isArabic
    //       ? FlutterIcons.chevron_left_fea
    //       : FlutterIcons.chevron_right_fea,
    //   size: size ?? 32,
    // );
  }
}
