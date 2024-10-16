import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/models/checkout.dart';
import 'package:midnightcity/models/coupon.dart';
import 'package:midnightcity/models/payment_method.dart';
import 'package:midnightcity/models/service.dart';
import 'package:midnightcity/requests/cart.request.dart';
import 'package:midnightcity/requests/payment_method.request.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/services/alert.service.dart';
import 'package:midnightcity/services/app.service.dart';
import 'package:midnightcity/view_models/checkout_base.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ServiceBookingSummaryViewModel extends CheckoutBaseViewModel {
  //
  ServiceBookingSummaryViewModel(BuildContext context, this.service) {
    this.viewContext = context;
    vendor = service!.vendor!;
    AppService().vendorId = vendor!.id;
    fetchPaymentOptions();

    //prepare checkout
    checkout = CheckOut();
    final subTotal = double.parse(
        ((service!.showDiscount! ? service!.discountPrice : service!.price)! *
                (!(service!.isFixed) ? (service!.selectedQty ?? 1) : 1))
            .toString());
    checkout!.subTotal = subTotal;
  }
//
  CartRequest cartRequest = CartRequest();
  PaymentMethodRequest paymentOptionRequest = PaymentMethodRequest();
  TextEditingController noteTEC = TextEditingController();
  //coupons
  bool? canApplyCoupon = false;
  Coupon? coupon;
  TextEditingController couponTEC = TextEditingController();

  //
  CheckOut? checkout = CheckOut();
  Service? service;
  double subTotal = 0.0;
  double total = 0.0;
  final currencySymbol = AppStrings.currencySymbol;
  //
  List<PaymentMethod> paymentMethods = [];
  PaymentMethod? selectedPaymentMethod;

  //get payment options
  fetchPaymentOptions() async {
    setBusyForObject(paymentMethods, true);
    try {
      paymentMethods = await paymentOptionRequest.getPaymentOptions(
        vendorId: service!.vendor!.id,
      );
      //
      clearErrors();
    } catch (error) {
      print("Error getting payment methods ==> $error");
    }
    setBusyForObject(paymentMethods, false);
  }

  isSelected(PaymentMethod paymentMethod) {
    return selectedPaymentMethod != null &&
        paymentMethod.id == selectedPaymentMethod!.id;
  }

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
      //
      if (coupon!.percentage! == 1) {
        checkout!.discount = (coupon!.discount! / 100) * checkout!.subTotal!;
      } else {
        checkout!.discount = coupon!.discount;
      }
    } catch (error) {
      print("error ==> $error");
      setErrorForObject(coupon!, error);
    }
    setBusyForObject(coupon, false);
  }

  //
  //
  placeOrder({bool ignore = false}) async {
    //
    if (isScheduled && checkout!.deliverySlotDate!.isEmptyOrNull) {
      //
      AlertService.error(
        title: "Schedule Date".tr(),
        text: "Please select your desire order date".tr(),
      );
    } else if (isScheduled && checkout!.deliverySlotTime.isEmptyOrNull) {
      //
      AlertService.error(
        title: "Schedule Time".tr(),
        text: "Please select your desire order time".tr(),
      );
    } else if (!isPickup && service!.location! && deliveryAddress == null) {
      //
      AlertService.error(
        title: "Booking address".tr(),
        text: "Please select booking address".tr(),
      );
    } else if (service!.location! && delievryAddressOutOfRange && !isPickup) {
      //
      AlertService.error(
        title: "Booking address".tr(),
        text: "Booking address is out of vendor booking range".tr(),
      );
    } else if (selectedPaymentMethod == null) {
      AlertService.error(
        title: "Payment Methods".tr(),
        text: "Please select a payment method".tr(),
      );
    } else if (!ignore && !verifyVendorOrderAmountCheck()) {
      print("Failed");
    }
    //process the new order
    else {
      processOrderPlacement();
    }
  }

  //
  processOrderPlacement() async {
    //process the order placement
    setBusy(true);
    //set the total with discount as the new total
    checkout!.total = checkout!.totalWithTip;
    //
    final apiResponse = await checkoutRequest.newServiceOrder(
      checkout!,
      service: service,
      note: noteTEC.text,
    );
    //not error
    if (apiResponse.allGood) {
      //cash payment

      final paymentLink = apiResponse.body["link"].toString();
      if (!paymentLink.isEmptyOrNull) {
        Navigator.pop(viewContext!);
        //  showOrdersTab();
        openWebpageLink(paymentLink);
      }
      //cash payment
      else {
        CoolAlert.show(
            context: viewContext!,
            type: CoolAlertType.success,
            title: "Checkout".tr(),
            text: apiResponse.message,
            barrierDismissible: false,
            onConfirmBtnTap: () {
              //showOrdersTab();
              Navigator.pop(viewContext!);
              // viewContext!.pop(true);
              // if (viewContext!.navigator.canPop()) {
              //   viewContext!.navigator
              //       .popUntil(ModalRoute.withName(AppRoutes.homeRoute));
              // }

              Navigator.popUntil(
                  viewContext!, ModalRoute.withName(AppRoutes.homeRoute));
            });
      }
    } else {
      CoolAlert.show(
        context: viewContext!,
        type: CoolAlertType.error,
        title: "Checkout".tr(),
        text: apiResponse.message,
      );
    }
    setBusy(false);
  }
}
