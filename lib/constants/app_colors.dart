import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/services/app.service.dart';
import 'package:midnightcity/services/local_storage.service.dart';
import 'package:velocity_x/velocity_x.dart';

class AppColor {
  static Color? get accentColor => Vx.hexToColor(colorEnv('accentColor'));
  static Color? get primaryColor => Vx.hexToColor(colorEnv('primaryColor'));
  static Color get primaryColor1 => Vx.hexToColor(colorEnv('primaryColor'));
  static Color? get primaryColorDark =>
      Vx.hexToColor(colorEnv('primaryColorDark'));
  static Color? get cursorColor => accentColor;

  //material color
  static MaterialColor get accentMaterialColor => MaterialColor(
        Vx.getColorFromHex(colorEnv('accentColor')),
        <int, Color>{
          50: Vx.hexToColor(colorEnv('accentColor')),
          100: Vx.hexToColor(colorEnv('accentColor')),
          200: Vx.hexToColor(colorEnv('accentColor')),
          300: Vx.hexToColor(colorEnv('accentColor')),
          400: Vx.hexToColor(colorEnv('accentColor')),
          500: Vx.hexToColor(colorEnv('accentColor')),
          600: Vx.hexToColor(colorEnv('accentColor')),
          700: Vx.hexToColor(colorEnv('accentColor')),
          800: Vx.hexToColor(colorEnv('accentColor')),
          900: Vx.hexToColor(colorEnv('accentColor')),
        },
      );
  static MaterialColor? get primaryMaterialColor => MaterialColor(
        Vx.getColorFromHex(colorEnv('primaryColor')),
        <int, Color>{
          50: Vx.hexToColor(colorEnv('primaryColor')),
          100: Vx.hexToColor(colorEnv('primaryColor')),
          200: Vx.hexToColor(colorEnv('primaryColor')),
          300: Vx.hexToColor(colorEnv('primaryColor')),
          400: Vx.hexToColor(colorEnv('primaryColor')),
          500: Vx.hexToColor(colorEnv('primaryColor')),
          600: Vx.hexToColor(colorEnv('primaryColor')),
          700: Vx.hexToColor(colorEnv('primaryColor')),
          800: Vx.hexToColor(colorEnv('primaryColor')),
          900: Vx.hexToColor(colorEnv('primaryColor')),
        },
      );
  //code hide
  // static MaterialColor get primaryMaterialColorDark =>
  //     Vx.hexToColor(colorEnv('primaryColorDark'));
  static Color get primaryMaterialColorDark =>
      Vx.hexToColor(colorEnv('primaryColorDark'));
  static Color? get cursorMaterialColor => accentColor;

  //onboarding colors
  static Color get onboarding1Color =>
      Vx.hexToColor(colorEnv('onboarding1Color'));
  static Color get onboarding2Color =>
      Vx.hexToColor(colorEnv('onboarding2Color'));
  static Color get onboarding3Color =>
      Vx.hexToColor(colorEnv('onboarding3Color'));

  static Color get onboardingIndicatorDotColor =>
      Vx.hexToColor(colorEnv('onboardingIndicatorDotColor'));
  static Color get onboardingIndicatorActiveDotColor =>
      Vx.hexToColor(colorEnv('onboardingIndicatorActiveDotColor'));

  //Shimmer Colors
  static Color? shimmerBaseColor = Colors.grey[300];
  static Color? shimmerHighlightColor = Colors.grey[200];

  //inputs
  static Color? get inputFillColor => Colors.grey[200];
  static Color? get iconHintColor => Colors.grey[500];

  static Color? get openColor => Vx.hexToColor(colorEnv('openColor'));
  static Color? get closeColor => Vx.hexToColor(colorEnv('closeColor'));
  static Color? get deliveryColor => Vx.hexToColor(colorEnv('deliveryColor'));
  static Color? get pickupColor => Vx.hexToColor(colorEnv('pickupColor'));
  static Color? get ratingColor => Vx.hexToColor(colorEnv('ratingColor'));

  static const midnightCityLightBlue = const Color(0xff215588);
  static const lightPeriwinkle = const Color(0xffc5ccfd);
  static const oceanBlue = const Color(0xff0470b1);
  static const midnightCityYellow = const Color(0xfff4bd65);
  static const butterscotch = const Color(0xffffbf47);
  static const warmGrey = const Color(0xff777777);
  static const background2 = const Color(0xff142e47);
  static const white = const Color(0xffffffff);
  static const coolGrey = const Color(0xffa1a2a5);
  static const dark = const Color(0xff323549);
  static const greyishBrown = const Color(0xff5a5a5a);
  static const battleshipGrey = const Color(0xff7b7c87);
  static const panelColor = const Color(0xff1e3042);
  static const darkTwo = const Color(0xff252836);
  static const whiteTwo = const Color(0xfff8f8f8);
  static const errorCancel = const Color(0xffff1d23);
  static const black25 = const Color(0x40000000);
  static const primaryTextColor = const Color(0xfff5f6ff);
  static const midnightCityDarkBlue = const Color(0xff121422);
  static const formText = const Color(0xb2dfdedd);
  //static const mainBackground = Colors.white;//const Color(0xff121422);
  static const mainBackground = Colors.white; //const Color(0xff121422);
  static const twilight = const Color(0xff525298);

  //
  static Color get faintBgColor {
    try {
      final isLightMode =
          AppService().navigatorKey.currentContext?.brightness ==
              Brightness.light;
      return isLightMode ? Vx.hexToColor("#212121") : Vx.hexToColor("#212121");
    } catch (error) {
      return Colors.white;
    }
  }

  static Color getStausColor(String status) {
    //'pending','preparing','enroute','failed','cancelled','delivered'
    final statusColorName = "${status}Color";
    try {
      return Vx.hexToColor(colorEnv(statusColorName));
    } catch (error) {
      return Vx.hexToColor(colorEnv('pendingColor'));
    }
  }

  //saving
  static Future<bool> saveColorsToLocalStorage(String colorsMap) async {
    return await LocalStorageService.prefs!
        .setString(AppStrings.appColors, colorsMap);
  }

  static dynamic appColorsObject;
  static Future<void> getColorsFromLocalStorage() async {
    appColorsObject =
        LocalStorageService.prefs!.getString(AppStrings.appColors);
    if (appColorsObject != null) {
      appColorsObject = jsonDecode(appColorsObject);
    }
  }

  static String colorEnv(String colorRef) {
    //
    getColorsFromLocalStorage();
    //
    final selectedColor =
        appColorsObject != null ? appColorsObject[colorRef] : "#ffffff";
    return selectedColor;
  }
}
