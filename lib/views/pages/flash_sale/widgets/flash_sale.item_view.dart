import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/extensions/dynamic.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/services/navigation.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/currency_hstack.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class FlashSaleItemListItem extends StatelessWidget {
  FlashSaleItemListItem(this.product, {this.fullPage = false, Key? key})
      : super(key: key);

  final Product product;
  final bool fullPage;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        CustomImage(
          imageUrl: product.photo,
          width: double.infinity,
          height: fullPage
              ? (context.percentHeight * 18)
              : (context.percentWidth * 26),
        ),
        //
        VStack(
          [
            UiSpacer.vSpace(10),
            "${product.name}"
                .text
                .black
                .minFontSize(fullPage ? 13 : 17)
                .size(fullPage ? 13 : 17)
                .maxLines(fullPage ? 2 : 1)
                .ellipsis
                .make(),
            CurrencyHStack(
              [
                "${AppStrings.currencySymbol}".text.size(16).extraBold.make(),
                UiSpacer.hSpace(5),
                "${product.sellPrice}"
                    .currencyValueFormat()
                    .text
                    .black
                    .size(16)
                    .extraBold
                    .make(),
              ],
            ),
            //stock
            CustomVisibilty(
              visible: product.availableQty != null,
              child: VStack(
                [
                  UiSpacer.vSpace(10),
                  "%s items left"
                      .tr()
                      .fill([product.availableQty])
                      .text
                      .black
                      .sm
                      .semiBold
                      .make(),
                ],
              ),
            ),
          ],
        ).p8(),
      ],
    )
        .w(context.percentWidth * 42)
        .box
        .border(color: Vx.gray300)
        .roundedSM
        .make()
        .onTap(
      () {
        // context.nextPage(
        //   NavigationService().productDetailsPageWidget(product),
        // );
      },
    );
  }
}
