import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:midnightcity/models/search.dart';
import 'package:midnightcity/models/tag.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/search_filter.vm.dart';
import 'package:midnightcity/widgets/busy_indicator.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchFilterBottomSheet extends StatelessWidget {
  const SearchFilterBottomSheet({
    Key? key,
    this.onSubmitted,
    this.vm,
    this.search,
  }) : super(key: key);

  //
  final Search? search;
  final SearchFilterViewModel? vm;
  final Function(Search)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchFilterViewModel>.reactive(
      viewModelBuilder: () => vm!,
      onModelReady: (vm) => vm.fetchSearchData(),
      disposeViewModel: false,
      builder: (context, vm, child) {
        return VStack(
          [
            UiSpacer.swipeIndicator(),
            UiSpacer.vSpace(),
            //

            (vm.busy(vm.searchData) || vm.searchData == null)
                ? BusyIndicator()
                : VStack(
                    [
                      //sort
                      "Sort by".tr().text.semiBold.lg.make(),
                      FormBuilderRadioGroup(
                        name: "sort",
                        decoration: InputDecoration(border: InputBorder.none),
                        initialValue: search!.sort ?? "asc",
                        options: [
                          FormBuilderFieldOption(
                            value: "asc",
                            child: "Ascending (A-Z)".tr().text.make(),
                          ),
                          FormBuilderFieldOption(
                            value: "desc",
                            child: "Descending (Z-A)".tr().text.make(),
                          )
                        ],
                        onChanged: (value) {
                          search!.sort = value;
                        },
                      ),

                      UiSpacer.vSpace(10),
                      UiSpacer.divider(),
                      UiSpacer.vSpace(10),
                      //price
                      "Price".tr().text.semiBold.lg.make(),
                      FormBuilderRangeSlider(
                        name: "price",
                        decoration: InputDecoration(border: InputBorder.none),
                        initialValue: RangeValues(
                          vm.searchData!.priceRange![0] ?? 0,
                          vm.searchData!.priceRange![1] ?? 100,
                        ),
                        min: vm.searchData!.priceRange![0] ?? 0,
                        max: vm.searchData!.priceRange![1] ?? 100,
                        onChanged: (values) {
                          search!.minPrice = values!.start.toString();
                          search!.maxPrice = values!.end.toString();
                        },
                      ).wFull(context),

                      UiSpacer.vSpace(10),
                      UiSpacer.divider(),
                      UiSpacer.vSpace(10),
                      //tags
                      CustomVisibilty(
                        visible: (vm.searchData!.tags ?? []).isNotEmpty,
                        child: VStack(
                          [
                            "Filter by".tr().text.semiBold.lg.make(),
                            FormBuilderCheckboxGroup<Tag>(
                              name: "tag",
                              initialValue: search!.tags ?? [],
                              wrapDirection: Axis.vertical,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              options: vm.searchData!.tags!.map(
                                (e) {
                                  return FormBuilderFieldOption<Tag>(
                                    value: e,
                                    child: e.name!.text.make(),
                                  );
                                },
                              ).toList(),
                              onChanged: (values) {
                                search!.tags = values;
                              },
                            ),
                            UiSpacer.vSpace(10),
                            UiSpacer.divider(),
                            UiSpacer.vSpace(10),
                          ],
                        ),
                      ),

                      //filter by location or not
                      HStack(
                        [
                          Checkbox(
                            value: search!.byLocation,
                            onChanged: (value) {
                              search!.byLocation = value;
                              vm.notifyListeners();
                            },
                          ),
                          UiSpacer.smHorizontalSpace(),
                          "Filter by location".tr().text.make().expand(),
                        ],
                      ).onInkTap(() {
                        search!.byLocation = !search!.byLocation!;
                        vm.notifyListeners();
                      }),
                      //tags

                      //
                      CustomButton(
                        title: "Submit".tr(),
                        onPressed: () {
                          onSubmitted!(search!)!;
                          //context.pop();
                        },
                      ).centered().py16(),
                    ],
                  ),
          ],
        )
            .p20()
            .scrollVertical()
            .box
            .topRounded()
            .color(context.backgroundColor)
            .make();
        // .h(context.percentHeight * 90);
      },
    );
  }
}
