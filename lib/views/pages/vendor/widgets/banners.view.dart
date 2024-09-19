import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/utils/utils.dart';
import 'package:midnightcity/view_models/vendor/banners.vm.dart';
import 'package:midnightcity/widgets/cards/custom.visibility.dart';
import 'package:midnightcity/widgets/list_items/banner.list_item.dart';
import 'package:midnightcity/widgets/states/loading.shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Banners extends StatelessWidget {
  const Banners(
    this.vendorType, {
    this.viewportFraction = 0.8,
    this.showIndicators = false,
    this.featured = false,
    Key? key,
  }) : super(key: key);

  final VendorType vendorType;
  final double viewportFraction;
  final bool showIndicators;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BannersViewModel>.reactive(
      viewModelBuilder: () => BannersViewModel(
        context,
        vendorType,
        featured: featured,
      ),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return model.isBusy
            ? LoadingShimmer().px20().h(150)
            : Visibility(
                visible: model.banners != null && model.banners.isNotEmpty,
                child: VStack(
                  [
                    CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: viewportFraction,
                        autoPlay: true,
                        initialPage: 1,
                        height: (!model.isBusy && model.banners.length > 0)
                            ? (AppStrings.bannerHeight ?? 150.0)
                            : 0.00,
                        disableCenter: true,
                        onPageChanged: (index, reason) {
                          model.currentIndex = index;
                          model.notifyListeners();
                        },
                      ),
                      items: model.banners.map(
                        (banner) {
                          return BannerListItem(
                            radius: 20,
                            imageUrl: banner.imageUrl,
                            onPressed: () => model.bannerSelected(banner),
                          );
                        },
                      ).toList(),
                    ),

                    //indicators
                    CustomVisibilty(
                      visible: model.banners.length <= 10 || showIndicators,
                      child: AnimatedSmoothIndicator(
                        activeIndex: model.currentIndex,
                        count: model.banners.length ?? 0,
                        textDirection: Utils.isArabic
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        effect: ExpandingDotsEffect(
                          dotHeight: 6,
                          dotWidth: 10,
                          activeDotColor: context.primaryColor,
                        ),
                      ).centered().py8(),
                    ),

                    /*   ListView.builder(

                      itemCount: 2,
                      itemBuilder: (context, i) {


                             Container(
                               width: 100,
                                 height: 100,
                                 child: Image.network(model.banners[i+1].imageUrl));

                          //    onPressed: () => model.bannerSelected(banner),

                      },
                    ),*/

                    /*          Container(
                      height: 140,
                      child: Padding(
                        padding: const EdgeInsets.only(left:15,right:15),
                        child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            GestureDetector(
                              onTap:(){
                                model.bannerSelected(model.banners[1]);
                               },
                              child: Container(
                                child: Image.network(model.banners[1].imageUrl,
                                width: MediaQuery.of(context).size.width/2 - 20,
                                fit: BoxFit.cover,
                                ),

                              ),
                            ),
                            GestureDetector(

                              onTap:(){
                                model.bannerSelected(model.banners[1]);
                              },
                              child: Container(
                                child: Image.network(model.banners[2].imageUrl,
                         width: MediaQuery.of(context).size.width/2 - 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

*/
                  ],
                ),
              );
      },
    );
  }
}
