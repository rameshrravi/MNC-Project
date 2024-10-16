import 'package:flutter/material.dart';
import 'package:midnightcity/models/order_product.dart';
import 'package:midnightcity/services/navigation.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/product_details.vm.dart';
import 'package:midnightcity/views/pages/review/post_product_review.page.dart';
import 'package:midnightcity/widgets/buttons/arrow_indicator.dart';
import 'package:midnightcity/widgets/buttons/share.btn.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderProductActionBottomSheet extends StatelessWidget {
  const OrderProductActionBottomSheet(
    this.orderProduct, {
    Key? key,
  }) : super(key: key);

  //
  final OrderProduct orderProduct;

  //
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        UiSpacer.swipeIndicator(),
        UiSpacer.vSpace(15),
        HStack(
          [
            //
            CustomImage(
              imageUrl: orderProduct.product!.photo,
              width: context.percentWidth * 30,
              height: context.percentWidth * 30,
            ),
            UiSpacer.hSpace(6),

            VStack(
              [
                //
                orderProduct.product!.name!.text
                    .maxLines(3)
                    .ellipsis
                    .semiBold
                    .lg
                    .make(),

                UiSpacer.vSpace(6),
                ShareButton(
                  model: ProductDetailsViewModel(
                    context,
                    orderProduct!.product!,
                  ),
                ),
              ],
            ).px12().expand(),
            //
          ],
        ),
        UiSpacer.divider().py8(),
        HStack(
          [
            "Buy it again".tr().text.scale(1.3).medium.make().expand(),
            ArrowIndicator(26),
          ],
        ).py4().onInkTap(
          () {
            // context.push(
            //   (context) => NavigationService().productDetailsPageWidget(
            //     orderProduct.product,
            //   ),
            // );
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             NavigationService().productDetailsPageWidget(
            //               orderProduct.product!,
            //             )));
          },
        ),
        UiSpacer.divider(),
        CustomVisibilty(
          visible: !orderProduct.reviewed!,
          child: VStack(
            [
              "How's your item?".tr().text.extraBold.xl2.make().py12(),
              UiSpacer.divider(),
              HStack(
                [
                  "Write a product review"
                      .tr()
                      .text
                      .scale(1.3)
                      .medium
                      .make()
                      .px12()
                      .expand(),
                  ArrowIndicator(26),
                ],
              ).py8().onInkTap(
                () {
                  context.nextPage(PostProductReviewPage(orderProduct));
                },
              ),
              UiSpacer.divider(),
            ],
          ),
        ),
      ],
    )
        .p20()
        .scrollVertical()
        .hThreeForth(context)
        .box
        .color(context.backgroundColor)
        .topRounded()
        .make();
  }
}
