// import 'package:flutter/material.dart';
// import 'package:midnightcity/constants/app_colors.dart';
// import 'package:midnightcity/models/vendor_type.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:midnightcity/utils/utils.dart';
// import 'package:midnightcity/view_models/new_parcel.vm.dart';
// import 'package:midnightcity/views/pages/parcel/widgets/package_delivery_info.txt';
// import 'package:midnightcity/views/pages/parcel/widgets/package_delivery_parcel_info.txt';
// import 'package:midnightcity/views/pages/parcel/widgets/package_delivery_payment.txt';
// import 'package:midnightcity/views/pages/parcel/widgets/package_delivery_summary.txt';
// import 'package:midnightcity/views/pages/parcel/widgets/package_recipient_info.txt';
// import 'package:midnightcity/views/pages/parcel/widgets/package_type_selector.txt';
// import 'package:midnightcity/views/pages/parcel/widgets/vendor_package_type_selector.dart';
// import 'package:midnightcity/widgets/base.page.dart';
// import 'package:midnightcity/widgets/cards/custom.visibility.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:stacked/stacked.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class NewParcelPage extends StatelessWidget {
//   const NewParcelPage(this.vendorType, {this.onFinish, Key? key})
//       : super(key: key);
//
//   final VendorType vendorType;
//   final Function? onFinish;
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<NewParcelViewModel>.reactive(
//       viewModelBuilder: () =>
//           NewParcelViewModel(context, onFinish!, vendorType),
//       onModelReady: (vm) => vm.initialise(),
//       builder: (context, vm, child) {
//         return BasePage(
//           showAppBar: true,
//           showLeadingAction: true,
//           elevation: 0,
//           showCart: false,
//           // title: "${vendorType.name}",
//           appBarColor: AppColor.primaryColor,
//           appBarItemColor: Utils.textColorByTheme(),
//           body: VStack(
//             [
//               VStack(
//                 [
//                   "New Order"
//                       .tr()
//                       .text
//                       .color(Utils.textColorByTheme())
//                       .bold
//                       .xl3
//                       .make(),
//                   "Please complete the steps below to place an order"
//                       .tr()
//                       .text
//                       .base
//                       .color(Utils.textColorByTheme())
//                       .light
//                       .make(),
//                   UiSpacer.vSpace(12),
//                   //
//                   AnimatedSmoothIndicator(
//                     activeIndex: vm.activeStep,
//                     count: 7,
//                     effect: ExpandingDotsEffect(
//                       activeDotColor: context.backgroundColor,
//                       dotColor: context.backgroundColor,
//                       strokeWidth: 1,
//                       paintStyle: PaintingStyle.stroke,
//                     ),
//                   ),
//                   UiSpacer.vSpace(10),
//                 ],
//               )
//                   .p20()
//                   .box
//                   .bgImage(
//                     DecorationImage(
//                       image: NetworkImage(vendorType.logo!),
//                       opacity: 0.05,
//                     ),
//                   )
//                   .color(AppColor.primaryColor!)
//                   .make()
//                   .wFull(context),
//
//               //
//               PageView(
//                 scrollDirection: Axis.vertical,
//                 physics: NeverScrollableScrollPhysics(),
//                 controller: vm.pageController,
//                 children: [
//                   //package type
//                   PackageTypeSelector(vm: vm),
//
//                   //
//                   PackageDeliveryInfo(vm: vm),
//
//                   //vendors from sort delivery
//                   VendorPackageTypeSelector(vm: vm),
//
//                   //receiver info
//                   PackageRecipientInfo(vm: vm),
//
//                   //parcel info
//                   CustomVisibilty(
//                     visible: vm.requireParcelInfo,
//                     child: PackageDeliveryParcelInfo(vm: vm),
//                   ),
//
//                   //summary
//                   PackageDeliverySummary(vm: vm),
//
//                   //PAYMENT
//                   PackageDeliveryPayment(vm: vm),
//                 ],
//               ).box.make().px20().expand()
//             ],
//           ).pOnly(
//             bottom: context.mq.viewInsets.bottom,
//             // bottom: context.mq.viewPadding.bottom,
//           ),
//         );
//       },
//     );
//   }
// }
