import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:midnightcity/constants/api.dart';
import 'package:midnightcity/models/api_response.dart';
import 'package:midnightcity/services/http.service.dart';

class AuthRequest extends HttpService {
  //
  Future<ApiResponse> loginRequest({
    @required String? email,
    @required String? password,
  }) async {
    final apiResult = await post(
      Api.login,
      {
        "email": email,
        "password": password,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> qrLoginRequest({
    @required String? code,
  }) async {
    final apiResult = await post(
      Api.qrlogin,
      {
        "code": code,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> resetPasswordRequest({
    @required String? phone,
    @required String? password,
    @required String? firebaseToken,
  }) async {
    final apiResult = await post(
      Api.forgotPassword,
      {
        "phone": phone,
        "password": password,
        "firebase_id_token": firebaseToken,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> registerRequest({
    @required String? name,
    @required String? email,
    @required String? phone,
    @required String? countryCode,
    @required String? password,
    String? code = "",
  }) async {
    //  print("requesting....");
    final apiResult = await post(
      Api.register,
      {
        "name": name,
        "email": email,
        "phone": phone,
        "country_code": countryCode,
        "password": password,
        "code": code,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> logoutRequest() async {
    final apiResult = await get(Api.logout);
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> updateProfile({
    File? photo,
    String? name,
    String? email,
    String? phone,
    String? countryCode,
  }) async {
    final apiResult = await postWithFiles(
      Api.updateProfile,
      {
        "_method": "PUT",
        "name": name,
        "email": email,
        "phone": phone,
        "country_code": countryCode,
        "photo": photo != null
            ? await MultipartFile.fromFile(
                photo.path,
              )
            : null,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> updatePassword({
    String? password,
    String? new_password,
    String? new_password_confirmation,
  }) async {
    final apiResult = await post(
      Api.updatePassword,
      {
        "_method": "PUT",
        "password": password,
        "new_password": new_password,
        "new_password_confirmation": new_password_confirmation,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> verifyPhoneAccount(String? phone) async {
    final apiResult = await get(
      Api.verifyPhoneAccount,
      queryParameters: {
        "phone": phone,
      },
    );
    //  print(apiResult.data);
    //  print(apiResult.statusCode);
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> sendOTP(String? phoneNumber,
      {bool isLogin = false}) async {
    final apiResult = await post(
      Api.sendOtp,
      {
        "phone": phoneNumber,
        "is_login": isLogin,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    // print("login response   " + apiResponse.data.toString());
    if (apiResponse.allGood) {
      return apiResponse;
    } else {
      throw apiResponse.message!;
    }
  }

  Future<ApiResponse> sendOTPNew(String? phoneNumber, String? email,
      {bool isLogin = false}) async {
    final apiResult = await post(
      Api.sendOtp,
      {"phone": phoneNumber, "is_login": isLogin, "email": email},
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    //  print("login response   " + apiResponse.data.toString());
    if (apiResponse.allGood) {
      return apiResponse;
    } else {
      throw apiResponse.message!;
    }
  }

  Future<ApiResponse> verifyOTP(String? phoneNumber, String? code,
      {bool isLogin = false}) async {
    final apiResult = await post(
      Api.verifyOtp,
      {
        "phone": phoneNumber,
        "code": code,
        "is_login": isLogin,
      },
    );
/*
    print("A=> " + ApiResponse.fromResponse(apiResult).message.toString());
    print("B=> " + ApiResponse.fromResponse(apiResult).body.toString());
    print("C=> " + ApiResponse.fromResponse(apiResult).code.toString());
    print("D=> " + ApiResponse.fromResponse(apiResult).errors.toString());
    print("E=> " + ApiResponse.fromResponse(apiResult).data.toString());
*/
    final apiResponse = ApiResponse.fromResponse(apiResult);

    if (apiResponse.allGood) {
      return apiResponse;
    } else {
      throw apiResponse.message!;
    }
  }

//
  Future<ApiResponse> verifyFirebaseToken(
    String? phoneNumber,
    String? firebaseVerificationId,
  ) async {
    //
    final apiResult = await post(
      Api.verifyFirebaseOtp,
      {
        "phone": phoneNumber,
        "firebase_id_token": firebaseVerificationId,
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse;
    } else {
      throw apiResponse.message!;
    }
  }

  //
  Future<ApiResponse?> socialLogin(
    String? email,
    String? firebaseVerificationId,
    String? provider, {
    String? nonce,
    String? uid,
  }) async {
    //
    final apiResult = await post(
      Api.socialLogin,
      {
        "provider": provider,
        "email": email,
        "firebase_id_token": firebaseVerificationId,
        "nonce": nonce,
        "uid": uid,
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse;
    } else if (apiResponse.code == 401) {
      return null;
    } else {
      throw apiResponse.message!;
    }
  }

  Future<ApiResponse>? deleteProfile({String? password, String? res}) async {
    final apiResult = await post(
      Api.accountDelete,
      {
        "_method": "DELETE",
        "password": password,
        "reason": res,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }
}
