import 'dart:convert';
import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/constants/app_theme.dart';
import 'package:midnightcity/requests/settings.request.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/services/firebase.service.dart';
import 'package:midnightcity/widgets/cards/language_selector.view.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../services/local_storage.service.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashViewModel extends MyBaseViewModel {
  SplashViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  SettingsRequest settingsRequest = SettingsRequest();

  //
  initialise() async {
    super.initialise();
    await loadAppSettings();
    if (AuthServices.authenticated()) {
      await AuthServices.getCurrentUser(force: true);
    }
  }

  //

  //
  loadAppSettings() async {
    setBusy(true);
    try {
      final appSettingsObject = await settingsRequest.appSettings();
      debugger();
      //app settings
      await updateAppVariables(appSettingsObject.body["strings"]);
      //colors
      await updateAppTheme(appSettingsObject.body["colors"]);
      loadNextPage();
    } catch (error) {
      setError(error);
      print("Error loading app settings ==> $error");
      //show a dialog
      CoolAlert.show(
        context: viewContext!,
        barrierDismissible: false,
        type: CoolAlertType.error,
        title: "An error occurred".tr(),
        text: "$error",
        confirmBtnText: "Retry".tr(),
        onConfirmBtnTap: () {
          //     viewContext!.pop();
          Navigator.pop(viewContext!);
          initialise();
        },
      );
    }
    setBusy(false);
  }

  //
  Future<void> updateAppVariables(dynamic json) async {
    //
    await AppStrings.saveAppSettingsToLocalStorage(jsonEncode(json));
  }

  //theme change
  updateAppTheme(dynamic colorJson) async {
    //
    await AppColor.saveColorsToLocalStorage(jsonEncode(colorJson));
    //change theme
    // await AdaptiveTheme.of(viewContext).reset();
    AdaptiveTheme.of(viewContext!).setTheme(
      light: AppTheme().lightTheme(),
      dark: AppTheme().darkTheme(),
      notify: false,
    );
    await AdaptiveTheme.of(viewContext!).persist();
  }

  //
  loadNextPage() async {
    //
    //  await Jiffy.locale(translator.activeLocale.languageCode);
    //
    /*if (AuthServices.firstTimeOnApp()) {
      //choose language
      await showModalBottomSheet(
        context: viewContext,
        builder: (context) {
          return AppLanguageSelector();
        },
      );
    }*/
    //
    String branch = await AuthServices.getPrefBranch();

    if (AuthServices.firstTimeOnApp()!) {
      // viewContext!.
      //     .pushNamedAndRemoveUntil(AppRoutes.welcomeRoute, (route) => false);
      Navigator.pushNamedAndRemoveUntil(
          viewContext!, AppRoutes.welcomeRoute, (route) => false);
    } else if (branch == "1" || branch == "2") {
      // viewContext!.navigator
      //     .pushNamedAndRemoveUntil(AppRoutes.chooseVendorRoute, (route) => false);
      Navigator.pushNamedAndRemoveUntil(
          viewContext!, AppRoutes.chooseVendorRoute, (route) => false);
    } else {
      // viewContext!.navigator
      //     .pushNamedAndRemoveUntil(AppRoutes.chooseVendorRoute, (route) => false);
      Navigator.pushNamedAndRemoveUntil(
          viewContext!, AppRoutes.chooseVendorRoute, (route) => false);
    }

    //
    RemoteMessage? initialMessage =
        await FirebaseService().firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      //
      FirebaseService().saveNewNotification(initialMessage);
      FirebaseService().notificationPayloadData = initialMessage.data;
      FirebaseService().selectNotification("");
    }
  }
}
