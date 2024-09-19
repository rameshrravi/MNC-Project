import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_images.dart';
import 'package:midnightcity/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EmptySearch extends StatelessWidget {
  const EmptySearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      imageUrl: AppImages.emptySearch,
      title: "No Product Found".tr(),
      description: "There seems to be no such product".tr(),
    );
  }
}
