// import 'package:flutter/material.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:midnightcity/view_models/product_details.vm.dart';
// import 'package:midnightcity/views/pages/product/widgets/add_to_cart.btn.dart';
// import 'package:midnightcity/views/pages/product/widgets/buy_now.btn.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class CommerceProductDetailsCartBottomSheet extends StatelessWidget {
//   const CommerceProductDetailsCartBottomSheet({this.model, Key? key})
//       : super(key: key);
//
//   late ProductDetailsViewModel model;
//   @override
//   Widget build(BuildContext context) {
//     return VStack(
//       [
//         //
//         Visibility(
//           visible: model.product.hasStock,
//           child: HStack(
//             [
//               //add t cart
//               AddToCartButton(model).expand(),
//               UiSpacer.smHorizontalSpace(),
//               //buy now
//               BuyNowButton(model).expand(),
//             ],
//           ).p12(),
//         ),
//
//         Visibility(
//           visible: !model.product.hasStock,
//           child: "No stock"
//               .tr()
//               .text
//               .white
//               .makeCentered()
//               .p8()
//               .box
//               .red500
//               .roundedSM
//               .make()
//               .p8()
//               .wFull(context),
//         ),
//       ],
//     ).box.color(context.backgroundColor).shadowXl.make().wFull(context);
//   }
// }
