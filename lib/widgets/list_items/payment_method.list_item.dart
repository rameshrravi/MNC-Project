import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/models/payment_method.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentOptionListItem extends StatelessWidget {
  const PaymentOptionListItem(
    this.paymentMethod, {
    this.selected = false,
    Key? key,
    this.onSelected,
  }) : super(key: key);

  final bool? selected;
  final PaymentMethod? paymentMethod;
  final Function(PaymentMethod)? onSelected;

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        /*  color:  Colors.white,
        fontWeight: FontWeight.w300,
        fontFamily: "Poppins",
        fontStyle:  FontStyle.normal,
        fontSize: 16.0
*/

        CustomImage(
          imageUrl: paymentMethod!.photo,
          width: Vx.dp48,
          height: Vx.dp48,
          boxFit: BoxFit.contain,
        ).px4().py8(),
        //
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: paymentMethod!.name!.text.black
              .fontFamily("Poppins")
              .fontWeight(FontWeight.w300)
              .normal
              .size(16)
              .make(),
        ),
        UiSpacer.horizontalSpace(),
      ],
    )
        .box
        .roundedSM
        .border(
          color: selected!
              ? AppColor.primaryColor!
              : context.textTheme.bodyLarge!.color!.withOpacity(0.20),
          width: selected! ? 2 : 1,
        )
        .make()
        .onInkTap(
          () => onSelected!(paymentMethod!),
        );
  }
}
