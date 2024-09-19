// import 'package:flutter/material.dart';
// import 'package:midnightcity/constants/app_colors.dart';
// import 'package:midnightcity/extensions/dynamic.dart';
// import 'package:midnightcity/models/product.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:intl/intl.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class ProductReviewSumupView extends StatelessWidget {
//   const ProductReviewSumupView(this.product, {Key? key}) : super(key: key);
//   final Product product;
//
//   @override
//   Widget build(BuildContext context) {
//     return VStack(
//       [
//         //review summary
//         "Customer reviews".tr().text.extraBold.xl2.make(),
//         UiSpacer.vSpace(12),
//         HStack(
//           [
//             VxRating(
//               size: 20,
//               maxRating: 5.0,
//               value: product.rating,
//               isSelectable: false,
//               onRatingUpdate: null,
//               selectionColor: AppColor.ratingColor,
//             ),
//             UiSpacer.hSpace(10),
//             "%s out of %s"
//                 .tr()
//                 .fill(
//                     [double.parse(product.rating.toStringAsExponential(1)), 5])
//                 .text
//                 .color(AppColor.primaryColor)
//                 .make(),
//           ],
//         ),
//         UiSpacer.vSpace(8),
//         "%s total rating"
//             .tr()
//             .fill([NumberFormat('#,###').format(product.reviewsCount)])
//             .text
//             .color(AppColor.primaryColor)
//             .make(),
//       ],
//     );
//   }
// }
