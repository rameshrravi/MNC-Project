import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/checkout.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/checkout.vm.dart';
import 'package:midnightcity/views/pages/checkout/widgets/driver_cash_delivery_note.view.dart';
import 'package:midnightcity/views/pages/checkout/widgets/order_delivery_address.view.dart';
import 'package:midnightcity/views/pages/checkout/widgets/payment_methods.view.dart';
import 'package:midnightcity/views/pages/checkout/widgets/schedule_order.view.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/cards/order_summary.dart';
import 'package:midnightcity/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:supercharged/supercharged.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:flutter/services.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({this.checkout, Key? key}) : super(key: key);

  final CheckOut? checkout;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      viewModelBuilder: () => CheckoutViewModel(context, checkout!),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          elevation: 0,
          showAppBar: true,
          showLeadingAction: true,
          title: "Checkout".tr(),
          body: VStack(
            [
              //
              UiSpacer.verticalSpace(),
              /*  Visibility(
                visible: !vm.isPickup ?? true,
                child: CustomTextFormField(

                  labelText:
                      "Driver Tip".tr() + " (${AppStrings.currencySymbol})",
                  textEditingController: vm.driverTipTEC,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => vm.updateCheckoutTotalAmount(),
                ).pOnly(bottom: Vx.dp20),
              ),*/
              //

              //note
              //    Divider(thickness: 3).py12(),

              //pickup time slot
              /*   ScheduleOrderView(vm),*/

              //its pickup
              OrderDeliveryAddressPickerView(vm),
              Divider(
                color: Colors.black,
              ),
              // Delivery Instructions
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 12.0),
                child: Text("Pickup/Delivery Instructions",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.left),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 12, bottom: 12),
                child: CustomTextFormField(
                  borderRadius: 10,
                  maxLines: 3,
                  labelText: "Leave a note".tr(),
                  textEditingController: vm.noteTEC,
                ),
              ),

              Divider(
                color: AppColor.formText,
              ),
              //payment options
              Visibility(
                visible: vm.canSelectPaymentOption,
                child: PaymentMethodsView(vm),
              ),

              //order final price preview
              OrderSummary(
                subTotal: vm.checkout!.subTotal,
                discount: vm.checkout!.discount,
                deliveryFee: vm.checkout!.deliveryFee,
                tax: vm.checkout!.tax,
                vendorTax: vm.vendor.tax,
                driverTip: vm.driverTipTEC.text.toDouble() ?? 0.00,
                total: vm.checkout!.totalWithTip,
                fees: vm.vendor.fees,
              ),

              //show notice it driver should be paid in cash
              CheckoutDriverCashDeliveryNoticeView(),
              //
              CustomButton(
                title: "PLACE ORDER".tr().padRight(14),
                icon: Icons.ac_unit_rounded,
                // icon: FlutterIcons.credit_card_fea,
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
