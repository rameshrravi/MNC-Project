import 'package:flutter/material.dart' hide Banner;
import 'package:midnightcity/models/banner.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/requests/banner.request.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/models/search.dart';
import 'package:velocity_x/velocity_x.dart';

class BannersViewModel extends MyBaseViewModel {
  BannersViewModel(
    BuildContext context,
    this.vendorType, {
    this.featured,
  }) {
    this.viewContext = context;
  }
  //
  BannerRequest _bannerRequest = BannerRequest();
  bool? featured;
  VendorType? vendorType;
  //
  List<Banner> banners = [];
  int currentIndex = 0;

  //
  initialise() async {
    setBusy(true);
    try {
      banners = await _bannerRequest.banners(
        vendorTypeId: vendorType?.id,
        params: {
          "featured": featured! ? "1" : "0",
        },
      );
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //
  bannerSelected(Banner banner) {
    if (banner.link != null && banner.link!.isNotEmpty) {
      //
      openWebpageLink(banner.link!);
    } else if (banner.vendor != null) {
      // viewContext!.navigator.pushNamed(
      //   AppRoutes.vendorDetails,
      //   arguments: banner.vendor,
      // );
    } else {
      // viewContext!.navigator.pushNamed(
      //   AppRoutes.search,
      //   arguments: Search(category: banner.category),
      // );
    }
  }
}
