import 'package:flutter/material.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/view_models/vendor/categories.vm.dart';
import 'package:midnightcity/views/pages/grocery/widgets/grocery_picks.view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PharmaOnlyCategoryProducts extends StatelessWidget {
  const PharmaOnlyCategoryProducts(
    this.vendorType, {
    this.length = 2,
    Key? key,
  }) : super(key: key);

  final VendorType vendorType;
  final int length;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: vendorType),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: VStack(
                [
                  //

                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios)),
                  ),
                  ...(model.categories!
                      .sublist(
                          0,
                          model.categories!.length < length
                              ? model.categories!.length
                              : length)
                      .map(
                    (category) {
                      //

                      return category.name == "Pharmacy"
                          ? GroceryProductsSectionView(
                              category.name!,
                              model.dvendor!,
                              model.vendorType!,
                              showGrid: true,
                              category: category,
                              crossAxisCount: 2,
                            )
                          : SizedBox();
                    },
                  ).toList()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
