import 'package:flutter/src/widgets/framework.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/models/search.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/requests/vendor.request.dart';
import 'package:midnightcity/services/toast.service.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../../services/local_storage.service.dart';

class ListVendorsViewModel extends MyBaseViewModel {
  ListVendorsViewModel(
    BuildContext context,
    this.vendorType, {
    this.type = SearchFilterType.you,
    this.byLocation = false,
  }) {
    this.viewContext = context;
  }

  //
  List<Vendor> vendors = [];
  VendorType? vendorType;
  SearchFilterType type;
  bool byLocation;
  VendorRequest _vendorRequest = VendorRequest();

  //
  initialise() {
    fetchVendors();
  }

  //
  fetchVendors() async {
    setBusy(true);
    try {
      //filter by location if user selects delivery address
      vendors = await _vendorRequest.vendorsRequest(
        byLocation: byLocation ?? true,
        params: {
          "vendor_type_id": vendorType!.id,
          "type": type.name,
        },
      );

      clearErrors();
    } catch (error) {
      print("error loading vendors ==> $error");
      setError(error);
    }
    setBusy(false);
  }

  vendorSelected(Vendor vendor) async {
    setBusy(true);
    print(vendor.id);
    await LocalStorageService.prefs!.remove('branch');

    await LocalStorageService.prefs!.setString('branch', vendor.id.toString());

    // ToastService.toastSuccessful("Thank you for choosing our " + vendor.name + " branch. We are awaiting to serve you!!!");

    // viewContext!.navigator
    //    .pushNamedAndRemoveUntil(AppRoutes.homeRoute, (route) => false);
    setBusy(false);
    /*   if (vendor.name == "MidNight City Abuja") {
      VxDialog.showAlert(viewContext,
          title: "Opening Soon",
          content:
              "Thank you for your interest. We will be opening soon in Abuja");
    } else {
      viewContext!.navigator.pushNamed(
        AppRoutes.vendorDetails,
        arguments: vendor,
      );
    } */
  }
}
