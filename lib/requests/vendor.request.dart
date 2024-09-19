import 'package:flutter/material.dart';
import 'package:midnightcity/constants/api.dart';
import 'package:midnightcity/models/api_response.dart';
import 'package:midnightcity/models/delivery_address.dart';
import 'package:midnightcity/models/review.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/services/http.service.dart';
import 'package:midnightcity/services/location.service.dart';

class VendorRequest extends HttpService {
  //
  Future<List<Vendor>> vendorsRequest({
    int page = 1,
    bool byLocation = false,
    Map? params,
  }) async {
    Map<String, dynamic> queryParameters = {
      ...(params != null ? params : {}),
      "page": "$page",
      "latitude": byLocation
          ? LocationService?.currenctAddress?.coordinates?.latitude
          : null,
      "longitude": byLocation
          ? LocationService?.currenctAddress?.coordinates?.longitude
          : null,
    };

    //
    final apiResult = await get(
      Api.vendors,
      queryParameters: queryParameters,
    );

    print("queryParameters ==> $queryParameters");

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
    }

    throw apiResponse.message!;
  }

  //
  Future<List<Vendor>> topVendorsRequest({
    int page = 1,
    bool byLocation = false,
    Map? params,
  }) async {
    final apiResult = await get(
      Api.topVendors,
      queryParameters: {
        ...(params != null ? params : {}),
        "page": "$page",
        "latitude": byLocation
            ? LocationService?.currenctAddress?.coordinates?.latitude
            : null,
        "longitude": byLocation
            ? LocationService?.currenctAddress?.coordinates?.longitude
            : null,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
    }

    throw apiResponse.message!;
  }

  Future<List<Vendor>> nearbyVendorsRequest({
    int page = 1,
    bool byLocation = false,
    Map? params,
  }) async {
    final apiResult = await get(
      Api.vendors,
      queryParameters: {
        ...(params != null ? params : {}),
        "page": "$page",
        "latitude": byLocation
            ? LocationService?.currenctAddress?.coordinates?.latitude
            : null,
        "longitude": byLocation
            ? LocationService?.currenctAddress?.coordinates?.longitude
            : null,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();
    }

    throw apiResponse.message!;
  }

  Future<Vendor> vendorDetails(int id, {Map<String, String>? params}) async {
    //
    print("w8-1111");
    print(id.toString());
    print(params);
    final apiResult = await get(
      "${Api.vendors}/$id",
      queryParameters: params!,
    );
    print("w8-2");
    final apiResponse = ApiResponse.fromResponse(apiResult);
    print(apiResponse.data.toString());

    if (apiResponse.allGood) {
      print("w8-433");
      print(apiResponse.body.toString());
      return Vendor.fromJson(apiResponse.body);
    }
    print("w8-4");
    throw apiResponse.message!;
  }

  Future<List<Vendor>> fetchParcelVendors({
    int? packageTypeId,
    @required int? vendorTypeId,
    DeliveryAddress? deliveryAddress,
  }) async {
    final apiResult = await get(
      Api.vendors,
      queryParameters: {
        "vendor_type_id": vendorTypeId,
        "package_type_id": "$packageTypeId"
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Vendor> vendors = apiResponse.data
          .map((jsonObject) => Vendor.fromJson(jsonObject))
          .toList();

      //
      // if (AppStrings.enableParcelVendorByLocation && deliveryAddress != null) {
      //   vendors = vendors.where((element) {
      //     return element.canServiceLocation(deliveryAddress);
      //   }).toList();
      // }

      return vendors;
    }

    throw apiResponse.message!;
  }

  //
  Future<ApiResponse> rateVendor({
    int? rating,
    String? review,
    int? orderId,
    int? vendorId,
  }) async {
    //
    final apiResult = await post(
      Api.rating,
      {
        "order_id": orderId,
        "vendor_id": vendorId,
        "rating": rating,
        "review": review,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> rateDriver({
    int? rating,
    String? review,
    int? orderId,
    int? driverId,
  }) async {
    //
    final apiResult = await post(
      Api.rating,
      {
        "order_id": orderId,
        "driver_id": driverId,
        "rating": rating,
        "review": review,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<List<Review>> getReviews({int? page, int? vendorId}) async {
    final apiResult = await get(
      Api.vendorReviews,
      queryParameters: {
        "vendor_id": vendorId,
        "page": "$page",
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<Review> reviews = apiResponse.data.map(
        (jsonObject) {
          return Review.fromJson(jsonObject);
        },
      ).toList();

      return reviews;
    }

    throw apiResponse.message!;
  }
}
