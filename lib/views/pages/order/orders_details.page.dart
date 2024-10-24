import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/models/order.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/order_details.vm.dart';
import 'package:midnightcity/views/pages/order/widgets/order.bottomsheet.dart';
import 'package:midnightcity/views/pages/order/widgets/order_address.view.dart';
import 'package:midnightcity/views/pages/order/widgets/order_attachment.view.dart';
import 'package:midnightcity/views/pages/order/widgets/order_details_driver_info.view.dart';
import 'package:midnightcity/views/pages/order/widgets/order_details_items.view.dart';
import 'package:midnightcity/views/pages/order/widgets/order_details_vendor_info.view.dart';
import 'package:midnightcity/views/pages/order/widgets/order_payment_info.view.dart';
import 'package:midnightcity/views/pages/order/widgets/order_status.view.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/busy_indicator.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/cards/order_details_summary.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:glass_kit/glass_kit.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({
    this.order,
    Key? key,
    this.isOrderTracking = false,
  }) : super(key: key);

  //
  final Order? order;
  final bool? isOrderTracking;
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage>
    with WidgetsBindingObserver {
  //
  OrderDetailsViewModel? vm;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && vm != null) {
      vm!.fetchOrderDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    vm = OrderDetailsViewModel(context, widget.order!);

    //
    return ViewModelBuilder<OrderDetailsViewModel>.reactive(
      viewModelBuilder: () => vm!,
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          title: "Order Details".tr(),
          showAppBar: true,
          showLeadingAction: true,
          isLoading: vm.isBusy,
          onBackPressed: () {
            //context.pop(vm.order);
            Navigator.pop(context, vm.order);
          },
          //share button for parcel delivery order
          actions: vm.order.isPackageDelivery
              ? [
                  Icon(
                    // FlutterIcons.share_2_fea,
                    Icons.share,
                    color: Colors.white,
                  ).p8().onInkTap(vm.shareOrderDetails).p8(),
                ]
              : null,
          body: vm.isBusy
              ? BusyIndicator().centered()
              : SmartRefresher(
                  controller: vm.refreshController,
                  onRefresh: vm.fetchOrderDetails,
                  child: Stack(
                    children: [
                      //vendor details
                      /*   Stack(
                        children: [
                          //vendor feature image
                       /*   CustomImage(
                            imageUrl: vm.order.vendor.featureImage,
                            width: double.infinity,
                            height: 200,
                            boxFit: BoxFit.contain,
                          ),*/
                          //vendor details
                          GlassContainer(
                            height: 200,
                            width: context.screenWidth,
                            color: Colors.black54,
                            borderGradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.60),
                                Colors.white.withOpacity(0.10),
                                AppColor.primaryColor.withOpacity(0.05),
                                AppColor.primaryColor.withOpacity(0.6)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 0.39, 0.40, 1.0],
                            ),
                            blur: 2.0,
                            borderWidth: 0,
                            elevation: 0,
                            isFrostedGlass: true,
                            shadowColor: Colors.black.withOpacity(0.20),
                            alignment: Alignment.center,
                            frostedOpacity: 0.30,
                            padding: EdgeInsets.all(8.0),
                            child: VStack(
                              [
                                vm.order.vendor.name.text.center.white.xl3
                                    .semiBold
                                    .makeCentered(),
                                UiSpacer.verticalSpace(space: 40)
                              ],
                              alignment: MainAxisAlignment.center,
                            ),
                          ),
                        ],
                      ),*/

                      //
                      VStack(
                        [
                          //  UiSpacer.verticalSpace(space: 160),
                          VStack(
                            [
                              //free space
                              //header view
                              HStack(
                                [
                                  //vendor logo
                                  CustomImage(
                                    imageUrl: vm.order.vendor!.logo!,
                                    width: 50,
                                    height: 50,
                                  ).box.roundedSM.clip(Clip.antiAlias).make(),
                                  UiSpacer.horizontalSpace(),
                                  //
                                  VStack(
                                    [
                                      //
                                      "${vm.order.status!.tr().allWordsCapitilize() ?? vm.order.status!.tr()}"
                                          .text
                                          .semiBold
                                          .xl
                                          .color(AppColor.getStausColor(
                                              vm.order.status!))
                                          .make(),
                                      // "${Jiffy(vm.order.updatedAt).format('MMM dd, yyyy \| HH:mm')}"
                                      "".text.white.light.lg.make(),
                                    ],
                                  ).expand(),
                                  "#${vm.order.code}"
                                      .text
                                      .white
                                      .bold
                                      .xs
                                      .gray400
                                      .light
                                      .make(),
                                  //qr code icon
                                  /*  Visibility(
                                    visible:
                                        !vm.order.isTaxi && !vm.order.isSerice,
                                    child: Icon(
                                      FlutterIcons.qrcode_ant,
                                      size: 28,
                                    ).onInkTap(vm.showVerificationQRCode),
                                  ),*/
                                ],
                              )
                                  .color(AppColor.mainBackground)
                                  .p20()
                                  .wFull(context),
                              //
                              UiSpacer.cutDivider(),
                              //Payment status
                              OrderPaymentInfoView(vm),
                              //status
                              Visibility(
                                // visible: vm.order.showStatusTracking,
                                child: VStack(
                                  [
                                    OrderStatusView(vm).p20(),
                                    UiSpacer.divider(),
                                  ],
                                ),
                              ),
                              // either products/package details
                              OrderDetailsItemsView(vm).p20(),
                              //show package delivery addresses
                              Visibility(
                                visible: vm.order.deliveryAddress != null,
                                child: OrderAddressesView(vm).p20(),
                              ),
                              //
                              OrderAttachmentView(vm),
                              //
                              CustomVisibilty(
                                visible: (!vm.order.isPackageDelivery &&
                                    vm.order.deliveryAddress == null),
                                child: "Customer Order Pickup"
                                    .tr()
                                    .text
                                    .italic
                                    .light
                                    .xl
                                    .medium
                                    .make()
                                    .px20()
                                    .py20(),
                              ),

                              //note
                              "Note".tr().text.semiBold.xl.make().px20(),
                              "${vm.order.note}".text.light.sm.make().px20(),
                              UiSpacer.verticalSpace(),

                              UiSpacer.cutDivider(),
                              //vendor
                              Center(child: OrderDetailsVendorInfoView(vm)),

                              //driver
                              OrderDetailsDriverInfoView(vm),

                              UiSpacer.cutDivider(color: Vx.gray200),
                              //order summary
                              OrderDetailsSummary(vm.order)
                                  .wFull(context)
                                  .p20()
                                  .pOnly(bottom: context.percentHeight * 10)
                                  .box
                                  .make()
                            ],
                          )
                              .box
                              .topRounded(value: 15)
                              .clip(Clip.antiAlias)
                              .color(context.backgroundColor)
                              .make(),
                        ],
                      ).color(AppColor.white).scrollVertical(),
                    ],
                  ).color(AppColor.white),
                ),
          // bottomSheet: widget.isOrderTracking ? null : OrderBottomSheet(vm),
        );
      },
    );
  }
}
