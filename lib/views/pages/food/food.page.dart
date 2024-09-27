import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/enums/product_fetch_data_type.enum.dart';
import 'package:midnightcity/models/search.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/vendor.vm.dart';
import 'package:midnightcity/views/pages/flash_sale/widgets/flash_sale.view.dart';
import 'package:midnightcity/views/pages/vendor/widgets/banners.view.dart';
import 'package:midnightcity/views/pages/vendor/widgets/categories.view.dart';
import 'package:midnightcity/views/pages/vendor/widgets/header.view.dart';
import 'package:midnightcity/views/pages/vendor/widgets/section_products.view.dart';
import 'package:midnightcity/views/pages/vendor/widgets/section_vendors.view.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/cards/view_all_vendors.view.dart';
import 'package:midnightcity/widgets/inputs/search_bar.input.dart';
import 'package:midnightcity/widgets/list_items/food_horizontal_product.list_item.dart';
import 'package:midnightcity/widgets/list_items/grid_view_product.list_item.dart';
import 'package:midnightcity/widgets/list_items/horizontal_product.list_item.dart';
import 'package:midnightcity/widgets/list_items/horizontal_vendor.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/models/vendor.dart';

import 'package:midnightcity/views/pages/vendor/widgets/best_selling_products.view.dart';
import 'package:midnightcity/views/pages/grocery/widgets/grocery_categories.view.dart';
import 'package:midnightcity/views/pages/grocery/widgets/grocery_categories_products.view.dart';
import 'package:midnightcity/views/pages/grocery/widgets/grocery_picks.view.dart';
import 'package:midnightcity/constants/app_routes.dart';
import '../../../services/auth.service.dart';
import '../search/search.page.dart';
import '../vendor/widgets/categories_vendors.view.dart';
import '../vendor_details/vendor_category_products.page.dart';
import '../vendor_details/vendor_details.page.dart';
import '../vendor_details/widgets/vendor_with_menu.view.dart';
import '../vendor_details/widgets/vendor_with_subcategory.view_new.dart';
import '../vendor_details/widgets/vendor_with_subcategory.view.dart';

class FoodPage extends StatefulWidget {
  const FoodPage(this.vendorType, {Key? key}) : super(key: key);

  final VendorType vendorType;
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage>
    with AutomaticKeepAliveClientMixin<FoodPage> {
  GlobalKey pageKey = GlobalKey<State>();
  int? v_id;

  init() async {
    String branch = await AuthServices.getPrefBranch();

    v_id = int.parse(branch);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage(
      showAppBar: false,
      showLeadingAction: !AppStrings.isSingleVendorMode,
      elevation: 0,
      // title: "${widget.vendorType.name}",
      // appBarColor: context.theme.backgroundColor,
      // appBarItemColor: AppColor.primaryColor,
      // showCart: true,
      key: pageKey,
      body: ViewModelBuilder<VendorViewModel>.reactive(
        viewModelBuilder: () => VendorViewModel(context, widget.vendorType),
        // onModelReady: (model) => model.initialise(),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          return SafeArea(
            child: VStack(
              [
                //location section
                VendorHeader(
                  model: model,
                  showSearch: false,
                  vendorBusyState: model.dvendor.is_busy!,
                ),
                SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  controller: model.refreshController,
                  onRefresh: () {
                    model.refreshController.refreshCompleted();
                    setState(() {
                      pageKey = GlobalKey<State>();
                    });
                  },
                  child: VStack(
                    [
                      //  search bar
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Center(
                          child: Text(
                            "Welcome to " + model.dvendor.name!,
                            style: const TextStyle(
                                color: AppColor.midnightCityDarkBlue,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(
                                  search: Search(viewType: SearchType.products),
                                  showCancel: false,
                                ),
                              ));
                        },
                        child: Center(
                          child: Container(
                              height: 50,
                              width: context.screenWidth - 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Icon(
                                      Icons.search,
                                      size: 25,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Container(
                                      width: context.screenWidth - 120,
                                      child: Text(
                                        "Search for your desired foods or items",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12),
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ),
                                ],
                              ))),
                        ),
                      ),

                      /*   SearchBarInput(
                        hintText:
                            "Search for your desired foods or items".tr(),
                        readOnly: true,
                        search: Search(
                          vendorType: widget.vendorType,
                         // viewType: SearchType.vendorProducts,
                        ),
                      ).px20(),*/
                      UiSpacer.verticalSpace(),
                      //banners
                      Banners(
                        widget.vendorType,
                        viewportFraction: .9,
                      ),
                      // Popular Categories
                      /*      Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, right: 15, left: 15),
                        child: Text("Popular Categories",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0),
                            textAlign: TextAlign.left),
                      ),*/
                      // GroceryCategories(widget.vendorType),
                      //categories
                      Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20.0),
                        child:
                            CategoriesVendor(widget.vendorType, model.dvendor),
                      ),

/*
                      Container(
                          height: 500,
                          child: VendorDetailsWithSubcategoryPage(vendor:model.vendor)),
                        */
                      /* Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15),
                        child: Categories(
                          widget.vendorType,
                        ),
                      ),*/
                      //flash sales products
                      GroceryCategoryProducts(
                        widget.vendorType,
                        model.dvendor,
                        length: 10,
                      ),
                      //VendorDetailsWithMenuPage(),
                      //popular vendors
                      /* SectionVendorsView(
                        widget.vendorType,
                        title: "Popular vendors".tr(),
                        scrollDirection: Axis.horizontal,
                        type: SearchFilterType.sales,
                        itemWidth: context.percentWidth * 60,
                        byLocation: AppStrings.enableFatchByLocation,
                      ),*/
                      //campain vendors
                      /*    SectionProductsView(
                        widget.vendorType,
                        title: "Campaigns".tr(),
                        scrollDirection: Axis.horizontal,
                        type: ProductFetchDataType.FLASH,
                        itemWidth: context.percentWidth * 38,
                        viewType: GridViewProductListItem,
                        byLocation: false,//AppStrings.enableFatchByLocation,
                      ),*/
                      /*  Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, right: 15, left: 15),
                        child: Text("Must Try - Popular Foods",
                            style: const TextStyle(
                                color: AppColor.primaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0),
                            textAlign: TextAlign.left),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, right: 15, left: 15),
                        child: Text("explore these exciting finds",
                            style: const TextStyle(
                                color: AppColor.primaryTextColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            textAlign: TextAlign.left),
                      ),*/
                      //popular foods
                      /*   SectionProductsView(
                        widget.vendorType,
                        //  title: "Popular Foods".tr(),
                        scrollDirection: Axis.horizontal,
                        type: ProductFetchDataType.BEST,
                        itemWidth: context.percentWidth * 70,
                        itemHeight: 120,
                        viewType: FoodHorizontalProductListItem,
                        listHeight: 115,
                        byLocation: AppStrings.enableFatchByLocation,
                      ),*/
                      //new vendors
                      CustomVisibilty(
                        visible: false, // !AppStrings.enableSingleVendor,
                        child: Center(
                          child: SectionVendorsView(
                            widget.vendorType,
                            title:
                                "Our Locations", //"New on".tr() + " ${AppStrings.appName}",
                            scrollDirection: Axis.vertical,
                            //   type: SearchFilterType.,
                            itemWidth: context.percentWidth * 60,
                            byLocation: AppStrings.enableFatchByLocation,
                          ),
                        ),
                      ),

                      //    Container(),

                      //   VendorDetailsPage(vendor: model.dvendor),
                      //all vendor
                      /*    CustomVisibilty(
                        visible: !AppStrings.enableSingleVendor,
                        child: SectionVendorsView(
                          widget.vendorType,
                          title: "All Vendors/Restaurants".tr(),
                          scrollDirection: Axis.vertical,
                          type: SearchFilterType.best,
                          viewType: HorizontalVendorListItem,
                          separator: UiSpacer.verticalSpace(space: 0),
                        ),
                      ),*/
                      //all products
                      /*  GroceryProductsSectionView(
                        "Best Selling".tr() ,

                        model.vendorType,
                        showGrid: true,
                        type: ProductFetchDataType.BEST,
                        crossAxisCount: 2,
                      ),*/
                      // BestSellingProducts(widget.vendorType),
                      /*  Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: FlashSaleView(widget.vendorType),
                      ),*/
                      CustomVisibilty(
                        visible: AppStrings.enableSingleVendor,
                        child: SectionProductsView(
                          widget.vendorType,
                          title: "All Products".tr(),
                          scrollDirection: Axis.vertical,
                          type: ProductFetchDataType.BEST,
                          viewType: HorizontalProductListItem,
                          separator: UiSpacer.verticalSpace(space: 0),
                          listHeight: 0.0,
                        ),
                      ),
                      //view all vendors
                      ViewAllVendorsView(
                        vendorType: widget.vendorType,
                        vendorID: model.dvendor.id,
                      ),
                      UiSpacer.verticalSpace(),
                      /*  Container(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                child: Image.asset('assets/images/restaurant.png'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                child: Image.asset('assets/images/grocery.png'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                child: Image.asset('assets/images/pharmacy.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 34.49, right: 275.0),
                        child: Text(
                          "Must try",

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 05.0, right: 195.0),
                        child: Text(
                          "explore these exciting finds",

                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 140,
                            child: Image.asset(
                              'assets/images/stepcils.png',
                            ),
                          ),
                          Container(
                            height: 140,
                            child: Image.asset('assets/images/golden_morn.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Color(0xffF8F8F8),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: Colors.black,
                                    size: 50,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("View more",

                                ),
                                )],
                            ),
                          )
                        ],
                      )*/
                    ],
                    // key: model.pageKey,
                  ).scrollVertical(),
                ).expand(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
