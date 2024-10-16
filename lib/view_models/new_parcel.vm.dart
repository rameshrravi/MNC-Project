import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/coupon.dart';
import 'package:midnightcity/models/delivery_address.dart';
import 'package:midnightcity/models/order_stop.dart';
import 'package:midnightcity/models/package_checkout.dart';
import 'package:midnightcity/models/package_type.dart';
import 'package:midnightcity/models/payment_method.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/requests/cart.request.dart';
import 'package:midnightcity/requests/checkout.request.dart';
import 'package:midnightcity/requests/delivery_address.request.dart';
import 'package:midnightcity/requests/package.request.dart';
import 'package:midnightcity/requests/payment_method.request.dart';
import 'package:midnightcity/requests/vendor.request.dart';
import 'package:midnightcity/services/app.service.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/services/cart.service.dart';
import 'package:midnightcity/services/geocoder.service.dart';
import 'package:midnightcity/services/location.service.dart';
import 'package:midnightcity/services/parcel_vendor.service.dart';
import 'package:midnightcity/services/validator.service.dart';
import 'package:midnightcity/view_models/payment.view_model.dart';
import 'package:midnightcity/widgets/bottomsheets/parcel_location_picker_option.bottomsheet.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class NewParcelViewModel extends PaymentViewModel {
  //
  PackageRequest packageRequest = PackageRequest();
  CartRequest cartRequest = CartRequest();
  VendorRequest vendorRequest = VendorRequest();
  PaymentMethodRequest paymentOptionRequest = PaymentMethodRequest();
  CheckoutRequest checkoutRequest = CheckoutRequest();
  late Function onFinish;
  VendorType? vendorType;

  //Step 1
  List<PackageType> packageTypes = [];
  late PackageType selectedPackgeType;

  //Step 2
  List<Vendor> vendors = [];
  late Vendor? selectedVendor;
  bool requireParcelInfo = true;

  //Step 3
  late DeliveryAddress pickupLocation;
  late DeliveryAddress dropoffLocation;
  late DateTime selectedPickupDate;
  late String pickupDate;
  late TimeOfDay selectedPickupTime;
  late String pickupTime;

  final deliveryInfoFormKey = GlobalKey<FormState>();
  TextEditingController fromTEC = TextEditingController();
  TextEditingController toTEC = TextEditingController();
  List<TextEditingController> toTECs = [];
  TextEditingController dateTEC = TextEditingController();
  TextEditingController timeTEC = TextEditingController();
  bool isScheduled = false;
  List<String> availableTimeSlots = [];

  //step 4
  //receipents
  int openedRecipientFormIndex = 0;
  final recipientInfoFormKey = GlobalKey<FormState>();
  List<TextEditingController> recipientNamesTEC = [TextEditingController()];
  List<TextEditingController> recipientPhonesTEC = [TextEditingController()];
  List<TextEditingController> recipientNotesTEC = [TextEditingController()];

  //step 5
  final packageInfoFormKey = GlobalKey<FormState>();
  TextEditingController packageWeightTEC = TextEditingController();
  TextEditingController packageHeightTEC = TextEditingController();
  TextEditingController packageWidthTEC = TextEditingController();
  TextEditingController packageLengthTEC = TextEditingController();
  TextEditingController noteTEC = TextEditingController();

  //packageCheckout
  PackageCheckout packageCheckout = PackageCheckout();
  List<PaymentMethod> paymentMethods = [];
  late PaymentMethod selectedPaymentMethod;
  //
  bool canApplyCoupon = false;
  late Coupon coupon;
  TextEditingController couponTEC = TextEditingController();

  //
  late int activeStep = 0;
  PageController pageController = PageController();
  late StreamSubscription currentLocationChangeStream;

  //
  NewParcelViewModel(BuildContext context, this.onFinish, this.vendorType) {
    this.viewContext = context;
  }

  void initialise() async {
    //clear cart
    await CartServices.clearCart();
    //listen to user location change
    currentLocationChangeStream =
        LocationService.currenctAddressSubject.stream.listen(
      (location) async {
        //

        deliveryaddress!.address = location.addressLine;
        deliveryaddress!.latitude = location.coordinates!.latitude;
        deliveryaddress!.longitude = location.coordinates!.longitude;
        //get city, state & country
        deliveryaddress = await getLocationCityName(deliveryaddress);
        notifyListeners();
      },
    );
    //
    if (AppStrings.enableParcelMultipleStops) {
      packageCheckout.stopsLocation = [];
      addNewStop();
    }
    await fetchParcelTypes();
    await fetchPaymentOptions();
  }

  //
  dispose() {
    super.dispose();
    currentLocationChangeStream.cancel();
  }

  //
  fetchParcelTypes() async {
    //
    setBusyForObject(packageTypes, true);
    try {
      packageTypes = await packageRequest.fetchPackageTypes();
      clearErrors();
    } catch (error) {
      setErrorForObject(packageTypes, error);
    }
    setBusyForObject(packageTypes, false);
  }

  fetchParcelVendors() async {
    //
    vendors = [];
    selectedVendor = null;
    setBusyForObject(vendors, true);
    try {
      final mVendors = await vendorRequest.fetchParcelVendors(
        vendorTypeId: vendorType!.id,
        packageTypeId: selectedPackgeType.id,
        deliveryAddress: deliveryaddress,
      );

      //filter vendors and select the ones that can deliver to the addresses selected on previous page
      for (var vendor in mVendors) {
        final isAllowed = ParcelVendorService.canServiceAllLocations(
          packageCheckout.stopsLocation ?? [],
          vendor,
        );
        if (isAllowed) {
          vendors.add(vendor);
        }
      }

      //
      if (AppStrings.enableSingleVendor) {
        changeSelectedVendor(vendors.first);
      }
      clearErrors();
    } catch (error) {
      setErrorForObject(vendors, error);
    }
    setBusyForObject(vendors, false);
  }

  //
  fetchPaymentOptions() async {
    setBusyForObject(paymentMethods, true);
    try {
      paymentMethods = await paymentOptionRequest.getPaymentOptions();
      clearErrors();
    } catch (error) {
      print("Error getting payment methods ==> $error");
    }
    setBusyForObject(paymentMethods, false);
  }

  ///FORM MANIPULATION
  nextForm(int index) {
    activeStep = index;
    pageController.jumpToPage(index);
    notifyListeners();
  }

  //
  void changeSelectedPackageType(PackageType packgeType) async {
    selectedPackgeType = packgeType;
    packageCheckout.packageType = selectedPackgeType;
    notifyListeners();
  }

  void showNoVendorSelectedError() {
    toastError("No vendor for the selected package type.".tr());
    if (kDebugMode) {
      toastError(
        "DEBUG: Ensure you have at least one vendor under the package type. Also if you are using single mode, make sure the package types are attached to the active vendor."
            .tr(),
      );
    }
  }

  changeSelectedVendor(Vendor vendor) {
    selectedVendor = vendor;
    packageCheckout.vendor = selectedVendor;
    final vendorPackagePricing = selectedVendor!.packageTypesPricing!
        .firstWhere((e) => e.packageTypeId == selectedPackgeType.id);

    if (vendorPackagePricing != null) {
      requireParcelInfo = vendorPackagePricing.fieldRequired ?? true;
    }
    notifyListeners();
  }

  //
  changePickupAddress() async {
    //check that user is logged in to countinue else go to login page
    if (!AuthServices.authenticated()) {
      // final result =
      //     await viewContext!.navigator.pushNamed(AppRoutes.loginRoute);
      // paymentOptionRequest = PaymentMethodRequest();
      // if (result == null || !result) {
      //   return;
      // }
    }

    final result = await showDeliveryAddressPicker();
    if (result != null) {
      pickupLocation = result;
      fromTEC.text = pickupLocation.address!;
      //
      packageCheckout.pickupLocation = pickupLocation;
      notifyListeners();
    }
  }

  //
  changeDropOffAddress() async {
    //check that user is logged in to countinue else go to login page
    if (!AuthServices.authenticated()) {
      // final result =
      //     await viewContext!.navigator.pushNamed(AppRoutes.loginRoute);
      // paymentOptionRequest = PaymentMethodRequest();
      // if (result == null || !result) {
      //   return;
      // }
    }

    final result = await showDeliveryAddressPicker();
    if (result != null) {
      dropoffLocation = result;
      toTEC.text = dropoffLocation.address!;
      //
      packageCheckout.dropoffLocation = dropoffLocation;
      notifyListeners();
    }
  }

  //
  changeStopDeliveryAddress(int index) async {
    //check that user is logged in to countinue else go to login page
    if (!AuthServices.authenticated()) {
      // final result =
      //     await viewContext!.navigator.pushNamed(AppRoutes.loginRoute);
      paymentOptionRequest = PaymentMethodRequest();
      // if (result == null || !result) {
      //   return;
      // }
    }

    final result = await showDeliveryAddressPicker();
    if (result != null) {
      dropoffLocation = result;
      toTECs[index].text = dropoffLocation.address!;
      //
      packageCheckout.stopsLocation![index] = new OrderStop();
      packageCheckout.stopsLocation![index].deliveryAddress = dropoffLocation;
      notifyListeners();
    }
  }

  manualChangeStopDeliveryAddress(
    int index,
    DeliveryAddress deliveryAddress,
  ) async {
    //check that user is logged in to countinue else go to login page
    if (!AuthServices.authenticated()) {
      // final result =
      //     await viewContext!.navigator.pushNamed(AppRoutes.loginRoute);
      // paymentOptionRequest = PaymentMethodRequest();
      // if (result == null || !result) {
      //   return;
      // }
    }

    dropoffLocation = deliveryAddress;
    toTECs[index].text = dropoffLocation.address!;
    //
    packageCheckout.stopsLocation![index] = new OrderStop();
    packageCheckout.stopsLocation![index].deliveryAddress = dropoffLocation;
    notifyListeners();
  }

  ///
  handlePickupStop() async {
    final result = await showLocationPickerOptionBottomsheet();
    if (result is bool) {
      changePickupAddress();
    } else if (result is DeliveryAddress) {
      pickupLocation = result;
      pickupLocation.name = pickupLocation.address;
      fromTEC.text = pickupLocation.address!;
      //
      packageCheckout.pickupLocation = pickupLocation;
      notifyListeners();
    }
  }

  handleDropoffStop() async {
    final result = await showLocationPickerOptionBottomsheet();
    if (result is bool) {
      changeDropOffAddress();
    } else if (result is DeliveryAddress) {
      dropoffLocation = result;
      toTEC.text = dropoffLocation.address!;
      //
      packageCheckout.dropoffLocation = dropoffLocation;
      notifyListeners();
    }
  }

  handleOtherStop(int index) async {
    final result = await showLocationPickerOptionBottomsheet();
    if (result is bool) {
      changeStopDeliveryAddress(index);
    } else if (result is DeliveryAddress) {
      manualChangeStopDeliveryAddress(index, result);
    }
  }

  ///

  //location/delivery address picker options
  Future<dynamic> showLocationPickerOptionBottomsheet() async {
    final result = await showModalBottomSheet(
      context: viewContext!,
      builder: (ctx) {
        return ParcelLocationPickerOptionBottomSheet();
      },
    );

    //
    if (result != null && (result is int)) {
      //map address picker
      if (result == 1) {
        return await pickFromMap();
      } else {
        return true;
      }
    }
    return false;
  }

  Future<DeliveryAddress?> pickFromMap() async {
    //
    dynamic result = await newPlacePicker();

    if (result is PickResult) {
      PickResult locationResult = result;
      DeliveryAddress deliveryAddress = DeliveryAddress();
      deliveryaddress!.name = locationResult.formattedAddress;
      deliveryaddress!.address = locationResult.formattedAddress;
      deliveryaddress!.latitude = locationResult.geometry!.location.lat;
      deliveryaddress!.longitude = locationResult.geometry!.location.lng;
      // From coordinates
      setBusy(true);
      final coordinates = new Coordinates(
        deliveryaddress!.latitude!,
        deliveryaddress!.longitude!,
      );
      //
      final addresses = await GeocoderService().findAddressesFromCoordinates(
        coordinates,
      );
      deliveryaddress!.city = addresses.first.locality;
      deliveryaddress!.state = addresses.first.adminArea;
      deliveryaddress!.country = addresses.first.countryName;
      setBusy(false);
      //
      return deliveryAddress;
    } else if (result is Address) {
      Address locationResult = result;
      DeliveryAddress deliveryAddress = DeliveryAddress();
      deliveryaddress!.name = locationResult.addressLine;
      deliveryaddress!.address = locationResult.addressLine;
      deliveryaddress!.latitude = locationResult.coordinates!.latitude;
      deliveryaddress!.longitude = locationResult.coordinates!.longitude;
      deliveryaddress!.city = locationResult.locality;
      deliveryaddress!.state = locationResult.adminArea;
      deliveryaddress!.country = locationResult.countryName;
      //
      return deliveryAddress;
    }

    return null;
  }

  //

  //
  toggleScheduledOrder(bool value) {
    isScheduled = value;
    packageCheckout.isScheduled = isScheduled;
    //remove delivery address if pickup
    if (isScheduled) {
      packageCheckout.date = null;
      packageCheckout.time = null;
    } else {
      packageCheckout.date = null;
      packageCheckout.time = null;
    }

    notifyListeners();
  }

  //start of schedule related
  changeSelectedDeliveryDate(String string, int index) {
    packageCheckout.deliverySlotDate = string;
    packageCheckout.date = string;
    pickupDate = string;
    availableTimeSlots = selectedVendor!.deliverySlots![index].times!;
    notifyListeners();
  }

  changeSelectedDeliveryTime(String time) {
    packageCheckout.deliverySlotTime = time;
    packageCheckout.time = time;
    pickupTime = time;
    notifyListeners();
  }

  //
  changeDropOffDate() async {
    final result = await showDatePicker(
      context: viewContext!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(
          days: selectedVendor!.packageTypesPricing!.first!.maxBookingDays ?? 7,
        ),
      ),
      initialDate: selectedPickupDate ?? DateTime.now(),
    );

    //
    if (result != null) {
      selectedPickupDate = result;
      // pickupDate =
      //     Jiffy.unixFromMillisecondsSinceEpoch(result.millisecondsSinceEpoch)
      //         .format("yyyy-MM-dd");
      // dateTEC.text =
      //     Jiffy.unixFromMillisecondsSinceEpoch(result.millisecondsSinceEpoch)
      //         .yMMMMd;
      packageCheckout.date = pickupDate;
      notifyListeners();
    }
  }

  changeDropOffTime() async {
    final result = await showTimePicker(
      context: viewContext!,
      initialTime: selectedPickupTime ?? TimeOfDay.now(),
    );

    //
    if (result != null) {
      selectedPickupTime = result;
      pickupTime = result.format(viewContext!);
      timeTEC.text = pickupTime;

      try {
        packageCheckout.time = "${result.hour}:${result.minute}";
      } catch (error) {
        packageCheckout.time = "$pickupTime";
      }
      notifyListeners();
    }
  }

  changeSelectedPaymentMethod(PaymentMethod paymentMethod) {
    selectedPaymentMethod = paymentMethod;
    packageCheckout.paymentMethod = paymentMethod;
    notifyListeners();
  }

  //Form validationns
  validateDeliveryInfo() async {
    if (deliveryInfoFormKey.currentState!.validate()) {
      //
      //
      if (AppStrings.enableSingleVendor) {
        setBusyForObject(selectedVendor, true);
        await fetchParcelVendors();
        setBusyForObject(selectedVendor, false);
        //
        if (AppStrings.enableSingleVendor && selectedVendor == null) {
          showNoVendorSelectedError();
        } else {
          nextForm(2);
        }
      } else {
        nextForm(2);
        fetchParcelVendors();
      }
    }
  }

  // Recipient
  validateRecipientInfo() {
    //
    recipientInfoFormKey.currentState!.validate();
    bool dataRequired = false;
    //loop throug the recipents
    recipientNamesTEC.forEachIndexed((index, element) {
      if (element.text.isEmpty) {
        dataRequired = true;
        return;
      }
    });

    recipientPhonesTEC.forEachIndexed((index, element) {
      if (element.text.isEmpty ||
          FormValidator.validatePhone(element.text) != null) {
        dataRequired = true;
        return;
      }
    });

    if (dataRequired) {
      CoolAlert.show(
        context: viewContext!,
        type: CoolAlertType.warning,
        title: "Fill Contact Info".tr(),
        text:
            "Please ensure you fill in contact info for all added stops. Thank you"
                .tr(),
        onConfirmBtnTap: () {
          //hide keyboard
          FocusScope.of(viewContext!).requestFocus(FocusNode());
          //  viewContext!.pop();
        },
      );

      return;
    }

    //
    if (recipientInfoFormKey.currentState!.validate()) {
      //loop through recipients
      // recipientNamesTEC

      // packageCheckout.recipientName = recipientNameTEC.text;
      // packageCheckout.recipientPhone = recipientPhoneTEC.text;
      nextForm(!requireParcelInfo ? 5 : 4);
    }
  }

  validateDeliveryParcelInfo() {
    if (packageInfoFormKey.currentState!.validate()) {
      //
      packageCheckout.weight = packageWeightTEC.text;
      packageCheckout.width = packageWidthTEC.text;
      packageCheckout.length = packageLengthTEC.text;
      packageCheckout.height = packageHeightTEC.text;
      //hide keyboard
      FocusScope.of(viewContext!).unfocus();
      nextForm(5);
    }
  }

  //Submit form
  prepareOrderSummary() async {
    //
    nextForm(6);
    setBusyForObject(packageCheckout, true);
    try {
      List<OrderStop> allStops = [];
      if (packageCheckout.pickupLocation != null) {
        allStops
            .add(OrderStop(deliveryAddress: packageCheckout.pickupLocation));
      }

      if (packageCheckout.stopsLocation != null &&
          packageCheckout.stopsLocation!.isNotEmpty) {
        allStops.addAll(packageCheckout!.stopsLocation!);
      }
      if (packageCheckout.dropoffLocation != null) {
        allStops
            .add(OrderStop(deliveryAddress: packageCheckout.dropoffLocation));
      }

      //loop through deleivery addresses and create the onces that were selected from map directly
      for (var i = 0; i < allStops.length; i++) {
        final stop = allStops[i];
        //
        if (stop!.deliveryAddress!.id == null) {
          DeliveryAddressRequest dARequest = DeliveryAddressRequest();
          final apiResposne =
              await dARequest.saveDeliveryAddress(stop.deliveryAddress!);
          //
          if (apiResposne.allGood) {
            // allStops[i].deliveryAddress = deliveryaddress!.fromJson(
            //   (apiResposne.body as Map)["data"],
            // );
          } else {
            toastError("${apiResposne.message}");
          }
        }
      }

      //
      recipientNamesTEC.forEachIndexed((index, element) {
        allStops[index].stopId = allStops[index].deliveryAddress!.id;
        allStops[index].name = element.text;
        allStops[index].phone = recipientPhonesTEC[index].text;
        allStops[index].note = recipientNotesTEC[index].text;
      });

      //
      packageCheckout.allStops = allStops;

      //
      final mPackageCheckout = await packageRequest.parcelSummary(
        vendorId: selectedVendor!.id,
        packageTypeId: selectedPackgeType.id,
        stops: allStops,
        packageWeight: packageWeightTEC.text,
      );

      //
      packageCheckout.copyWith(packageCheckout: mPackageCheckout);

      clearErrors();
    } catch (error) {
      print("Package error ==> $error");
      setErrorForObject(packageCheckout, error);
    }
    setBusyForObject(packageCheckout, false);
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
      if (coupon.useLeft! <= 0) {
        throw "Coupon use limit exceeded".tr();
      } else if (coupon.expired!) {
        throw "Coupon has expired".tr();
      }
      clearErrors();
      //re-calculate the cart price with coupon
      calculateSubTotal();
    } catch (error) {
      print("error ==> $error");
      setErrorForObject(coupon, error);
      calculateSubTotal();
    }
    setBusyForObject(coupon, false);
  }

  //
  calculateSubTotal() {
    //
    double discountPrice = 0;
    if (coupon != null) {
      final foundVendor = coupon.vendors!
          .firstWhere((vendor) => selectedVendor!.id! == vendor.id);
      if (foundVendor != null ||
          (coupon.products!.isEmpty && coupon.vendors!.isEmpty)) {
        //
        if (coupon.percentage == 1) {
          discountPrice = (coupon.discount! / 100) * packageCheckout.subTotal!;
        } else {
          discountPrice = coupon.discount!;
        }
      }
    }

    //check if coupon is allow with the discount price
    if (coupon != null) {
      try {
        discountPrice = coupon.validateDiscount(
          packageCheckout.subTotal!,
          discountPrice,
        );
      } catch (error) {
        discountPrice = 0;
        setErrorForObject(coupon, error);
      }
    }
    //
    packageCheckout.discount = discountPrice;
    notifyListeners();
  }

  //Submit form
  initiateOrderPayment() async {
    //show loading dialog
    CoolAlert.show(
      context: viewContext!,
      type: CoolAlertType.loading,
      barrierDismissible: false,
      title: "Checkout".tr(),
      text: "Processing order. Please wait...".tr(),
    );

    try {
      //coupon
      packageCheckout.coupon = coupon;
      //
      final apiResponse = await checkoutRequest.newPackageOrder(
        packageCheckout,
        note: noteTEC.text,
      );

      //close loading dialog
      //viewContext!.pop();

      //not error
      if (apiResponse.allGood) {
        //cash payment

        final paymentLink = apiResponse.body["link"].toString();
        if (!paymentLink.isEmpty) {
          showOrdersTab();
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
                //   viewContext!.pop();
                showOrdersTab();
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
    } catch (error) {
      print("Error ==> $error");
    }
  }

  //
  showOrdersTab() {
    //
    // viewContext!.pop();
    //switch tab to orders
    AppService().changeHomePageIndex(index: 1);
  }

  addNewStop() {
    if (AppStrings.maxParcelStops > (toTECs.length - 1)) {
      final toTEC = TextEditingController();
      toTECs.add(toTEC);
      //
      recipientNamesTEC.add(TextEditingController());
      recipientPhonesTEC.add(TextEditingController());
      recipientNotesTEC.add(TextEditingController());
      //
      // packageCheckout.stopsLocation!.add(null);
      notifyListeners();
    }
  }

  removeStop(int index) {
    toTECs.removeAt(index);
    recipientNamesTEC.removeAt(index);
    recipientPhonesTEC.removeAt(index);
    recipientNotesTEC.removeAt(index);
    packageCheckout.stopsLocation!.removeAt(index);
    notifyListeners();
  }
}
