import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/models/order.dart';
import 'package:midnightcity/services/location.service.dart';
import 'package:midnightcity/view_models/order_tracking.vm.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({this.order, Key? key}) : super(key: key);

  //
  final Order? order;

  @override
  Widget build(BuildContext context) {
    //
    return ViewModelBuilder<OrderTrackingViewModel>.reactive(
      viewModelBuilder: () => OrderTrackingViewModel(context, order),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          title: "Order Tracking".tr(),
          showAppBar: true,
          showLeadingAction: true,
          isLoading: vm.isBusy,
          body: Stack(
            children: [
              //
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    LocationService?.currenctAddress?.coordinates?.latitude ??
                        0.00,
                    LocationService?.currenctAddress?.coordinates?.longitude ??
                        0.00,
                  ),
                  zoom: 15,
                ),
                padding: EdgeInsets.only(bottom: Vx.dp64 * 2),
                myLocationEnabled: true,
                // markers: vm.mapMarkers,
                //polylines: Set<Polyline>.of(vm.polylines.values),
                onMapCreated: vm.setMapController,
              ),

              //
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: HStack(
                    [
                      //driver profile
                      CustomImage(
                        imageUrl: order!.driver!.photo!,
                      )
                          .wh(Vx.dp56, Vx.dp56)
                          .box
                          .roundedFull
                          .shadowXs
                          .clip(Clip.antiAlias)
                          .make(),

                      //
                      VStack(
                        [
                          order!.driver!.name!.text.xl.semiBold.make(),
                          order!.driver!.phone!.text.make(),
                        ],
                      ).px12().expand(),

                      //call
                      CustomButton(
                        //icon: FlutterIcons.phone_call_fea,
                        icon: Icons.access_alarm,
                        iconColor: Colors.white,
                        title: "",
                        color: AppColor.primaryColor,
                        shapeRadius: Vx.dp24,
                        onPressed: vm.callDriver,
                      ).wh(Vx.dp64, Vx.dp40).p12(),
                    ],
                  )
                      .p12()
                      .box
                      .color(context.backgroundColor)
                      .roundedSM
                      .shadowXl
                      .outerShadow3Xl
                      .make()
                      .wFull(context)
                      .h(Vx.dp64 * 1.3)
                      .p12(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
