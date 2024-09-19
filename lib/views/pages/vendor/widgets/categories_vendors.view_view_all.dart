// import 'package:flutter/material.dart';
// import 'package:midnightcity/constants/app_colors.dart';
// import 'package:midnightcity/models/vendor_type.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:midnightcity/view_models/vendor/categories.vm.dart';
// import 'package:midnightcity/views/pages/category/categories.page.dart';
// import 'package:midnightcity/views/pages/grocery/widgets/grocery_picks.view.dart';
// import 'package:midnightcity/widgets/custom_horizontal_list_view.dart';
// import 'package:midnightcity/widgets/list_items/category.list_item.dart';
// import 'package:midnightcity/widgets/section.title.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:stacked/stacked.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../../../constants/app_routes.dart';
// import '../../../../models/vendor.dart';
// import '../../category/subcategories.page.dart';
// import '../../grocery/widgets/groceryonly_categories_products.view.dart';
// import '../../grocery/widgets/pharmaonly_categories_products.view.dart';
// import '../../vendor_details/vendor_category_products.page.dart';
// import '../../vendor_details/vendor_category_products.page_new.dart';
// import '../../vendor_details/vendor_category_products.page_new_view_all.dart';
//
// class CategoriesVendorViewAll extends StatelessWidget {
//   const CategoriesVendorViewAll(this.vendorType, this.vendor, {Key? key})
//       : super(key: key);
//   final VendorType vendorType;
//   final Vendor vendor;
//
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<CategoriesViewModel>.reactive(
//       viewModelBuilder: () => CategoriesViewModel(
//         context,
//         //   vendor: vendor,
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
//                 itemCount: model.dvendor.categories.length,
//                 itemBuilder: (context, i) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         print(model.dvendor.categories[i].name + "***********");
//
//                         print("***********" + model.dvendor.name);
//
//                         /*  context.nextPage(
//                          VendorCategoryProductsPage(
//                            category: model.categories[i],
//                            vendor: vendor,
//                          ),
//                        );*/
//
//                         // if( model.dvendor.categories[i].name=="Restaurant" || model.dvendor.categories[i].name=="Orange Bar" ) {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     VendorCategoryProductsPageNewViewAll(
//                                       category: model.dvendor.categories[i],
//                                       vendor: model.dvendor,
//                                     )));
//                         /* }else if( model.dvendor.categories[i].name=="Groceries" ) {
//
//
//
//                            Navigator.push(
//                                context, MaterialPageRoute(builder: (context) =>
//
//                                GroceryOnlyCategoryProducts(
//                                    vendorType, length: 10
//                                )));
//
//
//                          }else{
//
//                          Navigator.push(
//                              context, MaterialPageRoute(builder: (context) =>
//
//                              PharmaOnlyCategoryProducts(
//                                  vendorType, length: 10
//                              )));
//
//                        }*/
//
// /*
//                        Navigator.pushNamed(context,
//                          AppRoutes.vendorDetails,
//                          arguments: vendor,
//                        );
// */
//                       },
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(color: Colors.white, width: 1),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 2,
//                         child: Column(
//                           children: [
//                             Stack(alignment: Alignment.topLeft, children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(15),
//                                     topRight: Radius.circular(15)),
//                                 child: Image.network(
//                                   model.dvendor.categories[i].imageUrl,
//                                   width: MediaQuery.of(context).size.width - 40,
//                                   height: 150,
//                                   fit: BoxFit.fitWidth,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 20.0),
//                                 child: model.dvendor.categories[i].name !=
//                                         "Orange Bar"
//                                     ? Container(
//                                         height: 25,
//                                         decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.only(
//                                               topRight: Radius.circular(10),
//                                               bottomRight: Radius.circular(10),
//                                             ),
//                                             color:
//                                                 AppColor.midnightCityLightBlue),
//                                         width: model.dvendor.categories[i]
//                                                     .name ==
//                                                 "Restaurant"
//                                             ? 120
//                                             : model.dvendor.categories[i]
//                                                         .name ==
//                                                     "Groceries"
//                                                 ? 120
//                                                 : model.dvendor.categories[i]
//                                                             .name ==
//                                                         "Pharmacy"
//                                                     ? 140
//                                                     : model
//                                                                 .dvendor
//                                                                 .categories[i]
//                                                                 .name ==
//                                                             "Orange Bar"
//                                                         ? 180
//                                                         : 120,
//                                         child: Center(
//                                           child: Text(
//                                             model.dvendor.categories[i].name ==
//                                                     "Restaurant"
//                                                 ? "Great food"
//                                                 : model.dvendor.categories[i]
//                                                             .name ==
//                                                         "Groceries"
//                                                     ? "Essentials"
//                                                     : model
//                                                                 .dvendor
//                                                                 .categories[i]
//                                                                 .name ==
//                                                             "Pharmacy"
//                                                         ? "Drugs and more"
//                                                         : model
//                                                                     .dvendor
//                                                                     .categories[
//                                                                         i]
//                                                                     .name ==
//                                                                 "Orange Bar"
//                                                             ? ""
//                                                             : "",
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ),
//                                       )
//                                     : SizedBox(),
//                               ),
//                             ]),
//                             Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                       bottomRight: Radius.circular(15),
//                                       bottomLeft: Radius.circular(15)),
//                                   color: Colors.white,
//                                 ),
//                                 height: 50,
//                                 width: double.infinity,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         model.dvendor.categories[i].name,
//                                         style: TextStyle(
//                                             color: Colors.black, fontSize: 18),
//                                       ),
//                                       Spacer(),
//                                       Icon(
//                                         Icons.av_timer_rounded,
//                                         color: Colors.grey,
//                                       ),
//                                       Text(
//                                         model.dvendor.categories[i].name ==
//                                                 "Restaurant"
//                                             ? "40 - 50 mins"
//                                             : model.dvendor.categories[i]
//                                                         .name ==
//                                                     "Groceries"
//                                                 ? "20 - 40 mins"
//                                                 : model.dvendor.categories[i]
//                                                             .name ==
//                                                         "Pharmacy"
//                                                     ? "15 - 30 mins"
//                                                     : model
//                                                                 .dvendor
//                                                                 .categories[i]
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
