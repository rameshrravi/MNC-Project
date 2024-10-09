import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/models/category.dart';
import 'package:midnightcity/models/search.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/requests/search.request.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/vendor_category_products.vm.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/custom_list_view.dart';
import 'package:midnightcity/widgets/list_items/horizontal_product.list_item.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/models/category.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/requests/product.request.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../widgets/custom_grid_view.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/inputs/search_bar.input.dart';

class VendorCategoryProductsPageNew extends StatefulWidget {
  VendorCategoryProductsPageNew(
      {this.category, this.vendor, this.index, Key? key})
      : super(key: key);

  final Category? category;
  final Vendor? vendor;
  int? index = 0;

  @override
  _VendorCategoryProductsPageNewState createState() =>
      _VendorCategoryProductsPageNewState();
}

class _VendorCategoryProductsPageNewState
    extends State<VendorCategoryProductsPageNew> with TickerProviderStateMixin {
  //
  TabController? tabBarController;
  String? subcategory;
  String searchProduct = "";
  TextEditingController txtECSearch = new TextEditingController();

  ProductRequest _productRequest = ProductRequest();
  RefreshController refreshContoller = RefreshController();
  List<RefreshController> refreshContollers = [];
  List<int> refreshContollerKeys = [];

  //
  Category? category;
//  Vendor vendor;
  Map<int, List> categoriesProducts = {};
  Map<int, int> categoriesProductsQueryPages = {};
  final currencySymbol = AppStrings.currencySymbol;

  @override
  void initState() {
    category = widget.category;

    int index = widget.index ?? 0;

    super.initState();

    category!.subcategories!.sort((a, b) {
      return a.name!.compareTo(b.name!);
    });

    refreshContollers = List.generate(
      category!.subcategories!.length,
      (index) => new RefreshController(),
    );
    refreshContollerKeys = List.generate(
      category!.subcategories!.length,
      (index) => category!.subcategories![index].id!,
    );
    category!.subcategories!.forEach((element) {
      loadMoreProducts(element.id!);
      categoriesProductsQueryPages[element.id!] = 1;
    });

    tabBarController = TabController(
      length: widget.category!.subcategories!.length,
      vsync: this,
      initialIndex: index,
    );
  }

  void productSelected(Product product) async {
    /*   await viewContext!.navigator.pushNamed(
      AppRoutes.product,
      arguments: product,
    );
*/
    //
    // notifyListeners();
  }

  RefreshController getRefreshController(int key) {
    int index = refreshContollerKeys.indexOf(key);
    return refreshContollers[index];
  }

  loadMoreProducts(int id, {bool initialLoad = true}) async {
    int queryPage = categoriesProductsQueryPages[id] ?? 1;
    if (initialLoad) {
      queryPage = 1;
      categoriesProductsQueryPages[id] = queryPage;
      getRefreshController(id).refreshCompleted();
      // setBusyForObject(id, true);
    } else {
      categoriesProductsQueryPages[id] = ++queryPage;
    }

    //load the products by subcategory id
    try {
      final mProducts = await _productRequest.getProdcuts(
        page: queryPage,
        queryParams: {
          "sub_category_id": id,
          "vendor_id": widget.vendor?.id,
        },
      );

      //
      if (initialLoad) {
        categoriesProducts[id] = mProducts;
      } else {
        categoriesProducts[id]!.addAll(mProducts);
      }
    } catch (error) {}

    //
    if (initialLoad) {
      //setBusyForObject(id, false);
    } else {
      getRefreshController(id).loadComplete();
    }

    //
    //notifyListeners();
  }

  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorCategoryProductsViewModel>.reactive(
      viewModelBuilder: () => VendorCategoryProductsViewModel(
        context,
        widget.category,
        widget.vendor!,
      ),
      //onModelReady: (vm) => vm.initialise(),
      onViewModelReady: (vm) => vm.initialise(),
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
            body: Column(
              children: [
                //     Text("Search here"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextFormField(
                    // hintText: "Search here",
                    // labelText: "Search here",
                    prefixIcon: Icon(Icons.search),
                    textColor: Colors.black,
                    labelColor: Colors.black,
                    cursorColor: Colors.black,
                    textEditingController: txtECSearch,

                    onChanged: () {
                      setState(() {
                        searchProduct = txtECSearch.text;
                      });
                      print(searchProduct);
                    },
                    onSaved: (value) {
                      setState(() {
                        searchProduct = txtECSearch.text;
                      });
                    },
                  ),
                ),

                Expanded(
                  // height: 400,
                  child: TabBarView(
                    physics: ScrollPhysics(),
                    //  ..  dragStartBehavior: Dr,
                    controller: tabBarController,
                    children: model.category!.subcategories!.map(
                      (subcategory) {
                        return model.category!.name == "Groceries" ||
                                model.category!.name == "Pharmacy"
                            ? CustomGridView(
                                noScrollPhysics: false,
                                refreshController:
                                    model.getRefreshController(subcategory.id!),
                                canPullUp: true,
                                canRefresh: true,
                                // padding: EdgeInsets.symmetric(vertical: 10),
                                dataSet: searchProduct != ""
                                    ? model.categoriesProducts![subcategory.id]!
                                            .where((element) => element.name
                                                .toLowerCase()
                                                .toString()
                                                .contains(searchProduct
                                                    .toLowerCase()))
                                            .toList() ??
                                        []
                                    : model.categoriesProducts![
                                            subcategory.id] ??
                                        [],
                                isLoading: model.busy(subcategory.id),
                                onLoading: () => model.loadMoreProducts(
                                  subcategory.id!,
                                  initialLoad: false,
                                ),
                                onRefresh: () =>
                                    model.loadMoreProducts(subcategory.id!),
                                itemBuilder: (context, index) {
                                  //

                                  final product = (model.categoriesProducts![
                                              subcategory.id]! ??
                                          [])
                                      .where((element) => element.name
                                          .toLowerCase()
                                          .toString()
                                          .contains(
                                              searchProduct.toLowerCase()))
                                      .toList()[index];

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
                              )
                            : CustomListView(
                                noScrollPhysics: false,
                                refreshController:
                                    model.getRefreshController(subcategory.id!),
                                canPullUp: true,
                                canRefresh: true,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                dataSet: searchProduct != ""
                                    ? model.categoriesProducts![subcategory.id]!
                                            .where((element) => element.name
                                                .toLowerCase()
                                                .contains(searchProduct
                                                    .toLowerCase()))
                                            .toList() ??
                                        []
                                    : model.categoriesProducts![
                                            subcategory.id] ??
                                        [],
                                isLoading: model.busy(subcategory.id),
                                onLoading: () => model.loadMoreProducts(
                                  subcategory.id!,
                                  initialLoad: false,
                                ),
                                onRefresh: () {
                                  model.loadMoreProducts(subcategory.id!);

                                  if (model.subcategorynext = true) {
                                    print("sss");

                                    setState(() {});
                                  }
                                },
                                itemBuilder: (context, index) {
                                  //
                                  final product = (model.categoriesProducts![
                                              subcategory.id] ??
                                          [])
                                      .where((element) => element.name
                                          .toLowerCase()
                                          .toString()
                                          .contains(
                                              searchProduct.toLowerCase()))
                                      .toList()[index];
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
              ],
            ),
          ),
        );
      },
    );
  }

  showSearchPage(BuildContext context) {
    final search = Search(
      showType: 2,
      vendorType: widget.vendor!.vendorType,
    );
    //
  }
}
