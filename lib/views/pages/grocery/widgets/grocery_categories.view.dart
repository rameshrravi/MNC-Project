// import 'package:flutter/material.dart';
// import 'package:midnightcity/constants/app_strings.dart';
// import 'package:midnightcity/models/vendor_type.dart';
// import 'package:midnightcity/view_models/vendor/categories.vm.dart';
// import 'package:midnightcity/widgets/vendor_type_categories.view.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:stacked/stacked.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class GroceryCategories extends StatefulWidget {
//   const GroceryCategories(this.vendorType, {Key? key}) : super(key: key);
//
//   final VendorType vendorType;
//   @override
//   _GroceryCategoriesState createState() => _GroceryCategoriesState();
// }
//
// class _GroceryCategoriesState extends State<GroceryCategories> {
//   bool isOpen = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<CategoriesViewModel>.reactive(
//       viewModelBuilder: () =>
//           CategoriesViewModel(context, vendorType: widget.vendorType),
//       onModelReady: (model) => model.initialise(),
//       builder: (context, model, child) {
//         return Container(
//           child:
//               //
//               VendorTypeCategories(
//             widget.vendorType,
//             showTitle: true,
//             title: " ".tr(),
//             childAspectRatio: 1.4,
//             crossAxisCount: AppStrings.categoryPerRow,
//           ),
//           //
//         );
//       },
//     );
//   }
// }
