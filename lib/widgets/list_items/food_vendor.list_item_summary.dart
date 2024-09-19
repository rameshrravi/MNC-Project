import 'package:flutter/material.dart';

import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/buttons/call.button.dart';
import 'package:midnightcity/widgets/buttons/route.button.dart';
import 'package:midnightcity/widgets/currency_hstack.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:midnightcity/widgets/tags/delivery.tag.dart';
import 'package:midnightcity/widgets/tags/time.tag.dart';
import 'package:midnightcity/widgets/tags/pickup.tag.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class FoodVendorListItemSummary extends StatelessWidget {
  const FoodVendorListItemSummary({
    this.vendor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final Vendor? vendor;
  final Function(Vendor)? onPressed;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //
                    Hero(
                      tag: vendor!.heroTag!,
                      child: CustomImage(
                        imageUrl: vendor!.logo,
                        height: 75,
                        width: 75,
                      ),
                    ),
                    vendor!.name!.text.xl
                        .maxLines(1)
                        .overflow(TextOverflow.ellipsis)
                        .bold
                        .make()
                        .px8()
                        .pOnly(top: Vx.dp8),
                    //location routing

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        (!vendor!.latitude.isEmptyOrNull &&
                                !vendor!.longitude.isEmptyOrNull)
                            ? RouteButton(
                                vendor!,
                                size: 12,
                              )
                            : UiSpacer.emptySpace(),
                        CallButton(vendor!, size: 12)
                      ],
                    )

                    //
                    /*  Positioned(
                      child: VStack(
                        [
                          TimeTag(vendor.prepareTime,
                              iconData: FlutterIcons.clock_outline_mco),
                          UiSpacer.verticalSpace(space: 5),
                          TimeTag(
                            vendor.deliveryTime,
                            iconData: FlutterIcons.ios_bicycle_ion,
                          ),
                        ],
                      ),
                      left: 10,
                      bottom: 5,
                    ), */

                    //closed
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !vendor!.isOpen!,
              child: VxBox(
                child: "Closed".tr().text.lg.white.bold.makeCentered(),
              )
                  .height(80)
                  .color(
                    AppColor.closeColor!.withOpacity(0.6),
                  )
                  .make(),
            ),
          ],
        ),

        //name

        //
        //description
        /* "${vendor.description}"
            .text
            .gray400
            .minFontSize(9)
            .size(9)
            .maxLines(1)
            .overflow(TextOverflow.ellipsis)
            .make()
            .px8(), */
        //words
        /*  Wrap(
          spacing: Vx.dp12,
          children: [
            //rating
            HStack(
              [
                "${vendor.rating.numCurrency} "
                    .text
                    .minFontSize(6)
                    .size(10)
                    .color(AppColor.ratingColor)
                    .medium
                    .make(),
                Icon(
                  FlutterIcons.star_ent,
                  color: AppColor.ratingColor,
                  size: 10,
                ),
              ],
            ),

            //
            //
            Visibility(
              visible: vendor.distance != null,
              child: HStack(
                [
                  Icon(
                    FlutterIcons.direction_ent,
                    color: AppColor.primaryColor,
                    size: 10,
                  ),
                  " ${vendor?.distance?.numCurrency}km"
                      .text
                      .minFontSize(6)
                      .size(10)
                      .make(),
                ],
              ),
            ),
          ],
        ).px8(),*/

//delivery fee && time
        /*     Wrap(
          spacing: Vx.dp12,
          children: [
            //
            Visibility(
              visible: vendor.minOrder != null,
              child: CurrencyHStack(
                [
                  "${AppStrings.currencySymbol}"
                      .text
                      .minFontSize(6)
                      .size(10)
                      .gray600
                      .medium
                      .maxLines(1)
                      .make(),
                  //
                  Visibility(
                    visible: vendor.minOrder != null,
                    child: "${vendor.minOrder}"
                        .text
                        .minFontSize(6)
                        .size(10)
                        .gray600
                        .medium
                        .maxLines(1)
                        .make(),
                  ),
                  //
                  Visibility(
                    visible: vendor.minOrder != null && vendor.maxOrder != null,
                    child: " - "
                        .text
                        .minFontSize(6)
                        .size(10)
                        .gray600
                        .medium
                        .maxLines(1)
                        .make(),
                  ),
                  //
                  Visibility(
                    visible: vendor.maxOrder != null,
                    child: "${vendor.maxOrder} "
                        .text
                        .minFontSize(6)
                        .size(10)
                        .gray600
                        .medium
                        .maxLines(1)
                        .make(),
                  ),
                ],
              ),
            ),
          ],
        ).px8(),*/

        //
        /* HStack(
          [
            //can deliver
            vendor.delivery == 1
                ? DeliveryTag().pOnly(right: 10)
                : UiSpacer.emptySpace(),

            //can pickup
            vendor.pickup == 1
                ? PickupTag().pOnly(right: 10)
                : UiSpacer.emptySpace(),
          ],
          crossAlignment: CrossAxisAlignment.end,
        ).p8() */
      ],
    )
        .onInkTap(
          () => this.onPressed!(this.vendor!),
        )
        .w(175)
        .box
        .rounded
        .color(context.backgroundColor)
        .clip(Clip.antiAlias)
        .withRounded(value: 15)
        .make()
        .pOnly(bottom: Vx.dp8);
  }
}
