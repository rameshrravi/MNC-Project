// import 'package:flutter/material.dart';
// import 'package:midnightcity/constants/app_colors.dart';
// import 'package:midnightcity/models/vendor_type.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:midnightcity/view_models/vendor/categories.vm.dart';
// import 'package:midnightcity/views/pages/category/categories.page.dart';
// import 'package:midnightcity/widgets/custom_horizontal_list_view.dart';
// import 'package:midnightcity/widgets/list_items/category.list_item.dart';
// import 'package:midnightcity/widgets/section.title.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:stacked/stacked.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../vendor_details/vendor_category_products.page.dart';
//
// class Categories extends StatelessWidget {
//   const Categories(this.vendorType, {Key? key}) : super(key: key);
//   final VendorType vendorType;
//
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<CategoriesViewModel>.reactive(
//       viewModelBuilder: () => CategoriesViewModel(
//         context,
//         vendorType: vendorType,
//       ),
//       onModelReady: (model) => model.initialise(),
//       builder: (context, model, child) {
//         return VStack(
//           [
//             //
//             /*  HStack(
//               [
//                 SectionTitle("Categories".tr()).expand(),
//                 UiSpacer.smHorizontalSpace(),
//                 "See all".tr().text.color(context.primaryColor).make().onInkTap(
//                   () {
//                     //
//                     context.nextPage(
//                       CategoriesPage(vendorType: vendorType),
//                     );
//                   },
//                 ),
//               ],
//             ).p12(),*/
//
//             //categories list
//
//             Container(
//               height: 880,
//               child: ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: model.categories.length,
//                 itemBuilder: (context, i) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         context.nextPage(
//                           VendorCategoryProductsPage(
//                             category: model.categories[i],
//                             vendor: model.vendor,
//                           ),
//                         );
//                       },
//                       child: Card(
//                         elevation: 5,
//                         child: Column(
//                           children: [
//                             Stack(alignment: Alignment.topLeft, children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                 ),
//                                 padding: EdgeInsets.only(left: 0),
//                                 child: Image.network(
//                                   model.categories[i].imageUrl,
//                                   width: MediaQuery.of(context).size.width - 40,
//                                   height: 150,
//                                   fit: BoxFit.fitWidth,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 20.0),
//                                 child: Container(
//                                   height: 25,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                         topRight: Radius.circular(10),
//                                         bottomRight: Radius.circular(10),
//                                       ),
//                                       color: AppColor.midnightCityLightBlue),
//                                   width: model.categories[i].name ==
//                                           "Restaurant"
//                                       ? 120
//                                       : model.categories[i].name == "Groceries"
//                                           ? 120
//                                           : model.categories[i].name ==
//                                                   "Pharmacy"
//                                               ? 140
//                                               : model.categories[i].name ==
//                                                       "Orange Bar"
//                                                   ? 180
//                                                   : 120,
//                                   child: Center(
//                                     child: Text(
//                                       model.categories[i].name == "Restaurant"
//                                           ? "Great food"
//                                           : model.categories[i].name ==
//                                                   "Groceries"
//                                               ? "Essentials"
//                                               : model.categories[i].name ==
//                                                       "Pharmacy"
//                                                   ? "Drugs and more"
//                                                   : model.categories[i].name ==
//                                                           "Orange Bar"
//                                                       ? "Cocktails and mocktails"
//                                                       : "",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ]),
//                             Container(
//                                 height: 50,
//                                 width: double.infinity,
//                                 color: Colors.white,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         model.categories[i].name,
//                                         style: TextStyle(
//                                             color: Colors.black, fontSize: 18),
//                                       ),
//                                       Spacer(),
//                                       Icon(
//                                         Icons.av_timer_rounded,
//                                         color: Colors.grey,
//                                       ),
//                                       Text(
//                                         model.categories[i].name == "Restaurant"
//                                             ? "40 - 50 mins"
//                                             : model.categories[i].name ==
//                                                     "Groceries"
//                                                 ? "20 - 40 mins"
//                                                 : model.categories[i].name ==
//                                                         "Pharmacy"
//                                                     ? "15 - 30 mins"
//                                                     : model.categories[i]
//                                                                 .name ==
//                                                             "Orange Bar"
//                                                         ? "20 - 30 mins"
//                                                         : "30 - 40 mins",
//                                         style: TextStyle(
//                                             color: Colors.grey, fontSize: 14),
//                                       ),
//                                     ],
//                                   ),
//                                 ))
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             /*  CustomHorizontalListView(
//               isLoading: model.isBusy,
//               itemsViews: model.categories.map(
//                 (category) {
//                   return CategoryListItem(
//                     category: category,
//                     onPressed: model.categorySelected,
//                     maxLine: false,
//                   );
//                 },
//               ).toList(),
//             ),*/
//           ],
//         );
//       },
//     );
//   }
// }
