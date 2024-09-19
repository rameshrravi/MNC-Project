import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/category.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem(
      {this.category, this.onPressed, this.maxLine = true, Key? key})
      : super(key: key);

  final Function(Category)? onPressed;
  final Category? category;
  final bool? maxLine;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //max line applied
        CustomVisibilty(
          visible: maxLine,
          child: VStack(
            [
              //
              CustomImage(
                imageUrl: category!.imageUrl,
                boxFit: BoxFit.fill,
                width: 130, // AppStrings.categoryImageWidth,
                height: 96, // AppStrings.categoryImageHeight,
              )
                  .box
                  .roundedSM
                  .clip(Clip.antiAlias)
                  .color(AppColor.midnightCityYellow)
                  .make(),

              category!.name!.text
                  .minFontSize(AppStrings.categoryTextSize)
                  .size(AppStrings.categoryTextSize)
                  .center
                  .maxLines(1)
                  .overflow(TextOverflow.ellipsis)
                  .black
                  .make()
                  .p2()
                  .expand(),
            ],
            crossAlignment: CrossAxisAlignment.start,
            alignment: MainAxisAlignment.start,
          )
              .w((AppStrings.categoryImageWidth * 1.8) +
                  AppStrings.categoryTextSize)
              .h((AppStrings.categoryImageHeight * 1.8) +
                  AppStrings.categoryImageHeight)
              .onInkTap(
                () => this.onPressed!(this.category!),
              )
              .px4(),
        ),

        //no max line applied
        CustomVisibilty(
          visible: !maxLine!,
          child: VStack(
            [
              //
              CustomImage(
                imageUrl: category!.imageUrl,
                boxFit: BoxFit.fill,
                width: AppStrings.categoryImageWidth,
                height: AppStrings.categoryImageHeight,
              )
                  .box
                  .roundedSM
                  .clip(Clip.antiAlias)
                  .color(Vx.hexToColor(category!.color!))
                  .make()
                  .py2(),

              //

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColor.midnightCityLightBlue),

                // height: 20,
                width: AppStrings.categoryImageWidth,

                child: category!.name!.text
                    .size(AppStrings.categoryTextSize)
                    .wrapWords(true)
                    .center
                    .white
                    .make()
                    .p2(),
              )
            ],
            crossAlignment: CrossAxisAlignment.center,
            alignment: MainAxisAlignment.start,
          )
              .onInkTap(
                () => this.onPressed!(this.category!),
              )
              .px4(),
        )

        //
      ],
    );
  }
}
