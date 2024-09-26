import 'package:flutter/material.dart';
import 'package:midnightcity/models/option_group.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/product_details.vm.dart';
import 'package:midnightcity/widgets/list_items/commerce_option.list_item.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceProductOptionGroup extends StatelessWidget {
  const CommerceProductOptionGroup({this.optionGroup, this.model, Key? key})
      : super(key: key);

  final OptionGroup? optionGroup;
  final ProductDetailsViewModel? model;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //group name
        optionGroup!.name!.text.base.semiBold.make(),
        UiSpacer.vSpace(6),

        //options
        Wrap(
          children: optionGroup!.options!.map(
            (e) {
              return CommerceOptionListItem(
                option: e,
                optionGroup: optionGroup,
                model: model,
              );
            },
          ).toList(),
        ),
      ],
    ).px20().py12();
  }
}
