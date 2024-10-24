// import 'package:flutter/material.dart';
// import 'package:midnightcity/models/vendor.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:midnightcity/view_models/vendor_details.vm.dart';
// import 'package:midnightcity/views/pages/vendor_details/service_vendor_details.page.dart';
// import 'package:midnightcity/views/pages/vendor_details/widgets/upload_prescription.btn.dart';
// import 'package:midnightcity/views/pages/vendor_details/widgets/vendor_with_menu.view.dart';
// import 'package:midnightcity/views/pages/vendor_details/widgets/vendor_with_subcategory.view.dart';
// import 'package:midnightcity/widgets/base.page.dart';
// import 'package:midnightcity/widgets/buttons/custom_leading.dart';
// import 'package:midnightcity/widgets/buttons/share.btn.dart';
// import 'package:midnightcity/widgets/cards/custom.visibility.dart';
// import 'package:midnightcity/widgets/cart_page_action.dart';
// import 'package:stacked/stacked.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class VendorDetailsPage2 extends StatelessWidget {
//   VendorDetailsPage2({this.vendor, Key? key}) : super(key: key);
//
//   final Vendor vendor;
//
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<VendorDetailsViewModel>.reactive(
//       viewModelBuilder: () => VendorDetailsViewModel(context, vendor),
//       onModelReady: (model) => model.getVendorDetails(),
//       builder: (context, model, child) {
//         return (!model.vendor.hasSubcategories && !model.vendor.isServiceType)
//             ? VendorDetailsWithMenuPage(vendor: model.vendor)
//             : BasePage(
//                 showAppBar: true,
//                 showLeadingAction: true,
//                 showCart: true,
//                 elevation: 0,
//                 extendBodyBehindAppBar: true,
//                 appBarColor: Colors.transparent,
//                 backgroundColor: context.backgroundColor,
//                 leading: CustomLeading(),
//                 fab: UploadPrescriptionFab(model),
//                 actions: [
//                   SizedBox(
//                     width: 50,
//                     height: 50,
//                     child: FittedBox(
//                       child: ShareButton(
//                         model: model,
//                       ),
//                     ),
//                   ),
//                   UiSpacer.hSpace(10),
//                   PageCartAction(),
//                 ],
//                 body: VStack(
//                   [
//                     //subcategories && hide for service vendor type
//                     CustomVisibilty(
//                       visible: (model.vendor.hasSubcategories &&
//                           !model.vendor.isServiceType),
//                       child: VendorDetailsWithSubcategoryPage(
//                         vendor: model.vendor,
//                       ),
//                     ),
//
//                     //show for service vendor type
//                     CustomVisibilty(
//                       visible: model.vendor.isServiceType,
//                       child: ServiceVendorDetailsPage(
//                         model,
//                         vendor: model.vendor,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//       },
//     );
//   }
// }
