import 'package:midnightcity/constants/api.dart';
import 'package:midnightcity/models/api_response.dart';
import 'package:midnightcity/models/coupon.dart';
import 'package:midnightcity/services/http.service.dart';

class CartRequest extends HttpService {
  //
  Future<Coupon> fetchCoupon(String code) async {
    final apiResult = await get("${Api.coupons}/$code");
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Coupon.fromJson(apiResponse.body);
    } else {
      throw apiResponse.message!;
    }
  }
}
