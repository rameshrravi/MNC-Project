// import 'package:flutter/material.dart';
// import 'package:midnightcity/models/vendor.dart';
// import 'package:midnightcity/view_models/vendor_details.vm.dart';
// import 'package:midnightcity/views/pages/vendor_details/vendor_category_products.page.dart';
// import 'package:midnightcity/views/pages/vendor_details/widgets/vendor_details_header.view.dart';
// import 'package:midnightcity/widgets/busy_indicator.dart';
// import 'package:midnightcity/widgets/custom_masonry_grid_view.dart';
// import 'package:midnightcity/widgets/list_items/category.list_item.dart';
// import 'package:stacked/stacked.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../../../constants/app_colors.dart';
// import '../vendor_category_products.page_new.dart';
//
// class VendorDetailsWithSubcategoryPage extends StatelessWidget {
//   VendorDetailsWithSubcategoryPage({this.vendor, Key? key}) : super(key: key);
//
//   final Vendor vendor;
//
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<VendorDetailsViewModel>.reactive(
//       viewModelBuilder: () => VendorDetailsViewModel(context, vendor),
//       onModelReady: (model) => model.getVendorDetails(),
//       builder: (context, model, child) {
//         return VStack(
//           [
//             //
//             VendorDetailsHeader(model),
//             //categories
//             model.isBusy
//                 ? BusyIndicator().p20().centered()
//                 : Container(
//                     height: 1000,
//                     child: ListView.builder(
//                       padding: EdgeInsets.zero,
//
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: model
//                           .vendor.categories.length, // model.categories.length,
//                       itemBuilder: (context, i) {
//                         return GestureDetector(
//                           onTap: () {
//                             print(model.vendor.categories[i].name +
//                                 "***********");
//                             print("***********" + vendor.name);
//                             /*  context.nextPage(
//                        VendorCategoryProductsPage(
//                          category: model.categories[i],
//                          vendor: vendor,
//                        ),
//                      );*/
//
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         VendorCategoryProductsPageNew(
//                                           category: model.vendor.categories[i],
//                                           vendor: model.vendor,
//                                         )));
//                           },
//                           child: Card(
//                             elevation: 5,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Stack(alignment: Alignment.topLeft, children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                     ),
//                                     padding: EdgeInsets.only(left: 0),
//                                     child: Image.network(
//                                       model.vendor.categories[i].imageUrl,
//                                       width: MediaQuery.of(context).size.width -
//                                           40,
//                                       height: 150,
//                                       fit: BoxFit.fitWidth,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 20.0),
//                                     child: Container(
//                                       height: 25,
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.only(
//                                             topRight: Radius.circular(10),
//                                             bottomRight: Radius.circular(10),
//                                           ),
//                                           color:
//                                               AppColor.midnightCityLightBlue),
//                                       width: model.vendor.categories[i].name ==
//                                               "Restaurant"
//                                           ? 120
//                                           : model.vendor.categories[i].name ==
//                                                   "Groceries"
//                                               ? 120
//                                               : model.vendor.categories[i]
//                                                           .name ==
//                                                       "Pharmacy"
//                                                   ? 140
//                                                   : model.vendor.categories[i]
//                                                               .name ==
//                                                           "Orange Bar"
//                                                       ? 180
//                                                       : 120,
//                                       child: Center(
//                                         child: Text(
//                                           model.vendor.categories[i].name ==
//                                                   "Restaurant"
//                                               ? "Great food"
//                                               : model.vendor.categories[i]
//                                                           .name ==
//                                                       "Groceries"
//                                                   ? "Essentials"
//                                                   : model.vendor.categories[i]
//                                                               .name ==
//                                                           "Pharmacy"
//                                                       ? "Drugs and more"
//                                                       : model
//                                                                   .vendor
//                                                                   .categories[i]
//                                                                   .name ==
//                                                               "Orange Bar"
//                                                           ? "Cocktails and mocktails"
//                                                           : "",
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ]),
//                                 Container(
//                                     height: 50,
//                                     width: double.infinity,
//                                     color: Colors.white,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             model.vendor.categories[i].name,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 18),
//                                           ),
//                                           Spacer(),
//                                           Icon(
//                                             Icons.av_timer_rounded,
//                                             color: Colors.grey,
//                                           ),
//                                           Text(
//                                             model.vendor.categories[i].name ==
//                                                     "Restaurant"
//                                                 ? "40 - 50 mins"
//                                                 : model.vendor.categories[i]
//                                                             .name ==
//                                                         "Groceries"
//                                                     ? "20 - 40 mins"
//                                                     : model.vendor.categories[i]
//                                                                 .name ==
//                                                             "Pharmacy"
//                                                         ? "15 - 30 mins"
//                                                         : model
//                                                                     .vendor
//                                                                     .categories[
//                                                                         i]
//                                                                     .name ==
//                                                                 "Orange Bar"
//                                                             ? "20 - 30 mins"
//                                                             : "30 - 40 mins",
//                                             style: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontSize: 14),
//                                           ),
//                                         ],
//                                       ),
//                                     ))
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//
//             /*    CustomMasonryGridView(
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     crossAxisCount: 4,
//                     items: model.vendor.categories.toList()
//                         .map(
//                           (category) => CategoryListItem(
//                             category: category,
//                             onPressed: (category) {
//                               //
//                               context.nextPage(
//                                 VendorCategoryProductsPage(
//                                   category: category,
//                                   vendor: model.vendor,
//                                 ),
//                               );
//                             },
//                           ),
//                         )
//                         .toList(),
//                   ).p20(), */
//           ],
//         ).scrollVertical().expand();
//       },
//     );
//   }
// }
