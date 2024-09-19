import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_images.dart';
import 'package:midnightcity/services/validator.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';

import 'package:midnightcity/view_models/forgot_password.view_model.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      viewModelBuilder: () => ForgotPasswordViewModel(context),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          body: SafeArea(
            top: true,
            bottom: false,
            child: VStack(
              [
                Image.asset(
                  AppImages.onboarding1,
                ).hOneForth(context).centered(),
                //
                VStack(
                  [
                    //
                    "Forgot Password".tr().text.xl2.semiBold.make(),

                    //form
                    Form(
                      key: model.formKey,
                      child: VStack(
                        [
                          //
                          CustomTextFormField(
                            prefixIcon: HStack(
                              [
                                //icon/flag
                                Flag.fromString(
                                  model.selectedCountry!.countryCode,
                                  width: 20,
                                  height: 20,
                                ),
                                UiSpacer.horizontalSpace(space: 5),
                                //text
                                ("+" + model.selectedCountry!.phoneCode)
                                    .text
                                    .make(),
                              ],
                            ).px8().onInkTap(model.showCountryDialPicker),
                            labelText: "Phone Number".tr(),
                            hintText: "",
                            keyboardType: TextInputType.phone,
                            textEditingController: model.phoneTEC,
                            validator: FormValidator.validatePhone,
                          ).py12(),
                          Text(
                            "Format - +234 8888888888 (Please don't input '0' in front)",
                            style: TextStyle(color: Colors.white),
                          ),
                          //
                          CustomButton(
                            title: "Send OTP".tr(),
                            loading: model.isBusy,
                            onPressed: model.processForgotPassword,
                          ).h(Vx.dp48).centered().py12(),
                        ],
                        crossAlignment: CrossAxisAlignment.end,
                      ),
                    ).py20(),
                  ],
                ).wFull(context).p20(),

                //
              ],
            ).scrollVertical(),
          ),
        );
      },
    );
  }
}
