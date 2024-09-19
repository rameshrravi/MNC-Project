import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/vendor/categories.vm.dart';
import 'package:midnightcity/views/pages/category/categories.page.dart';
import 'package:midnightcity/widgets/custom_dynamic_grid_view.dart';
import 'package:midnightcity/widgets/list_items/category.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorTypeCategories extends StatefulWidget {
  const VendorTypeCategories(
    this.vendorType, {
    this.title,
    this.description,
    this.showTitle = true,
    this.crossAxisCount,
    this.childAspectRatio,
    Key? key,
  }) : super(key: key);

  //
  final VendorType vendorType;
  final String? title;
  final String? description;
  final bool? showTitle;
  final int? crossAxisCount;
  final double? childAspectRatio;
  @override
  _VendorTypeCategoriesState createState() => _VendorTypeCategoriesState();
}

class _VendorTypeCategoriesState extends State<VendorTypeCategories> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: widget.vendorType),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //

            //categories list
            /*  Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: CustomDynamicHeightGridView(
                crossAxisCount: AppStrings.categoryPerRow,
                itemCount: model.categories.length,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                isLoading: model.isBusy,
                noScrollPhysics: true,
                itemBuilder: (ctx, index) {
                  return CategoryListItem(
                    category: model.categories[index],
                    onPressed: model.categorySelected,
                    maxLine: false,
                  );
                },
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Container(
                height: 700,
                //  width: 300,
                child: ListView.builder(
                  itemCount: model.categories!.length,
                  itemBuilder: (ctx, index) {
                    return CategoryListItem(
                      category: model.categories![index],
                      onPressed: model.categorySelected,
                      maxLine: false,
                    );
                  },
                ),
              ),
            ),
            // CustomGridView(
            //   // scrollDirection: Axis.horizontal,
            //   noScrollPhysics: true,
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   dataSet:
            //       (!isOpen && model.categories.length > widget.lessItemCount)
            //           ? model.categories.sublist(0, widget.lessItemCount)
            //           : model.categories,
            //   isLoading: model.isBusy,
            //   crossAxisCount: widget.crossAxisCount ?? 3,
            //   childAspectRatio: widget.childAspectRatio ?? 1.1,
            //   mainAxisSpacing: 10,
            //   crossAxisSpacing: 10,
            //   itemBuilder: (context, index) {
            //     //
            //     return CategoryListItem(
            //       category: model.categories[index],
            //       onPressed: model.categorySelected,
            //     );
            //   },
            // ),
          ],
        );
      },
    );
  }
}
