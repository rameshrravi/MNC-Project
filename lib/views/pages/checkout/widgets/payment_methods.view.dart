import 'package:flutter/material.dart';
import 'package:midnightcity/view_models/checkout_base.vm.dart';
import 'package:midnightcity/widgets/custom_grid_view.dart';
import 'package:midnightcity/widgets/custom_list_view.dart';

import 'package:midnightcity/widgets/list_items/payment_method.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView(this.vm, {Key? key}) : super(key: key);

  final CheckoutBaseViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Container(
        child: CustomListView(
          noScrollPhysics: true,
          dataSet: vm.paymentMethods,
          //  childAspectRatio: 3,
          //  crossAxisSpacing: 10,
          //  mainAxisSpacing: 10,
          isLoading: vm.busy(vm.paymentMethods),
          itemBuilder: (context, index) {
            //
            final paymentMethod = vm.paymentMethods[index];
            return PaymentOptionListItem(
              paymentMethod,
              selected: vm.isSelected(paymentMethod),
              onSelected: vm.changeSelectedPaymentMethod,
            );
          },
        ),
      ),
      //
    );
  }
}
