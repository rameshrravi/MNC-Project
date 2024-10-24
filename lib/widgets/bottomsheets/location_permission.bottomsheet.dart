import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/services/app.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class LocationPermissionDialog extends StatelessWidget {
  const LocationPermissionDialog({Key? key, this.onResult}) : super(key: key);

  //
  final Function(bool)? onResult;

  //
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: VStack(
        [
          //title
          "Location Permission Request".tr().text.semiBold.xl.make().py12(),
          ("${AppStrings.appName} " +
                  "requires your location permission to show you nearby vendors, setup delivery address/location during checkout and Live tracking of Order and Delivery Persons"
                      .tr())
              .text
              .make(),
          UiSpacer.verticalSpace(),
          CustomButton(
            title: "Next".tr(),
            onPressed: () {
              onResult!(true)!;
              //AppService().navigatorKey.currentContext!.pop();
              Navigator.pop(AppService().navigatorKey.currentContext!);
            },
          ).py12(),
          CustomButton(
            title: "Cancel".tr(),
            color: Colors.grey[400]!,
            onPressed: () {
              onResult!(false);
              //  AppService().navigatorKey.currentContext.pop();
              Navigator.pop(AppService().navigatorKey.currentContext!);
            },
          ),
        ],
      ).p20().wFull(context).scrollVertical(), //.hTwoThird(context),
    );
  }
}
