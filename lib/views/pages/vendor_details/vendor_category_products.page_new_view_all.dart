// import 'package:flutter/material.dart';
// import 'package:midnightcity/constants/app_colors.dart';
// import 'package:midnightcity/models/category.dart';
// import 'package:midnightcity/models/search.dart';
// import 'package:midnightcity/models/vendor.dart';
// import 'package:midnightcity/requests/search.request.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:midnightcity/view_models/vendor_category_products.vm.dart';
// import 'package:midnightcity/widgets/base.page.dart';
// import 'package:midnightcity/widgets/custom_list_view.dart';
// import 'package:midnightcity/widgets/list_items/horizontal_product.list_item.dart';
// import 'package:stacked/stacked.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:flutter/material.dart';
// import 'package:midnightcity/constants/app_routes.dart';
// import 'package:midnightcity/models/category.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:midnightcity/models/product.dart';
// import 'package:midnightcity/constants/app_strings.dart';
// import 'package:midnightcity/models/vendor.dart';
// import 'package:midnightcity/requests/product.request.dart';
// import 'package:midnightcity/view_models/base.view_model.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../../widgets/custom_grid_view.dart';
// import '../../../widgets/custom_text_form_field.dart';
// import '../../../widgets/inputs/search_bar.input.dart';
// import '../../../widgets/list_items/commerce_product.list_item.dart';
// import '../../../widgets/list_items/grocery_product.list_item.dart';
// import '../grocery/widgets/grocery_picks.view.dart';
//
// class VendorCategoryProductsPageNewViewAll extends StatefulWidget {
//   VendorCategoryProductsPageNewViewAll({this.category, this.vendor, Key? key})
//       : super(key: key);
//
//   final Category category;
//   final Vendor vendor;
//
//   @override
//   _VendorCategoryProductsPageNewViewAllState createState() =>
//       _VendorCategoryProductsPageNewViewAllState();
// }
//
// class _VendorCategoryProductsPageNewViewAllState
//     extends State<VendorCategoryProductsPageNewViewAll>
//     with TickerProviderStateMixin {
//   //
//   TabController tabBarController;
//   String subcategory;
//   String searchProduct = "";
//   TextEditingController txtECSearch = new TextEditingController();
//
//   ProductRequest _productRequest = ProductRequest();
//   RefreshController refreshContoller = RefreshController();
//   List<RefreshController> refreshContollers = [];
//   List<int> refreshContollerKeys = [];
//
//   //
//   Category category;
// //  Vendor vendor;
//   Map<int, List> categoriesProducts = {};
//   Map<int, int> categoriesProductsQueryPages = {};
//   final currencySymbol = AppStrings.currencySymbol;
//
//   @override
//   void initState() {
//     category = widget.category;
//
//     super.initState();
//
//     category.subcategories.sort((a, b) {
//       return a.name.compareTo(b.name);
//     });
//
//     refreshContollers = List.generate(
//       category.subcategories.length,
//       (index) => new RefreshController(),
//     );
//     refreshContollerKeys = List.generate(
//       category.subcategories.length,
//       (index) => category.subcategories[index].id,
//     );
//     category.subcategories.forEach((element) {
//       loadMoreProducts(element.id);
//       categoriesProductsQueryPages[element.id] = 1;
//     });
//
//     tabBarController = TabController(
//       length: widget.category.subcategories.length,
//       vsync: this,
//     );
//   }
//
//   void productSelected(Product product) async {
//     /*   await viewContext!.navigator.pushNamed(
//       AppRoutes.product,
//       arguments: product,
//     );
// */
//     //
//     // notifyListeners();
//   }
//
//   RefreshController getRefreshController(int key) {
//     int index = refreshContollerKeys.indexOf(key);
//     return refreshContollers[index];
//   }
//
//   loadMoreProducts(int id, {bool initialLoad = true}) async {
//     int queryPage = categoriesProductsQueryPages[id] ?? 1;
//     if (initialLoad) {
//       queryPage = 1;
//       categoriesProductsQueryPages[id] = queryPage;
//       getRefreshController(id).refreshCompleted();
//       // setBusyForObject(id, true);
//     } else {
//       categoriesProductsQueryPages[id] = ++queryPage;
//     }
//
//     //load the products by subcategory id
//     try {
//       final mProducts = await _productRequest.getProdcuts(
//         page: queryPage,
//         queryParams: {
//           "sub_category_id": id,
//           "vendor_id": widget.vendor?.id,
//         },
//       );
//
//       //
//       if (initialLoad) {
//         categoriesProducts[id] = mProducts;
//       } else {
//         categoriesProducts[id].addAll(mProducts);
//       }
//     } catch (error) {}
//
//     //
//     if (initialLoad) {
//       //setBusyForObject(id, false);
//     } else {
//       getRefreshController(id).loadComplete();
//     }
//
//     //
//     //notifyListeners();
//   }
//
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<VendorCategoryProductsViewModel>.reactive(
//       viewModelBuilder: () => VendorCategoryProductsViewModel(
//         context,
//         widget.category,
//         widget.vendor,
//       ),
//       onModelReady: (vm) => vm.initialise(),
//       //
//       builder: (context, model, child) {
//         return BasePage(
//           elevation: 0,
//           title: model.category.name,
//           showAppBar: true,
//           showLeadingAction: true,
//           showCart: true,
//           body: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //     Text("Search here"),
//
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(right: 20.0, left: 20, bottom: 10),
//                   child: Container(
//                     height: 40,
//                     child: CustomTextFormField(
//                       borderRadius: 5,
//
//                       hintText: "Search here",
//                       // labelText: "Search here",
//                       prefixIcon: Icon(Icons.search),
//                       textColor: Colors.black,
//
//                       labelColor: Colors.black,
//                       cursorColor: Colors.black,
//                       textEditingController: txtECSearch,
//
//                       onChanged: (value) {
//                         setState(() {
//                           searchProduct = txtECSearch.text;
//                         });
//                         print(searchProduct);
//                       },
//                     ),
//                   ),
//                 ),
//
//                 Container(
//                   // height: 5000,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: model.category.subcategories.map(
//                       (subcategory) {
//                         return Container(
//                           // height: 500,
//                           padding: EdgeInsets.only(right: 20, left: 20),
//
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 5.0),
//                                 child: Container(
//                                   padding: EdgeInsets.only(left: 0, right: 10),
//                                   height: 25,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                         topRight: Radius.circular(10),
//                                         bottomRight: Radius.circular(10),
//                                       ),
//                                       color: AppColor.midnightCityLightBlue),
//                                   //width: MediaQuery.of(context).size.width*.6,
//
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 8.0, top: 2),
//                                     child: Text(
//                                       subcategory.name,
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               CustomGridView(
//                                 noScrollPhysics: true,
//                                 childAspectRatio: 2 / 4,
//                                 crossAxisCount: 3,
//                                 mainAxisSpacing: 10,
//                                 crossAxisSpacing: 5,
//                                 // canPullUp: true,
//                                 canRefresh: false,
//                                 padding: EdgeInsets.symmetric(vertical: 5),
//                                 dataSet: searchProduct != ""
//                                     ? model.categoriesProducts[subcategory.id]
//                                             .where((element) => element.name
//                                                 .toLowerCase()
//                                                 .toString()
//                                                 .contains(searchProduct
//                                                     .toLowerCase()))
//                                             .toList() ??
//                                         []
//                                     : model.categoriesProducts[
//                                             subcategory.id] ??
//                                         [],
//                                 isLoading: model.busy(subcategory.id),
//                                 onLoading: () => model.loadMoreProducts(
//                                   subcategory.id,
//                                   initialLoad: false,
//                                 ),
//                                 onRefresh: () =>
//                                     model.loadMoreProducts(subcategory.id),
//                                 itemBuilder: (context, index) {
//                                   //
//                                   final product = (model.categoriesProducts[
//                                               subcategory.id] ??
//                                           [])
//                                       .where((element) => element.name
//                                           .toLowerCase()
//                                           .toString()
//                                           .contains(
//                                               searchProduct.toLowerCase()))
//                                       .toList()[index];
//                                   return CommerceProductListItem(
//                                     product,
//                                     //height: 250,
//                                     //onPressed: model.productSelected,
//                                     qtyUpdated: model.addToCartDirectly,
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ).toList(),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   showSearchPage(BuildContext context) {
//     final search = Search(
//       showType: 2,
//       vendorType: widget.vendor.vendorType,
//     );
//     //
//   }
// }
