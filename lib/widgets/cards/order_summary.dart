import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/extensions/dynamic.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/fee.dart';
import 'package:midnightcity/views/pages/cart/widgets/amount_tile.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({
    this.subTotal,
    this.discount,
    this.deliveryFee,
    this.tax,
    this.vendorTax,
    this.fees,
    this.total,
    this.driverTip = 0.00,
    this.mCurrencySymbol,
    Key? key,
  }) : super(key: key);

  final double? subTotal;
  final double? discount;
  final double? deliveryFee;
  final double? tax;
  final String? vendorTax;
  final double? total;
  final double? driverTip;
  final String? mCurrencySymbol;
  final List<Fee>? fees;
  @override
  Widget build(BuildContext context) {
    final currencySymbol =
        mCurrencySymbol != null ? mCurrencySymbol : AppStrings.currencySymbol;
    return VStack(
      [
        "Order Summary"
            .tr()
            .text
            .semiBold
            .white
            .xl
            .make()
            .pOnly(bottom: Vx.dp12),
        AmountTile("Subtotal".tr(), (subTotal ?? 0).currencyValueFormat())
            .py2(),
        AmountTile(
          "Discount".tr(),
          "- " +
              "$currencySymbol ${discount ?? 0}".currencyFormat(currencySymbol),
        ).py2(),
        Visibility(
          visible: deliveryFee != null,
          child: AmountTile(
            "Delivery Fee".tr(),
            "+ " +
                "$currencySymbol ${deliveryFee ?? 0}"
                    .currencyFormat(currencySymbol),
          ).py2(),
        ),
        AmountTile(
          "Tax (%s)".tr().fill(["${vendorTax ?? 0}%"]),
          "+ " + " $currencySymbol ${tax ?? 0}".currencyFormat(currencySymbol),
        ).py2(),
        //DottedLine(dashColor: context.textTheme.bodyText1.color).py8(),
        Visibility(
          visible: fees != null && fees!.isNotEmpty,
          child: VStack(
            [
              ...((fees ?? []).map((fee) {
                //fixed
                if ((fee.percentage != 1)) {
                  return AmountTile(
                    "${fee.name}".tr(),
                    "+ " +
                        " $currencySymbol ${fee.value ?? 0}"
                            .currencyFormat(currencySymbol),
                  ).py2();
                } else {
                  //percentage
                  return AmountTile(
                    "${fee.name} (%s)".tr().fill(["${fee.value ?? 0}%"]),
                    "+ " +
                        " $currencySymbol ${fee.getRate(subTotal!) ?? 0}"
                            .currencyFormat(currencySymbol),
                  ).py2();
                }
              }).toList()),
              //  DottedLine(dashColor: context.textTheme.bodyText1.color).py8(),
            ],
          ),
        ),
        Visibility(
          visible: driverTip != null && driverTip! > 0,
          child: VStack(
            [
              AmountTile(
                "Driver Tip".tr(),
                "+ " +
                    "$currencySymbol ${driverTip ?? 0}"
                        .currencyFormat(currencySymbol),
              ).py2(),
              //    DottedLine(dashColor: context.textTheme.bodyText1.color).py8(),
            ],
          ),
        ),
        Divider(color: Colors.black),
        AmountTile(
          "Total Amount".tr(),
          "$currencySymbol ${total ?? 0}".currencyFormat(currencySymbol),
        ),
      ],
    );
  }
}
