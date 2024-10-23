import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/services/app.service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class AlertService {
  //

  static Future<bool> showConfirm({
    String? title,
    String? text,
    String? cancelBtnText = "Cancel",
    String? confirmBtnText = "Ok",
    Function? onConfirm,
  }) async {
    //
    bool result = false;

    await CoolAlert.show(
        context: AppService().navigatorKey.currentContext!,
        type: CoolAlertType.confirm,
        title: title,
        text: text,
        cancelBtnText: cancelBtnText!.tr(),
        confirmBtnText: confirmBtnText!.tr(),
        confirmBtnColor: AppColor.midnightCityYellow,
        backgroundColor: AppColor.midnightCityDarkBlue,
        onConfirmBtnTap: () {
          if (onConfirm == null) {
            result = true;
            AppService().navigatorKey.currentContext!;
          } else {
            onConfirm();
          }
        });

    //
    return result;
  }

  static Future<bool> success({
    String? title,
    String? text,
    String? cancelBtnText = "Cancel",
    String? confirmBtnText = "Ok",
  }) async {
    //
    bool result = false;

    await CoolAlert.show(
        context: AppService().navigatorKey.currentContext!,
        type: CoolAlertType.success,
        title: title,
        text: text,
        confirmBtnText: confirmBtnText!.tr(),
        confirmBtnColor: AppColor.midnightCityYellow,
        backgroundColor: AppColor.midnightCityDarkBlue,
        onConfirmBtnTap: () {
          result = true;
          //AppService().navigatorKey.currentContext.pop();
          AppService().navigatorKey.currentContext;
        });

    //
    return result;
  }

  static Future<bool> info({
    String? title,
    String? text,
    String confirmBtnText = "Ok",
  }) async {
    //
    bool result = false;

    await CoolAlert.show(
        context: AppService().navigatorKey.currentContext!,
        type: CoolAlertType.info,
        title: title,
        text: text,
        confirmBtnText: confirmBtnText.tr(),
        confirmBtnColor: AppColor.midnightCityYellow,
        backgroundColor: AppColor.midnightCityDarkBlue,
        onConfirmBtnTap: () {
          result = true;
          AppService().navigatorKey.currentContext!;
        });

    //
    return result;
  }

  static Future<bool> error({
    String? title,
    String? text,
    String confirmBtnText = "Ok",
  }) async {
    //
    bool result = false;

    await CoolAlert.show(
        context: AppService().navigatorKey.currentContext!,
        type: CoolAlertType.error,
        title: title,
        text: text,
        confirmBtnText: confirmBtnText.tr(),
        confirmBtnColor: AppColor.midnightCityYellow,
        backgroundColor: AppColor.midnightCityDarkBlue,
        onConfirmBtnTap: () {
          result = true;
          AppService().navigatorKey.currentContext!;
        });
    //
    return result;
  }

  static void showLoading() {
    CoolAlert.show(
      context: AppService().navigatorKey.currentContext!,
      confirmBtnColor: AppColor.midnightCityYellow,
      backgroundColor: AppColor.midnightCityDarkBlue,
      type: CoolAlertType.loading,
      title: "".tr(),
      text: "Processing. Please wait...".tr(),
      barrierDismissible: false,
    );
  }

  static void stopLoading() {
    AppService().navigatorKey.currentContext!;
  }
}
