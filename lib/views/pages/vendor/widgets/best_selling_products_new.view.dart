import 'package:flutter/material.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/vendor/best_selling_products.vm.dart';
import 'package:midnightcity/widgets/custom_dynamic_grid_view.dart';
import 'package:midnightcity/widgets/list_items/commerce_product.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:midnightcity/widgets/custom_list_view.dart';
import 'package:midnightcity/widgets/custom_masonry_grid_view.dart';
import 'package:midnightcity/widgets/list_items/grocery_product.list_item.dart';

class BestSellingProductsNew extends StatelessWidget {
  const BestSellingProductsNew(
    this.vendorType, {
    this.imageHeight,
    Key? key,
  }) : super(key: key);

  final VendorType vendorType;
  final double? imageHeight;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BestSellingProductsViewModel>.reactive(
      viewModelBuilder: () => BestSellingProductsViewModel(
        context,
        vendorType,
      ),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            UiSpacer.verticalSpace(),
            "Best Selling".tr().text.white.make().px12().py2(),
            CustomListView(
              isLoading: model.isBusy,
              dataSet: model.products,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: Vx.dp12),
              itemBuilder: (context, index) {
                return GroceryProductListItem(
                  product: model.products.elementAt(index),
                  onPressed: model.productSelected,
                  qtyUpdated: model.addToCartDirectly,
                );
              },
            ).h(200),

            CustomDynamicHeightGridView(
              noScrollPhysics: true,
              separatorBuilder: (context, index) =>
                  UiSpacer.smHorizontalSpace(),
              itemCount: model.products.length,
              isLoading: model.isBusy,
              itemBuilder: (context, index) {
                //
                return CommerceProductListItem(
                  model.products[index],
                  height: imageHeight ?? 80,
                  // onPressed: model.productSelected,
                  // qtyUpdated: model.addToCartDirectly,
                );
              },
            ).px12().py2(),
          ],
        );
      },
    );
  }
}
