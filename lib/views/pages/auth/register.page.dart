import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_images.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/services/validator.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/register.view_model.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/constants/api.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    this.email,
    this.name,
    this.phone,
    Key? key,
  }) : super(key: key);

  final String? email;
  final String? name;
  final String? phone;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool sendGreeting = false;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(context),
      onModelReady: (model) {
        model.nameTEC.text = widget.name!;
        model.emailTEC.text = widget.email!;
        model.phoneTEC.text = widget.phone!;
        model.initialise();
      },
      builder: (context, model, child) {
        return BasePage(
          backgroundColor: Color(0xff121422),
          /*  showLeadingAction: true,
          leading: IconButton(
            icon: Icon(FlutterIcons.ios_arrow_back_ion,
                color: AppColor.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
            showAppBar: true,
          appBarColor: Colors.transparent,*/
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Padding(
                padding: EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
                child: VStack(
                  [
                    IconButton(
                      icon: Icon(Icons.abc_sharp,
                          // FlutterIcons.ios_arrow_back_ion,
                          color: AppColor.white,
                          size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    /*  Image.asset(
                          AppImages.onboarding2,
                        ).hOneForth(context).centered(),*/
                    //
                    Center(
                      child: VStack(
                        [
                          //

                          Text("Enter your details",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18.0),
                              textAlign: TextAlign.left),
                          /* Center(child: "Join Us".tr().text.xl2.semiBold.color(Colors.white).make()),
                              Center(child: "Create an account now".tr().text.color(Colors.white).light.make()),
*/
                          //form
                          Form(
                            key: model.formKey,
                            child: VStack(
                              [
                                //
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Text(
                                    "Full Name",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0),
                                  ),
                                ),

                                CustomTextFormField(
                                  labelText: "FullName".tr(),
                                  labelColor: Colors.white,
                                  textColor: Colors.white,
                                  textEditingController: model.nameTEC,
                                  fillColor: Color(0xff323549),
                                  validator: FormValidator.validateName,
                                ).py12(),
                                //
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    "Email",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0),
                                  ),
                                ),
                                CustomTextFormField(
                                  labelText: "Email Address".tr(),
                                  labelColor: Colors.white,
                                  textColor: Colors.white,
                                  fillColor: Color(0xff323549),
                                  keyboardType: TextInputType.emailAddress,
                                  textEditingController: model.emailTEC,
                                  validator: FormValidator.validateEmail,
                                ).py12(),
                                //
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    "Phone number",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0),
                                  ),
                                ),
                                HStack(
                                  [
                                    CustomTextFormField(
                                      prefixIcon: HStack(
                                        [
                                          //icon/flag
                                          Flag.fromString(
                                            "NG",
                                            width: 20,
                                            height: 20,
                                          ),
                                          UiSpacer.horizontalSpace(space: 5),
                                          //text
                                          ("+" + "234")
                                              .text
                                              .color(Colors.white)
                                              .make(),
                                        ],
                                      ).px8(),
                                      labelText: "".tr(),
                                      labelColor: Colors.white,
                                      textColor: Colors.white,
                                      fillColor: Color(0xff323549),
                                      hintText: "",
                                      keyboardType: TextInputType.phone,
                                      textEditingController: model.phoneTEC,
                                      validator: FormValidator.validatePhone,
                                      onChanged: () {},
                                      // onChanged: (value) {
                                      //   String result = value;
                                      //   // Here replace 4 by your maxLength value8064353000
                                      //   if (result.length > 10) {
                                      //     result = result.substring(0, 10);
                                      //   }
                                      //   //  model.phoneTEC.text = result;
                                      //   //  model.phoneTEC.selection = TextSelection.fromPosition(
                                      //   //    TextPosition(offset: result.length),
                                      //   //  );
                                      // },
                                    ).expand(),
                                  ],
                                ).py12(),
                                //

                                Text(
                                  "Format - +234 8888888888 (Please do not input '0' in front)",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    "Password",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0),
                                  ),
                                ),
                                CustomTextFormField(
                                  labelText: "Password".tr(),
                                  labelColor: Colors.white,
                                  textColor: Colors.white,
                                  fillColor: Color(0xff323549),
                                  obscureText: true,
                                  textEditingController: model.passwordTEC,
                                  validator: FormValidator.validatePassword,
                                ).py12(),
                                //
                                AppStrings.enableReferSystem
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          "Referral Code",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 18.0),
                                        ),
                                      )
                                    : UiSpacer.emptySpace(),
                                AppStrings.enableReferSystem
                                    ? CustomTextFormField(
                                        labelText:
                                            "Referral Code(optional)".tr(),
                                        labelColor: Colors.white,
                                        textColor: Colors.white,
                                        fillColor: Color(0xff323549),
                                        textEditingController:
                                            model.referralCodeTEC,
                                      ).py12()
                                    : UiSpacer.emptySpace(),

                                //terms
                                HStack(
                                  [
                                    Checkbox(
                                      side: BorderSide(color: AppColor.white),
                                      //fillColor:M
                                      checkColor: AppColor.primaryTextColor,
                                      activeColor:
                                          AppColor.midnightCityLightBlue,
                                      value: model.agreed,
                                      onChanged: (value) {
                                        model.agreed = value!;
                                        model.notifyListeners();
                                      },
                                    ),
                                    //
                                    "I agree with"
                                        .tr()
                                        .text
                                        .color(Colors.white)
                                        .make(),
                                    UiSpacer.horizontalSpace(space: 2),
                                    "Terms & Conditions"
                                        .tr()
                                        .text
                                        .color(AppColor.midnightCityYellow)
                                        .bold
                                        .underline
                                        .make()
                                        .onInkTap(model.openTerms)
                                        .expand(),
                                  ],
                                ),

                                Text(
                                    "Your information is safe & will not be shared. Confirm your birthday for a personalised experience",
                                    style: const TextStyle(
                                        color: const Color(0xffaeaeae),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 11.0),
                                    textAlign: TextAlign.center),

                                HStack(
                                  [
                                    Checkbox(
                                      side: BorderSide(color: AppColor.white),
                                      //fillColor:M
                                      checkColor: AppColor.primaryTextColor,
                                      activeColor:
                                          AppColor.midnightCityLightBlue,
                                      value: sendGreeting,
                                      onChanged: (value) {
                                        sendGreeting = value!;
                                        model.notifyListeners();
                                      },
                                    ),
                                    //
                                    Text(
                                        "Send me notifications, promos & birthday deals via email ",
                                        style: const TextStyle(
                                            color: const Color(0xffaeaeae),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 10.0),
                                        textAlign: TextAlign.center)
                                  ],
                                ),

                                //
                                CustomButton(
                                  height: 35,
                                  color: AppColor.midnightCityLightBlue,
                                  title: "Sign Up".tr(),
                                  loading: model.isBusy,
                                  onPressed: model.processRegister,
                                ).centered().py12(),
// Your information is safe & will not be shared. Confirm your birthday for a personalised experience

                                //register
                                "OR"
                                    .tr()
                                    .text
                                    .color(Colors.white)
                                    .light
                                    .makeCentered(),
                                "Already have an Account"
                                    .tr()
                                    .text
                                    .semiBold
                                    .color(Colors.white)
                                    .makeCentered()
                                    .py12()
                                    .onInkTap(model.openLogin),
                              ],
                              alignment: MainAxisAlignment.start,
                              crossAlignment: CrossAxisAlignment.start,
                            ),
                          ).py20(),
                        ],
                      ).wFull(context).p20(),
                    ),

                    //
                  ],
                  alignment: MainAxisAlignment.start,
                ).scrollVertical(),
              ),
            ),
          ),
        );
      },
    );
  }
}
