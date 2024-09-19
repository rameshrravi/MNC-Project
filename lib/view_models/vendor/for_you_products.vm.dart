import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/requests/product.request.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:midnightcity/views/pages/auth/forgot_password.page.dart';
import 'package:velocity_x/velocity_x.dart';

class ForYouProductsViewModel extends MyBaseViewModel {
  //
  ProductRequest _productRequest = ProductRequest();
  //
  List<Product> products = [];
  VendorType? vendorType;

  ForYouProductsViewModel(BuildContext context, this.vendorType) {
    this.viewContext = context;
  }

  //
  initialise() async {
    setBusy(true);
    try {
      products = await _productRequest.forYouProductsRequest(
        queryParams: {
          "vendor_type_id": vendorType!.id,
        },
      );
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //
  productSelected(Product product) async {
    Navigator.pushNamed(
      viewContext!,
      AppRoutes.product,
    );
    // viewContext!.navigator.pushNamed(
    //   AppRoutes.product,
    //   arguments: product,
    // );
  }
}
