import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

///import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constants/app_colors.dart';

class ToogleGridViewIcon extends StatefulWidget {
  ToogleGridViewIcon({
    this.showGrid = false,
    this.onchange,
    Key? key,
  }) : super(key: key);

  final bool showGrid;
  final Function(bool)? onchange;
  @override
  State<ToogleGridViewIcon> createState() => _ToogleGridViewIconState();
}

class _ToogleGridViewIconState extends State<ToogleGridViewIcon> {
  bool showGrid = false;

  @override
  void initState() {
    super.initState();
    showGrid = widget.showGrid;
  }

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        CustomVisibilty(
          visible: showGrid,
          child: Icon(
            //Icons.list,
            FlutterIcons.list_fea,
            size: 20,
            color: AppColor.midnightCityLightBlue,
          ),
        ),

        //
        CustomVisibilty(
          visible: !showGrid,
          child: Icon(
            //Icons.list,
            FlutterIcons.grid_fea,
            size: 20,
            color: AppColor.midnightCityLightBlue,
          ),
        ),
      ],
    )
        .p8()
        .onInkTap(
          () {
            setState(() {
              showGrid = !showGrid;
            });
            //
            if (widget.onchange != null) {
              widget.onchange!(showGrid)!;
            }
          },
        )
        .material(color: context.backgroundColor)
        .box
        .outerShadowSm
        .roundedSM
        .clip(Clip.antiAlias)
        .color(context.backgroundColor)
        .make();
  }
}
