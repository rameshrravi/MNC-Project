import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/currency_hstack.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class FoodHorizontalProductListItem extends StatelessWidget {
  //
  const FoodHorizontalProductListItem(
    this.product, {
    this.onPressed,
    @required this.qtyUpdated,
    this.height,
    Key? key,
  }) : super(key: key);

  //
  final Product? product;
  final Function(Product)? onPressed;
  final Function(Product, int)? qtyUpdated;
  final double? height;
  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;

    //
    Widget widget = HStack(
      [
        //

        //Details
        VStack(
          [
            //name
            product!.name!.text.lg.medium
                .maxLines(2)
                .white
                .overflow(TextOverflow.ellipsis)
                .make(),
            //description
            /* "${product.vendor.name}"
                .text
                .xs
                .light
                .gray600
                .maxLines(1)
                .overflow(TextOverflow.ellipsis)
                .make(),*/
            //price
            Spacer(),
            Wrap(
              children: [
                //price
                CurrencyHStack(
                  [
                    (product!.showDiscount
                            ? " " + product!.discountPrice.currencyValueFormat()
                            : " " + product!.price.currencyValueFormat())
                        .text
                        .white
                        .lg
                        .semiBold
                        .make(),
                    currencySymbol.text.lg.white.semiBold.make(),
                  ],
                  crossAlignment: CrossAxisAlignment.start,
                ),
                UiSpacer.horizontalSpace(),
                //discount price
                CustomVisibilty(
                  visible: product!.showDiscount,
                  child: CurrencyHStack(
                    [
                      currencySymbol.text.lineThrough.xs.make(),
                      product!.price
                          .currencyValueFormat()
                          .text
                          .white
                          .lineThrough
                          .lg
                          .medium
                          .make(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ).px12().expand(),
        Hero(
          tag: product!.heroTag!,
          child: CustomImage(
            imageUrl: product!.photo,
            width: height != null ? height! / 1.6 : height,
            height: height,
          )
              // .wh(Vx.dp40, Vx.dp40)
              .box
              .clip(Clip.antiAlias)
              .roundedSM
              .make(),
        ),
      ],
    ).onInkTap(() => onPressed!(product!));

    //height set
    if (height != null) {
      widget = widget.h(height!);
    }

    //
    return widget.box.p4.roundedSM
        .color(AppColor.midnightCityLightBlue)
        .outerShadow
        .makeCentered()
        .p8();
  }
}
