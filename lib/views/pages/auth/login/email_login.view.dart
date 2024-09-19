import 'package:flutter/material.dart';
import 'package:midnightcity/services/validator.service.dart';
import 'package:midnightcity/view_models/login.view_model.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmailLoginView extends StatelessWidget {
  const EmailLoginView(this.model, {Key? key}) : super(key: key);

  final LoginViewModel model;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !model.otpLogin,
      child: Form(
        key: model.formKey,
        child: VStack(
          [
            //
            CustomTextFormField(
              labelText: "Email".tr(),
              labelColor: Colors.white,
              textColor: Colors.white,
              fillColor: Color(0xff323549),
              keyboardType: TextInputType.emailAddress,
              textEditingController: model.emailTEC,
              validator: FormValidator.validateEmail,
            ).py12(),
            CustomTextFormField(
              labelText: "Password".tr(),
              textColor: Colors.white,
              labelColor: Colors.white,
              fillColor: Color(0xff323549),
              obscureText: true,
              textEditingController: model.passwordTEC,
              validator: FormValidator.validatePassword,
            ).py12(),

            //
            "Forgot Password ?"
                .tr()
                .text
                .underline
                .color(Colors.white)
                .make()
                .onInkTap(
                  model.openForgotPassword,
                ),
            //
            CustomButton(
              title: "Login".tr(),
              loading: model.isBusy,
              onPressed: model.processLogin,
            ).centered().py12(),
//otp login
            "Login with Phone Number"
                .tr()
                .text
                .color(Colors.white)
                .semiBold
                .makeCentered()
                .py12()
                .onInkTap(model.toggleLoginType),
            //register
            "OR".tr().text.light.color(Colors.white).makeCentered(),
            "Create An Account"
                .tr()
                .text
                .color(Colors.white)
                .semiBold
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
