import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midnightcity/models/order.dart';
import 'package:midnightcity/models/order_product.dart';
import 'package:midnightcity/services/toast.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/utils/utils.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class DigitialProductOrderDownload extends StatelessWidget {
  const DigitialProductOrderDownload(this.order, this.orderProduct, {Key? key})
      : super(key: key);

  final Order order;
  final OrderProduct orderProduct;
  @override
  Widget build(BuildContext context) {
    final downloadLink = orderProduct!.product!.digitalFiles![0].link ?? "";
    //
    return Visibility(
      visible: order.isCompleted && orderProduct.product!.isDigital,
      child: HStack(
        [
          CustomButton(
            title: "Download".tr(),
            child: HStack(
              [
                "Download".tr().text.make(),
                UiSpacer.hSpace(10),
                Icon(
                  Icons.access_alarm_outlined,
                  //  FlutterIcons.download_ant,
                  size: 20,
                ),
              ],
            ),
            onPressed: () => openDownloadLink(downloadLink),
          ).box.clip(Clip.antiAlias).roundedLg.make().expand(),
          UiSpacer.hSpace(),
          CustomButton(
            child: Icon(
              Icons.access_alarm_outlined,
              //FlutterIcons.copy_ent,
              size: 20,
              color: Utils.textColorByTheme(),
            ),
            onPressed: () => copyDownloadLink(downloadLink),
          ).box.clip(Clip.antiAlias).roundedLg.make(),
        ],
      ),
    );
  }

  //Link
  copyDownloadLink(downloadLink) {
    try {
      Clipboard.setData(
        ClipboardData(
          text: downloadLink,
        ),
      );
      //
      ToastService.toastSuccessful("Link copied to clipboard".tr());
    } catch (error) {
      ToastService.toastError("$error");
    }
  }

  openDownloadLink(downloadLink) {
    //
    try {
      launchUrlString(
        downloadLink,
        mode: LaunchMode.externalApplication,
      );
    } catch (error) {
      ToastService.toastError("$error");
    }
  }
}
