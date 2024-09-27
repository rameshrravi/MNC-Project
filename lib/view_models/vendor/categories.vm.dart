import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:midnightcity/models/category.dart';
import 'package:midnightcity/models/search.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/requests/category.request.dart';
import 'package:midnightcity/services/navigation.service.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:midnightcity/views/pages/category/subcategories.page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/models/menu.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/requests/product.request.dart';
import 'package:midnightcity/requests/vendor.request.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:midnightcity/views/pages/pharmacy/pharmacy_upload_prescription.page.dart';
import 'package:midnightcity/views/pages/vendor_search/vendor_search.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../services/auth.service.dart';
import '../../views/pages/vendor_details/vendor_category_products.page.dart';

class CategoriesViewModel extends MyBaseViewModel {
  CategoriesViewModel(BuildContext context,
      {this.tickerProvider, required this.vendorType}) {
    this.viewContext = context;
    // this.vendor = vendor ;
  }

  CategoryRequest _categoryRequest = CategoryRequest();
  RefreshController refreshController = RefreshController();
  VendorRequest? _vendorRequest = VendorRequest();
  //
  List<Category>? categories = [];
  VendorType? vendorType;
  int queryPage = 1;

  List<Vendor>? vendors = [];
  Vendor? dvendor;

  TickerProvider? tickerProvider;
  TabController? tabBarController;
  final currencySymbol = AppStrings.currencySymbol;

  ProductRequest _productRequest = ProductRequest();
  RefreshController refreshContoller = RefreshController();
  List<RefreshController> refreshContollers = [];
  List<int> refreshContollerKeys = [];

  //
  Map<int, List> menuProducts = {};
  Map<int, int> menuProductsQueryPages = {};

  initialise({bool all = false}) async {
    setBusy(true);
    debugger();
    try {
      //filter by location if user selects delivery address
      vendors = await _vendorRequest!.vendorsRequest(
        byLocation: false, // byLocation ?? true,
        params: {
          "vendor_type_id": vendorType?.id,
        },
      );

      String branch = await AuthServices.getPrefBranch();
      int v_id;
      if (branch == "1") {
        v_id = 0;
      } else {
        v_id = 1;
      }

      dvendor = await vendors?[v_id];
      //print(dvendor.name)

      clearErrors();
    } catch (error) {
      print("error loading vendors ==> $error");
      setError(error);
    }

//    dvendor.hasSubcategories = true;

    // print("sssss" + vendor.name.toString());

    print("w2");
    try {
      print("w3");
      categories = await _categoryRequest.categories(
        vendorTypeId: vendorType?.id,
        page: queryPage,
        full: all ? 1 : 0,
      );
      print("w4");
      clearErrors();
      print("w5");
    } catch (error) {
      setError(error);
    }

    print("w6");
    try {
      print("w7");
      dvendor = await _vendorRequest?.vendorDetails(
        dvendor!.id!,
        params: {
          "type": "small",
        },
      );
      // print(dvendor.);
      //empty menu
      dvendor!.menus!.insert(
        0,
        Menu(
          id: null,
          name: "All".tr(),
        ),
      );
      print("w9");

      updateUiComponents();
      print("w10");
      clearErrors();
      print("w11");
    } catch (error) {
      setError(error);
      print("error ==> ${error}");
    }

    setBusy(false);
  }

  //
  loadMoreItems([bool initialLoading = false, bool all = true]) async {
    if (initialLoading) {
      setBusy(true);
      queryPage = 1;
      refreshController.refreshCompleted();
    } else {
      queryPage += 1;
    }
    //
    try {
      final mCategories = await _categoryRequest.categories(
        vendorTypeId: vendorType!.id,
        page: queryPage,
        full: all ? 1 : 0,
      );
      clearErrors();

      //
      if (initialLoading) {
        categories = mCategories;
      } else {
        categories!.addAll(mCategories);
      }
    } catch (error) {
      setError(error);
    }
    if (initialLoading) {
      setBusy(false);
    }
    refreshController.loadComplete();
    notifyListeners();
  }

  //
  categorySelected(Category category) async {
    Vendor vendor;
    vendor = this.vendor!;
    Widget page;
    if (category!.hasSubcategories!) {
      // page= VendorCategoryProductsPage(category: category,vendor: vendor );
      page = SubcategoriesPage(category: category);
    } else {
      final search = Search(
        vendorType: category.vendorType,
        category: category,
        showType: (category.vendorType!.isService ?? false) ? 5 : 4,
      );
      // page = NavigationService().searchPageWidget(search);
    }
    // viewContext!.nextPage(page);
  }

  categorySelectedNew(Category category, Vendor vendor) async {
    Widget page;
    if (category.hasSubcategories!) {
      // page = VendorCategoryProductsPage(
      //  category: category,
      //  vendor: vendor,
      //);
      //  page = SubcategoriesPage(category: category);
    } else {
      final search = Search(
        vendorType: category.vendorType,
        category: category,
        showType: (category.vendorType!.isService ?? false) ? 5 : 4,
      );
      //page = NavigationService().searchPageWidget(search);
    }
    //viewContext!.nextPage(page);
  }

  //vendor details by deep

  //

  //
  void getVendorDetails() async {
    //
    setBusy(true);

    try {
      vendor = await _vendorRequest!.vendorDetails(
        vendor!.id!,
        params: {
          "type": "small",
        },
      );

      //empty menu
      vendor!.menus!.insert(
        0,
        Menu(
          id: null,
          name: "All".tr(),
        ),
      );

      updateUiComponents();
      clearErrors();
    } catch (error) {
      setError(error);
      print("error ==> ${error}");
    }
    setBusy(false);
  }

  //
  updateUiComponents() {
    //
    print("wwww");
    if (!dvendor!.hasSubcategories!) {
      print("222");
      tabBarController = TabController(
        length: dvendor!.menus!.length,
        vsync: tickerProvider!,
      );

      //
      loadMenuProduts();
    } else {
      //nothing to do yet
    }
  }

  void productSelected(Product product) async {
    // await viewContext!.navigator.pushNamed(
    //   AppRoutes.product,
    //   arguments: product,
    // );

    //
    notifyListeners();
  }

  //
  void uploadPrescription() {
    //
    // viewContext!.push(
    //   (context) => PharmacyUploadPrescription(dvendor!),
    // );
  }

  RefreshController getRefreshController(int key) {
    int index = refreshContollerKeys.indexOf(key);
    return refreshContollers[index];
  }

  //
  loadMenuProduts() {
    //
    refreshContollers = List.generate(
      dvendor!.menus!.length,
      (index) => new RefreshController(),
    );
    refreshContollerKeys = List.generate(
      dvendor!.menus!.length,
      (index) => dvendor!.menus![index].id!,
    );
    //
    dvendor!.menus!.forEach((element) {
      loadMoreProducts(element.id!);
      menuProductsQueryPages[element.id!] = 1;
    });
  }

  //
  loadMoreProducts(int id, {bool initialLoad = true}) async {
    int queryPage = menuProductsQueryPages[id] ?? 1;
    if (initialLoad) {
      queryPage = 1;
      menuProductsQueryPages[id] = queryPage;
      getRefreshController(id).refreshCompleted();
      setBusyForObject(id, true);
    } else {
      menuProductsQueryPages[id] = ++queryPage;
    }

    //load the products by subcategory id
    try {
      final mProducts = await _productRequest.getProdcuts(
        page: queryPage,
        queryParams: {
          "menu_id": id,
          "vendor_id": dvendor?.id,
        },
      );

      //
      if (initialLoad) {
        menuProducts[id] = mProducts;
      } else {
        menuProducts[id]!.addAll(mProducts);
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

    notifyListeners();
  }

  openVendorSearch() {
    // viewContext!.push(
    //   (context) => VendorSearchPage(dvendor),
    // );
  }
}
