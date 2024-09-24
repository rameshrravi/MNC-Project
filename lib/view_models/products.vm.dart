import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/enums/product_fetch_data_type.enum.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/models/user.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/requests/product.request.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/services/location.service.dart';
import 'package:midnightcity/view_models/base.view_model.dart';

class ProductsViewModel extends MyBaseViewModel {
  //
  ProductsViewModel(
    BuildContext context,
    this.vendorType,
    this.type, {
    this.categoryId,
    this.byLocation = true,
  }) {
    this.viewContext = context;
    this.byLocation = AppStrings.enableFatchByLocation;
  }

  //
  late User currentUser;

  //
  VendorType? vendorType;
  late int? categoryId;
  late ProductFetchDataType type;
  ProductRequest productRequest = ProductRequest();
  List<Product> products = [];
  late bool? byLocation;
  late String branch;

  bool get anyProductWithOptions {
    try {
      return products.firstWhere((e) =>
              e.optionGroups != null &&
              e.optionGroups!.first != null &&
              e.optionGroups!.first.options!.isNotEmpty) !=
          null;
    } catch (error) {
      return false;
    }
  }

  void initialise() async {
    //
    if (AuthServices.authenticated()) {
      currentUser = (await AuthServices.getCurrentUser(force: true))!;
      notifyListeners();
    }

    deliveryaddress?.address = LocationService?.currenctAddress?.addressLine;
    deliveryaddress?.latitude =
        LocationService?.currenctAddress?.coordinates?.latitude;
    deliveryaddress?.longitude =
        LocationService?.currenctAddress?.coordinates?.longitude;

    branch = await AuthServices.getPrefBranch();
    //get today picks
    fetchProducts();
  }

  //
  fetchProducts() async {
    //
    setBusy(true);
    print(
      "type => " + type.name.toLowerCase(),
    );

    try {
      products = await productRequest.getProdcuts(
        queryParams: {
          "category_id": categoryId,
          "vendor_type_id": vendorType!.id,
          "type": 'random',
          "vendor_id": int.parse(branch),
          "latitude": byLocation! ? deliveryaddress?.latitude : null,
          "longitude": byLocation! ? deliveryaddress?.longitude : null,
        },
      );
    } catch (error) {
      print("Error ==> $error");
    }
    setBusy(false);
  }
}
