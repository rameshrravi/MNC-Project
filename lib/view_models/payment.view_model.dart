import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:midnightcity/services/toast.service.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:midnightcity/views/pages/payment/custom_webview.page.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  // @override
  // void onCompletedInitialLoad() {
  //   print("ChromeSafari browser initial load completed");
  // }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}

class PaymentViewModel extends MyBaseViewModel {
  refreshDataSet() {}
  //
  // openWebpageLink(String url) async {
  //   //
  //   try {
  //     ChromeSafariBrowser browser = new MyChromeSafariBrowser();
  //     await browser.open(
  //       url: Uri.parse(url),
  //       options: ChromeSafariBrowserClassOptions(
  //         android: AndroidChromeCustomTabsOptions(
  //           addDefaultShareMenuItem: false,
  //           enableUrlBarHiding: true,
  //         ),
  //         ios: IOSSafariOptions(
  //           barCollapsingEnabled: true,
  //         ),
  //       ),
  //     );
  //   } catch (error) {
  //     await launchUrlString(url);
  //   }
  //   //
  //   refreshDataSet();
  // }

  Future<dynamic> openWebpageLink(
    String url, {
    bool external = false,
    bool embeded = false,
  }) async {
    //
    if (!embeded && (Platform.isIOS || external)) {
      await launchUrlString(url);
      return;
    }
    // final result = await viewContext!.push(
    //   (context) => CustomWebviewPage(
    //     selectedUrl: url,
    //   ),
    // );
    //
    // final result = await Navigator.push(
    //     viewContext!,
    //     MaterialPageRoute(
    //         builder: (context) => CustomWebviewPage(
    //               selectedUrl: url,
    //             )));

    refreshDataSet();
    return null;
    // return result;
  }

  Future<dynamic> openExternalWebpageLink(String url) async {
    try {
      final result = await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
      refreshDataSet();
      return result;
    } catch (error) {
      ToastService.toastError("$error");
    }
    return null;
  }
}
