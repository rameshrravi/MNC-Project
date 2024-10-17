import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/constants/app_colors.dart';

class CustomStepper extends StatefulWidget {
  CustomStepper({Key? key, this.defaultValue, this.max, this.onChange})
      : super(key: key);

  final int? defaultValue;
  final int? max;
  final Function(int)? onChange;
  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  int qty = 0;

  @override
  void initState() {
    super.initState();

    //
    setState(() {
      qty = widget.defaultValue!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Center(
            child: Icon(
              FlutterIcons.minus_ant,
              //Icons.minimize,
              size: 14,
              color: Colors.white,
            ).px4().onInkTap(() {
              if (qty > 0) {
                setState(() {
                  qty -= 1;
                });
                //
                widget!.onChange!(qty)!;
              }
            }),
          ),
        ),
        //
        Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15),
          child: "$qty"
              .text
              .white
              .make()
              .box
              .color(AppColor.midnightCityLightBlue)
              .roundedSM
              .make(),
        ),
        //
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            FlutterIcons.plus_ant,
            //Icons.minimize,
            size: 14,
            color: Colors.white,
          ).onInkTap(() {
            if (widget.max == null || widget.max! > qty) {
              setState(() {
                qty += 1;
              });
              //
              widget.onChange!(qty);
            }
          }),
        ),
      ],
      alignment: MainAxisAlignment.center,
      crossAlignment: CrossAxisAlignment.center,
    )
        .h(24)
        .box
        .color(AppColor.midnightCityLightBlue)
        .border(color: AppColor.midnightCityLightBlue)
        .rounded
        .make();
  }
}
