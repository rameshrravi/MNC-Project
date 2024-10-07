import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/home_screen.config.dart';
import 'package:midnightcity/models/user.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/services/navigation.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/utils/utils.dart';
import 'package:midnightcity/view_models/welcome.vm.dart';
import 'package:midnightcity/views/pages/vendor/widgets/banners.view.dart';
import 'package:midnightcity/views/pages/vendor/widgets/section_vendors.view.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/custom_list_view.dart';
import 'package:midnightcity/widgets/finance/wallet_management.view.dart';
import 'package:midnightcity/widgets/list_items/vendor_type.list_item.dart';
import 'package:midnightcity/widgets/list_items/vendor_type.vertical_list_item.dart';
import 'package:midnightcity/widgets/states/loading.shimmer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_routes.dart';
import '../../requests/auth.request.dart';
import '../../views/pages/splash.page.dart';
import '../../views/pages/vendor/widgets/list_vendors.dart';
import '../buttons/custom_button.dart';

class EmptyWelcome extends StatelessWidget {
  EmptyWelcome({this.vm, Key? key}) : super(key: key);

  final WelcomeViewModel? vm;
  VendorType? vt = new VendorType();
  bool showLoginAndRegister = true;

  AuthRequest _authRequest = AuthRequest();

  init() {
    vt!.id = 2;
    // vt.name = "restaruant";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: vm!.genKey,
      fit: StackFit.expand,
      children: [
        VxBox(
          child: SafeArea(
              child: VStack(
            [
              //welcome intro and loggedin account name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: AuthServices.listenToAuthState(),
                  builder: (ctx, snapshot) {
                    //
                    String introText = "Welcome to Midnightcity";

                    String fullIntroText = introText;
                    //
                    if (snapshot.hasData) {
                      showLoginAndRegister = false;
                      return FutureBuilder<User?>(
                          future: AuthServices.getCurrentUser()!,
                          builder: (ctx, snapshot) {
                            if (snapshot.hasData) {
                              fullIntroText =
                                  "$introText \nHi, ${snapshot.data!.name}";
                            }
                            return fullIntroText.text.white.xl.semiBold.make();
                          });
                    }
                    return fullIntroText.text.white.center.make();
                  },
                ),
              ),
              //

              CustomVisibilty(
                visible: true, //HomeScreenConfig.showBannerOnHomeScreen &&
                //HomeScreenConfig.isBannerPositionTop,

                child: Banners(
                  vt!,
                  // featured: true,
                ).py2(),
              ),
            ],
          )),
        ).color(AppColor.primaryColor!).p4.make().wFull(context).positioned(
              left: 0,
              right: 0,
              top: 0,
            ),

        //
        VStack(
          [
            VStack([
              "Please select your branch".tr().text.xl.bold.white.make(),
              CustomVisibilty(
                visible: true, //(HomeScreenConfig.isVendorTypeListingBoth &&
                //!vm.showGrid) ||
                //(!HomeScreenConfig.isVendorTypeListingBoth &&
                //    HomeScreenConfig.isVendorTypeListingListView),
                child: Flexible(
                  child: CustomListView(
                    padding: EdgeInsets.all(0),
                    noScrollPhysics: true,
                    dataSet: vm!.vendorTypes!,
                    scrollDirection: Axis.vertical,
                    isLoading: vm!.isBusy,
                    // loadingWidget: LoadingShimmer().px20(),
                    itemBuilder: (context, index) {
                      //  debugger();
                      final vendorType = vm!.vendorTypes![index];

                      if (index != 2) {
                        return SizedBox();
                      } else {
                        return vendorType!.id == null
                            ? SizedBox()
                            : ListVendorsView(
                                vendorType!,
                              );
                      } //vm.vendorTypes[index];
                    },
                    separatorBuilder: (context, index) => UiSpacer.emptySpace(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: AuthServices.listenToAuthState(),
                  builder: (ctx, snapshot) {
                    //
                    //
                    if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.only(left: 40, right: 40, top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white)),
                          child: CustomButton(
                            onPressed: () async {
                              await processLogout;

                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.loading,
                                title: "Logout".tr(),
                                text: "Logging out Please wait...".tr(),
                                barrierDismissible: false,
                              );

                              final apiResponse =
                                  await _authRequest.logoutRequest();

                              //

                              if (!apiResponse.allGood) {
                                //
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  title: "Logout".tr(),
                                  text: apiResponse.message,
                                );
                              } else {
                                //
                                //await AuthServices.logout();
                              }

                              // context.navigator.pushAndRemoveUntil(
                              //   MaterialPageRoute(
                              //       builder: (context) => SplashPage()),
                              //   (route) => false,
                              // );
                            },
                            height: 30,
                            //   color: AppColor.white,
                            title: "Sign Out".tr(),
                            // loading: model.isBusy,
                            // onPressed: model.processRegister,
                          ).centered(),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 40, right: 40, top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.white)),
                            child: CustomButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.registerRoute,
                                );
                              },
                              height: 30,
                              //   color: AppColor.white,
                              title: "Sign Up".tr(),
                              // loading: model.isBusy,
                              // onPressed: model.processRegister,
                            ).centered(),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Center(
                              child: Text("Already have an Account",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10)),
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.white)),
                            child: CustomButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.loginRoute,
                                );
                              },

                              height: 30,
                              // color: AppColor.midnightCityYellow,
                              title: "Sign In".tr(),
                              // loading: model.isBusy,
                              // onPressed: model.processRegister,
                            ).centered(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

/*
                    Padding(
      padding: EdgeInsets.only(left:40 ,right : 40,top: 10),
                      child: Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)
                              ,
                          border: Border.all(color: Colors.white)
                        ),
                        child: CustomButton(
                          onPressed: (){
                            Navigator.pushNamed(
                              context,
                              AppRoutes.registerRoute,

                            );

                          },
                          height: 30,
                          color: AppColor.white,
                          title: "Sign Up".tr(),
                          // loading: model.isBusy,
                          // onPressed: model.processRegister,
                        ).centered(),
                      ),
                    ),*/
            ])
                .p12()
                .box
                .topRounded(value: 25)
                .height(context.percentHeight * 58)
                .color(AppColor.primaryColor!)
                .make(),
          ],
        )
            .p4()
            .scrollVertical()
            // .backgroundColor(AppColor.midnightCityLightBlue)
            .box
            .color(AppColor.white)
            .topRounded(value: 25)
            .make()
            .positioned(
              top: (context.percentHeight * 42),
              left: 0,
              right: 0,
              bottom: 0,
            ),
      ],
    );
  }

  void processLogout() async {
    //

    //
    final apiResponse = await _authRequest.logoutRequest();

    //

    if (!apiResponse.allGood) {
      //
      // CoolAlert.show(
      //   //context: viewContext,
      //   type: CoolAlertType.error,
      //   title: "Logout".tr(),
      //   text: apiResponse.message,,
      // );
    } else {
      //
      await AuthServices.logout();
    }
  }
}
