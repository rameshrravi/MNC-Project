import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_images.dart';
import 'package:midnightcity/view_models/onboarding.vm.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/busy_indicator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/constants/app_routes.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Color(0xff121422),
      body: ViewModelBuilder<OnboardingViewModel>.nonReactive(
        viewModelBuilder: () => OnboardingViewModel(context, finishLoading),
        // onModelReady: (vm) => vm.initialise(),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return VStack(
            [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                    child: Image.asset(
                  AppImages.appLogo,
                  height: 90,
                  width: 80,
                )),
              ),
              Visibility(
                visible: vm.isBusy,
                child: BusyIndicator().centered().expand(),
              ),
              //
              Visibility(
                visible: !vm.isBusy,
                child: OverBoard(
                  pages: vm.onBoardData,
                  showBullets: true,
                  skipText: "Skip".tr(),
                  nextText: "Next".tr(),
                  finishText: "Done".tr(),
                  skipCallback: vm.onDonePressed,
                  finishCallback: vm.onDonePressed,
                  buttonColor: AppColor.midnightCityLightBlue,
                  inactiveBulletColor: AppColor.midnightCityLightBlue,
                  activeBulletColor: Colors.white,
                ).expand(),
              ),
              /*   Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:40.0),
                      child: Center(
                        child: Text(
                            "Do you have an account?",
                            style: const TextStyle(
                                color:  Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 10.0
                            ),
                            textAlign: TextAlign.center
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:12.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.loginRoute,
                                  (route) => false,
                            );

                          },
                          child: Container(
                              width: 150,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: AppColor.midnightCityLightBlue,
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: // Sign in
                              Center(
                                child: Text(
                                    "Sign in",
                                    style: const TextStyle(
                                        color:  Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Nunito",
                                        fontStyle:  FontStyle.normal,
                                        fontSize: 16.0
                                    ),
                                    textAlign: TextAlign.center
                                ),
                              )
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: Center(
                        child: Text(
                            "First time here?",
                            style: const TextStyle(
                                color:  Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle:  FontStyle.normal,
                                fontSize: 10.0
                            ),
                            textAlign: TextAlign.center
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:12.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.registerRoute,
                                  (route) => false,
                            );




                          },
                          child: Container(
                              width: 150,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: AppColor.midnightCityLightBlue,
                                      width: 1.5
                                  ),
                                  color: AppColor.midnightCityDarkBlue
                              ),
                              child: // Sign in
                              Center(
                                child: Text(
                                    "Get started",
                                    style: const TextStyle(
                                        color:  Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Nunito",
                                        fontStyle:  FontStyle.normal,
                                        fontSize: 16.0
                                    ),
                                    textAlign: TextAlign.center
                                ),
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )*/
            ],
          ).color(Color(0xff121422));
        },
      ),
    );
  }

  finishLoading() {
    setState(() {});
  }
}
