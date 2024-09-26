import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/view_models/product_details.vm.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/currency_hstack.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/constants/app_colors.dart';

class ProductDetailsCartBottomSheet extends StatelessWidget {
  const ProductDetailsCartBottomSheet({this.model, Key? key}) : super(key: key);

  final ProductDetailsViewModel? model;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        /*  Visibility(
          visible: model!.product.hasStock,
         child: HStack(
            [
              //
              "Quantity".tr().text.xl.medium.white.make().expand(),
              //
              Container(
                decoration: BoxDecoration(
                  color: AppColor.midnightCityYellow,
                  borderRadius: BorderRadius.circular(12)

                ),

                child: VxStepper(
                  actionButtonColor: AppColor.midnightCityYellow,
                  inputBoxColor: AppColor.midnightCityYellow,

                  defaultValue: model!.product.selectedQty ?? 1,
                  min: 1,
                  max: (model.product.availableQty != null &&
                          model!.product.availableQty > 0)
                      ? model!.product.availableQty
                      : 20,
                  disableInput: true,
                  onChange: model!.updatedSelectedQty,
                ),
              ),
            ],
          ),
        ),*/

        //
        Visibility(
          visible: model!.product.hasStock,
          child: HStack(
            [
              /*
              CustomButton(
                color:AppColor.mainBackground ,
                loading: model!.isBusy,
                child: Icon(
                  model!.product.isFavourite
                  ?FlutterIcons.favorite_mdi
                   :FlutterIcons.favorite_border_mdi,
                  color: Colors.red,
                ),
                onPressed: !model.isAuthenticated()
                    ? model!.openLogin
                    : !model.product.isFavourite
                        ? model!.addToFavourite
                        : model!.removeFromFavourite,
              ).w(Vx.dp64).pOnly(right: Vx.dp24).color(AppColor.mainBackground),
              */
              CustomButton(
                color: AppColor.midnightCityYellow,
                loading: model!.isBusy,
                child: HStack(
                  [
                    "Add to Cart"
                        .tr()
                        .text
                        .color(AppColor.background2)
                        .fontWeight(FontWeight.w600)
                        .fontFamily("Poppins")
                        .size(14)
                        .make()
                        .expand(),
                    CurrencyHStack(
                      [
                        model!.total
                            .currencyValueFormat()
                            .text
                            .color(AppColor.background2)
                            .fontWeight(FontWeight.w600)
                            .fontFamily("Poppins")
                            .size(14)
                            .make(),
                        model!.currencySymbol.text
                            .color(AppColor.background2)
                            .fontWeight(FontWeight.w600)
                            .fontFamily("Poppins")
                            .size(14)
                            .make(),
                      ],
                    ),
                  ],
                ).p12(),
                onPressed: model!.addToCart,
              ).expand(),
            ],
          ).py12(),
        ),

        Visibility(
          visible: model!.product.hasStock,
          child: "Back soon"
              .tr()
              .text
              .white
              .makeCentered()
              .p8()
              .box
              .red500
              .roundedSM
              .make()
              .p8()
              .wFull(context),
        ),
      ],
    ).p20().box.color(AppColor.mainBackground).shadowXl.make().wFull(context);
  }
}
