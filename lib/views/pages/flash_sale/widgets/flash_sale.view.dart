import 'dart:io';

import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/models/flash_sale.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/utils/utils.dart';
import 'package:midnightcity/view_models/flash_sale.vm.dart';
import 'package:midnightcity/views/pages/flash_sale/flash_sale.page.dart';
import 'package:midnightcity/views/pages/flash_sale/widgets/flash_sale.item_view.dart';
import 'package:midnightcity/widgets/busy_indicator.dart';
import 'package:midnightcity/widgets/custom_listed.list_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:slide_countdown/slide_countdown.dart';

class FlashSaleView extends StatefulWidget {
  const FlashSaleView(this.vendorType, {Key? key}) : super(key: key);

  //
  final VendorType vendorType;

  @override
  State<FlashSaleView> createState() => _FlashSaleViewState();
}

class _FlashSaleViewState extends State<FlashSaleView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FlashSaleViewModel>.reactive(
      viewModelBuilder: () =>
          FlashSaleViewModel(context, vendorType: widget.vendorType),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        //
        if (vm.isBusy) {
          return BusyIndicator().p20().centered();
        } else if (vm.flashSales!.isEmpty) {
          return UiSpacer.emptySpace();
        }
        //
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 15),
          child: VStack(
            [
              ...flashSalesListView(context, vm),
              //UiSpacer.verticalSpace(),
            ],
          ),
        );
      },
    );
  }

  //
  List<Widget> flashSalesListView(
    BuildContext context,
    FlashSaleViewModel vm,
  ) {
    List<Widget> list = [];
    List<FlashSale> flashsales = vm.flashSales!;
    //
    flashsales.forEach((flashsale) {
      //
      if (flashsale.items == null ||
          flashsale.items!.isEmpty ||
          flashsale.isExpired) {
        list.add(UiSpacer.emptySpace());
        return;
      }

      Widget title = HStack(
        [
          Icon(
            Icons.ac_unit,
            //   FlutterIcons.local_offer_mdi,
            color: Colors.black,
          ),
          UiSpacer.hSpace(10),
          VStack(
            [
              "${flashsale.name}".text.semiBold.lg.black.make(),
              UiSpacer.vSpace(1),
              HStack(
                [
                  "TIME LEFT:".tr().text.light.sm.black.make(),
                  UiSpacer.hSpace(6),
                  SlideCountdown(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: AppColor.midnightCityDarkBlue),
                    style: TextStyle(
                      fontSize: 11,
                      color: Utils.textColorByColor(AppColor.closeColor!),
                    ),
                    duration: flashsale.countDownDuration,
                    separatorType: SeparatorType.symbol,
                    slideDirection: SlideDirection.up,
                    onDone: () {
                      vm.notifyListeners();
                    },
                  ),
                ],
              ),
            ],
          ).expand(),
          UiSpacer.hSpace(10),
          //
          "SEE ALL".tr().text.black.make().onTap(
                () => openFlashSaleItems(context, flashsale),
              ),
        ],
      ).p12().box.white.border(color: Colors.black).make().wFull(context);
      //categories list
      /*   Widget items = CustomListedListView(
        noScrollPhysics: false,
        scrollDirection: Axis.horizontal,
        items: flashsale.items.map(
          (flashSaleItem) {
            return FittedBox(
              child: FlashSaleItemListItem(flashSaleItem),
            );
          },
        ).toList(),
      ).h(Platform.isAndroid ? 160 : 190);*/

      //
      list.add(
        VStack(
          [
            title,
            UiSpacer.vSpace(10),
          ],
        ),
      );
    });

    return list;
  }

  openFlashSaleItems(BuildContext context, FlashSale flashsale) {
    context.nextPage(FlashSaleItemsPage(flashsale));
  }
}
