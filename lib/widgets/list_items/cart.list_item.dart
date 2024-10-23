import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/cart.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class CartListItem extends StatelessWidget {
  const CartListItem(
    this.cart, {
    this.onQuantityChange,
    this.deleteCartItem,
    Key? key,
  }) : super(key: key);

  final Cart? cart;
  final Function(int)? onQuantityChange;
  final Function? deleteCartItem;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;

    return Expanded(
      child: Container(
        height: 180,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(26)),
        child: HStack(
          [
            //
            //PRODUCT IMAGE
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomImage(
                imageUrl: cart!.product!.photo,
                width: 120, //context.percentWidth * 24,
                height: 120, //context.percentWidth * 24,
              ).box.clip(Clip.antiAlias).roundedSM.make(),
            ),

            //
            UiSpacer.horizontalSpace(),
            VStack(
              [
                //product name

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("${cart!.product!.name}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                ),
                //  "${cart.product.name}".text.semiBold.xl.make(),
                UiSpacer.verticalSpace(space: 0),
                //product options

                /* cart.optionsSentence.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("${cart.product.name}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            textAlign: TextAlign.left),
                      )
                    //           ? cart.optionsSentence.text.lg.gray600.medium.make()
                    : UiSpacer.emptySpace(),*/
                cart!.optionsSentence!.isNotEmpty
                    ? UiSpacer.verticalSpace(space: 10)
                    : UiSpacer.verticalSpace(space: 5),

                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                      "$currencySymbol ${(cart!.selectedQty! * cart!.price!)}"
                          .currencyFormat(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                ), //
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.midnightCityYellow,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: VxStepper(
                      inputBoxColor: AppColor.midnightCityYellow,
                      actionButtonColor: AppColor.midnightCityYellow,
                      defaultValue: cart!.selectedQty! ?? 1,
                      min: 1,
                      max: cart!.product!.availableQty ?? 20,
                      disableInput: true,
                      onChange: onQuantityChange,
                    ),
                  ),
                ),
              ],
            ).expand(),

            //
            UiSpacer.horizontalSpace(),
            VStack(
              [
                //delete icon
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Icon(
                    FlutterIcons.x_fea,
                    //Icons.access_alarm_outlined,
                    size: 20,
                    color: Colors.black,
                  )
                      .centered()
                      .p8()
                      .onInkTap(
                        this.deleteCartItem as VoidCallback?,
                      )
                      .box
                      .roundedFull
                      .color(AppColor.primaryTextColor)
                      .make(),
                ),

                //cart item price
                UiSpacer.verticalSpace(),
                /*     "$currencySymbol ${(cart.selectedQty * cart.price)}".currencyFormat()
                    .text
                    .semiBold
                    .xl
                    .make(),*/
              ],
              alignment: MainAxisAlignment.start,
              crossAlignment: CrossAxisAlignment.start,
            )
          ],
          alignment: MainAxisAlignment.start,
          crossAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
