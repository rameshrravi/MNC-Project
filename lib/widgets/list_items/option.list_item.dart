import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/option.dart';
import 'package:midnightcity/models/option_group.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/product_details.vm.dart';
import 'package:midnightcity/widgets/currency_hstack.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class OptionListItem extends StatelessWidget {
  const OptionListItem({
    this.option,
    this.optionGroup,
    this.model,
    Key? key,
  }) : super(key: key);

  final Option? option;
  final OptionGroup? optionGroup;
  final ProductDetailsViewModel? model;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;
    return HStack(
      [
        //image/photo
        Stack(
          children: [
            //
            /*           CustomImage(
              imageUrl: option.photo,
              width: Vx.dp32,
              height: Vx.dp32,
              canZoom: true,
            ).card.clip(Clip.antiAlias).roundedSM.make(),
*/
            Container(
              width: Vx.dp24,
              height: Vx.dp24,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
            ).card.make(),

            //
            model!.isOptionSelected(option!)
                ? Positioned(
                    top: 5,
                    bottom: 5,
                    left: 5,
                    right: 5,
                    child: Icon(
                      //FlutterIcons.check_ant,
                      Icons.ac_unit_outlined,

                      color: Colors.white,
                    ).box.color(AppColor.midnightCityLightBlue).make(),
                  )
                : UiSpacer.emptySpace(),
          ],
        ),

        //details
        VStack(
          [
            //
            option!.name!.text.black.medium.lg.make(),
            option!.description != null && option!.description.isEmptyOrNull
                ? "${option!.description}"
                    .text
                    .sm
                    .maxLines(3)
                    .overflow(TextOverflow.ellipsis)
                    .make()
                : UiSpacer.emptySpace(),
          ],
        ).px12().expand(),

        //price
        CurrencyHStack(
          [
            currencySymbol.text.black.sm.medium.make(),
            option!.price.currencyValueFormat().text.black.sm.bold.make(),
          ],
          crossAlignment: CrossAxisAlignment.end,
        ),
      ],
      crossAlignment: CrossAxisAlignment.center,
    ).onInkTap(() => model!.toggleOptionSelection(optionGroup!, option!));
  }
}
