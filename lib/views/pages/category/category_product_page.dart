import 'dart:developer';

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
import '../search/search.page.dart';
import '../vendor_details/vendor_category_products.page_new.dart';
import 'categorey_list.dart';

class CategoryProductsPage extends StatefulWidget {
  CategoryProductsPage({this.category, this.vendor, Key? key})
      : super(key: key);

  final Category? category;
  final Vendor? vendor;

  @override
  _CategoryProductsPage createState() => _CategoryProductsPage();
}

class _CategoryProductsPage extends State<CategoryProductsPage>
    with TickerProviderStateMixin {
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
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextFormField(
                      // hintText: "Search here",
                      // labelText: "Search here",
                      isReadOnly: true,
                      prefixIcon: Icon(Icons.search),
                      textColor: Colors.black,
                      labelColor: Colors.black,
                      cursorColor: Colors.black,
                      textEditingController: txtECSearch,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(
                                search: Search(viewType: SearchType.products),
                                showCancel: false,
                              ),
                            ));
                      },

                      onChanged: () {
                        setState(() {
                          //searchProduct = txtECSearch!.text;
                        });
                        //   print(searchProduct);
                      },
                      onSaved: (value) {
                        setState(() {
                          model.category!.subcategories =
                              model.category!.subcategories!.where((element) {
                            return element.name!
                                .toLowerCase()
                                .contains(value.toLowerCase());
                          }).toList();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: model.category!.subcategories!.length,
                      itemBuilder: (context, index) {
                        Category category =
                            model.category!.subcategories![index];

                        return GestureDetector(
                            onTap: () {},
                            child: CategoryCard(
                                name: category.name!,
                                imageUrl: category.imageUrl!,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VendorCategoryProductsPageNew(
                                                category: model.category!,
                                                vendor: model.vendor,
                                                index: index,
                                              )));
                                }));
                      },
                    ),
                  ),
                ],
              ),
            ));
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
