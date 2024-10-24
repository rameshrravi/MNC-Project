import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorTypeListItem extends StatelessWidget {
  const VendorTypeListItem(this.vendorType, {this.onPressed, Key? key})
      : super(key: key);

  final VendorType? vendorType;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: vendorType!.id!,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: InkWell(
            onTap: onPressed,
            child: VStack(
              [
                //image + details
                Visibility(
                  visible: !AppStrings.showVendorTypeImageOnly,
                  child: HStack(
                    [
                      //
                      CustomImage(
                        imageUrl: vendorType!.logo,
                        width: Vx.dp40,
                        height: Vx.dp40,
                      ).p12(),
                      //

                      VStack(
                        [
                          vendorType!.name!.text.xl.white.semiBold.make(),
                          vendorType!.description!.text.white.sm.make(),
                        ],
                      ).expand(),
                    ],
                  ).p12(),
                ),

                //image only
                Visibility(
                  visible: AppStrings.showVendorTypeImageOnly,
                  child: CustomImage(
                    imageUrl: vendorType!.logo,
                    width: context.percentWidth * 100,
                    height: 140,
                    boxFit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          )
              .box
              .clip(Clip.antiAlias)
              .withRounded(value: 15)
              .outerShadow
              .color(Vx.hexToColor(vendorType!.color!))
              .make()
              .pOnly(bottom: Vx.dp20),
        ),
      ),
    );
  }
}
