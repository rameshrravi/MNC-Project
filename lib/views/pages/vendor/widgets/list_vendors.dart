import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/search.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/view_models/vendor/section_vendors.vm.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/custom_list_view.dart';
import 'package:midnightcity/widgets/list_items/food_vendor.list_item.dart';
import 'package:midnightcity/widgets/list_items/food_vendor.list_item_summary.dart';
import 'package:midnightcity/widgets/list_items/horizontal_vendor.list_item.dart';
import 'package:midnightcity/widgets/list_items/vendor.list_item.dart';
import 'package:midnightcity/widgets/section.title.dart';
import 'package:midnightcity/widgets/states/vendor.empty.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../view_models/vendor/list_vendors.vm.dart';

class ListVendorsView extends StatelessWidget {
  const ListVendorsView(
    this.vendorType, {
    this.title = "",
    this.scrollDirection = Axis.vertical,
    this.type = SearchFilterType.sales,
    this.itemWidth,
    this.viewType,
    this.separator,
    this.byLocation = false,
    Key? key,
  }) : super(key: key);

  final VendorType vendorType;
  final Axis scrollDirection;
  final SearchFilterType type;
  final String title;
  final double? itemWidth;
  final dynamic viewType;
  final Widget? separator;
  final bool byLocation;

  @override
  Widget build(BuildContext context) {
    return CustomVisibilty(
      visible: true, // !AppStrings.enableSingleVendor,
      child: ViewModelBuilder<ListVendorsViewModel>.reactive(
        viewModelBuilder: () => ListVendorsViewModel(
          context,
          vendorType,
          type: type,
          byLocation: byLocation,
        ),
        onModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          //
          Widget listView = CustomListView(
            scrollDirection: scrollDirection,
            padding: EdgeInsets.symmetric(horizontal: 2),
            dataSet: model.vendors,
            isLoading: model.isBusy,
            noScrollPhysics: scrollDirection != Axis.horizontal,
            itemBuilder: (context, index) {
              //
              final vendor = model.vendors[index];
              //
              if (viewType != null && viewType == HorizontalVendorListItem) {
                return HorizontalVendorListItem(
                  vendor,
                  onPressed: model.vendorSelected,
                );
              } else if (vendor.vendorType!.isFood) {
                print("2");
                return FoodVendorListItemSummary(
                  vendor: vendor,
                  onPressed: model.vendorSelected,
                ).w(MediaQuery.of(context).size.width * .95);
              }
            },
            emptyWidget: EmptyVendor(),
            separatorBuilder:
                separator != null ? (ctx, index) => separator : null,
          );

          //
          return VStack(
            [
              //

              //vendors list
              if (model.vendors.isEmpty)
                listView.h(model.vendors.isEmpty ? 240 : 195)
              else if (scrollDirection == Axis.horizontal)
                listView.h(195)
              else
                listView
            ],
          );
        },
      ),
    );
  }
}
