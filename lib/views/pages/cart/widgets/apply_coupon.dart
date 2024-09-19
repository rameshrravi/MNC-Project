import 'package:flutter/material.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/cart.vm.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/custom_text_form_field.dart';
import 'package:midnightcity/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ApplyCoupon extends StatelessWidget {
  const ApplyCoupon(this.vm, {Key? key}) : super(key: key);

  final CartViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        "Add Coupon".tr().text.color(Colors.black).semiBold.xl.make(),
        UiSpacer.verticalSpace(space: 10),
        //
        vm.isAuthenticated()
            ? CustomTextFormField(
                borderRadius: 10,
                hintText: "Enter Coupon Code".tr(),
                textEditingController: vm.couponTEC,
                errorText: vm.hasErrorForKey(vm.coupon!)
                    ? vm.error(vm.coupon!).toString()
                    : null,
                onChanged: () {
                  vm.couponCodeChange;
                },
                suffixIcon: CustomButton(
                  child: Icon(Icons.ac_unit_rounded
                      //FlutterIcons.check_ant,
                      ),
                  isFixedHeight: true,
                  loading: vm.busy(vm.coupon),
                  onPressed: vm.canApplyCoupon! ? vm.applyCoupon : null,
                ).w(62).p8(),
              )
            : VStack(
                [
                  //
                  EmptyState(
                    auth: true,
                    showImage: false,
                    actionPressed: vm.openLogin,
                  ),
                ],
              ),
      ],
    );
  }
}
