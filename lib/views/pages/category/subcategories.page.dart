import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/category.dart';
import 'package:midnightcity/view_models/vendor/sub_categories.vm.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/custom_dynamic_grid_view.dart';
import 'package:midnightcity/widgets/list_items/category.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';

class SubcategoriesPage extends StatelessWidget {
  const SubcategoriesPage({this.category, Key? key}) : super(key: key);

  final Category? category;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubcategoriesViewModel>.reactive(
      viewModelBuilder: () => SubcategoriesViewModel(context, category!),
      onModelReady: (vm) => vm.initialise(all: true),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showCart: true,
          showLeadingAction: true,
          title: "Subcategories".tr(),
          body: CustomDynamicHeightGridView(
            noScrollPhysics: true,
            crossAxisCount: AppStrings.categoryPerRow ?? 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            isLoading: vm.isBusy,
            itemCount: vm.subcategories.length,
            canPullUp: true,
            canRefresh: true,
            refreshController: vm.refreshController,
            onLoading: vm.loadMoreItems,
            onRefresh: () => vm.loadMoreItems(true),
            padding: EdgeInsets.all(20),
            itemBuilder: (context, index) {
              return Center(
                child: CategoryListItem(
                  category: vm.subcategories[index],
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
