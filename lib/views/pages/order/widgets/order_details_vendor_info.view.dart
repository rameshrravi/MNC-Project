import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_ui_settings.dart';
import 'package:midnightcity/extensions/dynamic.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/order_details.vm.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderDetailsVendorInfoView extends StatelessWidget {
  const OrderDetailsVendorInfoView(this.vm, {Key? key}) : super(key: key);
  final OrderDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        HStack(
          [
            //
            /*   VStack(
              [
                (!vm.order.isSerice ? "Vendor" : "Service Provider")
                    .tr()
                    .text
                    .gray500
                    .medium
                    .make(),
                vm.order.vendor.name.text.medium.xl
                    .make()
                    .py8()
                    .pOnly(bottom: Vx.dp4),
              ],
            ).expand(),*/
            //call
            /*        vm.order.canChatVendor
                ? CustomButton(
              height: 20,
                    icon: FlutterIcons.phone_call_fea,
                    iconColor: Colors.white,
                    color: AppColor.primaryColor,
                    shapeRadius: Vx.dp20,
                    onPressed: vm.callVendor,
                  ).wh(Vx.dp64, Vx.dp40).p12()
                : UiSpacer.emptySpace(),
*/
            if (vm.order.canChatVendor)
              Visibility(
                visible: AppUISettings.canVendorChat,
                child: CustomButton(
                  height: 32,
                  //icon: FlutterIcons.chat_ent,
                  icon: Icons.access_alarm_outlined,
                  iconColor: Colors.white,
                  title: "Chat with us".tr().fill([
                    (!vm.order.isSerice ? "Vendor" : "Service Provider").tr()
                  ]),
                  color: AppColor.primaryColor,
                  onPressed: vm.chatVendor,
                ).h(Vx.dp48).pOnly(top: Vx.dp12, bottom: Vx.dp20),
              )
            else
              UiSpacer.emptySpace(),

            vm.order.canRateVendor
                ? CustomButton(
                    // icon: FlutterIcons.rate_review_mdi,
                    //icon: Icons.access_alarm_outlined,
                    iconColor: Colors.white,
                    title: "Rate %s".tr().fill([
                      (!vm.order.isSerice ? "Vendor" : "Service Provider").tr()
                    ]),
                    color: AppColor.primaryColor,
                    onPressed: vm.rateVendor,
                  ).h(Vx.dp48).pOnly(top: Vx.dp12, bottom: Vx.dp20)
                : UiSpacer.emptySpace(),
          ],
          alignment: MainAxisAlignment.center,
          crossAlignment: CrossAxisAlignment.center,
        ),

        //chat

        //rate vendor
      ],
      alignment: MainAxisAlignment.center,
      crossAlignment: CrossAxisAlignment.center,
    );
  }
}
