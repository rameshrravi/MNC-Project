import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:midnightcity/widgets/states/product_stock.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem(
      {this.product, this.onPressed, @required this.qtyUpdated, Key? key})
      : super(key: key);

  final Function(Product)? onPressed;
  final Function(Product, int)? qtyUpdated;
  final Product? product;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        Stack(
          children: [
            //product image
            Hero(
              tag: product!.heroTag!,
              child: CustomImage(
                imageUrl: product!.photo,
                boxFit: BoxFit.cover,
                width: double.infinity,
                height: Vx.dp64 * 1.5,
              ),
            ),

            //price
            Positioned(
              bottom: 0,
              right: 0,
              child: HStack(
                [
                  AppStrings.currencySymbol.text.white.make(),
                  product!.showDiscount
                      ? "${product!.price}"
                          .text
                          .sm
                          .lineThrough
                          .white
                          .make()
                          .px2()
                      : "${product!.price}".text.xl.white.make(),
                  // discount price
                  product!.showDiscount
                      ? "${product!.discountPrice}".text.xl.white.make()
                      : UiSpacer.emptySpace(),
                ],
              ).py4().box.px8.rounded.color(AppColor.primaryColor!).make(),
            ),
          ],
        ),

        //
        product!.name!.text.medium.lg
            .maxLines(1)
            .overflow(TextOverflow.ellipsis)
            .make(),
        product!.vendor!.name!.text.sm
            .maxLines(1)
            .overflow(TextOverflow.ellipsis)
            .makeCentered(),

        // plus/min icon here
        ProductStockState(product, qtyUpdated: qtyUpdated),
      ],
    )
        .box
        .roundedSM
        .p4
        .color(context.cardColor)
        .outerShadow
        .make()
        .w32(context)
        .onInkTap(
          () => onPressed!(product!),
        );
  }
}
