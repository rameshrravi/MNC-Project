import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/models/checkout.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/requests/vendor.request.dart';
import 'package:midnightcity/view_models/checkout_base.vm.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class PharmacyUploadPrescriptionViewModel extends CheckoutBaseViewModel {
  //
  PharmacyUploadPrescriptionViewModel(BuildContext context, this.vendor) {
    this.viewContext = context;
    this.checkout = CheckOut(subTotal: 0.00);
    this.canSelectPaymentOption = true;
  }

  //
  VendorRequest vendorRequest = VendorRequest();
  late Vendor vendor;
  final picker = ImagePicker();
  File? prescriptionPhoto;

  void initialise() async {
    calculateTotal = false;
    super.initialise();
  }

  //
  fetchVendorDetails() async {
    //
    setBusyForObject(vendor, true);
    try {
      vendor = await vendorRequest.vendorDetails(vendor!.id!);
    } catch (error) {
      print("Error ==> $error");
    }
    setBusyForObject(vendor, false);
  }

  //
  void changePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      prescriptionPhoto = File(pickedFile.path);
    } else {
      prescriptionPhoto = null;
    }

    notifyListeners();
  }

  //
  //
  processOrderPlacement() async {
    setBusy(true);
    //set the total with discount as the new total
    checkout?.total = checkout!.totalWithTip!;
    //
    final apiResponse = await checkoutRequest.newPrescriptionOrder(
      checkout!,
      vendor!,
      photo: prescriptionPhoto,
      note: noteTEC.text,
    );
    //not error
    if (apiResponse.allGood) {
      //cash payment

      final paymentLink = "";
      // apiResponse.body["link"].toString();
      if (!paymentLink.isEmptyOrNull) {
        //  viewContext!.pop();
        Navigator.pop(viewContext!);
       // showOrdersTab(context: viewContext!);
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
            //  showOrdersTab(context: viewContext!);
              // if (viewContext!.navigator.canPop()) {
              //   viewContext!.pop();
              // }

              Navigator.pop(viewContext!);
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
