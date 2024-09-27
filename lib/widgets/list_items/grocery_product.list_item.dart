import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/buttons/custom_steppr.view.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:midnightcity/widgets/inputs/drop_down.input.dart';
import 'package:midnightcity/widgets/states/product_stock.dart';
import 'package:midnightcity/widgets/tags/discount.positioned.dart';
import 'package:midnightcity/widgets/tags/fav.positioned.dart';
import 'package:velocity_x/velocity_x.dart';

class GroceryProductListItem extends StatefulWidget {
  const GroceryProductListItem({
    this.product,
    this.onPressed,
    @required this.qtyUpdated,
    this.showStepper = false,
    this.height,
    Key? key,
  }) : super(key: key);

  final Function(Product)? onPressed;
  final Function(Product, int)? qtyUpdated;
  final Product? product;
  final bool? showStepper;
  final double? height;

  @override
  State<GroceryProductListItem> createState() => _GroceryProductListItemState();
}

class _GroceryProductListItemState extends State<GroceryProductListItem> {
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        //product image
        Stack(
          children: [
            //

            Hero(
              tag: widget.product!.heroTag!,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomImage(
                  imageUrl: widget.product!.photo,
                  boxFit: BoxFit.contain,
                  width: double.infinity,
                  height: Vx.dp64 * 1.2,
                ),
              ),
            ),
            //

            //discount tag
            DiscountPositiedView(widget.product!),

            //fav icon
            FavPositiedView(widget.product!),

            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Container(
                child: VStack(
                  [
                    //
                    CustomVisibilty(
                      visible: widget.product!.hasStock,
                      child: HStack(
                        [
                          //price
                          Text(" "),
                          Spacer(),
                          UiSpacer.smHorizontalSpace(),
                          //counter input
                          CustomVisibilty(
                            visible: widget.product!.selectedQty != null &&
                                widget.product!.selectedQty! >= 1,
                            child: CustomStepper(
                              defaultValue: widget.product!.selectedQty ?? 0,
                              max: widget.product!.availableQty ?? 20,
                              onChange: (qty) {
                                //
                                updateProductQty(value: qty);
                              },
                            ),
                          ),
                          //add to cart icon
                          //hide when selected qty is more than 0
                          CustomVisibilty(
                            visible: widget.product!.selectedQty == null ||
                                widget.product!.selectedQty! < 1,
                            child: Icon(
                              FlutterIcons.plus_ant,
                              //Icons.access_alarm_outlined,
                              size: 16,
                              color: Colors.white,
                            )
                                .box
                                .p4
                                .color(AppColor.midnightCityLightBlue)
                                .outerShadowSm
                                .roundedFull
                                .make()
                                .onInkTap(
                              () {
                                //
                                updateProductQty();
                              },
                            ),
                          ),
                        ],
                        crossAlignment: CrossAxisAlignment.end,
                        alignment: MainAxisAlignment.end,
                      ).h(24).p4(),
                    ),

                    //no stock indicator
                    CustomVisibilty(
                      visible: !widget.product!.hasStock,
                      child: ProductStockState(widget.product),
                    ),
                  ],
                ).box.color(Colors.transparent).roundedSM.make().p2(),
              ),
            ),
          ],
        ),

        //
        VStack(
          [
            CustomVisibilty(
              visible: widget.product!.showDiscount,
              child: "${AppStrings.currencySymbol} ${widget.product!.price}"
                  .currencyFormat()
                  .text
                  .black
                  .lineThrough
                  .xs
                  .semiBold
                  .make()
                  .px8(),
            ),
            //options
            CustomVisibilty(
              visible: widget.showStepper! &&
                  widget.product!.optionGroups!.firstOrNull() != null,
              child: DropdownInput(
                options: widget.product!.optionGroups!.isNotEmpty
                    ? widget.product!.optionGroups![0].options
                    : [],
                onChanged: (option) {
                  widget.product!.selectedOptions = [option];
                },
              ).pOnly(top: Vx.dp4),
            ),
            "${AppStrings.currencySymbol} ${widget.product!.sellPrice} "
                .currencyFormat()
                .text
                .size(12)
                .black
                .base
                .make()
                .py2()
                .px8(),

            "${widget.product!.name}"
                .text
                .bold
                .black
                .size(14)
                .minFontSize(12)
                .maxFontSize(14)
                .maxLines(widget.product!.showDiscount ? 1 : 2)
                .overflow(TextOverflow.ellipsis)
                .make()
                .py2()
                .px8()

            //discounted price
          ],
        ).p2()

        /*   VStack(
          [
            //
            CustomVisibilty(
              visible: widget.product.hasStock,
              child: HStack(

                [
                  //price
                  Text(" "),
                  Spacer(),
                  UiSpacer.smHorizontalSpace(),
                  //counter input
                  CustomVisibilty(
                    visible: widget.product.selectedQty != null &&
                        widget.product.selectedQty >= 1,
                    child: CustomStepper(
                      defaultValue: widget.product.selectedQty ?? 0,
                      max: widget.product.availableQty ?? 20,
                      onChange: (qty) {
                        //
                        updateProductQty(value: qty);
                      },
                    ),
                  ),
                  //add to cart icon
                  //hide when selected qty is more than 0
                  CustomVisibilty(
                    visible: widget.product.selectedQty == null ||
                        widget.product.selectedQty < 1,
                    child: Icon(
                      FlutterIcons.plus_ant,
                      size: 16,
                      color: Colors.white,
                    )
                        .box
                        .p4
                        .color(AppColor.midnightCityLightBlue)
                        .outerShadowSm
                        .roundedFull
                        .make()
                        .onInkTap(
                      () {
                        //
                        updateProductQty();
                      },
                    ),
                  ),
                ],
                crossAlignment: CrossAxisAlignment.end,
                alignment: MainAxisAlignment.end,
              ).h(24).p4(),

            ),

            //no stock indicator
            CustomVisibilty(
              visible: !widget.product.hasStock,
              child: ProductStockState(widget.product),
            ),
          ],
        ).box.color(Colors.white).roundedSM.make().p2(),*/
      ],
    )
        .onInkTap(
          () => this.widget.onPressed!(this.widget.product!),
        )
        .material(color: context.backgroundColor)
        //  .color(context.backgroundColor)
        //.clip(Clip.antiAlias)
        //   .outerShadowSm
        // .makeCentered()
        .w(context.percentWidth * 35);
  }

  //
  void updateProductQty({int value = 1}) {
    bool required = widget!.product!.optionGroupRequirementCheck()!;
    if (!required) {
      //add to cart/update cart
      widget.qtyUpdated!(widget.product!, value);
      //
      setState(() {
        widget.product!.selectedQty = value;
      });
    } else {
      //open the product details page
      widget.onPressed!(widget.product!);
    }
  }
}
