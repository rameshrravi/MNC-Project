import 'dart:io';

import 'package:flutter/material.dart';
import 'package:midnightcity/enums/product_fetch_data_type.enum.dart';
import 'package:midnightcity/models/category.dart';
import 'package:midnightcity/models/search.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/utils/utils.dart';
import 'package:midnightcity/view_models/products.vm.dart';
import 'package:midnightcity/views/pages/search/search.page.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/custom_list_view.dart';
import 'package:midnightcity/widgets/custom_masonry_grid_view.dart';
import 'package:midnightcity/widgets/list_items/commerce_product.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductsSectionView extends StatelessWidget {
  const ProductsSectionView(
    this.title, {
    this.vendorType,
    this.category,
    this.type = ProductFetchDataType.RANDOM,
    this.showGrid = true,
    Key? key,
  }) : super(key: key);

  final String? title;
  final VendorType? vendorType;
  final ProductFetchDataType type;
  final Category? category;
  final bool showGrid;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductsViewModel>.reactive(
      viewModelBuilder: () => ProductsViewModel(
        context,
        vendorType!,
        type,
        categoryId: category!.id!,
      ),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return CustomVisibilty(
          visible: !model.isBusy && model.products.isNotEmpty,
          child: VStack(
            [
              //
              HStack(
                [
                  "$title".text.semiBold.lg.make().expand(),
                  UiSpacer.horizontalSpace(),
                  HStack(
                    [
                      "See all".tr().text.make(),
                      UiSpacer.smHorizontalSpace(),
                      Icon(Icons.import_contacts),
                      // Icon(
                      //   Utils.isArabic
                      //       ? FlutterIcons.arrow_left_evi
                      //       : FlutterIcons.arrow_right_evi,
                      // ),
                    ],
                  ).onInkTap(() => openSearchPage(context)),
                ],
              )
                  .box
                  .p12
                  .color(context.backgroundColor)
                  .outerShadowSm
                  .roundedSM
                  .make()
                  .wFull(context),
              UiSpacer.verticalSpace(space: 5),
              CustomVisibilty(
                visible: !showGrid,
                child: CustomListView(
                  isLoading: model.isBusy,
                  dataSet: model.products,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final product = model.products[index];
                    return FittedBox(
                      child: CommerceProductListItem(
                        product,
                        height: 80,
                      ).w(context.percentWidth * 30),
                    );
                  },
                ).h(Platform.isAndroid ? 160 : 190),
              ),
              CustomVisibilty(
                visible: showGrid,
                child: CustomMasonryGridView(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  isLoading: model.isBusy,
                  items: List.generate(
                    model.products.length ?? 0,
                    (index) {
                      //
                      final product = model.products[index];
                      return CommerceProductListItem(product);
                    },
                  ),
                ),
              ),
            ],
          ).py12(),
        );
      },
    );
  }

  //
  openSearchPage(BuildContext context) {
    //
    final search = Search(
      type: type?.name,
      category: category,
      vendorType: vendorType,
      showType: 2,
    );
    //open search
    // context.push(
    //   (context) => SearchPage(
    //     search: search,
    //   ),
    // );
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (_) => SearchPage(search: search)));
  }
}
