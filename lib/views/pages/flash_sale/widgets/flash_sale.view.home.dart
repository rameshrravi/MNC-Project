import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:flutter_icons/flutter_icons.dart';
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

class FlashSaleViewHome extends StatefulWidget {
  const FlashSaleViewHome(this.vendorType, {Key? key}) : super(key: key);

  //
  final VendorType vendorType;

  @override
  State<FlashSaleViewHome> createState() => _FlashSaleViewHomeState();
}

class _FlashSaleViewHomeState extends State<FlashSaleViewHome> {
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
          return Center(
            child:
                "Sorry! No Offers Avaiable Now".text.semiBold.black.lg.make(),
          );
        }
        //
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 50, right: 12),
            child: VStack(
              [
                ...flashSalesListView(context, vm),
                //UiSpacer.verticalSpace(),
              ],
            ),
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
          /*   Icon(
            FlutterIcons.sale_mco,
            color: Utils.textColorByColor(AppColor.closeColor),
          ),*/
          // UiSpacer.hSpace(10),
          VStack(
            [
              HStack(
                [
                  "${flashsale.name}".text.semiBold.black.lg.make(),
                  UiSpacer.vSpace(1),
                  UiSpacer.hSpace(6),
                ],
              ),
            ],
          ).expand(),
          UiSpacer.hSpace(10),
          //
          VStack(
            [
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
              SizedBox(
                height: 10,
              ),
              "View All Offers".tr().text.black.make().onTap(
                    () => openFlashSaleItems(context, flashsale),
                  ),
            ],
            alignment: MainAxisAlignment.end,
            crossAlignment: CrossAxisAlignment.end,
          )
        ],
      ).p12().box.border(color: Vx.gray300).white.make().wFull(context);
      //categories list
      Widget items = CustomListedListView(
        noScrollPhysics: false,
        scrollDirection: Axis.horizontal,
        items: flashsale.items!.map(
          (flashSaleItem) {
            return FittedBox(
              child: FlashSaleItemListItem(flashSaleItem),
            );
          },
        ).toList(),
      ).h(Platform.isAndroid ? 160 : 190);

      //
      list.add(
        VStack(
          [
            title,
            items,
            UiSpacer.vSpace(30),
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
