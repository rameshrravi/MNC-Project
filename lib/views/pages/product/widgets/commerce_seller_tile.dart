// import 'package:flutter/material.dart';
// import 'package:midnightcity/constants/app_colors.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:midnightcity/view_models/product_details.vm.dart';
// import 'package:midnightcity/views/pages/vendor_details/vendor_details.page.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class CommerceSellerTile extends StatelessWidget {
//   const CommerceSellerTile({this.model, Key? key}) : super(key: key);
//   final ProductDetailsViewModel model;
//   @override
//   Widget build(BuildContext context) {
//     return HStack(
//       [
//         "Seller:".text.make().expand(flex: 2),
//         UiSpacer.smHorizontalSpace(),
//         "${model.product?.vendor?.name}"
//             .text
//             .underline
//             .color(AppColor.primaryColor)
//             .make()
//             .onInkTap(() {
//           context.nextPage(
//             VendorDetailsPage(
//               vendor: model.product.vendor,
//             ),
//           );
//         }).expand(flex: 4),
//       ],
//     ).py12().px20();
//   }
// }
