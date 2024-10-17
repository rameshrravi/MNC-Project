import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/models/category.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/vendor_category_products.vm.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/custom_list_view.dart';
import 'package:midnightcity/widgets/list_items/horizontal_product.list_item.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorCategoryProductsPage extends StatefulWidget {
  VendorCategoryProductsPage({this.category, this.vendor, Key? key})
      : super(key: key);

  final Category? category;
  final Vendor? vendor;

  @override
  _VendorCategoryProductsPageState createState() =>
      _VendorCategoryProductsPageState();
}

class _VendorCategoryProductsPageState extends State<VendorCategoryProductsPage>
    with TickerProviderStateMixin {
  //
  TabController? tabBarController;
  String? subcategory;

  @override
  void initState() {
    super.initState();
    tabBarController = TabController(
      length: widget.category!.subcategories!.length,
      vsync: this,
    );
  }

  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorCategoryProductsViewModel>.reactive(
      viewModelBuilder: () => VendorCategoryProductsViewModel(
        context,
        widget.category,
        widget.vendor!,
      ),
      onModelReady: (vm) => vm.initialise(),
      //
      builder: (context, model, child) {
        return BasePage(
          elevation: 0,
          title: model.category!.name,
          showAppBar: true,
          showLeadingAction: true,
          showCart: true,
          body: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  title: "".text.black.make(),
                  floating: true,
                  pinned: true,
                  snap: true,
                  primary: false,
                  automaticallyImplyLeading: false,
                  flexibleSpace: TabBar(
                    // dragStartBehavior: DragStartDetails(),
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColor.midnightCityLightBlue),
                    unselectedLabelColor: Colors.black,
                    splashBorderRadius: BorderRadius.circular(10),
                    isScrollable: true,
                    labelColor: Colors.white,
                    indicatorColor: AppColor.midnightCityDarkBlue,

                    indicatorWeight: 2,
                    controller: tabBarController,
                    tabs: model.category!.subcategories!.map(
                      (subcategory) {
                        return Tab(
                          text: subcategory.name,
                        );
                      },
                    ).toList(),
                  ),
                ),
              ];
            },
            body: Container(
              child: TabBarView(
                physics: BouncingScrollPhysics(),
                controller: tabBarController,
                children: model.category!.subcategories!.map(
                  (subcategory) {
                    return CustomListView(
                      noScrollPhysics: false,
                      refreshController:
                          model.getRefreshController(subcategory.id!),
                      canPullUp: true,
                      canRefresh: true,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      dataSet: model.categoriesProducts![subcategory.id] ?? [],
                      isLoading: model.busy(subcategory.id),
                      // onLoading: () => model.loadMoreProducts(
                      //   subcategory.id!,
                      //   initialLoad: false,
                      // ),
                      onRefresh: () => model.loadMoreProducts(subcategory.id!),
                      itemBuilder: (context, index) {
                        //
                        final product =
                            (model.categoriesProducts![subcategory.id] ??
                                [])[index];
                        return Column(
                          children: [
                            HorizontalProductListItem(
                              product,
                              onPressed: model.productSelected,
                              qtyUpdated: model.addToCartDirectly,
                            ),
                            Divider(
                              color: AppColor.midnightCityDarkBlue,
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return UiSpacer.verticalSpace(space: 5);
                      },
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
