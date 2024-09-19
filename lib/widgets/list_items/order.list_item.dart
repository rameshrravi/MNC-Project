import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/extensions/dynamic.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/order.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp/whatsapp.dart';
import 'dart:io';

class OrderListItem extends StatelessWidget {
  const OrderListItem({
    this.order,
    this.onPayPressed,
    this.orderPressed,
    Key? key,
  }) : super(key: key);

  final Order? order;
  final Function? onPayPressed;
  final VoidCallback? orderPressed;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        HStack(
          [
            //
            VStack(
              [
                //
                HStack(
                  [
                    "#${order!.code}".text.medium.make().expand(),
                    "${AppStrings.currencySymbol} ${order!.total}"
                        .currencyFormat()
                        .text
                        .lg
                        .semiBold
                        .make(),
                  ],
                ),
                Divider(height: 4),

                //
                // "${order.vendor.name}".text.lg.medium.make().py4(),
                //amount and total products
                HStack(
                  [
                    (order!.isPackageDelivery!
                            ? order!.packageType!.name!
                            : order!.isSerice!
                                ? "${order?.orderService?.service?.category?.name}"
                                : "%s Product(s)"
                                    .tr()
                                    .fill([order!.orderProducts!.length ?? 0]))
                        .text
                        .medium
                        .make()
                        .expand(),
                    "${order!.status}"
                        .tr()
                        .allWordsCapitilize()
                        .text
                        .color(
                          AppColor.getStausColor(order!.status!),
                        )
                        .medium
                        .make(),
                  ],
                ),
                //time & status
                HStack(
                  [
                    //time
                    Visibility(
                      visible: order!.paymentMethod != null,
                      child: "${order!.paymentMethod?.name}".text.medium.make(),
                    ).expand(),
                    // VxTextBuilder(Jiffy(order.createdAt).format('dd E, MMM y'))
                    //     .sm
                    //     .make(),
                    //EEEE dd MMM yyyy
                  ],
                ),
              ],
            ).p12().expand(),
          ],
        ),

        //
        //payment is pending
        order!.isPaymentPending!
            ? Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*  CustomButton(
                      title: "PAY FOR ORDER".tr(),
                      titleStyle: context.textTheme.bodyText1.copyWith(
                        color: Colors.white,
                      ),
                      icon: FlutterIcons.credit_card_fea,
                      iconSize: 18,
                      onPressed: onPayPressed,
                      shapeRadius: 0,
                    ),*/
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          height: 20,
                          title: "Confirm payment".tr(),
                          titleStyle: context.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                          //icon: FlutterIcons.payment_mdi,
                          icon: Icons.ac_unit_sharp,
                          iconColor: Colors.white,
                          iconSize: 18,
                          onPressed: onPayPressed,
                          shapeRadius: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : UiSpacer.emptySpace(),
      ],
      crossAlignment: CrossAxisAlignment.center,
    )
        .box
        .color(AppColor.white)
        // .border(color: Colors.grey[200])
        .make()
        .onInkTap(orderPressed)
        .card
        .elevation(0.5)
        .clip(Clip.antiAlias)
        .roundedSM
        .make();
  }

  _openwhatsapp() async {
    var whatsapp = "+2348139175717";
    var whatsappURl_android = "whatsapp://send?phone=" +
        whatsapp +
        "&text=Hi Crunchr team, In-app support needed";
    var whatappURL_ios =
        "https://wa.me/$whatsapp?text=${Uri.parse("Hi Crunchr team, In-app support needed")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        SnackBar(content: new Text("Whatsapp not installed"));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        SnackBar(content: new Text("Whatsapp not installed"));
      }
    }
  }
}
