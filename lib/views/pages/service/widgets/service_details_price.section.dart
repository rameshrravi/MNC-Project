// /*
// import 'package:flutter/material.dart';
// import 'package:midnightcity/constants/app_colors.dart';
// import 'package:midnightcity/constants/app_strings.dart';
// import 'package:midnightcity/extensions/dynamic.dart';
// import 'package:midnightcity/extensions/string.dart';
// import 'package:midnightcity/models/service.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:midnightcity/widgets/currency_hstack.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class ServiceDetailsPriceSectionView extends StatelessWidget {
//   const ServiceDetailsPriceSectionView(this.service,
//       {this.onlyPrice = false, Key? key})
//       : super(key: key);
//
//   final Service service;
//   final bool onlyPrice;
//
//   @override
//   Widget build(BuildContext context) {
//     return HStack(
//       [
//         CurrencyHStack(
//           [
//             "${AppStrings.currencySymbol}"
//                 .text
//                 .xl
//                 .medium
//                 .color(AppColor.primaryColor)
//                 .make(),
//             service.price
//                 .currencyValueFormat()
//                 .text
//                 .semiBold
//                 .color(AppColor.primaryColor)
//                 .xl2
//                 .make(),
//           ],
//         ),
//
//         " ${service.durationText}".text.medium.xl.make(),
//         UiSpacer.horizontalSpace(space: 5),
//         //discount
//         Visibility(
//           visible: !onlyPrice,
//           child: service.showDiscount
//               ? "%s Off"
//                   .tr()
//                   .fill(["${service.discountPercentage}%"])
//                   .text
//                   .white
//                   .semiBold
//                   .make()
//                   .p2()
//                   .px4()
//                   .box
//                   .red500
//                   .roundedLg
//                   .make()
//               : UiSpacer.emptySpace(),
//         ),
//         //
//         UiSpacer.emptySpace().expand(),
//         //rating
//         Visibility(
//           visible: !onlyPrice,
//           child: VxRating(
//             value: double.parse((service?.vendor?.rating ?? 5.0).toString()),
//             count: 5,
//             isSelectable: false,
//             onRatingUpdate: null,
//             selectionColor: AppColor.ratingColor,
//             normalColor: Colors.grey,
//             size: 18,
//           ),
//         ),
//       ],
//     );
//   }
// }
// */
