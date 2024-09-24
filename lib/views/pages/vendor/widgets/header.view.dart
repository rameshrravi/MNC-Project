import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/services/alert.service.dart';
import 'package:midnightcity/services/toast.service.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../widgets/cart_page_action.dart';

class VendorHeader extends StatefulWidget {
  const VendorHeader({
    Key? key,
    required this.model,
    this.showSearch = true,
    this.vendorBusyState = 0,
  }) : super(key: key);

  final MyBaseViewModel model;
  final bool showSearch;
  final int vendorBusyState;

  @override
  _VendorHeaderState createState() => _VendorHeaderState();
}

class _VendorHeaderState extends State<VendorHeader> {
  @override
  void initState() {
    print("is busy : " + widget.vendorBusyState.toString());
    super.initState();

    //
    if (widget.model.deliveryaddress!.address == "Current Location") {
      widget.model.fetchCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        HStack(
          [
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: GestureDetector(
                onTap: () {
                  widget.model.openProfile();
                },
                child: Icon(
                  Icons.account_circle_outlined,
                  color: AppColor.midnightCityDarkBlue,
                  size: 32.0,
                ),
              ),
            ),

            //location icon
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.location_on,
                size: 24,
                color: AppColor.midnightCityDarkBlue,
              ).onInkTap(
                widget.model.useUserLocation,
              ),
            ),

            //
            VStack(
              [
                //
                /*  HStack(
                  [
                    //
                    "Delivery Location".tr().text.sm.semiBold.make(),
                    //
                    Icon(
                      FlutterIcons.chevron_down_fea,
                    ).px4(),
                  ],
                ),*/
                Container(
                  padding: EdgeInsets.only(right: 5),
                  // width: 200,
                  child: widget.model.deliveryaddress!.address!.text
                      .maxLines(1)
                      .color(AppColor.midnightCityDarkBlue)
                      .fontWeight(FontWeight.w600)
                      .fontFamily("Poppins")
                      .size(16)
                      .ellipsis
                      .base
                      .make(),
                ),
              ],
            )
                .onInkTap(
                  widget.model.pickDeliveryAddress,
                )
                .expand(),

            widget.vendorBusyState == 1
                ? Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        AlertService.info(
                            title: "Sorry",
                            text:
                                "We are quite busy now. \nKindly give us little extra time \nto prepare your order",
                            confirmBtnText: "OK");
                      },
                      child: Image.asset(
                        "assets/images/busy.png",
                        width: 40,
                        height: 40,
                      ),
                    ))
                : SizedBox(),

            PageCartAction(color: AppColor.midnightCityYellow)
          ],
          alignment: MainAxisAlignment.center,
          crossAlignment: CrossAxisAlignment.center,
        ).expand(),

        //
        CustomVisibilty(
          visible: widget.showSearch,
          child: Icon(
            FlutterIcons.search_fea,
            size: 20,
          )
              .p8()
              .onInkTap(() {
                widget.model.openSearch();
              })
              .box
              .roundedSM
              .clip(Clip.antiAlias)
              .color(Colors.red)
              .outerShadowSm
              .make(),
        ),
      ],
      alignment: MainAxisAlignment.center,
    )
        .p12()
        .box
        .color(AppColor.mainBackground)
        .outerShadowSm
        .make()
        .pOnly(bottom: Vx.dp20);
  }
}
