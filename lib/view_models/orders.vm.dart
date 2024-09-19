import 'dart:async';

import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/models/order.dart';
import 'package:midnightcity/requests/order.request.dart';
import 'package:midnightcity/services/app.service.dart';
import 'package:midnightcity/view_models/payment.view_model.dart';
import 'package:midnightcity/views/pages/order/taxi_order_details.page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class OrdersViewModel extends PaymentViewModel {
  //
  OrdersViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  OrderRequest orderRequest = OrderRequest();
  List<Order> orders = [];
  //
  int queryPage = 1;
  RefreshController refreshController = RefreshController();
  late StreamSubscription homePageChangeStream;
  late StreamSubscription refreshOrderStream;

  void initialise() async {
    await fetchMyOrders();

    homePageChangeStream = AppService().homePageIndex.stream.listen(
      (index) {
        //
        fetchMyOrders();
      },
    );

    refreshOrderStream = AppService().refreshAssignedOrders.listen((refresh) {
      if (refresh) {
        fetchMyOrders();
      }
    });
  }

  //
  dispose() {
    super.dispose();
    //
    if (homePageChangeStream != null) {
      homePageChangeStream.cancel();
    }
    //
    if (refreshOrderStream != null) {
      refreshOrderStream.cancel();
    }
  }

  //
  fetchMyOrders({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      refreshController.refreshCompleted();
      queryPage = 1;
    } else {
      queryPage++;
    }

    try {
      final mOrders = await orderRequest.getOrders(page: queryPage);
      if (!initialLoading) {
        orders.addAll(mOrders);
        refreshController.loadComplete();
      } else {
        orders = mOrders;
      }
      clearErrors();
    } catch (error) {
      print("Order Error ==> $error");
      setError(error);
    }

    setBusy(false);
  }

  refreshDataSet() {
    initialise();
  }

  openOrderDetails(Order order) async {
    //
    if (order.taxiOrder != null) {
      // await viewContext!.push(
      //   (context) => TaxiOrderDetailPage(order: order),
      // );
      Navigator.push(
          viewContext!,
          MaterialPageRoute(
              builder: (context) => TaxiOrderDetailPage(order: order)));

      return;
    }
    // final result = await viewContext!.navigator.pushNamed(
    //   AppRoutes.orderDetailsRoute,
    //   arguments: order,
    // );
    final result = await Navigator.pushNamed(
      viewContext!,
      AppRoutes.orderDetailsRoute,
      arguments: order,
    );

    //
    if (result != null && (result is Order || result is bool)) {
      if (result is Order) {
        final orderIndex = orders.indexWhere((e) => e.id == result.id);
        orders[orderIndex] = result;
        notifyListeners();
      } else {
        fetchMyOrders();
      }
    }
  }

  void openLogin() async {
    // await viewContext!.navigator.pushNamed(AppRoutes.loginRoute);
    Navigator.pushNamed(viewContext!, AppRoutes.loginRoute);

    notifyListeners();
    fetchMyOrders();
  }
}
