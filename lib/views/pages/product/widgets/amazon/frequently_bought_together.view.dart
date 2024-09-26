import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/product_bought_together.vm.dart';
import 'package:midnightcity/views/pages/product/amazon_styled_commerce_product_details.page.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:midnightcity/widgets/custom_list_view.dart';
import 'package:midnightcity/widgets/list_items/frequent_bought_product.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:midnightcity/widgets/list_items/grid_view_product.list_item.dart';
import 'package:midnightcity/widgets/list_items/product.list_item.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../../constants/app_routes.dart';
import '../../../../../widgets/list_items/food_product.list_item.dart';
import '../../product_details.page.dart';

class FrequentlyBoughtTogetherView extends StatelessWidget {
  const FrequentlyBoughtTogetherView(this.product, {Key? key})
      : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductBoughtTogetherViewModel>.reactive(
      viewModelBuilder: () => ProductBoughtTogetherViewModel(context, product),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return CustomVisibilty(
          visible: vm.products.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              "You might also like".tr().text.black.bold.make().px20(),
              UiSpacer.vSpace(10),
              VStack(
                [
                  /*   Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    // alignment: WrapAlignment.center,
                    children: [
                      ...(_itemsListView(vm.products, context)),
                    ],
                  ).p12(),*/
                  //collapsed
                  UiSpacer.divider(),
                  /*  CustomVisibilty(
                    visible: true,// !vm.expanded,
                    child: HStack(
                      [

                        //
                       HStack(
                          [
                          //  "Buy Together:".tr().text.make(),
                            UiSpacer.hSpace(6),
                            "${AppStrings.currencySymbol} ${vm.totalSellPrice}"
                                .currencyFormat()
                                .text
                                .scale(1.3)
                                .color(AppColor.primaryColor)
                                .semiBold
                                .make(),
                          ],
                          crossAlignment: CrossAxisAlignment.center,
                          alignment: MainAxisAlignment.center,
                        ).expand(),
                        //expand icon
                        Icon(
                          FlutterIcons.chevron_down_fea,
                          size: 20,
                        ),
                      ],
                    ).onTap(vm.toggleExpanded).p12(),
                  ), */
                  //expaned
                  VStack(
                    [
                      CustomListView(
                        noScrollPhysics: true,
                        dataSet: vm.products,
                        itemBuilder: (ctx, index) {
                          return Container(
                            //   color: Colors.blue,
                            width: MediaQuery.of(context).size.width * .9,
                            child: InkWell(
                              onTap: () {
                                // print("fadfasdf");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => ProductDetailsPage(
                                          product: vm.products[index]),
                                    ));
                              },
                              child: Container(
                                //   color: Colors.green,
                                height: 120,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: FoodProductListItem(
                                    product: vm.products[index],
                                    qtyUpdated: vm.addToCartDirectly,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (ctx, index) => UiSpacer.divider(),
                      ),

                      /*    VStack(
                        [
                          //total price
                          HStack(
                            [
                              "Total price:".tr().text.make(),
                              UiSpacer.hSpace(6),
                              "${AppStrings.currencySymbol} ${vm.totalSellPrice}"
                                  .currencyFormat()
                                  .text
                                  .scale(1.3)
                                  .color(AppColor.primaryColor)
                                  .semiBold
                                  .make(),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                            alignment: MainAxisAlignment.center,
                          ).wFull(context),
                          UiSpacer.vSpace(15),
                          //add them to cart
                          CustomButton(
                            loading: vm.busy(vm.selectedProducts),
                            title: "Add all to Cart".tr(),
                            onPressed: vm.addFrequentBoughtToCart,
                          ).wFull(context)
                        ],
                      ).p20()*/
                    ],
                  ),
                ],
              ).px20(),

              //list
              UiSpacer.divider(height: 4, thickness: 5).py12(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _itemsListView(List<Product> products, BuildContext context) {
    List<Widget> items = [];
    for (var i = 0; i < products.length; i++) {
      Widget item = CustomImage(
        imageUrl: products[i].photo,
        width: 70,
        height: 70,
      ).onTap(
        () {
          context.nextPage(
            AmazonStyledCommerceProductDetailsPage(product: products[i]),
          );
        },
      ).pOnly(bottom: Vx.dp16);
      items.add(item);
      //add the plus
      if (i != (products.length - 1)) {
        item = Icon(
          FlutterIcons.plus_faw5s,
          size: 15,
          color: Vx.gray500,
        ).p8();
        items.add(item);
      }
    }
    return items;
  }
}
