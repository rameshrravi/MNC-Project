import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/service.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/requests/service.request.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:midnightcity/views/pages/service/service_details.page.dart';
import 'package:velocity_x/velocity_x.dart';

class PopularServicesViewModel extends MyBaseViewModel {
  //
  ServiceRequest _serviceRequest = ServiceRequest();
  //
  List<Service> services = [];
  VendorType? vendorType;

  PopularServicesViewModel(BuildContext context, this.vendorType) {
    this.viewContext = context;
  }

  //
  initialise() async {
    setBusy(true);
    try {
      services = await _serviceRequest.getServices(
        byLocation: AppStrings.enableFatchByLocation,
        queryParams: {
          "vendor_type_id": vendorType!.id,
        },
      );
      clearErrors();
    } catch (error) {
      print("PopularServicesViewModel Error ==> $error");
      setError(error);
    }
    setBusy(false);
  }

  //
  serviceSelected(Service service) {
    // Navigator.push(
    //   viewContext!,
    //   MaterialPageRoute(
    //     builder: (context) => ServiceDetailsPage(service),
    //   ),
    // );
    // viewContext!.push(
    //   (context) => ServiceDetailsPage(service),
    // );
  }
}
