import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart' as intl;
import 'package:singleton/singleton.dart';

class AppService {
  //

  /// Factory method that reuse same instance automatically
  factory AppService() => Singleton.lazy(() => AppService._());

  /// Private constructor
  AppService._() {}

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  BehaviorSubject<int> homePageIndex = BehaviorSubject<int>();
  BehaviorSubject<bool> refreshAssignedOrders = BehaviorSubject<bool>();
  BehaviorSubject<bool> refreshWalletBalance = BehaviorSubject<bool>();
  GlobalKey<AutoCompleteTextFieldState<String>> key =
      GlobalKey<AutoCompleteTextFieldState<String>>();
  int? vendorId;

  //
  changeHomePageIndex({int index = 2}) async {
    print("Changed Home Page");
    homePageIndex.add(index);
  }

  static bool isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(translator.activeLocale.languageCode);
  }
}
