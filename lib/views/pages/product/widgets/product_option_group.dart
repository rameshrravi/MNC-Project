// import 'package:flutter/material.dart';
// import 'package:midnightcity/models/option_group.dart';
// import 'package:midnightcity/view_models/product_details.vm.dart';
// import 'package:midnightcity/widgets/custom_list_view.dart';
// import 'package:midnightcity/widgets/list_items/option.list_item.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class ProductOptionGroup extends StatelessWidget {
//   const ProductOptionGroup({this.optionGroup, this.model, Key? key})
//       : super(key: key);
//
//   final OptionGroup optionGroup;
//   final ProductDetailsViewModel model;
//   @override
//   Widget build(BuildContext context) {
//     return VStack(
//       [
//         //group name
//         optionGroup.name.text.white.base.semiBold.make(),
//
//         //options
//         CustomListView(
//           dataSet: optionGroup.options,
//           noScrollPhysics: true,
//           itemBuilder: (context, index) {
//             //
//             final option = optionGroup.options[index];
//             return OptionListItem(
//               option: option,
//               optionGroup: optionGroup,
//               model: model,
//             );
//           },
//         ),
//       ],
//     ).px20();
//   }
// }
