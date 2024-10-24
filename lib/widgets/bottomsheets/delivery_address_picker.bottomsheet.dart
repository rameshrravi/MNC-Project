import 'package:flutter/material.dart';
import 'package:midnightcity/models/delivery_address.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/delivery_address/delivery_addresses_picker.vm.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/custom_list_view.dart';
import 'package:midnightcity/widgets/custom_text_form_field.dart';
import 'package:midnightcity/widgets/list_items/delivery_address.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/constants/app_colors.dart';

class DeliveryAddressPicker extends StatelessWidget {
  const DeliveryAddressPicker(
      {this.onSelectDeliveryAddress, this.allowOnMap = false, Key? key})
      : super(key: key);

  final Function(DeliveryAddress)? onSelectDeliveryAddress;
  final bool? allowOnMap;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeliveryAddressPickerViewModel>.reactive(
      viewModelBuilder: () =>
          DeliveryAddressPickerViewModel(context, onSelectDeliveryAddress!),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return VStack(
          [
            //
            UiSpacer.swipeIndicator().py12(),
            //
            HStack(
              [
                //
                VStack(
                  [
                    "Delivery address".tr().text.white.make(),
                    "Select order delivery address".tr().text.white.make(),
                  ],
                ).expand(),

                //
                AuthServices.authenticated()
                    ? CustomButton(
                        title: "New".tr(),
                        //  icon: FlutterIcons.plus_ant,
                        icon: Icons.import_contacts_sharp,
                        iconColor: Colors.white,
                        onPressed: vm.newDeliveryAddressPressed,
                      )
                    : UiSpacer.emptySpace(),
              ],
            ).p16().box.outerShadow.color(context.cardColor).make(),
            //filter result
            CustomTextFormField(
              hintText: "Search".tr(),
              prefixIcon: Icon(
                Icons.import_contacts_sharp,
                //FlutterIcons.search_fea,
                size: 20,
              ),
              onChanged: () {
                vm.filterResult!;
              },
            ).p20().color(AppColor.mainBackground),
            //result list
            CustomVisibilty(
              visible: vm.isBusy ||
                  (vm.deliveryAddresses != null &&
                      vm.deliveryAddresses.isNotEmpty),
              child: SafeArea(
                top: false,
                child: Container(
                  color: AppColor.mainBackground,
                  child: CustomListView(
                    dataSet: vm.deliveryAddresses,
                    isLoading: vm.isBusy,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      //
                      final deliveryAddress = vm.deliveryAddresses[index];
                      return DeliveryAddressListItem(
                        deliveryAddress: deliveryAddress,
                        action: false,
                        borderColor: Colors.grey.shade300,
                      ).onInkTap(
                        (deliveryAddress.can_deliver == null ||
                                deliveryAddress.can_deliver!)
                            ? () =>
                                this.onSelectDeliveryAddress!(deliveryAddress)
                            : null,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        UiSpacer.verticalSpace(),
                  ),
                ),
              ),
            ).expand(),

            //
            allowOnMap!
                ? SafeArea(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(alignment: Alignment.center),
                      label: "Choose on map".tr().text.make(),
                      // icon: Icon(FlutterIcons.location_pin_ent),
                      icon: Icon(Icons.location_on_sharp),
                      onPressed: vm.pickFromMap,
                    ).wFull(context).px20(),
                  )
                : UiSpacer.emptySpace(),
          ],
        )
            .box
            .color(context.backgroundColor)
            .topRounded()
            .clip(Clip.antiAlias)
            .make()
            .h(context.percentHeight * 95);
      },
    );
  }
}
