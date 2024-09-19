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

class HorizontalProductListItem extends StatelessWidget {
  //
  const HorizontalProductListItem(
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
                .black
                .fontWeight(FontWeight.w500)
                .fontFamily("Poppins")
                .size(14)
                .overflow(TextOverflow.ellipsis)
                .make(),

            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: product!.description!.text.lg.medium
                  .maxLines(3)
                  .black
                  .fontWeight(FontWeight.w400)
                  .fontFamily("Poppins")
                  .size(11)
                  .overflow(TextOverflow.ellipsis)
                  .make(),
            ),

            Spacer(),

            HStack([
              CurrencyHStack(
                [
                  (product!.showDiscount
                          ? " " + product!.discountPrice.currencyValueFormat()
                          : " " + product!.price.currencyValueFormat())
                      .text
                      .black
                      .fontWeight(FontWeight.w400)
                      .fontFamily("Poppins")
                      .size(14)
                      .lg
                      //.semiBold
                      .make(),
                  currencySymbol.text.black
                      .fontWeight(FontWeight.w400)
                      .fontFamily("Poppins")
                      .size(14)
                      .lg
                      //  .semiBold
                      .make(),
                ],
                crossAlignment: CrossAxisAlignment.start,
              ),
              product!.showDiscount
                  ? CurrencyHStack(
                      [
                        product!.price
                            .currencyValueFormat()
                            .text
                            .lineThrough
                            .black
                            .fontWeight(FontWeight.w400)
                            .fontFamily("Poppins")
                            .size(14)
                            .lg
                            // .semiBold
                            .make(),
                        " ".text.make(),
                        currencySymbol.text.lineThrough
                            .black //color(AppColor.midnightCityYellow)
                            .fontWeight(FontWeight.w400)
                            .fontFamily("Poppins")
                            .size(14)
                            .lg
                            .semiBold
                            .make(),
                      ],
                    )
                  : UiSpacer.emptySpace(),
            ]),

            // //description
            // product.description.text.xs.light
            //     .maxLines(1)
            //     .overflow(TextOverflow.ellipsis)
            //     .make(),
          ],
        ).expand(),

        //
        VStack(
          [
            /*          //price
            CurrencyHStack(
              [
                currencySymbol.text.sm.make(),
                (product.showDiscount
                        ? product.discountPrice.currencyValueFormat()
                        : product.price.currencyValueFormat())
                    .text
                    .lg
                    .semiBold
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.end,
            ),
            //discount
            product.showDiscount
                ? CurrencyHStack(
                    [
                      currencySymbol.text.lineThrough.xs.make(),
                      product.price
                          .currencyValueFormat()
                          .text
                          .lineThrough
                          .lg
                          .medium
                          .make(),
                    ],
                  )
                : UiSpacer.emptySpace(),
*/
            // plus/min icon here
          ],
          crossAlignment: CrossAxisAlignment.end,
        ),
        Center(
          child: VStack(
            [
              Hero(
                tag: product!.heroTag!,
                child: CustomImage(
                  imageUrl: product!.photo,
                  width: 100,
                  height: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Center(
                    child: ProductStockState(product, qtyUpdated: qtyUpdated)),
              ),
              //s Divider()
            ],
            alignment: MainAxisAlignment.center,
            crossAlignment: CrossAxisAlignment.center,
          ),
        ),
      ],
    ).onInkTap(() => onPressed!(product!));

    //height set
    if (height != null) {
      widget = widget.h(140);
    }

    //
    return widget.box.p4.roundedSM
        .height(140)
        .color(context.cardColor)
        // .outerShadow
        .makeCentered()
        .p8();
  }
}
