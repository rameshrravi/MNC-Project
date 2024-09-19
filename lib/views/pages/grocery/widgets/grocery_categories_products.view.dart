import 'package:flutter/material.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/view_models/vendor/categories.vm.dart';
import 'package:midnightcity/views/pages/grocery/widgets/grocery_picks.view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../models/vendor.dart';

class GroceryCategoryProducts extends StatelessWidget {
  const GroceryCategoryProducts(
    this.vendorType,
    this.vendor, {
    this.length = 2,
    Key? key,
  }) : super(key: key);

  final VendorType vendorType;
  final Vendor vendor;
  final int length;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: vendorType),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            ...(model.dvendor!.categories!
                .sublist(
                    0,
                    model.categories!.length < length
                        ? model.categories!.length!
                        : length)
                .map(
              (category) {
                //

                return GroceryProductsSectionView(
                  category.name!,
                  model.dvendor!,
                  model.vendorType!,
                  showGrid: false,
                  category: category,
                );
              },
            ).toList()),
          ],
        );
      },
    );
  }
}
