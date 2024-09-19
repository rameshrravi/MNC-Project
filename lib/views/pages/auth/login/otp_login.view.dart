import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/services/validator.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/login.view_model.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/constants/app_colors.dart';

class OTPLoginView extends StatelessWidget {
  const OTPLoginView(this.model, {Key? key}) : super(key: key);

  final LoginViewModel model;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: model.otpLogin,
      child: Form(
        key: model.formKey,
        child: VStack(
          [
            //
            HStack(
              [
                CustomTextFormField(
                  prefixIcon: HStack(
                    [
                      //icon/flag
                      Flag.fromString(
                        model.selectedCountry.countryCode,
                        width: 20,
                        height: 20,
                      ),
                      UiSpacer.horizontalSpace(space: 5),
                      //text
                      ("+" + model.selectedCountry.phoneCode)
                          .text
                          .color(Colors.white)
                          .make(),
                    ],
                  ).px8().onInkTap(model.showCountryDialPicker),
                  labelText: "Phone number".tr(),
                  labelColor: Colors.white,
                  textColor: Colors.white,
                  hintText: "",
                  keyboardType: TextInputType.phone,
                  textEditingController: model.phoneTEC,
                  validator: FormValidator.validatePhone,
                  fillColor: AppColor.dark,
                  // onChanged: (value) {
                  //   String result = value;
                  //   // Here replace 4 by your maxLength value
                  //   if (result.length > 10) {
                  //     result = result.substring(0, 10);
                  //   }
                  //   model.phoneTEC.text = result;
                  //   model.phoneTEC.selection = TextSelection.fromPosition(
                  //     TextPosition(offset: result.length),
                  //   );
                  // },
                ).expand(),
              ],
            ).py12(),
            //
            Text(
              "Format - +234 8888888888 (Please do not input '0' in front)",
              style: TextStyle(color: Colors.white),
            ),

            CustomButton(
              color: AppColor.midnightCityLightBlue,
              height: 35,
              title: "Sign In".tr(),
              loading: model.busy(model.otpLogin),
              onPressed: model.processOTPLogin,
            ).centered().py12(),
            //email login

            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Center(
                child: Text("We will send you an SMS for verification ",
                    style: const TextStyle(
                        color: AppColor.formText,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.center),
              ),
            ),

            "Login with Email"
                .tr()
                .text
                .color(Colors.white)
                .semiBold
                .makeCentered()
                .py12()
                .onInkTap(model.toggleLoginType),
            //register
            "OR".tr().text.color(Colors.white).light.makeCentered(),
            "Create an Account"
                .tr()
                .text
                .semiBold
                .color(Colors.white)
                .makeCentered()
                .py12()
                .onInkTap(model.openRegister),
          ],
          crossAlignment: CrossAxisAlignment.end,
        ),
      ).py20(),
    );
  }
}
