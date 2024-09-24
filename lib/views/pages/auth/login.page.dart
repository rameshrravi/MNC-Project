import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_images.dart';
import 'package:midnightcity/view_models/login.view_model.dart';
import 'package:midnightcity/views/pages/auth/login/email_login.view.dart';
import 'package:midnightcity/views/pages/auth/login/otp_login.view.dart';
import 'package:midnightcity/views/pages/auth/login/social_media.view.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'login/scan_login.view.dart';
import 'package:flutter_launcher_icons/abs/icon_generator.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/config/config.dart';
import 'package:flutter_launcher_icons/config/macos_config.dart';
import 'package:flutter_launcher_icons/config/web_config.dart';
import 'package:flutter_launcher_icons/config/windows_config.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/logger.dart';
import 'package:flutter_launcher_icons/macos/macos_icon_generator.dart';
import 'package:flutter_launcher_icons/macos/macos_icon_template.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/pubspec_parser.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_launcher_icons/web/web_icon_generator.dart';
import 'package:flutter_launcher_icons/web/web_template.dart';
import 'package:flutter_launcher_icons/windows/windows_icon_generator.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.required = false, Key? key}) : super(key: key);

  final bool required;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(context),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (widget.required) {
              // context.pop();
              Navigator.pop(context);
            }
            return true;
          },
          child: BasePage(
            backgroundColor: Color(0xff121422),
            /*    showLeadingAction: !widget.required,
           showAppBar: !widget.required,
            appBarColor: Color(0xff121422),
            leading:
            elevation: 0,*/
            isLoading: model.isBusy,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                  top: true,
                  bottom: false,
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
                    child: VStack(
                      [
                        // icon: Icon(FlutterIcons.ios_arrow_back_ion,
                        IconButton(
                          //icon: Icon(FlutterIcons.ios_arrow_back_ion),
                          icon: Icon(FlutterIcons.ios_arrow_back_ion,
                              color: AppColor.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        // "Welcome Back".tr().text.xl2.semiBold.color(Colors.white).make(),
                        // "Login to continue".tr().text.light.make(),

                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Center(
                            child: Image.asset(
                              AppImages.appLogo,
                            )
                                .h(190)
                                .w(190)
                                .centered()
                                .box
                                .roundedFull
                                .clip(Clip.antiAlias)
                                .make(),
                          ),
                        ),

// Enter your number
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Center(
                            child: Text("Enter your number",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 22.0),
                                textAlign: TextAlign.center),
                          ),
                        ),

                        //otp form
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 43.0, left: 43, top: 20),
                          child: OTPLoginView(model),
                        ),

// If you are creating a new account, Terms and Condition and Privacy Policy will apply.
                        Padding(
                          padding: const EdgeInsets.only(right: 60, left: 60.0),
                          child: Center(
                            child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                      style: const TextStyle(
                                          color: const Color(0xff979797),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Poppins",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 10.0),
                                      text:
                                          "If you are creating a new account, "),
                                  TextSpan(
                                      style: const TextStyle(
                                          color: AppColor.butterscotch,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 10.0),
                                      text: "Terms and Condition "),
                                  TextSpan(
                                      style: const TextStyle(
                                          color: const Color(0xff979797),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Poppins",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 10.0),
                                      text: " and "),
                                  TextSpan(
                                      style: const TextStyle(
                                          color: AppColor.butterscotch,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 10.0),
                                      text: "Privacy Policy "),
                                  TextSpan(
                                      style: const TextStyle(
                                          color: const Color(0xff979797),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Poppins",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 10.0),
                                      text: " will apply.")
                                ])),
                          ),
                        ),
                        // We will send you an SMS for verification

                        //email form
                        EmailLoginView(model),

                        //
                        SocialMediaView(model, bottomPadding: 10),
                        ScanLoginView(model),
                      ],
                    ).scrollVertical(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
