import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/delivery_address.dart';
import 'package:midnightcity/requests/delivery_address.request.dart';
import 'package:midnightcity/services/app.service.dart';
import 'package:midnightcity/services/cart.service.dart';
import 'package:midnightcity/services/geocoder.service.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class DeliveryAddressPickerViewModel extends MyBaseViewModel {
  //
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  List<DeliveryAddress> deliveryAddresses = [];
  List<DeliveryAddress> unFilterDeliveryAddresses = [];
  final Function(DeliveryAddress) onSelectDeliveryAddress;

  //
  DeliveryAddressPickerViewModel(
      BuildContext context, this.onSelectDeliveryAddress) {
    this.viewContext = context;
  }

  //
  void initialise() {
    //
    fetchDeliveryAddresses();
  }

  //
  fetchDeliveryAddresses() async {
    //
    final vendorId = CartServices.productsInCart.isNotEmpty
        ? CartServices.productsInCart.first.product!.vendor!.id!
        : AppService().vendorId ?? null;

    List<int?>? vendorIds = (CartServices.productsInCart.isNotEmpty &&
            AppStrings.enableMultipleVendorOrder)
        ? CartServices.productsInCart
            .map((e) => e.product!.vendorId)
            .toList()
            .toSet()
            .toList()
        : null;

    setBusy(true);
    try {
      unFilterDeliveryAddresses =
          deliveryAddresses = await deliveryAddressRequest.getDeliveryAddresses(
        vendorId: vendorId,
        vendorIds: vendorIds,
      );
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //
  newDeliveryAddressPressed() async {
    // await viewContext!.navigator.pushNamed(
    //   AppRoutes.newDeliveryAddressesRoute,
    // );
    fetchDeliveryAddresses();
  }

  //
  void pickFromMap() async {
    //
    dynamic result = await newPlacePicker();
    DeliveryAddress deliveryAddress = DeliveryAddress();

    if (result is PickResult) {
      PickResult locationResult = result;
      deliveryAddress.address = locationResult.formattedAddress;
      deliveryAddress.latitude = locationResult.geometry!.location.lat;
      deliveryAddress.longitude = locationResult.geometry!.location.lng;
      // From coordinates
      setBusy(true);
      final coordinates = new Coordinates(
        deliveryAddress.latitude!,
        deliveryAddress.longitude!,
      );
      //
      final addresses = await GeocoderService().findAddressesFromCoordinates(
        coordinates,
      );
      deliveryAddress.city = addresses.first.locality;
      setBusy(false);
      //
      this.onSelectDeliveryAddress(deliveryAddress);
    } else if (result is Address) {
      Address locationResult = result;
      deliveryAddress.address = locationResult.addressLine;
      deliveryAddress.latitude = locationResult.coordinates!.latitude;
      deliveryAddress.longitude = locationResult.coordinates!.longitude;
      deliveryAddress.city = locationResult.locality;
      deliveryAddress.state = locationResult.adminArea;
      deliveryAddress.country = locationResult.countryName;
      //
      this.onSelectDeliveryAddress(deliveryAddress);
    }
  }

  filterResult(String keyword) {
    deliveryAddresses = unFilterDeliveryAddresses
        .where((e) =>
            e.name!.toLowerCase().contains(keyword) ||
            e.address!.toLowerCase().contains(keyword))
        .toList();
    notifyListeners();
  }
}
