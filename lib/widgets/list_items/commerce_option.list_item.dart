import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/option.dart';
import 'package:midnightcity/models/option_group.dart';
import 'package:midnightcity/utils/utils.dart';
import 'package:midnightcity/view_models/product_details.vm.dart';
import 'package:midnightcity/widgets/bottomsheets/option_details.bottomsheet.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceOptionListItem extends StatelessWidget {
  const CommerceOptionListItem({
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
    return "${option?.name}${option!.price! > 0 ? ' (+${option!.price.currencyValueFormat()})' : ''}"
        .text
        .medium
        .lg
        .make()
        .box
        .p8
        .withRounded(value: 2)
        .border(
            color: model!.isOptionSelected(option!)
                ? AppColor.primaryColor!
                : Colors.grey,
            width: model!.isOptionSelected(option!) ? 1.4 : 1)
        .make()
        .pOnly(left: !Utils.isArabic ? 0 : 10, right: Utils.isArabic ? 0 : 10)
        .onInkTap(() => model!.toggleOptionSelection(optionGroup!, option!))
        .onInkLongPress(
      () {
        //open the option details
        showOptionDetails(context, option!);
      },
    );
  }

  void showOptionDetails(BuildContext ctx, Option option) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (ctx) {
        return OptionDetailsBottomSheet(option);
      },
    );
  }
}
