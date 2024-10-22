import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/views/pages/product/amazon_styled_commerce_product_details.page.dart';
import 'package:midnightcity/views/pages/product/product_details.page.dart';
// import 'package:midnightcity/views/pages/product/commerce_product_details.page.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/currency_hstack.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:midnightcity/widgets/tags/fav.positioned.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/widgets/states/product_stock.dart';

class CommerceProductListItem extends StatelessWidget {
  const CommerceProductListItem(this.product,
      {this.height, this.qtyUpdated, Key? key})
      : super(key: key);

  final Product? product;
  final double? height;
  final Function(Product, int)? qtyUpdated;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: VStack(
        [
          //image and fav icon
          Stack(
            children: [
              //prouct first image

              Container(
                height: 110,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomImage(
                    imageUrl: "${product!.photo}",
                    width: double.infinity,
                    // height: 50,
                    boxFit: BoxFit.contain,
                  ).box.topRounded(value: 5).clip(Clip.antiAlias).make(),
                ),
              ),

              //fav icon
              FavPositiedView(product!),
            ],
          ).p4(),

          Padding(
            padding:
                const EdgeInsets.only(left: 20.0, bottom: 20, right: 8, top: 5),
            child: VStack(
              [
                //name
                "${product!.name}"
                    .text
                    .medium
                    .white
                    .fontFamily("Poppins")
                    .fontWeight(FontWeight.w400)
                    .size(12)
                    .maxLines(2)
                    .minFontSize(12)
                    .maxFontSize(14)
                    .overflow(TextOverflow.ellipsis)
                    .make(),

                // "${product.vendor.name}".text.make(),

                // price
                CurrencyHStack(
                  [
                    " ".text.make(),
                    product!.sellPrice
                        .currencyValueFormat()
                        .text
                        .white
                        .base
                        .bold
                        .make(),
                    AppStrings.currencySymbol.text.white.base.semiBold.make(),
                  ],
                  crossAlignment: CrossAxisAlignment.end,
                ),
                //discount
                CustomVisibilty(
                  visible: product!.showDiscount,
                  child: CurrencyHStack(
                    [
                      " ".text.make(),
                      product!.price
                          .currencyValueFormat()
                          .text
                          .white
                          .lineThrough
                          .xs
                          .medium
                          .make(),
                      AppStrings.currencySymbol.text.white.lineThrough.xs
                          .make(),
                    ],
                  ).px4(),
                ),
              ],
            ),
          ),

          ProductStockState(product, qtyUpdated: qtyUpdated)
        ],
        alignment: MainAxisAlignment.spaceBetween,
      )
          .onInkTap(
            () => openProductDetailsPage(context, product),
          )
          .material(color: AppColor.midnightCityLightBlue)
          .box
          .clip(Clip.antiAlias)
          .withRounded(value: 8)
          .outerShadowSm
          .make(),
    );
  }

  openProductDetailsPage(BuildContext context, product) {
    // context.push(
    //   (context) => ProductDetailsPage(product: product),
    // );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product)));
  }
}
