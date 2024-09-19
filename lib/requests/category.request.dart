import 'package:midnightcity/constants/api.dart';
import 'package:midnightcity/models/api_response.dart';
import 'package:midnightcity/models/category.dart';
import 'package:midnightcity/services/http.service.dart';

class CategoryRequest extends HttpService {
  //
  Future<List<Category>> categories({
    int? vendorTypeId,
    int? page = 0,
    int? full = 0,
  }) async {
    final apiResult = await get(
      //
      Api.categories,
      queryParameters: {
        "vendor_type_id": vendorTypeId,
        "page": page,
        "full": full,
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);

    if (apiResponse.allGood) {
      return apiResponse.data
          .map((jsonObject) => Category.fromJson(jsonObject))
          .toList();
    } else {
      throw apiResponse.message!;
    }
  }

  Future<List<Category>>? subcategories({int? categoryId, int? page}) async {
    final apiResult = await get(
      //
      Api.categories,
      queryParameters: {
        "category_id": categoryId,
        "page": page,
        "type": "sub",
      },
    );
    print("0000");

    final apiResponse = ApiResponse.fromResponse(apiResult);

    if (apiResponse.allGood) {
      print("11111");

      apiResponse.data
          .map((jsonObject) => Category.fromJson(jsonObject))
          .toList();

      apiResponse.data.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      print('2222');
      return apiResponse.data.first;
    } else {
      throw apiResponse.message!;
    }
  }
}
