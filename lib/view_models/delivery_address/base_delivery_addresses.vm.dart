import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/delivery_address.dart';
import 'package:midnightcity/requests/delivery_address.request.dart';
import 'package:midnightcity/services/geocoder.service.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:midnightcity/views/pages/delivery_address/widgets/address_search.view.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:what3words/what3words.dart' hide Coordinates;
import 'package:velocity_x/velocity_x.dart';
import 'package:supercharged/supercharged.dart';

class BaseDeliveryAddressesViewModel extends MyBaseViewModel {
  //
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController placeSearchTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController what3wordsTEC = TextEditingController();
  bool isDefault = false;
  DeliveryAddress? deliveryAddress;
  What3WordsV3 what3WordsV3Api = What3WordsV3(AppStrings.what3wordsApiKey);

  //
  openLocationPicker() async {
    //
    showModalBottomSheet(
      context: viewContext!,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return AddressSearchView(
          this,
          addressSelected: (dynamic prediction) async {
            if (prediction is Prediction) {
              addressTEC.text = prediction.description!;
              deliveryAddress!.address = prediction.description!;
              deliveryAddress!.latitude = prediction.lat!.toDouble();
              deliveryAddress!.longitude = prediction.lng?.toDouble();
              //
              setBusy(true);
              await getLocationCityName(deliveryAddress!);
              setBusy(false);
            } else if (prediction is Address) {
              print("Regular Address ==> ${prediction.addressLine}");
              addressTEC.text = prediction.addressLine!;
              deliveryAddress!.address = prediction!.addressLine!;
              deliveryAddress!.latitude = prediction.coordinates!.latitude;
              deliveryAddress!.longitude = prediction.coordinates!.longitude;
              deliveryAddress!.city = prediction.locality!;
              deliveryAddress!.state = prediction.adminArea!;
              deliveryAddress!.country = prediction.countryName!;
            }
          },
          selectOnMap: showAddressLocationPicker,
        );
      },
    );
  }

  //
  showAddressLocationPicker() {}

  //
  validateWhat3words(String value) async {
    //
    var coordinates =
        await what3WordsV3Api.convertToCoordinates(value).execute();

    //
    if (coordinates.isSuccessful()) {
      // print('Coordinates ${coordinates.toJson()}');
      addressTEC.text = coordinates.data()!.toJson()["nearestPlace"];
      deliveryAddress!.address = coordinates.data()!.toJson()["nearestPlace"];
      deliveryAddress!.latitude =
          coordinates.data()!.toJson()["coordinates"]["lat"];
      deliveryAddress!.longitude =
          coordinates.data()!.toJson()["coordinates"]["lng"];
      // From coordinates
      setBusy(true);
      final locationCoordinates = new Coordinates(
        deliveryAddress!.latitude!,
        deliveryAddress!.longitude!,
      );
      //
      final addresses = await GeocoderService().findAddressesFromCoordinates(
        locationCoordinates,
      );
      deliveryAddress!.city = addresses.first.locality!;
      setBusy(false);
    } else {
      //
      var error = coordinates.error();
      viewContext!.showToast(msg: error!.message!, bgColor: Colors.red);
      if (error == What3WordsError.BAD_WORDS) {
        // The three word address provided is invalid
        print('BadWords: ${error.message!}');
      } else if (error == What3WordsError.INTERNAL_SERVER_ERROR) {
        // Server Error
        print('InternalServerError: ${error.message}');
      } else if (error == What3WordsError.NETWORK_ERROR) {
        // Network Error
        print('NetworkError: ${error.message}');
      } else {
        print('${error.code} : ${error.message}');
      }
    }
  }

  void shareWhat3words() {
    launchUrlString("https://what3words.com/");
  }
}
