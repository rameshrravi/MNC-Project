import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:midnightcity/models/user.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/services/location.service.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:midnightcity/requests/product.request.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/models/search.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/requests/vendor.request.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorViewModel extends MyBaseViewModel {
  //
  VendorViewModel(BuildContext context, VendorType vendorType) {
    this.viewContext = context;
    this.vendorType = vendorType;
  }
  //
  User? currentUser;
  StreamSubscription? currentLocationChangeStream;
  List<Vendor>? vendors = [];
  Vendor dvendor = new Vendor();
  bool? byLocation;
  VendorRequest _vendorRequest = VendorRequest();
  ProductRequest _productRequest = ProductRequest();
  SearchFilterType? type;
  Map<int, List>? menuProducts = {};
  //
  int queryPage = 1;

  RefreshController refreshController = RefreshController();

  void initialise() async {
    //
    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser(force: true);
      notifyListeners();
    }

    //listen to user location change
    currentLocationChangeStream =
        LocationService.currenctAddressSubject.stream.listen(
      (location) {
        //
        deliveryaddress!.address = location.addressLine;
        deliveryaddress!.latitude = location.coordinates!.latitude;
        deliveryaddress!.longitude = location.coordinates!.longitude;
        notifyListeners();
      },
    );

    print("dfsdfdsfdsf");

    setBusy(true);
    try {
      //filter by location if user selects delivery address
      debugger();
      vendors = await _vendorRequest.vendorsRequest(
        byLocation: false, // byLocation ?? true,
        params: {
          "vendor_type_id": vendorType!.id!,
        },
      );

      String branch = await AuthServices.getPrefBranch();
      int v_id;
      print("********" + branch);
      if (branch == "1") {
        v_id = 0;
      } else {
        v_id = 1;
      }

      dvendor = await vendors![v_id];

      //  dvendor = vendors[1];

      clearErrors();
    } catch (error) {
      print("error loading vendors ==> $error");
      setError(error);
    }
    setBusy(false);

    //
  }

  loadMenuProduts() {
    //

    //
    dvendor.menus!.forEach((element) {
      loadMoreProducts(element.id!);
      //  menuProductsQueryPages[element.id] = 1;
    });
  }

  loadMoreProducts(int id, {bool initialLoad = true}) async {
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

      menuProducts![id]!.addAll(mProducts);
    } catch (error) {
      print("load more error ==> $error");
    }

    //

    notifyListeners();
  }

  fetchVendors() async {
    setBusy(true);
    try {
      //filter by location if user selects delivery address
      debugger();
      vendors = await _vendorRequest.vendorsRequest(
        byLocation: false, // byLocation ?? true,
        params: {
          "vendor_type_id": vendorType!.id,
        },
      );

      String branch = await AuthServices.getPrefBranch();

      int v_id;
      print("sssss" + branch);
      if (branch == "1") {
        v_id = 0;
      } else {
        v_id = 1;
      }

      dvendor = await vendors![v_id];

      clearErrors();
    } catch (error) {
      print("error loading vendors ==> $error");
      setError(error);
    }
    setBusy(false);
  }

  //switch to use current location instead of selected delivery address
  void useUserLocation() {
    LocationService.geocodeCurrentLocation();
  }

  //
  dispose() {
    super.dispose();
    currentLocationChangeStream!.cancel();
  }
}
