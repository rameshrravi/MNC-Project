import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/view_models/order_details.vm.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderPaymentInfoView extends StatelessWidget {
  const OrderPaymentInfoView(this.vm, {Key? key}) : super(key: key);
  final OrderDetailsViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //payment is pending

        CustomVisibilty(
          visible: vm.order.isPaymentPending,
          child: CustomButton(
            title: "Confirm payment".tr(),
            titleStyle: context.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
            icon: FlutterIcons.payment_mdi,
            //icon: Icons.access_alarm_outlined,
            iconSize: 18,
            iconColor: Colors.white,
            onPressed: () => vm.openExternalWebpageLink(vm.order.paymentLink!),
          ).p20().pOnly(bottom: Vx.dp20),
        ),
        //request payment
        CustomVisibilty(
          visible: (vm.order.paymentStatus == "request" &&
              ["pending"].contains(vm.order.status)),
          child: CustomButton(
            title: "PAY FOR ORDER".tr(),
            titleStyle: context.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
            icon: FlutterIcons.credit_card_fea,
            //icon: Icons.access_alarm_outlined,
            iconSize: 18,
            loading: vm.busy(vm.order.paymentStatus),
            onPressed: vm.openPaymentMethodSelection,
          ).wFull(context).p20().pOnly(bottom: Vx.dp20),
        ),
      ],
    );
  }
}
