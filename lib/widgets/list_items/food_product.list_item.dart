import 'package:flutter/material.dart';
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

class FoodProductListItem extends StatefulWidget {
  const FoodProductListItem({
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
  State<FoodProductListItem> createState() => _FoodProductListItemState();
}

class _FoodProductListItemState extends State<FoodProductListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.deepPurple,
      width: MediaQuery.of(context).size.width * .9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //   width: MediaQuery.of(context).size.width*.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomVisibilty(
                  visible: widget.product!.showDiscount,
                  child: "${AppStrings.currencySymbol} ${widget.product!.price}"
                      .currencyFormat()
                      .text
                      .black
                      .lineThrough
                      .xs
                      .semiBold
                      .make(),
                ),
                //options
                /*    CustomVisibilty(
                        visible: widget.showStepper &&
                            widget.product.optionGroups.firstOrNull() != null,
                        child: DropdownInput(
                          options: widget.product.optionGroups.isNotEmpty
                              ? widget.product.optionGroups[0].options
                              : [],
                          onChanged: (option) {
                            widget.product.selectedOptions = [option];
                          },
                        ).pOnly(top: Vx.dp4),
                      ),*/

                Container(
                  width: 150,
                  child: "${widget.product!.name}"
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
                      .px8(),
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
                //discounted price
                //     DiscountPositiedView(widget.product),
              ],
            ).p2(),
          ),
          Stack(children: [
            Container(
              child: Image.network(
                widget!.product!.photo!,
                fit: BoxFit.contain,
                width: 120,
                height: 80,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //    FavPositiedView(widget.product),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, left: 5),
                  child: Column(children: [
                    CustomVisibilty(
                      visible: widget.product!.hasStock,
                      child: Row(
                        children: [
                          //price

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
                              //FlutterIcons.plus_ant,
                              Icons.import_contacts_sharp,
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
                      ),
                    ),

                    //no stock indicator
                    CustomVisibilty(
                      visible: !widget.product!.hasStock,
                      child: ProductStockState(widget.product),
                    ),
                  ]),
                ),
              ],
            ),
          ]),

          /*   Container(
                  height: 50,
                  width: 200,
                  child: Column(
                    children:
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
    ).box.color(Colors.white).roundedSM.make().p2(),
                ),*/
        ],
      ),
    );
  }

  //
  void updateProductQty({int value = 1}) {
    bool? required = widget!.product!.optionGroupRequirementCheck();
    if (!required!) {
      //add to cart/update cart
      widget.qtyUpdated!(widget.product!, value);
      //
      setState(() {
        widget.product?.selectedQty = value;
      });
    } else {
      //open the product details page
      widget.onPressed!(widget.product!);
    }
  }
}
