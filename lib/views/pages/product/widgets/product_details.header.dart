import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/extensions/dynamic.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/currency_hstack.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/constants/app_strings.dart';

class ProductDetailsHeader extends StatelessWidget {
  const ProductDetailsHeader({this.product, this.showVendor = true, Key? key})
      : super(key: key);

  final Product? product;
  final bool showVendor;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;

    return VStack(
      [
        //product name, vendor name, and price
        HStack(
          [
            //name
            VStack(
              [
                //product name
                /*     color:  Colors.primaryTextColor,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins",
                fontStyle:  FontStyle.normal,
                fontSize: 20.0 */

                product!.name!.text
                    .color(Colors.white)
                    .fontWeight(FontWeight.w500)
                    .fontFamily("Poppins")
                    .size(20)
                    .make(),
                //vendor name
                /*    CustomVisibilty(
                  visible: showVendor,
                  child: product.vendor.name.text.lg.medium.make(),
                ),*/

                /*     color:  Colors.primaryTextColor,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                fontStyle:  FontStyle.normal,
                fontSize: 18.0
                */

                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: HStack([
                    CustomVisibilty(
                      visible: product!.showDiscount,
                      child: CurrencyHStack(
                        [
                          product!.price
                              .currencyValueFormat()
                              .text
                              .lineThrough
                              .color(Colors.white)
                              .fontFamily("Poppins")
                              .fontWeight(FontWeight.w600)
                              .size(18)
                              .make(),
                          currencySymbol.text
                              .color(Colors.white)
                              .fontFamily("Poppins")
                              .fontWeight(FontWeight.w600)
                              .size(18)
                              .make(),
                        ],
                      ),
                    ),
                    CurrencyHStack(
                      [
                        (product!.showDiscount
                                ? product!.discountPrice.currencyValueFormat()
                                : product!.price.currencyValueFormat())
                            .text
                            .color(AppColor.midnightCityYellow)
                            .fontFamily("Poppins")
                            .fontWeight(FontWeight.w600)
                            .size(18)
                            .make(),
                        currencySymbol.text
                            .color(AppColor.midnightCityYellow)
                            .fontFamily("Poppins")
                            .fontWeight(FontWeight.w600)
                            .size(18)
                            .make(),
                      ],
                      crossAlignment: CrossAxisAlignment.end,
                    ),
                  ]),
                ),

                //discount
              ],
            ).expand(),

            //price
          ],
        ),

        //product size details and more
        /* HStack(
          [
            //deliverable or not
            (product.canBeDelivered
                    ? "Deliverable".tr()
                    : "Not Deliverable".tr())
                .text
                .white
                .sm
                .make()
                .py4()
                .px8()
                .box
                .roundedLg
                .color(
                  product.canBeDelivered ? Vx.green500 : Vx.red500,
                )
                .make(),

            //
            UiSpacer.expandedSpace(),

            //size
            CustomVisibilty(
              visible: !product.capacity.isEmptyOrNull &&
                  !product.unit.isEmptyOrNull,
              child: "${product.capacity} ${product.unit}"
                  .text
                  .sm
                  .black
                  .make()
                  .py4()
                  .px8()
                  .box
                  .roundedLg
                  .gray500
                  .make()
                  .pOnly(right: Vx.dp12),
            ),

            //package items
            CustomVisibilty(
              visible: product.packageCount != null,
              child: "%s Items"
                  .tr()
                  .fill(["${product.packageCount}"])
                  .text
                  .sm
                  .black
                  .make()
                  .py4()
                  .px8()
                  .box
                  .roundedLg
                  .gray500
                  .make(),
            ),
          ],
        ).pOnly(top: Vx.dp10),

        */
      ],
    ).px20().py12();
  }
}
