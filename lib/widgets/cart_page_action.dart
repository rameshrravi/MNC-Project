import 'package:flutter/material.dart';
import 'package:midnightcity/services/cart.service.dart';
import 'package:midnightcity/utils/utils.dart';
import 'package:midnightcity/views/pages/cart/cart.page.dart';
import 'package:velocity_x/velocity_x.dart';

class PageCartAction extends StatefulWidget {
  const PageCartAction({
    this.color = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 12,
    this.iconSize = 24,
    this.badgeSize = 14,
    this.padding = 10,
    Key? key,
  }) : super(key: key);
  final Color color;
  final Color textColor;
  final double badgeSize;
  final double iconSize;
  final double fontSize;
  final double padding;

  @override
  _PageCartActionState createState() => _PageCartActionState();
}

class _PageCartActionState extends State<PageCartAction> {
  @override
  void initState() {
    super.initState();
    CartServices.getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CartServices.cartItemsCountStream.stream,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Icon(
          Icons.import_contacts_sharp,
          color: Colors.white, // widget.color,
          size: widget.iconSize,
        )
            .badge(
              count: snapshot.data,
              size: widget.badgeSize,
              color: widget.color ?? Colors.white,
              textStyle: context.textTheme.bodyLarge?.copyWith(
                fontSize: widget.fontSize,
                color: widget.textColor,
              ),
            )
            .centered()
            .box
            .p8
            .color(context.primaryColor)
            .roundedFull
            .make()
            .pOnly(
              right: Utils.isArabic! ? 0 : widget.padding,
              left: Utils.isArabic! ? widget.padding : 0,
            )
            .onInkTap(
          () async {
            //
            context.nextPage(CartPage());
          },
        );
      },
    );
  }
}
