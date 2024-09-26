import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/vendor/popular_services.vm.dart';
import 'package:midnightcity/widgets/buttons/custom_outline_button.dart';
import 'package:midnightcity/widgets/custom_list_view.dart';
import 'package:midnightcity/widgets/list_items/service.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PopularServicesView extends StatefulWidget {
  const PopularServicesView(this.vendorType, {Key? key}) : super(key: key);

  final VendorType vendorType;

  @override
  _PopularServicesViewState createState() => _PopularServicesViewState();
}

class _PopularServicesViewState extends State<PopularServicesView> {
  bool showGrid = true;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PopularServicesViewModel>.reactive(
      viewModelBuilder: () => PopularServicesViewModel(
        context,
        widget.vendorType,
      ),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return VStack(
          [
            //
            ("Popular".tr() + " ${widget.vendorType.name}")
                .text
                .lg
                .medium
                .make()
                .px12(),

            //
            CustomListView(
              noScrollPhysics: true,
              isLoading: vm.isBusy,
              dataSet: vm.services,
              itemBuilder: (context, index) {
                final service = vm.services[index];
                return ServiceListItem(
                  service: service,
                  onPressed: () => vm.serviceSelected,
                  //onPressed: vm.serviceSelected!,
                );
              },
              separatorBuilder: (context, index) =>
                  UiSpacer.verticalSpace(space: 10),
            ).p12(),

            //view more
            CustomOutlineButton(
              height: 24,
              child: "View More"
                  .tr()
                  .text
                  .medium
                  .sm
                  .color(AppColor.primaryColor)
                  .makeCentered(),
              titleStyle: context.textTheme.bodyLarge!.copyWith(
                color: AppColor.primaryColor,
              ),
              onPressed: vm.openSearch,
            ).px20(),
          ],
        ).py12();
      },
    );
  }
}
