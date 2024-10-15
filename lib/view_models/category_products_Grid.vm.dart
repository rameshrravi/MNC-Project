import 'dart:developer';

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

class CategoryProductsViewModel extends MyBaseViewModel {
  //
  CategoryProductsViewModel(
    BuildContext context,
    this.category,
    this.vendor,
  ) {
    this.viewContext = context;
  }

  ProductRequest _productRequest = ProductRequest();
  RefreshController refreshContoller = RefreshController();
  List<RefreshController>? refreshContollers = [];
  List<int>? refreshContollerKeys = [];

  //
  Category? category;
  Vendor vendor;
  Map<int, List>? categoriesProducts = {};
  Map<int, int>? categoriesProductsQueryPages = {};
  final currencySymbol = AppStrings.currencySymbol;
  bool subcategorynext = true;

  initialise() {
    //

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
      categoriesProductsQueryPages![element.id!] = 1;
    });
  }

  void productSelected(Product product) async {
    await Navigator.pushNamed(
      viewContext!,
      AppRoutes.product,
      arguments: product,
    );

    // await viewContext!.navigator.pushNamed(
    //   AppRoutes.product,
    //   arguments: product,
    // );

    //
    notifyListeners();
  }

  RefreshController getRefreshController(int key) {
    int index = refreshContollerKeys!.indexOf(key);
    return refreshContollers![index];
  }

  loadMoreProducts(int id, {bool initialLoad = true}) async {
    int queryPage = categoriesProductsQueryPages![id] ?? 1;
    if (initialLoad) {
      queryPage = 1;
      categoriesProductsQueryPages![id] = queryPage;
      getRefreshController(id).refreshCompleted();
      setBusyForObject(id, true);
    } else {
      categoriesProductsQueryPages![id] = ++queryPage;
    }
    //load the products by subcategory id
    try {
      final mProducts = await _productRequest.getProdcuts(
        page: queryPage,
        queryParams: {
          "sub_category_id": id,
          "vendor_id": vendor?.id,
        },
      );
      //

      if (initialLoad) {
        categoriesProducts![id] = mProducts;
        print(categoriesProducts.toString());
      } else {
        print(mProducts.length);
        if (mProducts.length == 0) {
          subcategorynext = true;
        } else {
          categoriesProducts![id]!.addAll(mProducts);
        }

        // print(categoriesProducts.toString());
      }
    } catch (error) {
      print("load more error ==> $error");
    }
    //
    if (initialLoad) {
      setBusyForObject(id, false);
    } else {
      getRefreshController(id).loadComplete();
    }
    //
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
