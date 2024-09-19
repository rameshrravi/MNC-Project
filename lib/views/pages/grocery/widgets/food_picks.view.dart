import 'package:flutter/material.dart';
import 'package:midnightcity/enums/product_fetch_data_type.enum.dart';
import 'package:midnightcity/models/category.dart';
import 'package:midnightcity/models/search.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/products.vm.dart';
import 'package:midnightcity/views/pages/search/search.page.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/custom_list_view.dart';
import 'package:midnightcity/widgets/custom_masonry_grid_view.dart';
import 'package:midnightcity/widgets/list_items/grocery_product.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_colors.dart';
import '../../../../widgets/list_items/food_product.list_item.dart';

class FoodProductsSectionView extends StatelessWidget {
  const FoodProductsSectionView(
    this.title,
    this.vendorType, {
    this.type = ProductFetchDataType.RANDOM,
    this.category,
    this.showGrid,
    this.crossAxisCount = 2,
    Key? key,
  }) : super(key: key);

  final String title;
  final bool? showGrid;
  final int crossAxisCount;
  final VendorType vendorType;
  final ProductFetchDataType type;
  final Category? category;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductsViewModel>.reactive(
      viewModelBuilder: () => ProductsViewModel(
        context,
        vendorType,
        type,
        categoryId: category!.id!,
      ),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return CustomVisibilty(
          visible: vm.products.isNotEmpty && !vm.isBusy,
          child: VStack(
            [
              //
              HStack(
                [
                  "$title"
                      .text
                      .xl
                      .semiBold
                      .color(AppColor.midnightCityDarkBlue)
                      .make()
                      .expand(),
                  UiSpacer.smHorizontalSpace(),
                  "View all"
                      .tr()
                      .text
                      .color(AppColor.midnightCityLightBlue)
                      .make()
                      .onInkTap(
                    () {
                      //
                      final search = Search(
                        category: category,
                        vendorType: vendorType,
                        showType: 2,
                      );
                      //open search page
                      // context.push(
                      //   (context) {
                      //     return SearchPage(
                      //       search: search,
                      //     );
                      //   },
                      // );

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => SearchPage(
                      //               search: search,
                      //             )));
                    },
                  ),
                ],
              ).px24(),
              CustomVisibilty(
                visible: !showGrid!,
                child: CustomListView(
                  isLoading: vm.isBusy,
                  dataSet: vm.products,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.symmetric(horizontal: Vx.dp12),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        FoodProductListItem(
                          product: vm.products.elementAt(index),
                          onPressed: vm.productSelected,
                          qtyUpdated: vm.addToCartDirectly,
                        ),
                        Divider(
                          thickness: 2,
                        )
                      ],
                    );
                  },
                ),
              ),
              CustomVisibilty(
                visible: showGrid,
                child: CustomMasonryGridView(
                  isLoading: vm.isBusy,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: crossAxisCount ?? 3,
                  items: vm.products
                      .map(
                        (product) => GroceryProductListItem(
                          product: product,
                          onPressed: vm.productSelected,
                          qtyUpdated: vm.addToCartDirectly,
                        ),
                      )
                      .toList(),
                ).px12(),
              ),
            ],
          ).py12(),
        );
      },
    );
  }
}
