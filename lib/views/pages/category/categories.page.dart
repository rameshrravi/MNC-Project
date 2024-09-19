import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/view_models/vendor/categories.vm.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/custom_dynamic_grid_view.dart';
import 'package:midnightcity/widgets/list_items/category.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({this.vendorType, Key? key}) : super(key: key);

  final VendorType? vendorType;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: vendorType!),
      onModelReady: (vm) => vm.initialise(all: true),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showCart: true,
          showLeadingAction: true,
          title: "Categories".tr(),
          body: CustomDynamicHeightGridView(
            noScrollPhysics: true,
            crossAxisCount: AppStrings.categoryPerRow ?? 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            isLoading: vm.isBusy,
            itemCount: vm.categories!.length,
            canPullUp: true,
            canRefresh: true,
            refreshController: vm.refreshController,
            onLoading: vm.loadMoreItems,
            onRefresh: () => vm.loadMoreItems(true),
            padding: EdgeInsets.all(20),
            itemBuilder: (context, index) {
              return Center(
                child: CategoryListItem(
                  category: vm.categories![index],
                  onPressed: vm.categorySelected,
                  maxLine: false,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
