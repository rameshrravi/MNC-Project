import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/cart.dart';
import 'package:midnightcity/models/checkout.dart';
import 'package:midnightcity/models/coupon.dart';
import 'package:midnightcity/requests/cart.request.dart';
import 'package:midnightcity/services/alert.service.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/services/cart.service.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:midnightcity/views/pages/cart/cart.page.dart';
import 'package:midnightcity/views/pages/checkout/multiple_order_checkout.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:midnightcity/widgets/list_items/cart.list_item.dart';
import 'package:velocity_x/velocity_x.dart';

class CartViewModel extends MyBaseViewModel {
  //
  CartRequest cartRequest = CartRequest();
  List<Cart>? cartItems = [];
  int totalCartItems = 0;
  double subTotalPrice = 0.0;
  double discountCartPrice = 0.0;
  double totalCartPrice = 0.0;
  bool? canApplyCoupon = false;
  //
  Coupon? coupon;
  TextEditingController couponTEC = TextEditingController();

  //
  CartViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void initialise() async {
    //
    cartItems = CartServices.productsInCart;
    //
    calculateSubTotal();
  }

  //
  calculateSubTotal() {
    //
    totalCartItems = 0;
    subTotalPrice = 0;
    discountCartPrice = 0;

    //
    cartItems!.forEach(
      (cartItem) {
        totalCartItems += cartItem.selectedQty!;

        final totalProductPrice = cartItem.price! * cartItem.selectedQty!;
        subTotalPrice += totalProductPrice;

        //discount/coupon
        if (coupon != null) {
          final foundProduct = coupon!.products!
              .firstWhere((product) => cartItem.product!.id == product.id);
          final foundVendor = coupon!.vendors!
              .firstWhere((vendor) => cartItem.product!.vendorId == vendor.id);
          if (foundProduct != null ||
              foundVendor != null ||
              (coupon!.products!.isEmpty && coupon!.vendors!.isEmpty)) {
            if (coupon!.percentage == 1) {
              discountCartPrice +=
                  (coupon!.discount! / 100) * totalProductPrice;
            } else {
              discountCartPrice += coupon!.discount!;
            }
          }
        }

        //
      },
    );

    //check if coupon is allow with the discount price
    if (coupon != null) {
      try {
        discountCartPrice = coupon!.validateDiscount(
          subTotalPrice,
          discountCartPrice,
        );
      } catch (error) {
        discountCartPrice = 0;
        setErrorForObject(coupon!, error);
      }
    }
    //
    totalCartPrice = subTotalPrice - discountCartPrice;
    notifyListeners();
  }

  //
  deleteCartItem(int index) {
    //
    // AlertService.showConfirm()
    AlertService.showConfirm(
      title: "Remove From Cart".tr(),
      text: "Are you sure you want to remove this product from cart?".tr(),
      confirmBtnText: "Yes".tr(),
      onConfirm: () async {
        //
        //remove item/product from cart
        cartItems?.removeAt(index);
        await CartServices.saveCartItems(cartItems!);
        initialise();

        //close dialog
        // viewContext!.pop();
        // Navigator.pop(viewContext!);
        // Navigator.of(viewContext!).pop(true);
        // Navigator.pushReplacement(
        //viewContext!, MaterialPageRoute(builder: (context) => CartPage()));
      },
    );
  }

  //
  updateCartItemQuantity(int qty, int index) async {
    cartItems![index].selectedQty = qty;
    await CartServices.saveCartItems(cartItems!);
    initialise();
  }

  //
  couponCodeChange(String code) {
    canApplyCoupon = code.isNotBlank;
    notifyListeners();
  }

  //
  applyCoupon() async {
    //
    setBusyForObject(coupon, true);
    try {
      coupon = await cartRequest.fetchCoupon(couponTEC.text);
      //
      if (coupon!.useLeft! <= 0) {
        throw "Coupon use limit exceeded".tr();
      } else if (coupon!.expired!) {
        throw "Coupon has expired".tr();
      }
      clearErrors();
      //re-calculate the cart price with coupon
      calculateSubTotal();
    } catch (error) {
      print("error ==> $error");
      setErrorForObject(coupon!, error);
      coupon = null;
      calculateSubTotal();
    }
    setBusyForObject(coupon, false);
  }

  //
  checkoutPressed() async {
    //
    bool canOpenCheckout = true;
    if (!AuthServices.authenticated()) {
      //
      // final result = await viewContext!.navigator.pushNamed(
      //   AppRoutes.loginRoute,
      // );

      final result =
          await Navigator.pushNamed(viewContext!, AppRoutes.loginRoute);
      if (result == null) {
        canOpenCheckout = false;
      }
    }

    //
    CheckOut checkOut = CheckOut();
    checkOut.coupon = coupon;
    checkOut.subTotal = subTotalPrice;
    checkOut.discount = discountCartPrice;
    checkOut.total = totalCartPrice;
    checkOut.totalWithTip = totalCartPrice;
    checkOut.cartItems = cartItems;

    //
    if (canOpenCheckout) {
      dynamic result;
      //check if multiple vendor order was added to cart
      if (AppStrings.enableMultipleVendorOrder &&
          CartServices.isMultipleOrder()) {
        // result = await viewContext!.push(
        //   (ctx) => MultipleOrderCheckoutPage(checkout: checkOut),
        // );
        result = await Navigator.push(
            viewContext!,
            MaterialPageRoute(
                builder: (context) =>
                    MultipleOrderCheckoutPage(checkout: checkOut)));
      } else {
        // result = await viewContext!.navigator.pushNamed(
        //   AppRoutes.checkoutRoute,
        //   arguments: checkOut,
        // );

        result = await Navigator.pushNamed(
            viewContext!, AppRoutes.checkoutRoute,
            arguments: checkOut);
      }

      if (result != null && result) {
        //
        await CartServices.saveCartItems([]);
        // viewContext!.pop();
        Navigator.pop(viewContext!);
      }
    }
  }
}
