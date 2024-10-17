import 'package:flutter/material.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/orders.vm.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/custom_list_view.dart';
import 'package:midnightcity/widgets/list_items/order.list_item.dart';
import 'package:midnightcity/widgets/list_items/taxi_order.list_item.dart';
import 'package:midnightcity/widgets/states/empty.state.dart';
import 'package:midnightcity/widgets/states/error.state.dart';
import 'package:midnightcity/widgets/states/order.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:whatsapp/whatsapp.dart';

class OrdersPageProfile extends StatefulWidget {
  const OrdersPageProfile({Key? key}) : super(key: key);

  @override
  _OrdersPageProfileState createState() => _OrdersPageProfileState();
}

class _OrdersPageProfileState extends State<OrdersPageProfile>
    with
        AutomaticKeepAliveClientMixin<OrdersPageProfile>,
        WidgetsBindingObserver {
  //
  WhatsApp whatsapp = WhatsApp("", "");

  OrdersViewModel? vm;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && vm != null) {
      vm!.fetchMyOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    vm = OrdersViewModel(context);
    super.build(context);
    return BasePage(
      body: SafeArea(
        child: ViewModelBuilder<OrdersViewModel>.reactive(
          viewModelBuilder: () => OrdersViewModel(context),
          onModelReady: (vm) => vm.initialise(),
          builder: (context, vm, child) {
            return VStack(
              [
                //
                HStack([
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, top: 20),
                    child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        )),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 24.0, top: 20),
                      child: "My Orders"
                          .tr()
                          .text
                          .black
                          .xl2
                          .semiBold
                          .make()
                          .pOnly(bottom: Vx.dp10))
                ]),

                //
                vm.isAuthenticated()
                    ? CustomListView(
                        canRefresh: true,
                        canPullUp: true,
                        refreshController: vm.refreshController,
                        onRefresh: vm.fetchMyOrders,
                        onLoading: () =>
                            vm.fetchMyOrders(initialLoading: false),
                        isLoading: vm.isBusy,
                        dataSet: vm.orders,
                        hasError: vm.hasError,
                        errorWidget: LoadingError(
                          onrefresh: vm.fetchMyOrders,
                        ),
                        //
                        emptyWidget: EmptyOrder(),
                        itemBuilder: (context, index) {
                          //
                          final order = vm.orders[index];
                          //for taxi tye of order
                          if (order.taxiOrder != null) {
                            return TaxiOrderListItem(
                              order: order,
                              orderPressed: () => vm.openOrderDetails(order),
                            );
                          }
                          return OrderListItem(
                            order: order,
                            onPayPressed: () {
                              print(order.paymentMethod!.name.toString());
                              vm.openExternalWebpageLink(order!.paymentLink!);
                              // _openwhatsapp();
                            },
                            orderPressed: () => vm.openOrderDetails(order),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            UiSpacer.verticalSpace(space: 2),
                      ).expand()
                    : EmptyState(
                        auth: true,
                        showAction: true,
                        actionPressed: vm.openLogin,
                      ).py12().centered().expand(),
              ],
            ).px20().pOnly(top: Vx.dp20);
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _openwhatsapp() async {
    var whatsapp = "+2348179705369";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=Hi, ";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("Hi, ")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Whatsapp not installed")));
      }
    }
  }
}
