import 'package:flutter/material.dart';
import 'package:midnightcity/models/checkout.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/multiple_checkout.vm.dart';
import 'package:midnightcity/views/pages/checkout/widgets/driver_cash_delivery_note.view.dart';
import 'package:midnightcity/views/pages/checkout/widgets/order_delivery_address.view.dart';
import 'package:midnightcity/views/pages/checkout/widgets/payment_methods.view.dart';
import 'package:midnightcity/views/pages/checkout/widgets/schedule_order.view.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/cards/multiple_vendor_order_summary.dart';
import 'package:midnightcity/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:supercharged/supercharged.dart';

class MultipleOrderCheckoutPage extends StatelessWidget {
  const MultipleOrderCheckoutPage({this.checkout, Key? key}) : super(key: key);

  final CheckOut? checkout;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MultipleCheckoutViewModel>.reactive(
      viewModelBuilder: () => MultipleCheckoutViewModel(context, checkout!),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Multiple Order Checkout".tr(),
          body: VStack(
            [
              //
              UiSpacer.verticalSpace(),
              //
              CustomTextFormField(
                labelText: "Note".tr(),
                textEditingController: vm.noteTEC,
              ),

              //note
              Divider(thickness: 3).py12(),

              //pickup time slot
              ScheduleOrderView(vm),

              //its pickup
              OrderDeliveryAddressPickerView(vm),

              //payment options
              Visibility(
                visible: vm.canSelectPaymentOption,
                child: PaymentMethodsView(vm),
              ),

              //order final price preview
              MultipleVendorOrderSummary(
                subTotal: vm.checkout!.subTotal,
                discount: vm.checkout!.discount,
                deliveryFee: vm.totalDeliveryFee,
                tax: vm.checkout!.tax,
                taxes: vm.taxes,
                vendors: vm.vendors,
                subtotals: vm.subtotals,
                driverTip: vm.driverTipTEC.text.toDouble() ?? 0.00,
                total: vm.checkout!.totalWithTip,
              ),

//show notice it driver should be paid in cash
              CheckoutDriverCashDeliveryNoticeView(),
              //
              CustomButton(
                title: "PLACE ORDER".tr().padRight(14),
                icon: Icons.ac_unit_rounded,
                //icon: FlutterIcons.credit_card_fea,
                onPressed: vm.placeOrder,
                loading: vm.isBusy,
              ).centered().py16(),
            ],
          ).p20().scrollVertical().pOnly(bottom: context.mq.viewInsets.bottom),
        );
      },
    );
  }
}
