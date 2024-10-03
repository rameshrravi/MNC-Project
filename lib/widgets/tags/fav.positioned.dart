import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/utils/utils.dart';
import 'package:midnightcity/view_models/favourite.vm.dart';
import 'package:midnightcity/widgets/busy_indicator.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class FavPositiedView extends StatelessWidget {
  const FavPositiedView(this.product, {Key? key}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    //fav icon

    return Positioned(
      top: 0,
      left: !Utils.isArabic ? null : 0,
      right: Utils.isArabic ? null : 0,
      child: ViewModelBuilder<FavouriteViewModel>.reactive(
        viewModelBuilder: () => FavouriteViewModel(context, product),
        builder: (context, model, child) {
          return model.isBusy
              ? BusyIndicator().wh(18, 18).p4()
              : Icon(
                  // product.isFavourite!
                  //     ? Icons.import_contacts
                  //     : Icons.import_contacts,

                  product.isFavourite!
                      ? FlutterIcons.favorite_mdi
                      : FlutterIcons.favorite_border_mdi,
                  color: Colors.red.shade600,
                  size: 20,
                )
                  .p4()
                  .box
                  /*  .withDecoration(
                    BoxDecoration(
                      color: context.backgroundColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(Utils.isArabic ? 6 : 0),
                        bottomLeft: Radius.circular(!Utils.isArabic ? 6 : 0),
                      ),
                    ),
                  )*/
                  .make()
                  .onTap(
                  () {
                    !model.isAuthenticated()
                        ? model.openLogin()
                        : !model.product.isFavourite!
                            ? model.addFavourite()
                            : model.removeFavourite();
                  },
                );
        },
      ),
    );
  }
}
