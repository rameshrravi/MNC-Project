import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/models/option_group.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/product_bought_together.vm.dart';
import 'package:midnightcity/view_models/product_details.vm.dart';
import 'package:midnightcity/views/pages/product/widgets/amazon/frequently_bought_together.view.dart';
import 'package:midnightcity/views/pages/product/widgets/product_details.header.dart';
import 'package:midnightcity/views/pages/product/widgets/product_details_cart.bottom_sheet.dart';
import 'package:midnightcity/views/pages/product/widgets/product_option_group.dart';
import 'package:midnightcity/views/pages/product/widgets/product_options.header.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/busy_indicator.dart';
import 'package:midnightcity/widgets/buttons/share.btn.dart';
import 'package:midnightcity/widgets/cart_page_action.dart';
import 'package:midnightcity/widgets/custom_image.view.dart';
import 'package:midnightcity/widgets/html_text_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/currency_hstack.dart';

import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/extensions/dynamic.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/constants/app_strings.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({this.product, Key? key}) : super(key: key);

  final Product? product;
  final currencySymbol = AppStrings.currencySymbol;
  //
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductDetailsViewModel>.reactive(
      viewModelBuilder: () => ProductDetailsViewModel(context, product!),
      //onModelReady: (model) => model.getProductDetails(),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          // title: model.product.name,
          showAppBar: true,
          showLeadingAction: true,
          elevation: 0,
          appBarColor: Colors.black,
          appBarItemColor: Colors.black,
          showCart: true,
          actions: [
            SizedBox(
              width: 50,
              height: 50,
              child: FittedBox(
                child: ShareButton(
                  model: model,
                ),
              ),
            ),
            UiSpacer.hSpace(10),
            PageCartAction(),
          ],
          body: CustomScrollView(
            slivers: [
              //product image
              SliverToBoxAdapter(
                child: Hero(
                  tag: model.product.heroTag!,
                  child: BannerCarousel(
                    customizedBanners: model.product.photos!.map((photoPath) {
                      return Container(
                        child: CustomImage(
                          imageUrl: photoPath,
                          boxFit: BoxFit.contain,
                          canZoom: true,
                        ),
                      );
                    }).toList(),
                    customizedIndicators: IndicatorModel.animation(
                      width: 10,
                      height: 6,
                      spaceBetween: 2,
                      widthAnimation: 50,
                    ),
                    margin: EdgeInsets.zero,
                    height: context.percentHeight * 30,
                    width: context.percentWidth * 100,
                    activeColor: AppColor.primaryColor,
                    disableColor: Colors.grey.shade300,
                    animation: true,
                    borderRadius: 0,
                    indicatorBottom: true,
                  ).box.color(Colors.white).make(),
                ),
              ),

              SliverToBoxAdapter(
                child: VStack(
                  [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: HStack(
                        [
                          product!.name!.text
                              .color(Colors.black)
                              .fontWeight(FontWeight.w500)
                              .fontFamily("Poppins")
                              .size(20)
                              .make(),
                          Spacer(),
                          CustomButton(
                            elevation: 0,
                            color: AppColor.mainBackground,
                            loading: model.isBusy,
                            child: Icon(
                              model.product.isFavourite!
                                  ? FlutterIcons.favorite_mdi
                                  : FlutterIcons.favorite_border_mdi,
                              color: AppColor.midnightCityLightBlue,
                            ),
                            onPressed: !model.isAuthenticated()
                                ? model.openLogin
                                : !model.product.isFavourite!
                                    ? model.addToFavourite
                                    : model.removeFromFavourite,
                          )
                        ],
                        alignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, left: 20),
                      child: HStack([
                        CustomVisibilty(
                          visible: product!.showDiscount,
                          child: CurrencyHStack(
                            [
                              product!.price
                                  .currencyValueFormat()
                                  .text
                                  .lineThrough
                                  .color(Colors.black)
                                  .fontFamily("Poppins")
                                  .fontWeight(FontWeight.w600)
                                  .size(18)
                                  .make(),
                              currencySymbol.text
                                  .color(Colors.black)
                                  .fontFamily("Poppins")
                                  .fontWeight(FontWeight.w600)
                                  .size(18)
                                  .make(),
                            ],
                          ),
                        ),
                        CurrencyHStack(
                          [
                            (product!.showDiscount
                                    ? product!.discountPrice!
                                        .currencyValueFormat()
                                    : product!.price.currencyValueFormat())
                                .text
                                .color(Colors.black)
                                .fontFamily("Poppins")
                                .fontWeight(FontWeight.w600)
                                .size(18)
                                .make(),
                            currencySymbol.text
                                .color(Colors.black)
                                .fontFamily("Poppins")
                                .fontWeight(FontWeight.w600)
                                .size(18)
                                .make(),
                            " ".text.make(),
                          ],
                          crossAlignment: CrossAxisAlignment.end,
                        ),
                        Spacer(),
                        Visibility(
                          visible: model.product.hasStock,
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColor.midnightCityYellow,
                                borderRadius: BorderRadius.circular(12)),
                            child: VxStepper(
                              actionButtonColor: AppColor.midnightCityYellow,
                              inputBoxColor: AppColor.midnightCityYellow,
                              defaultValue: model.product.selectedQty ?? 1,
                              min: 1,
                              max: (model.product.availableQty != null &&
                                      model.product.availableQty! > 0)
                                  ? model.product.availableQty!
                                  : 20,
                              disableInput: true,
                              onChange: model.updatedSelectedQty,
                            ),
                          ),
                        ),
                      ]),
                    ),

                    //discount

                    //product header
                    /*   ProductDetailsHeader(product: model.product),*/
                    //product description
                    UiSpacer.divider(height: 4, thickness: 5).py12(),
                    HtmlTextView(model.product.description!),
                    UiSpacer.divider(height: 4, thickness: 5).py12(),

                    //options header
                    Visibility(
                      visible: model.product.optionGroups!.isNotEmpty,
                      child: VStack(
                        [
                          ProductOptionsHeader(
                            description: "Select add ons :".tr(),
                          ),

                          //options
                          model.busy(model.product)
                              ? BusyIndicator().centered().py20()
                              : VStack(
                                  [
                                    ...buildProductOptions(model),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FrequentlyBoughtTogetherView(this.product!),
                    )
                    //more from vendor
                    /*    OutlinedButton(
                      onPressed: model.openVendorPage,
                      child: "View more from"
                          .tr()
                          .richText
                          .sm
                          .withTextSpanChildren(
                            [
                              " ${model.product.vendor.name}"
                                  .textSpan
                                  .semiBold
                                  .make(),
                            ],
                          )
                          .make()
                          .py12(),
                    ).centered().py16(),*/
                  ],
                )
                    .pOnly(bottom: context.percentHeight * 30)
                    .box
                    .outerShadow3Xl
                    .color(AppColor.mainBackground)
                    .topRounded(value: 20)
                    .clip(Clip.antiAlias)
                    .make(),
              ),
            ],
          ).box.color(AppColor.mainBackground).make(),
          bottomSheet: ProductDetailsCartBottomSheet(model: model),
        );
      },
    );
  }

  //
  buildProductOptions(model) {
    return model.product.optionGroups.map((OptionGroup optionGroup) {
      return ProductOptionGroup(optionGroup: optionGroup, model: model)
          .pOnly(bottom: Vx.dp12);
    }).toList();
  }
}
