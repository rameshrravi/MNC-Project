// import 'package:flutter/material.dart';
// import 'package:midnightcity/models/vendor_type.dart';
// import 'package:midnightcity/view_models/vendor/categories.vm.dart';
// import 'package:midnightcity/views/pages/grocery/widgets/grocery_picks.view.dart';
// import 'package:stacked/stacked.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import 'food_picks.view.dart';
//
// class BarOnlyCategoryProducts extends StatelessWidget {
//   const BarOnlyCategoryProducts(
//     this.vendorType, {
//     this.length = 2,
//     Key? key,
//   }) : super(key: key);
//
//   final VendorType vendorType;
//   final int length;
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<CategoriesViewModel>.reactive(
//       viewModelBuilder: () =>
//           CategoriesViewModel(context, vendorType: vendorType),
//       onModelReady: (model) => model.initialise(),
//       builder: (context, model, child) {
//         return VStack(
//           [
//             //
//             ...(model.categories!
//                 .sublist(
//                     0,
//                     model.categories!.length < length
//                         ? model.categories!.length
//                         : length)
//                 .map(
//               (category) {
//                 //
//
//                 return category.name == "Orange Bar"
//                     ? FoodProductsSectionView(
//                         category.name!,
//                         model.vendorType!,
//                         showGrid: false,
//                         category: category,
//                         crossAxisCount: 2,
//                       )
//                     : SizedBox();
//               },
//             ).toList()),
//           ],
//         );
//       },
//     );
//   }
// }
