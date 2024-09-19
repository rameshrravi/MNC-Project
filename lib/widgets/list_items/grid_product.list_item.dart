import 'package:flutter/material.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/currency_hstack.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:midnightcity/widgets/states/product_stock.dart';
import 'package:velocity_x/velocity_x.dart';

class GridNewProductListItem extends StatelessWidget {
  //
  const GridNewProductListItem(
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
    Widget widget = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: product!.heroTag!,
            child: CustomImage(
              imageUrl: product!.photo!,
              width: 80,
              height: 80,
              boxFit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: product!.name!.text.lg.medium
                .maxLines(2)
                .black
                .fontWeight(FontWeight.w500)
                .fontFamily("Poppins")
                .size(12)
                .center
                .overflow(TextOverflow.ellipsis)
                .make(),
          ),
          HStack([
            CurrencyHStack(
              [
                (product!.showDiscount!
                        ? " " + product!.discountPrice.currencyValueFormat()
                        : " " + product!.price.currencyValueFormat())
                    .text
                    .black
                    .fontWeight(FontWeight.w400)
                    .fontFamily("Poppins")
                    .size(10)
                    .lg
                    //.semiBold
                    .make(),
                currencySymbol.text.black
                    .fontWeight(FontWeight.w400)
                    .fontFamily("Poppins")
                    .size(10)
                    .lg
                    //  .semiBold
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.start,
            ),
            product!.showDiscount!
                ? CurrencyHStack(
                    [
                      product!.price
                          .currencyValueFormat()
                          .text
                          .lineThrough
                          .black
                          .fontWeight(FontWeight.w400)
                          .fontFamily("Poppins")
                          .size(10)
                          .lg
                          // .semiBold
                          .make(),
                      " ".text.make(),
                      currencySymbol.text.lineThrough
                          .black //color(AppColor.midnightCityYellow)
                          .fontWeight(FontWeight.w400)
                          .fontFamily("Poppins")
                          .size(10)
                          .lg
                          .semiBold
                          .make(),
                    ],
                  )
                : UiSpacer.emptySpace(),
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Center(
                child: ProductStockState(product, qtyUpdated: qtyUpdated)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: product!.description!.text.lg.medium
                .maxLines(3)
                .black
                .fontWeight(FontWeight.w400)
                .fontFamily("Poppins")
                .size(11)
                .overflow(TextOverflow.ellipsis)
                .make(),
          ),
        ],
      ),
    ).onInkTap(() => onPressed!(product!));

    return widget;
  }
}
