import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/views/shared/go_to_cart.view.dart';
import 'package:midnightcity/widgets/cart_page_action.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:measure_size/measure_size.dart';
import 'package:velocity_x/velocity_x.dart';

class BasePage extends StatefulWidget {
  final bool? showAppBar;
  final bool? showLeadingAction;
  final bool? extendBodyBehindAppBar;
  final Function? onBackPressed;
  final bool? showCart;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? body;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final Widget? fab;
  final bool? isLoading;
  final Color? appBarColor;
  final double? elevation;
  final Color? appBarItemColor;
  final Color? backgroundColor;
  final bool? showCartView;

  BasePage({
    this.showAppBar = false,
    this.leading,
    this.showLeadingAction = false,
    this.onBackPressed,
    this.showCart = false,
    this.title = "",
    this.actions,
    this.body,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.fab,
    this.isLoading = false,
    this.appBarColor,
    this.appBarItemColor,
    this.backgroundColor,
    this.elevation,
    this.extendBodyBehindAppBar,
    this.showCartView = false,
    Key? key,
  }) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  //
  double bottomPaddingSize = 0;

  //
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: translator.activeLocale.languageCode == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: widget.backgroundColor ??
            AppColor.mainBackground ??
            AppColor.mainBackground,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar ?? false,
        appBar: widget.showAppBar!
            ? AppBar(
                backgroundColor:
                    AppColor.mainBackground ?? AppColor.mainBackground,
                elevation: widget.elevation,
                automaticallyImplyLeading: widget.showLeadingAction!,
                leading: widget.showLeadingAction!
                    ? widget.leading == null
                        ? IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: widget.appBarItemColor == null
                                  ? Colors.black
                                  : widget.appBarItemColor != Colors.transparent
                                      ? widget.appBarItemColor
                                      : AppColor.primaryColor,
                            ),
                            onPressed: () {})
                        : widget.leading
                    : null,
                title: widget.title!.text.black
                    .maxLines(1)
                    .overflow(TextOverflow.ellipsis)
                    //.color(widget.appBarItemColor ?? Colors.white)
                    .make(),
                actions: widget.actions ??
                    [
                      widget.showCart!
                          ? PageCartAction()
                          : UiSpacer.emptySpace(),
                    ],
              )
            : null,
        body: Stack(
          children: [
            //body
            VStack(
              [
                //
                widget.isLoading!
                    ? LinearProgressIndicator()
                    : UiSpacer.emptySpace(),

                //
                widget!.body!.pOnly(bottom: bottomPaddingSize).expand(),
              ],
            ),

            //cart view
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Visibility(
                visible: widget.showCartView!,
                child: MeasureSize(
                  onChange: (size) {
                    setState(() {
                      bottomPaddingSize = size.height;
                    });
                  },
                  child: GoToCartView(),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: widget.bottomNavigationBar,
        bottomSheet: widget.bottomSheet,
        floatingActionButton: widget.fab,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
