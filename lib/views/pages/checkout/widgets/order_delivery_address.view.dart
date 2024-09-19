import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/extensions/dynamic.dart';
import 'package:midnightcity/view_models/checkout_base.vm.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/list_items/delivery_address.list_item.dart';
import 'package:midnightcity/widgets/states/delivery_address.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/constants/app_colors.dart';

class OrderDeliveryAddressPickerView extends StatefulWidget {
  const OrderDeliveryAddressPickerView(
    this.vm, {
    Key? key,
    this.showPickView = true,
    this.isBooking = false,
  }) : super(key: key);
  final CheckoutBaseViewModel vm;
  final bool showPickView;
  final bool isBooking;

  @override
  State<OrderDeliveryAddressPickerView> createState() =>
      _OrderDeliveryAddressPickerViewState();
}

class _OrderDeliveryAddressPickerViewState
    extends State<OrderDeliveryAddressPickerView> {
  bool isDelivery = true;
  bool isPickup = false;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Center(
          child: HStack([
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.vm.isPickup = false;
                  isDelivery = true;
                  isPickup = false;
                  widget.vm.togglePickupStatus(false);
                });
              },
              child: Container(
                width: 90,
                height: 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: isDelivery ? Colors.black : Colors.white),
                child: Center(
                  child: Text("Delivery",
                      style: TextStyle(
                          color: isDelivery ? AppColor.white : Colors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.vm.isPickup = true;
                  isDelivery = false;
                  isPickup = true;
                  widget.vm.togglePickupStatus(true);
                });
              },
              child: Container(
                width: 90,
                height: 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: isPickup ? Colors.black : Colors.white),
                child: Center(
                  child: Text("Pickup",
                      style: TextStyle(
                          color: isPickup ? AppColor.white : Colors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ]),
        ),

        Visibility(
          visible: false, // isPickup, //widget.showPickView,
          child: HStack(
            [
              //
              Checkbox(
                activeColor: Colors.black,
                value: widget.vm.isPickup,
                onChanged: (changed) {
                  widget.vm.togglePickupStatus;
                },
              ),
              //
              VStack(
                [
                  "Pickup Order"
                      .tr()
                      .text
                      .xl
                      .semiBold
                      .color(Colors.black)
                      .make(),
                  "Please indicate if you would come pickup order at the vendor"
                      .tr()
                      .text
                      .color(Colors.black)
                      .make(),
                ],
              ).expand(),
            ],
            crossAlignment: CrossAxisAlignment.start,
          ).wFull(context).onInkTap(
                () => widget.vm.togglePickupStatus(!widget.vm.isPickup),
              ),
        ),

        //

        //delivery address pick preview
        Visibility(
          visible: isDelivery, // !widget.vm.isPickup,
          child: VStack(
            [
              //divider
              Visibility(
                visible: widget.showPickView,
                child: Divider(thickness: 1).py4(),
              ),
              //
              HStack(
                [
                  //
                  VStack(
                    [
                      // "${!widget.isBooking ? 'Delivery' : 'Booking'} address"
                      "Delivery Details".tr().text.black.semiBold.xl.make(),
                      /* "Please select %s address/location"
                          .tr()
                          .fill(["${!widget.isBooking ? 'delivery' : 'booking'}".tr()])
                          .text
                          .white
                          .make(),*/
                    ],
                  ).expand(),
                  //
                  CustomButton(
                    //title: "Select".tr(),
                    icon: Icons.edit,
                    onPressed: widget.vm.showDeliveryAddressPicker,
                  ),
                ],
              ),
              //Selected delivery address box

              widget.vm.deliveryAddress != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: DeliveryAddressListItem(
                          deliveryAddress: widget.vm.deliveryAddress,
                          action: false,
                          border: false,
                          showDefault: true,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: EmptyDeliveryAddress(
                          selection: true,
                          isBooking: widget.isBooking,
                        )
                            .py12()
                            .opacity(value: 0.60)
                            .wFull(context)
                            .py12()
                            .onInkTap(
                              widget.vm.showDeliveryAddressPicker,
                            ),
                      ),
                    ),

              //within vendor range
              Visibility(
                visible: widget.vm.delievryAddressOutOfRange,
                child: "Delivery address is out of vendor delivery range"
                    .tr()
                    .text
                    .sm
                    .red500
                    .make(),
              ),
            ],
          ),
        ),
      ],
    ).p12().box.roundedSM.make().pOnly(
          bottom: Vx.dp20,
        );
  }
}
