// import 'package:flutter/material.dart';
// import 'package:midnightcity/constants/app_colors.dart';
// import 'package:midnightcity/constants/app_strings.dart';
// import 'package:midnightcity/models/vendor_type.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:midnightcity/view_models/vendor.vm.dart';
// import 'package:midnightcity/views/pages/vendor/widgets/banners.view.dart';
// import 'package:midnightcity/views/pages/vendor/widgets/best_selling_products.view.dart';
// import 'package:midnightcity/views/pages/vendor/widgets/for_you_products.view.dart';
// import 'package:midnightcity/views/pages/vendor/widgets/header.view.dart';
// import 'package:midnightcity/views/pages/vendor/widgets/nearby_vendors.view.dart';
// import 'package:midnightcity/views/pages/vendor/widgets/top_vendors.view.dart';
// import 'package:midnightcity/widgets/base.page.dart';
// import 'package:midnightcity/widgets/cards/view_all_vendors.view.dart';
// import 'package:midnightcity/widgets/vendor_type_categories.view.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
// import 'package:stacked/stacked.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class VendorPage extends StatefulWidget {
//   const VendorPage(this.vendorType, {Key? key}) : super(key: key);
//
//   final VendorType vendorType;
//   @override
//   _VendorPageState createState() => _VendorPageState();
// }
//
// class _VendorPageState extends State<VendorPage>
//     with AutomaticKeepAliveClientMixin<VendorPage> {
//   GlobalKey pageKey = GlobalKey<State>();
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return BasePage(
//       showAppBar: true,
//       showLeadingAction: !AppStrings.isSingleVendorMode,
//       elevation: 0,
//       title: "${widget.vendorType.name}",
//       appBarColor: context.theme.backgroundColor,
//       appBarItemColor: AppColor.primaryColor,
//       showCart: true,
//       key: pageKey,
//       body: ViewModelBuilder<VendorViewModel>.reactive(
//         viewModelBuilder: () => VendorViewModel(context, widget.vendorType),
//         onModelReady: (model) => model.initialise(),
//         builder: (context, model, child) {
//           return VStack(
//             [
//               //
//               VendorHeader(model: model),
//
//               SmartRefresher(
//                 enablePullDown: true,
//                 enablePullUp: false,
//                 controller: model.refreshController,
//                 onRefresh: () {
//                   model.refreshController.refreshCompleted();
//                   setState(() {
//                     pageKey = GlobalKey<State>();
//                   });
//                 }, // model.reloadPage,
//                 child: VStack(
//                   [
//                     //
//                     Banners(widget.vendorType),
//                     //categories
//                     VendorTypeCategories(
//                       widget.vendorType,
//                       showTitle: false,
//                       description: "Categories".tr(),
//                       childAspectRatio: 1.4,
//                     ),
//
//                     //nearby vendors
//                     AppStrings.enableSingleVendor
//                         ? UiSpacer.emptySpace()
//                         : NearByVendors(widget.vendorType),
//
//                     //best selling
//                     BestSellingProducts(widget.vendorType),
//
//                     //For you
//                     ForYouProducts(widget.vendorType),
//
//                     //
//                     AppStrings.enableSingleVendor
//                         ? UiSpacer.verticalSpace()
//                         : TopVendors(widget.vendorType),
//
//                     //view cart and all vendors
//                     ViewAllVendorsView(vendorType: widget.vendorType),
//                   ],
//                 ).scrollVertical(),
//               ).expand(),
//             ],
//             // key: model.pageKey,
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }
