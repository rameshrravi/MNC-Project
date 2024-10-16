import 'package:flutter/material.dart';
import 'package:midnightcity/services/validator.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/delivery_address/new_delivery_addresses.vm.dart';
import 'package:midnightcity/views/pages/delivery_address/widgets/what3words.view.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class NewDeliveryAddressesPage extends StatelessWidget {
  const NewDeliveryAddressesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewDeliveryAddressesViewModel>.reactive(
      viewModelBuilder: () => NewDeliveryAddressesViewModel(context),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "New Delivery Address".tr(),
          body: Form(
              key: vm.formKey,
              child: VStack(
                [
                  //
                  CustomTextFormField(
                    labelText: "Name".tr(),
                    borderRadius: 10,
                    textEditingController: vm.nameTEC,
                    validator: FormValidator.validateName,
                  ),
                  //what3words
                  What3wordsView(vm),
                  //
                  CustomTextFormField(
                    labelText: "Address".tr(),
                    isReadOnly: true,
                    borderRadius: 10,
                    textEditingController: vm.addressTEC,
                    validator: (value) => FormValidator.validateEmpty(value,
                        errorTitle: "Address".tr()),
                    onTap: vm.openLocationPicker,
                  ).py2(),
                  // description
                  UiSpacer.verticalSpace(),
                  CustomTextFormField(
                    labelText: "Description".tr(),
                    borderRadius: 10,
                    textEditingController: vm.descriptionTEC,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    textInputAction: TextInputAction.newline,
                  ).py2(),
                  //
                  HStack(
                    [
                      Checkbox(
                        value: vm.isDefault,
                        onChanged: (value) {
                          vm.toggleDefault(value!);
                        },
                      ),
                      //
                      "Default".tr().text.make(),
                    ],
                  )
                      .onInkTap(
                        () => vm.toggleDefault(!vm.isDefault),
                      )
                      .wFull(context)
                      .py12(),

                  CustomButton(
                    isFixedHeight: true,
                    height: Vx.dp48,
                    title: "Save".tr(),
                    onPressed: vm.saveNewDeliveryAddress,
                    loading: vm.isBusy,
                  ).centered(),
                ],
              )
                  .p20()
                  .scrollVertical()
                  .pOnly(bottom: context.mq.viewInsets.bottom)),
        );
      },
    );
  }
}
