import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_images.dart';
import 'package:midnightcity/view_models/splash.vm.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Color(0xff121422),
      body: ViewModelBuilder<SplashViewModel>.reactive(
        viewModelBuilder: () => SplashViewModel(context),
        onModelReady: (vm) => vm.initialise(),
        builder: (context, model, child) {
          return VStack(
            [
              Image.asset(
                AppImages.splashImage,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ],
          );
        },
      ),
    );
  }
}
