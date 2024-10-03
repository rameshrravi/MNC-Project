import 'package:flutter/material.dart';
import 'package:midnightcity/models/option_group.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/buttons/custom_steppr.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductStockState extends StatefulWidget {
  const ProductStockState(this.product, {this.qtyUpdated, Key? key})
      : super(key: key);

  final Product? product;
  final Function? qtyUpdated;

  @override
  _ProductStockStateState createState() => _ProductStockStateState();
}

class _ProductStockStateState extends State<ProductStockState> {
  int selectedQty = 0;
  @override
  Widget build(BuildContext context) {
    return optionGroupRequirementCheck(context)
        ? UiSpacer.emptySpace()
        : (widget.product!.hasStock)
            ? CustomStepper(
                defaultValue: 0,
                max: widget.product!.availableQty ?? 20,
                onChange: (qty) {
                  //
                  bool required = optionGroupRequirementCheck(context);
                  if (!required) {
                    widget.qtyUpdated!(widget.product, qty);
                  } else {
                    print("not working");
                  }
                },
              )
                //  VxStepper(
                //     disableInput: true,
                //     defaultValue: 0,
                //     max: widget.product.availableQty ?? 20,
                //     onChange: (qty) {
                //       //
                //       bool required = optionGroupRequirementCheck(context);
                //       if (!required) {
                //         widget.qtyUpdated(widget.product, qty);
                //       } else {
                //         print("not working");
                //       }
                //     },
                //   )
                .py2()
                .centered()
            : !widget.product!.hasStock
                ? "Back soon"
                    .tr()
                    .text
                    .sm
                    .white
                    .makeCentered()
                    .py2()
                    .px4()
                    .box
                    .red600
                    .roundedSM
                    .make()
                : UiSpacer.emptySpace();
  }

  optionGroupRequirementCheck(BuildContext context) {
    //check if the option groups with required setting has an option selected
    OptionGroup optionGroupRequired = widget.product!.optionGroups!
        .firstWhere((e) => e.required == 1, orElse: () {
      return OptionGroup();
    });
    //

    if (optionGroupRequired == null) {
      return false;
    } else {
      return true;
    }
  }
}
