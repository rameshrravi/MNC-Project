import 'package:flutter/material.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/new_parcel.vm.dart';
import 'package:midnightcity/widgets/custom_list_view.dart';
import 'package:midnightcity/widgets/list_items/package_type.list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import 'form_step_controller.dart';

class PackageTypeSelector extends StatelessWidget {
  const PackageTypeSelector({this.vm, Key? key}) : super(key: key);
  //
  final NewParcelViewModel? vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        "Select Package Type".tr().text.xl.medium.make().py20(),
        //package type
        CustomListView(
          isLoading: vm!.busy(vm!.packageTypes),
          dataSet: vm!.packageTypes,
          noScrollPhysics: true,
          itemBuilder: (context, index) {
            //
            final packageType = vm!.packageTypes[index];
            return PackageTypeListItem(
              packageType: packageType,
              selected: vm!.selectedPackgeType == packageType,
              onPressed: () => vm!.changeSelectedPackageType(packageType),
            );
          },
          separatorBuilder: (context, index) =>
              UiSpacer.verticalSpace(space: 5),
        ).box.make().scrollVertical().expand(),

        //
        FormStepController(
            showPrevious: false,
            showLoadingNext: vm!.busy(vm!.vendors),
            onNextPressed: () {
              if (vm!.selectedPackgeType != null) {
                vm!.nextForm(1);
              }
            }
            // onNextPressed: vm.selectedPackgeType != null
            //     ? () {
            //         vm.nextForm(1);
            //       }
            //     : null,
            ),
      ],
    );
  }
}
