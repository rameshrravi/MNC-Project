import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/requests/favourite.request.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class FavouritesViewModel extends MyBaseViewModel {
  //
  FavouriteRequest favouriteRequest = FavouriteRequest();
  List<Product> products = [];

  //
  FavouritesViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  void initialise() {
    //
    fetchProducts();
  }

  //
  fetchProducts() async {
    //
    setBusyForObject(products, true);
    try {
      products = await favouriteRequest.favourites();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(products, false);
  }

  //
  removemyFavourite(Product product) {
    //
    CoolAlert.show(
        context: viewContext!,
        type: CoolAlertType.confirm,
        title: "Remove Product From Favourite".tr(),
        text:
            "Are you sure you want to remove this product from your favourite list?"
                .tr(),
        confirmBtnText: "Remove".tr(),
        onConfirmBtnTap: () {
          //  viewContext!.pop();
          Navigator.pop(viewContext!);
          processRemove(product);
        });
  }

  //
  processRemove(Product product) async {
    setBusy(true);
    //
    final apiResponse = await favouriteRequest.removeFavourite(
      product.id!,
    );

    //remove from list
    if (apiResponse.allGood) {
      products.remove(product);
    }

    setBusy(false);

    CoolAlert.show(
      context: viewContext!,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Remove Product From Favourite".tr(),
      text: apiResponse.message,
    );
  }

  openProductDetails(Product product) {
    // viewContext!.navigator.pushNamed(
    //   AppRoutes.product,
    //   arguments: product,
    // );

    Navigator.pushNamed(viewContext!, AppRoutes.product, arguments: product);
  }
}
