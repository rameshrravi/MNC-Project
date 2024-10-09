import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/app_strings.dart';
import '../../../models/vendor_type.dart';
import '../../../view_models/vendor/categories.vm.dart';
import '../../../widgets/base.page.dart';
import '../../../widgets/custom_dynamic_grid_view.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/list_items/category.list_item.dart';
import '../search/widget/search.header.dart';
import 'category_product_page.dart';

class CategoreyList extends StatefulWidget {
  CategoreyList({Key? key, this.vendorType}) : super(key: key);
  final VendorType? vendorType;
  @override
  State<CategoreyList> createState() => _CategoreyListState();
}

class _CategoreyListState extends State<CategoreyList> {
  //VendorType? vendorType;
  //String? searchProduct;

  TextEditingController? txtECSearch = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: widget.vendorType!),
      //onModelReady: (vm) => vm.initialise(all: true),
      onViewModelReady: (vm) => vm.initialise(all: true),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showCart: true,
          showLeadingAction: true,
          title: "Categories".tr(),
          body: vm.categories!.length != 0
              ? SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextFormField(
                          // hintText: "Search here",
                          // labelText: "Search here",
                          prefixIcon: Icon(Icons.search),
                          textColor: Colors.black,
                          labelColor: Colors.black,
                          cursorColor: Colors.black,
                          textEditingController: txtECSearch,

                          onChanged: () {
                            setState(() {
                              //searchProduct = txtECSearch!.text;
                            });
                            //   print(searchProduct);
                          },
                          onSaved: (value) {
                            setState(() {
                              vm.searchMethod(value!);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: vm.dvendor!.categories!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {},
                                child: CategoryCard(
                                    name: vm.dvendor!.categories![index].name!,
                                    imageUrl: vm
                                        .dvendor!.categories![index].imageUrl!,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryProductsPage(
                                                    category: vm.dvendor!
                                                        .categories![index],
                                                    vendor: vm.dvendor,
                                                  )));
                                    }));
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class CategoryItem {
  final String name;
  final String imageUrl;

  CategoryItem(this.name, this.imageUrl);
}

class CategoryCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  VoidCallback onTap;
  CategoryCard(
      {required this.name, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black45,
              ),
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
