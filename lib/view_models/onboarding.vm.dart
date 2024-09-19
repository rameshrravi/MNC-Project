import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/requests/settings.request.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/utils/utils.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/constants/app_colors.dart';

class OnboardingViewModel extends MyBaseViewModel {
  OnboardingViewModel(BuildContext context, this.finishLoading) {
    this.viewContext = context;
  }

  final PageController pageController = PageController();
  final Function finishLoading;

  List<PageModel> onBoardData = [];

  initialise() {
    final bgColor =
        Color(0xff121422); //Colors.black; //viewContext!.backgroundColor;
    final textColor = Utils.textColorByColor(viewContext!.backgroundColor);
    //
    /*onBoardData = [
      PageModel(
        color: bgColor,
        titleColor: textColor,
        bodyColor: textColor,
        imageAssetPath: AppImages.onboarding1,
        title: "Browse dds different vendors".tr(),
        body: "Get your favourite meal/food/items from varities of vendor".tr(),
        doAnimateImage: true,
      ),
      PageModel(
        color: bgColor,
        titleColor: textColor,
        bodyColor: textColor,
        imageAssetPath: AppImages.onboarding2,
        title: "Chat with vendor/delivery boy".tr(),
        body:
            "Call/Chat with vendor/delivery boy for update about your order and more"
                .tr(),
        doAnimateImage: true,
      ),
      PageModel(
        color: bgColor,
        titleColor: textColor,
        bodyColor: textColor,
        imageAssetPath: AppImages.onboarding3,
        title: "Delivfdfdery made easy".tr(),
        body:
            "Get your ordered food/item or parcel delivered at a very fast, cheap and reliable way"
                .tr(),
        doAnimateImage: true,
      ),
    ];*/
    //
    loadOnboardingData();
  }

  loadOnboardingData() async {
    setBusy(true);
    try {
      final apiResponse = await SettingsRequest().appOnboardings();
      //load the data
      if (apiResponse.allGood) {
        final mOnBoardDatas = (apiResponse.body as List).map(
          (e) {
            return PageModel.withChild(
              child: VStack(
                [
                  Padding(
                    padding: new EdgeInsets.only(top: 0, bottom: 40.0),
                    child: CustomImage(
                      imageUrl: "${e['photo']}",
                      width: viewContext!.percentWidth * 40,
                      height: viewContext!.percentWidth * 40,
                      boxFit: BoxFit.cover,
                    ).centered(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Center(
                        child: "${e["title"]}"
                            .tr()
                            .text
                            .xl3
                            .bold
                            .color(Colors.white)
                            .make()),
                  ),
                  UiSpacer.vSpace(5),
                  Padding(
                    padding: const EdgeInsets.only(right: 50.0, left: 50),
                    child: Center(
                        child: "${e["description"]}"
                            .tr()
                            .text
                            .lg
                            .hairLine
                            .center
                            .color(Colors.white)
                            .make()),
                  ),
                ],
                alignment: MainAxisAlignment.start,
              ).p20(),
              color: Color(
                  0xff121422), // Colors.black,// viewContext!.backgroundColor,
              doAnimateChild: true,
            );
          },
        ).toList();
        //
        if (mOnBoardDatas != null && mOnBoardDatas.isNotEmpty) {
          onBoardData = mOnBoardDatas;
        }
      } else {
        toastError("${apiResponse.message}");
      }
    } catch (error) {
      toastError("$error");
    }
    setBusy(false);
    finishLoading();
  }

  void onDonePressed() async {
    //
    await AuthServices.firstTimeCompleted();
    // viewContext!.navigator.pushNamedAndRemoveUntil(
    //   AppRoutes.chooseVendorRoute,
    //   (route) => false,
    // );

    Navigator.pushNamed(viewContext!, AppRoutes.chooseVendorRoute);
  }
}
