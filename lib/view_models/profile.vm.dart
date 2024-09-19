import 'dart:io';
import 'dart:typed_data';
import 'package:midnightcity/views/pages/order/orders.page.profile.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/extensions/dynamic.dart';
import 'package:midnightcity/view_models/payment.view_model.dart';
import 'package:midnightcity/views/pages/profile/account_delete.page.dart';
import 'package:midnightcity/views/pages/splash.page.dart';
import 'package:midnightcity/constants/api.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/user.dart';
import 'package:midnightcity/requests/auth.request.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/widgets/bottomsheets/referral.bottomsheet.dart';
import 'package:midnightcity/widgets/cards/language_selector.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:package_info/package_info.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:share/share.dart';
import 'package:midnightcity/views/pages/profile/profile.inner.page.dart';
import 'package:midnightcity/views/pages/profile/customer.support.page.dart';
import 'package:midnightcity/views/pages/profile/help.center.page.dart';

class ProfileViewModel extends PaymentViewModel {
  //
  String appVersionInfo = "";
  bool authenticated = false;
  late User currentUser;

  //
  AuthRequest _authRequest = AuthRequest();

  ProfileViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void initialise() async {
    //
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    appVersionInfo = "$versionName($versionCode)";
    authenticated = await AuthServices.authenticated();
    if (authenticated) {
      currentUser = (await AuthServices.getCurrentUser(force: true))!;
    }
    notifyListeners();
  }

  /**
   * Edit Profile
   */

  openEditProfile() async {
    // final result = await viewContext!.navigator.pushNamed(
    //   AppRoutes.editProfileRoute,
    // );
    //
    // if (result != null && result) {
    //   initialise();
    // }
  }

  openProfileInner() {
    //viewContext!.nextPage(ProfileInnerPage());
  }

  openHelpCenter() {
    viewContext!.nextPage(HelpCenterPage());
  }

  /**
   * Change Password
   */

  openChangePassword() async {
    // viewContext!.navigator.pushNamed(
    //   AppRoutes.changePasswordRoute,
    // );
  }

//
  openRefer() async {
    await showModalBottomSheet(
      context: viewContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReferralBottomsheet(this),
    );
  }

  //
  openWallet() {
    // viewContext!.navigator.pushNamed(
    //   AppRoutes.walletRoute,
    // );
  }

  /**
   * Delivery addresses
   */
  openDeliveryAddresses() {
    // viewContext!.navigator.pushNamed(
    //   AppRoutes.deliveryAddressesRoute,
    // );
  }

  //
  openFavourites() {
    // viewContext!.navigator.pushNamed(
    //   AppRoutes.favouritesRoute,
    // );
  }

  openOrders() {
    viewContext!.nextPage(OrdersPageProfile());
  }

  /**
   * Logout
   */
  logoutPressed() async {
    CoolAlert.show(
      context: viewContext!,
      type: CoolAlertType.confirm,
      title: "Logout".tr(),
      text: "Are you sure you want to logout?".tr(),
      onConfirmBtnTap: () {
        Navigator.pop(viewContext!);

        processLogout();
      },
    );
  }

  void processLogout() async {
    //
    CoolAlert.show(
      context: viewContext!,
      type: CoolAlertType.loading,
      title: "Logout".tr(),
      text: "Logging out Please wait...".tr(),
      barrierDismissible: false,
    );

    //
    final apiResponse = await _authRequest.logoutRequest();

    //
    Navigator.pop(viewContext!);

    if (!apiResponse.allGood) {
      //
      CoolAlert.show(
        context: viewContext!,
        type: CoolAlertType.error,
        title: "Logout".tr(),
        text: apiResponse.message,
      );
    } else {
      //
      await AuthServices.logout();
      // viewContext!.navigator.pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => SplashPage()),
      //   (route) => false,
      // );
    }
  }

  openNotification() async {
    // viewContext!.navigator.pushNamed(
    //   AppRoutes.notificationsRoute,
    // );
  }

  /**
   * App Rating & Review
   */
  openReviewApp() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (Platform.isAndroid) {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    } else if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    }
  }

  //
  openPrivacyPolicy() async {
    final url = Api.privacyPolicy;
    openWebpageLink(url);
  }

  openTerms() {
    final url = Api.terms;
    openWebpageLink(url);
  }

  //
  openContactUs() async {
    final url = Api.contactUs;
    openWebpageLink(url);
  }

  opeCustomerSupport() async {
    // viewContext!.nextPage(CustomerSupportPage());
  }

  openLivesupport() async {
    final url = Api.inappSupport;
    openWebpageLink(url);
  }

  //
  changeLanguage() async {
    showModalBottomSheet(
      context: viewContext!,
      builder: (context) {
        return AppLanguageSelector();
      },
    );
  }

  openLogin() async {
    // await viewContext!.navigator.pushNamed(
    //   AppRoutes.loginRoute,
    // );
    // //
    initialise();
  }

  void shareReferralCode() {
    Share.share(
      "%s is inviting you to join %s via this referral code: %s".tr().fill(
            [
              currentUser.name,
              AppStrings.appName,
              currentUser.code,
            ],
          ) +
          "\n" +
          AppStrings.androidDownloadLink +
          "\n" +
          AppStrings.iOSDownloadLink +
          "\n",
    );
  }

  //
  deleteAccount() {
    // viewContext!.nextPage(AccountDeletePage());
  }
}
