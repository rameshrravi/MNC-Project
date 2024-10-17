import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:midnightcity/models/address.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/ops_map.vm.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/busy_indicator.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OPSMapPage extends StatelessWidget {
  const OPSMapPage({
    this.useCurrentLocation,
    this.region,
    this.initialPosition,
    Key? key,
  }) : super(key: key);

  final bool? useCurrentLocation;
  final String? region;
  final LatLng? initialPosition;
  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: ViewModelBuilder<OPSMapViewModel>.reactive(
        viewModelBuilder: () => OPSMapViewModel(context),
        builder: (ctx, vm, child) {
          return SafeArea(
            child: VStack(
              [
                HStack([
                  //close btn
                  Icon(
                    //Icons.access_alarm_outlined,
                    FlutterIcons.arrow_back_mdi,
                  ).p2().onInkTap(() {
                    Navigator.pop(context);
                  }),
                  UiSpacer.horizontalSpace(),
                  //auto complete

                  Expanded(
                    child: TypeAheadField<Address>(
                      suggestionsCallback: (keyword) async {
                        return await vm.fetchPlaces(keyword);
                      },

                      //   suggestionsCallback: (search) => vm.fetchPlaces(search),
                      builder: (context, controller, focusNode) {
                        return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Search address".tr(),
                            ));
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title:
                              suggestion.addressLine!.text.base.semiBold.make(),
                          subtitle: suggestion.adminArea!.text.sm.make(),
                        );
                      },
                      onSelected: (address) async {
                        vm.addressSelected(address, 1);
                      },
                    ),
                  )
                ]).px20().py4(),

                //google map body
                Stack(
                  children: [
                    //
                    GoogleMap(
                      myLocationEnabled: useCurrentLocation!,
                      myLocationButtonEnabled: useCurrentLocation!,
                      initialCameraPosition: CameraPosition(
                        target: initialPosition ?? LatLng(0.00, 0.00),
                        zoom: initialPosition != null ? 16 : 10,
                      ),
                      padding: vm.googleMapPadding!,
                      onMapCreated: vm.onMapCreated,
                      onCameraMove: vm.mapCameraMove,
                      markers: Set<Marker>.of(vm.gMarkers.values),
                    ),

                    // //center marker
                    // Padding(
                    //   padding: vm.googleMapPadding,
                    //   child: Align(
                    //     alignment: Alignment.center,
                    //     child: new Icon(
                    //       Icons.location_on,
                    //       size: 50.0,
                    //       color: AppColor.primaryColor,
                    //     ),
                    //   ),
                    // ),

                    //loading indicator
                    Positioned(
                      bottom: 30,
                      left: 30,
                      right: 30,
                      child: CustomVisibilty(
                        visible: vm.busy(vm.selectedAddress),
                        child: BusyIndicator().centered().p32(),
                      ),
                    ),
                    //selected address details
                    Positioned(
                      bottom: 30,
                      left: 30,
                      right: 30,
                      child: CustomVisibilty(
                        visible: vm.selectedAddress != null,
                        child: MeasureSize(
                          onChange: vm.updateMapPadding,
                          child: VStack(
                            [
                              Text(
                                '${vm.selectedAddress?.featureName}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              //address full
                              // vm.selectedAddress?.featureName?.text?.semiBold
                              //     ?.center?.xl
                              //     ?.maxLines(3)
                              //     ?.overflow(TextOverflow.ellipsis)
                              //     ?.make(),
                              // UiSpacer.verticalSpace(space: 5),
                              // vm.selectedAddress?.addressLine?.text?.light
                              //     ?.center?.sm
                              //     ?.maxLines(2)
                              //     ?.overflow(TextOverflow.ellipsis)
                              //     ?.make(),
                              // UiSpacer.verticalSpace(space: 5),
                              // Text(
                              //   '${vm.selectedAddress?.addressLine!.text.light.center.xl}',
                              //   maxLines: 3,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: TextStyle(
                              //       fontSize: 16, fontWeight: FontWeight.bold),
                              // ),
                              UiSpacer.verticalSpace(),
                              //submit
                              CustomButton(
                                title: "Select".tr(),
                                onPressed: vm.submit,
                              ),
                            ],
                          )
                              .box
                              .shadow2xl
                              .color(context.backgroundColor)
                              .p20
                              .make(),
                        ),
                      ),
                    ),
                  ],
                ).expand(),
              ],
            ),
          );
        },
      ),
    );
  }
}
