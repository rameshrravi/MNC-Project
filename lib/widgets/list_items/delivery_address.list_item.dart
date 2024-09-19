import 'package:flutter/material.dart';
import 'package:midnightcity/models/delivery_address.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class DeliveryAddressListItem extends StatelessWidget {
  const DeliveryAddressListItem({
    this.deliveryAddress,
    this.onEditPressed,
    this.onDeletePressed,
    this.action = true,
    this.border = true,
    this.borderColor,
    this.showDefault = true,
    Key? key,
  }) : super(key: key);

  final DeliveryAddress? deliveryAddress;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final bool? action;
  final bool? border;
  final bool? showDefault;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        HStack(
          [
            //
            VStack(
              [
                deliveryAddress!.name!.text.semiBold.black.lg.make(),
                deliveryAddress!.address!.text.black.sm
                    .maxLines(3)
                    .overflow(TextOverflow.ellipsis)
                    .make(),
                "${deliveryAddress!.description}".text.sm.black.make(),
                (deliveryAddress!.defaultDeliveryAddress! && showDefault!)
                    ? "Default"
                        .tr()
                        .text
                        .black
                        .xs
                        .italic
                        .maxLines(3)
                        .overflow(TextOverflow.ellipsis)
                        .make()
                    : UiSpacer.emptySpace(),
              ],
            ).p12().expand(),
            //
            this.action!
                ? VStack(
                    [
                      //delete icon
                      Icon(
                        //  FlutterIcons.delete_ant,
                        Icons.access_alarm_outlined,
                        size: 16,
                        color: Colors.black,
                      ).wFull(context).onInkTap(this.onDeletePressed!).py12(),
                      //edit icon
                      Icon(
                        // FlutterIcons.edit_ent,
                        Icons.access_alarm_outlined,
                        size: 16,
                        color: Colors.black,
                      ).wFull(context).onInkTap(this.onEditPressed!).py12(),
                    ],
                    axisSize: MainAxisSize.max,
                    // crossAlignment: CrossAxisAlignment.center,
                  ).w(context.percentWidth * 15)
                : UiSpacer.emptySpace(),
          ],
        ),

        //
        //can deliver
        CustomVisibilty(
          visible: deliveryAddress!.can_deliver != null &&
              !deliveryAddress!.can_deliver!,
          child: "Vendor does not service this location"
              .tr()
              .text
              .red500
              .xs
              .thin
              .make()
              .px12()
              .py2(),
        ),
      ],
    );
  }
}
