import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:midnightcity/constants/app_images.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/constants/app_ui_settings.dart';
import 'package:midnightcity/resources/resources.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/profile.vm.dart';
import 'package:midnightcity/widgets/busy_indicator.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/menu_item.dart';
import 'package:midnightcity/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class HelpCenterCard extends StatelessWidget {
  const HelpCenterCard(this.model, {Key? key}) : super(key: key);

  final ProfileViewModel model;
  @override
  Widget build(BuildContext context) {
    return model.authenticated
        ? VStack(
            [
              //profile card
              /*HStack(
                [
                  //
                  CachedNetworkImage(
                    imageUrl: model.currentUser.photo,
                    progressIndicatorBuilder: (context, imageUrl, progress) {
                      return BusyIndicator();
                    },
                    errorWidget: (context, imageUrl, progress) {
                      return Image.asset(
                        AppImages.user,
                      );
                    },
                  )
                      .wh(Vx.dp64, Vx.dp64)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make(),

                  //


                  VStack(
                    [
                      //name
                      model.currentUser.name.text.xl.semiBold.make(),
                      //email
                      model.currentUser.email.text.light.make(),
                      //share invation code
                      AppStrings.enableReferSystem
                          ? "Share referral code"
                              .tr()
                              .text
                              .sm
                              .color(context.textTheme.bodyText1.color)
                              .make()
                              .box
                              .px4
                              .roundedSM
                              .border(color: Colors.grey)
                              .make()
                              .onInkTap(model.shareReferralCode)
                              .py4()
                          : UiSpacer.emptySpace(),
                    ],
                  ).px20().expand(),

                  //
                ],
              ).p12(),*/

              //
              VStack(
                [
                  MenuItem(
                    title: "About Midnight City".tr(),
                    onPressed: model.openContactUs,
                    //ic: AppIcons.edit,
                  ),

                  /*   MenuItem(
                      title: "Complaints & Feedback".tr(),
                      onPressed: model.openContactUs
                      //ic: AppIcons.favourite,
                      ),*/
                  //favourites
                  MenuItem(title: "FAQs".tr(), onPressed: model.openContactUs
                      //ic: AppIcons.favourite,
                      ),
                  MenuItem(
                      title: "Contact Support".tr(),
                      onPressed: model.opeCustomerSupport
                      //ic: AppIcons.favourite,
                      ),
                  MenuItem(
                      title: "Rate us on the App Store".tr(),
                      onPressed: model.openReviewApp
                      //ic: AppIcons.favourite,
                      ),
                  //referral
                  /*            CustomVisibilty(
                    visible: AppStrings.enableReferSystem,
                    child: MenuItem(
                      title: "Referrals".tr(),
                      onPressed: model.openRefer,
                      //ic: AppIcons.refer,
                    ),
                  ),

                  MenuItem(
                    title: "Help Center".tr(),
                    onPressed: model.openContactUs,
                    //ic: AppIcons.communicate,
                  ),




                  MenuItem(
                    title: "Terms & Conditions".tr(),
                    onPressed: model.openTerms,
                    //ic: AppIcons.termsAndConditions,
                  ),

                  MenuItem(
                    child: "Logout".tr().text.red500.make(),
                    onPressed: model.logoutPressed,
                    suffix: Icon(
                      FlutterIcons.logout_ant,
                      size: 16,
                    ),
                  ),

                  //change password
                 MenuItem(
                    title: "Change Password".tr(),
                    onPressed: model.openChangePassword,
                    //ic: AppIcons.password,
                  ),
                  MenuItem(
                    title: "Contact Us".tr(),
                    onPressed: model.openContactUs,
                    //ic: AppIcons.communicate,
                  ),
                  //Wallet
                  CustomVisibilty(
                    visible: false, //AppUISettings.allowWallet ?? true,
                    child: MenuItem(
                      title: "Wallet".tr(),
                      onPressed: model.openWallet,
                      //ic: AppIcons.wallet,
                    ),
                  ),
                  //addresses
                  MenuItem(
                    title: "Delivery Addresses".tr(),
                    onPressed: model.openDeliveryAddresses,
                    //ic: AppIcons.homeAddress,
                  ),
                  MenuItem(
                    title: "Notifications".tr(),
                    onPressed: model.openNotification,
                    //ic: AppIcons.bell,
                  ),
                  MenuItem(
                    title: "Rate & Review".tr(),
                    onPressed: model.openReviewApp,
                    //ic: AppIcons.rating,
                  ),
                  MenuItem(
                    title: "Privacy Policy".tr(),
                    onPressed: model.openPrivacyPolicy,
                    //ic: AppIcons.compliant,
                  ),
                  MenuItem(
                    title: "Live Support".tr(),
                    onPressed: model.openLivesupport,
                    //ic: AppIcons.livesupport,
                  ),  */
                  /* MenuItem(
                    title: "Language".tr(),
                    divider: false,
                    //ic: AppIcons.translation,
                    onPressed: model.changeLanguage,
                  ),*/
                  //

                  /*
                  UiSpacer.vSpace(15),
                  HStack(
                    [
                      UiSpacer.expandedSpace(),
                      HStack(
                        [
                          Icon(
                            FlutterIcons.delete_ant,
                            size: 12,
                            color: Vx.red400,
                          ),
                          UiSpacer.hSpace(10),
                          "Delete Account".tr().text.xs.make(),
                        ],
                      ).onInkTap(model.deleteAccount),
                      UiSpacer.expandedSpace(),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                    alignment: MainAxisAlignment.center,
                  ).wFull(context),
                  UiSpacer.vSpace(15),
                   */
                ],
              ),
            ],
          ).wFull(context)
        //.box
        //.border(color: Theme.of(context).cardColor)
        //.color(Theme.of(context).cardColor)
        //.shadow
        //.roundedSM
        //.make()
        : EmptyState(
            auth: true,
            showAction: true,
            actionPressed: model.openLogin,
          ).py12();
  }
}
