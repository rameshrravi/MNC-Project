import 'dart:developer';
import 'dart:io';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_upgrade_settings.dart';
import 'package:midnightcity/models/search.dart';
import 'package:midnightcity/services/location.service.dart';
import 'package:midnightcity/utils/utils.dart';
import 'package:midnightcity/views/pages/category/subcategories.page.dart';
import 'package:midnightcity/views/pages/commerce/widgets/commerce_categories_products.view.dart';
import 'package:midnightcity/views/pages/flash_sale/flash_sale.page.dart';
import 'package:midnightcity/views/pages/flash_sale/widgets/flash_sale.view.home.dart';
import 'package:midnightcity/views/pages/food/food.page.dart';
import 'package:midnightcity/views/pages/grocery/widgets/grocery_categories.view.dart';
import 'package:midnightcity/views/pages/grocery/widgets/grocery_picks.view.dart';
import 'package:midnightcity/views/pages/order/orders_tracking.page.dart';
import 'package:midnightcity/views/pages/pharmacy/pharmacy.page.dart';
import 'package:midnightcity/views/pages/pharmacy/widgets/pharmacy_categories.view.dart';
import 'package:midnightcity/views/pages/profile/profile.page.dart';
import 'package:midnightcity/view_models/home.vm.dart';
import 'package:midnightcity/views/pages/search/search.page.dart';
import 'package:midnightcity/views/pages/vendor_details/vendor_category_products.page_new.dart';
import 'package:midnightcity/views/pages/vendor_details/vendor_category_products.page_new_home.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:midnightcity/widgets/list_items/food_horizontal_product.list_item.dart';
import 'package:midnightcity/widgets/list_items/product.list_item.dart';
import 'package:midnightcity/widgets/states/loading.shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import 'package:velocity_x/velocity_x.dart';

import 'category/category_product_page.dart';
import 'grocery/widgets/baronly_categories_products.view.dart';
import 'grocery/widgets/foodonly_categories_products.view.dart';
import 'grocery/widgets/grocery_categories_products.view.dart';
import 'grocery/widgets/groceryonly_categories_products.view.dart';
import 'grocery/widgets/pharmaonly_categories_products.view.dart';
import 'order/orders.page.dart';
import 'order/orders.page.profile.dart';
import 'order/orders_details.page.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = HomeViewModel(context);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        LocationService.prepareLocationListener();
        vm.initialise();
      },
    );
    super.initState();
  }

  VendorType vendorType = VendorType.fromJson(AppStrings.enabledVendorType);
  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: "Press back again to close".tr(),
      child: ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => vm,
        builder: (context, model, child) {
          //debugger();
          return model.vendors.isEmpty && vm.dvendor.categories == null
              ? LoadingShimmer().px20().h(200)
              : vm.dvendor.categories!.length == 0
                  ? LoadingShimmer().px20().h(200)
                  : BasePage(
                      //showCart: true,
                      body: UpgradeAlert(
                        upgrader: Upgrader(),
                        // upgrader: Upgrader(
                        //   showIgnore: !AppUpgradeSettings.forceUpgrade(),
                        //   shouldPopScope: () => !AppUpgradeSettings.forceUpgrade(),
                        //   dialogStyle: Platform.isIOS
                        //       ? UpgradeDialogStyle.cupertino
                        //       : UpgradeDialogStyle.material,
                        // ),
                        child: PageView(
                          controller: model.pageViewController,
                          onPageChanged: model.onPageChanged,
                          children: [
                            model.homeView,
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: SafeArea(
                                child: Container(
                                    height:
                                        MediaQuery.of(context).size.height * .9,
                                    child: CategoryProductsPage(
                                      category: vm.dvendor!.categories![0],
                                      vendor: vm.dvendor,
                                      screens: "home",
                                    )),

                                // VendorCategoryProductsPageNewHome(
                                //   vendor: vm.dvendor,
                                //   category: vm.dvendor.categories![0],
                                // )
                                //,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: SafeArea(
                                child: Container(
                                    height:
                                        MediaQuery.of(context).size.height * .9,
                                    child: CategoryProductsPage(
                                      category: vm.dvendor!.categories![1],
                                      vendor: vm.dvendor,
                                      screens: "home",
                                    )

                                    // VendorCategoryProductsPageNewHome(
                                    //   vendor: vm.dvendor,
                                    //   category: vm.dvendor.categories![1],
                                    // )

                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: SafeArea(
                                child: SingleChildScrollView(
                                    child: FlashSaleViewHome(vendorType)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: SafeArea(
                                child: OrdersPage(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      bottomNavigationBar: VxBox(
                        child: SafeArea(
                          child: Container(
                              padding: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width - 30,
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  color: Colors.white),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        vm.currentIndex = 0;
                                      });
                                      model.onTabChange(vm.currentIndex);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Opacity(
                                        opacity:
                                            vm.currentIndex == 0 ? .99 : .4,
                                        child: Column(children: [
                                          Icon(
                                            Icons.home,
                                            size:
                                                vm.currentIndex == 0 ? 22 : 22,
                                            color: vm.currentIndex == 0
                                                ? AppColor.midnightCityYellow
                                                : AppColor.midnightCityDarkBlue,
                                          ),
                                          Text("Home",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: vm.currentIndex == 0
                                                      ? AppColor
                                                          .midnightCityYellow
                                                      : Colors.black))
                                        ]),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        vm.currentIndex = 1;
                                      });
                                      model.onTabChange(vm.currentIndex);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Opacity(
                                        opacity:
                                            vm.currentIndex == 1 ? .99 : .4,
                                        child: Column(children: [
                                          vm.currentIndex == 1
                                              ? Image.asset(
                                                  "assets/images/restarunt_yellow.png",
                                                  width: 24)
                                              : Image.asset(
                                                  "assets/images/restarunt_darkblue.png",
                                                  width: 24),
                                          Text("Restaurant",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: vm.currentIndex == 1
                                                      ? AppColor
                                                          .midnightCityYellow
                                                      : Colors.black))
                                        ]),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        vm.currentIndex = 2;
                                      });
                                      model.onTabChange(vm.currentIndex);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Opacity(
                                        opacity:
                                            vm.currentIndex == 2 ? .99 : .4,
                                        child: Column(children: [
                                          vm.currentIndex == 2
                                              ? Image.asset(
                                                  "assets/images/groceries_yellow.png",
                                                  width: 22)
                                              : Image.asset(
                                                  "assets/images/groceries_blue.png",
                                                  width: 22),
                                          Text("Groceries",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: vm.currentIndex == 2
                                                      ? AppColor
                                                          .midnightCityYellow
                                                      : Colors.black))
                                        ]),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        vm.currentIndex = 3;
                                      });
                                      model.onTabChange(vm.currentIndex);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Opacity(
                                        opacity:
                                            vm.currentIndex == 3 ? .99 : .4,
                                        child: Column(children: [
                                          vm.currentIndex == 3
                                              ? Image.asset(
                                                  "assets/images/offers_yellow.png",
                                                  width: 22)
                                              : Image.asset(
                                                  "assets/images/offers_blue.png",
                                                  width: 22),
                                          Text("Offers",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: vm.currentIndex == 3
                                                      ? AppColor
                                                          .midnightCityYellow
                                                      : Colors.black))
                                        ]),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        vm.currentIndex = 4;
                                      });
                                      model.onTabChange(vm.currentIndex);
                                    },
                                    child: Opacity(
                                      opacity: vm.currentIndex == 4 ? .99 : .4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(children: [
                                          vm.currentIndex == 4
                                              ? Image.asset(
                                                  "assets/images/orders_yellow.png",
                                                  width: 22)
                                              : Image.asset(
                                                  "assets/images/orders_blue.png",
                                                  width: 22),
                                          Text("Orders",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: vm.currentIndex == 4
                                                      ? AppColor
                                                          .midnightCityYellow
                                                      : Colors.black))
                                        ]),
                                      ),
                                    ),
                                  ),
                                ],
                              )

                              /*   GNav(

                    tabBorderRadius: 0,
                    // tabActiveBorder: Border.all(color: Colors.black, width: 1), // tab button border
                    // tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
                    tabShadow: [BoxShadow(color: Colors.white, blurRadius: 8)],
                    backgroundColor: AppColor.white,
                    curve: Curves.easeOutExpo,
                    gap: 0,
                    tabActiveBorder: Border.all(color: AppColor.midnightCityLightBlue),
                    activeColor: AppColor.midnightCityYellow,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    iconSize: 1,
                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    duration: Duration(milliseconds: 500),
                    tabBackgroundColor: AppColor.white,
                    tabs: [

                      GButton(

                        hoverColor: AppColor.midnightCityYellow,
                        text: "Home",


                        textStyle: TextStyle(
                          fontSize: 14,
                          color:AppColor.midnightCityYellow
                        ),

                       style: GnavStyle.google,

                       leading: Column(
                         children: [
                           Icon(Icons.home_filled,size: 22,),
                         ],
                       ),

                      ),

                      GButton(
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: AppColor.midnightCityYellow
                        ),

                      text: ''.tr(),

                        leading: Column(
                          children: [
                            Image.asset("assets/images/restarunt_darkblue.png",
                            width: 40,height: 40,),
                            Text("Restaurant",style: TextStyle(
                                fontSize: 30,
                                color: AppColor.midnightCityYellow
                            ),),
                          ],
                      ),
                        hoverColor: AppColor.midnightCityYellow,
                      ),
                      GButton(
                          hoverColor: AppColor.midnightCityYellow,
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: AppColor.midnightCityYellow
                        ),
                        icon: Icons.local_grocery_store,
                        iconColor: AppColor.black25,
                            iconSize:22 ,

                        text: ''.tr(),

                          leading: Column(
                            children: [
                              Image.asset("assets/images/restarunt_darkblue.png",),
                              Text("Groceries",
                                style: TextStyle(
                                    fontSize: 30,
                                    color:
                                    model.currentIndex == 2
                                    ?AppColor.midnightCityYellow
                                        : Colors.black
                                ),),
                            ],
                          )

                      ),
                      GButton(
                          hoverColor: AppColor.midnightCityYellow,
                       // icon: Icons.local_offer_rounded,
                      //  iconColor: AppColor.black25,
                        //  iconSize:22 ,


                          leading: Column(
                            children: [
                              Icon( Icons.local_offer_rounded),
                              Text("Offers"),
                            ],
                          )

                      ),
                      GButton(

                        textStyle: TextStyle(
                            fontSize: 14,
                            color: AppColor.midnightCityYellow
                        ),
                        icon: Icons.list_alt_outlined,
                        iconColor: AppColor.black25,
                          iconSize:1 ,

                        hoverColor: AppColor.midnightCityYellow,
                          leading: Column(
                            children: [
                              Icon( Icons.list_alt_outlined,


                              ),
                              Text("Orders"),
                            ],
                          )
                      ),
                    ],
                    selectedIndex: model.currentIndex,
                    onTabChange: model.onTabChange,
                  ), */

                              ),
                        ),
                      ).shadow.color(AppColor.mainBackground).make(),
                    );
        },
      ),
    );
  }
}
