import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:midnightcity/constants/api.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/models/service.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/requests/product.request.dart';
import 'package:midnightcity/requests/service.request.dart';
import 'package:midnightcity/requests/vendor.request.dart';
import 'package:midnightcity/services/alert.service.dart';
import 'package:midnightcity/services/app.service.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/services/cart.service.dart';
import 'package:midnightcity/services/local_storage.service.dart';
import 'package:midnightcity/services/navigation.service.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:midnightcity/views/pages/auth/login.page.dart';
import 'package:midnightcity/views/pages/product/amazon_styled_commerce_product_details.page.dart';
import 'package:midnightcity/views/pages/product/product_details.page.dart';
import 'package:midnightcity/views/pages/service/service_details.page.dart';
import 'package:midnightcity/views/pages/vendor_details/vendor_details.page.dart';
import 'package:midnightcity/views/pages/welcome/welcome.page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/models/search.dart';

import '../constants/app_routes.dart';
import '../models/menu.dart';

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

class HomeViewModel extends MyBaseViewModel {
  //
  HomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  late int currentIndex = 0;
  PageController pageViewController = PageController(initialPage: 0);
  int totalCartItems = 0;
  late StreamSubscription homePageChangeStream;
  Widget homeView = WelcomePage();
  late int v_id;

  List<Vendor> vendors = [];
  Vendor dvendor = new Vendor();
  late bool byLocation;
  VendorRequest _vendorRequest = VendorRequest();
  late SearchFilterType type;

  late TickerProvider tickerProvider;
  late TabController tabBarController;
  final currencySymbol = AppStrings.currencySymbol;

  ProductRequest _productRequest = ProductRequest();
  RefreshController refreshContoller = RefreshController();
  List<RefreshController> refreshContollers = [];
  List<int> refreshContollerKeys = [];

  //
  Map<int, List> menuProducts = {};
  Map<int, int> menuProductsQueryPages = {};

  @override
  void initialise() async {
    //
    handleAppLink();

    //determine if homeview should be multiple vendor types or single vendor page
    // if (AppStrings.isSingleVendorMode) {
    //   VendorType vendorType = VendorType.fromJson(AppStrings.enabledVendorType);
    //   homeView = NavigationService.vendorTypePage(
    //     vendorType,
    //     context: viewContext,
    //   );
    //   //require login
    //   if (vendorType.authRequired && !AuthServices.authenticated()) {
    //     await viewContext!.push(
    //       (context) => LoginPage(
    //         required: true,
    //       ),
    //     );
    //   }
    //   notifyListeners();
    // }

    //start listening to changes to items in cart
    LocalStorageService.rxPrefs!.getIntStream(CartServices.totalItemKey).listen(
      (total) {
        if (total != null) {
          totalCartItems = total;
          notifyListeners();
        }
      },
    );

    //
    homePageChangeStream = AppService().homePageIndex.stream.listen(
      (index) {
        //
        onTabChange(index);
      },
    );

    try {
      //filter by location if user selects delivery address
      vendors = await _vendorRequest.vendorsRequest(
        byLocation: false, // byLocation ?? true,
        params: {
          "vendor_type_id": 2,
        },
      );
      print("********" + vendors.length.toString());
      print("0 ==> " + vendors[0].name.toString());
      print("1 ==> " + vendors[1].name.toString());

      String branch = await AuthServices.getPrefBranch();

      print("branch is " + branch);
      if (branch == "1") {
        v_id = 0;
      } else {
        v_id = 1;
      }
      print("v_id is " + v_id.toString());
      dvendor = await vendors[v_id];

      print("dvendor name is " + dvendor.name!);

      clearErrors();
    } catch (error) {
      print("error loading vendors ==> $error");
      setError(error);
    }
    getVendorDetails();
    loadMenuProduts();
  }

  void getVendorDetails() async {
    print("sfffggjkj");

    //

    dvendor.hasSubcategories = true;
    setBusy(true);

    try {
      dvendor = await _vendorRequest.vendorDetails(
        dvendor.id!,
        params: {
          "type": "small",
        },
      );

      //empty menu
      dvendor.menus!.insert(
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
    if (!vendor.hasSubcategories!) {
      print("222 - 3333");
      tabBarController = TabController(
        length: vendor.menus!.length,
        vsync: tickerProvider,
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

  RefreshController getRefreshController(int key) {
    int index = refreshContollerKeys.indexOf(key);
    return refreshContollers[index];
  }

  //
  loadMenuProduts() {
    //
    refreshContollers = List.generate(
      dvendor.menus!.length,
      (index) => new RefreshController(),
    );
    refreshContollerKeys = List.generate(
      dvendor.menus!.length,
      (index) => vendor.menus![index].id!,
    );
    //
    dvendor.menus!.forEach((element) {
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
    //       (context) => VendorSearchPage(vendor),
    // );
  }
  //
  // dispose() {
  //   super.dispose();
  //   homePageChangeStream.cancel();
  // }

  //
  onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  //
  onTabChange(int index) {
    currentIndex = index;
    pageViewController.animateToPage(
      currentIndex,
      duration: Duration(microseconds: 5),
      curve: Curves.bounceInOut,
    );
    notifyListeners();
  }

  //
  handleAppLink() async {
    // Get any initial links
    // final PendingDynamicLinkData initialLink =
    //     await FirebaseDynamicLinks.instance.getInitialLink();
    // if (initialLink != null) {
    //   final Uri deepLink = initialLink.link;
    //   openPageByLink(deepLink);
    // }
    //
    // //
    // FirebaseDynamicLinks.instance.onLink.listen(
    //   (dynamicLinkData) {
    //     //
    //     openPageByLink(dynamicLinkData.link);
    //   },
    // ).onError(
    //   (error) {
    //     // Handle errors
    //     print("error opening link ==> $error");
    //   },
    // );
  }

  //
  openPageByLink(Uri deepLink) async {
    final cleanLink = Uri.decodeComponent(deepLink.toString());
    if (cleanLink.contains(Api.appShareLink)) {
      //
      try {
        final linkFragments = cleanLink.split(Api.appShareLink);
        final dataSection = linkFragments[1];
        final pathFragments = dataSection.split("/");
        final dataId = pathFragments[pathFragments.length - 1];

        if (dataSection.contains("product")) {
          Product product = Product(id: int.parse(dataId));
          ProductRequest _productRequest = ProductRequest();
          AlertService.showLoading();
          product = await _productRequest.productDetails(product.id!);
          AlertService.stopLoading();
          if (!product.vendor!.vendorType!.slug!.contains("commerce")) {
            // viewContext!.push(
            //   (context) => ProductDetailsPage(
            //     product: product,
            //   ),
            // );
          } else {
            // viewContext!.push(
            //   (context) => AmazonStyledCommerceProductDetailsPage(
            //     product: product,
            //   ),
            // );
          }
        } else if (dataSection.contains("vendor")) {
          Vendor vendor = Vendor(id: int.parse(dataId));
          VendorRequest _vendorRequest = VendorRequest();
          AlertService.showLoading();
          vendor = await _vendorRequest.vendorDetails(vendor.id!);
          AlertService.stopLoading();
          // viewContext!.push(
          //   (context) => VendorDetailsPage(
          //     vendor: vendor,
          //   ),
          // );
        } else if (dataSection.contains("service")) {
          Service service = Service(id: int.parse(dataId));
          ServiceRequest _serviceRequest = ServiceRequest();
          AlertService.showLoading();
          service = await _serviceRequest.serviceDetails(service.id!);
          AlertService.stopLoading();
          // viewContext!.push(
          //   (context) => ServiceDetailsPage(service),
          // );
        }
      } catch (error) {
        AlertService.stopLoading();
        toastError("$error");
      }
    }
    print("Url Link ==> $cleanLink");
  }
}
