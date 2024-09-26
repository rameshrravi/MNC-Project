import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/models/driver.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class TaxiDriverInfoView extends StatelessWidget {
  const TaxiDriverInfoView(this.driver, {Key? key}) : super(key: key);

  final Driver driver;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        CustomImage(
          imageUrl: driver.photo,
          width: 50,
          height: 50,
        ).box.roundedFull.clip(Clip.antiAlias).make(),
        //driver info
        VStack(
          [
            "${driver.name}".text.medium.xl.make(),
            //rating
            VxRating(
              size: 14,
              maxRating: 5.0,
              value: driver.rating!,
              isSelectable: false,
              onRatingUpdate: (value) {},
              selectionColor: AppColor.ratingColor!,
            ),
          ],
        ).px12().expand(),
        //vehicle info
        VStack(
          [
            driver.vehicle!.reg_no!.text.xl2.semiBold.make(),
            driver.vehicle!.vehicleInfo!.text.medium.sm.make(),
          ],
          crossAlignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }
}
