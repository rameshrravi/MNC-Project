import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;

import 'package:awesome_notifications/awesome_notifications.dart'
    hide NotificationModel;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/models/notification.dart';
import 'package:midnightcity/models/order.dart';
import 'package:midnightcity/models/product.dart';
import 'package:midnightcity/models/service.dart';
import 'package:midnightcity/models/vendor.dart';
import 'package:midnightcity/services/app.service.dart';
import 'package:midnightcity/services/notification.service.dart';
import 'package:midnightcity/views/pages/service/service_details.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:singleton/singleton.dart';
import 'package:velocity_x/velocity_x.dart';

class FirebaseService {
  //
  /// Factory method that reuse same instance automatically
  factory FirebaseService() => Singleton.lazy(() => FirebaseService._());

  /// Private constructor
  FirebaseService._() {}

  //
  NotificationModel? notificationModel;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Map? notificationPayloadData;

  setUpFirebaseMessaging() async {
    //Request for notification permission
    /*NotificationSettings settings = */
    await firebaseMessaging.requestPermission();
    //subscribing to all topic
    firebaseMessaging.subscribeToTopic("all");

    //on notification tap tp bring app back to life
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      saveNewNotification(message);
      selectNotification("From onMessageOpenedApp");
      //
      refreshOrdersList(message);
    });

    //normal notification listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      saveNewNotification(message);
      showNotification(message);
      //
      refreshOrdersList(message);
    });
  }

  //write to notification list
  saveNewNotification(RemoteMessage? message, {String? title, String? body}) {
    //
    notificationPayloadData = message != null ? message.data : null;
    if (message?.notification == null &&
        message?.data != null &&
        message?.data["title"] == null &&
        title == null) {
      return;
    }
    //Saving the notification
    notificationModel = NotificationModel();
    notificationModel!.title =
        message?.notification?.title ?? title ?? message?.data["title"] ?? "";
    notificationModel!.body =
        message?.notification?.body ?? body ?? message?.data["body"] ?? "";
    //

    if (message != null && message.data != null) {
      final imageUrl = message?.data["image"] ??
          (Platform.isAndroid
              ? message?.notification?.android?.imageUrl
              : message?.notification?.apple?.imageUrl);
      notificationModel!.image = imageUrl;
    }

    //
    notificationModel!.timeStamp = DateTime.now().millisecondsSinceEpoch;

    //add to database/shared pref
    NotificationService.addNotification(notificationModel!);
  }

  //
  showNotification(RemoteMessage message) async {
    if (message.notification == null && message.data["title"] == null) {
      return;
    }

    //
    notificationPayloadData = message.data;

    //
    try {
      //
      String? imageUrl;

      try {
        imageUrl = message.data["image"] ??
            (Platform.isAndroid
                ? message?.notification?.android?.imageUrl
                : message?.notification?.apple?.imageUrl);
      } catch (error) {
        print("error getting notification image");
      }

      //
      if (imageUrl != null) {
        //
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(20),
            channelKey:
                NotificationService.appNotificationChannel().channelKey!,
            title: message.data["title"] ?? message.notification!.title!,
            body: message.data["body"] ?? message.notification!.body!,
            bigPicture: imageUrl,
            icon: "resource://drawable/notification_icon",
            notificationLayout: imageUrl != null
                ? NotificationLayout.BigPicture
                : NotificationLayout.Default,
            payload: Map<String, String>.from(message.data),
          ),
        );
      } else {
        //
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(20),
            channelKey:
                NotificationService.appNotificationChannel().channelKey!,
            title: message.data["title"] ?? message.notification!.title,
            body: message.data["body"] ?? message.notification!.body,
            icon: "resource://drawable/notification_icon",
            notificationLayout: NotificationLayout.Default,
            payload: Map<String, String>.from(message.data),
          ),
        );
      }

      ///
    } catch (error) {
      print("Notification Show error ===> ${error}");
    }
  }

  //handle on notification selected
  Future selectNotification(String payload) async {
    if (payload == null) {
      return;
    }
    // try {
    //   log("NotificationPaylod ==> ${jsonEncode(notificationPayloadData)}");
    //   //
    //   if (notificationPayloadData != null && notificationPayloadData is Map) {
    //     //
    //
    //     //
    //     final isChat = notificationPayloadData!.containsKey("is_chat");
    //     final isOrder = notificationPayloadData!.containsKey("is_order") &&
    //         (notificationPayloadData!["is_order"].toString() == "1" ||
    //             (notificationPayloadData!["is_order"] is bool &&
    //                 notificationPayloadData!["is_order"]));
    //
    //     ///
    //     final hasProduct = notificationPayloadData!.containsKey("product");
    //     final hasVendor = notificationPayloadData!.containsKey("vendor");
    //     final hasService = notificationPayloadData!.containsKey("service");
    //     //
    //     if (isChat) {
    //       //
    //       dynamic user = jsonDecode(notificationPayloadData!['user']);
    //       dynamic peer = jsonDecode(notificationPayloadData!['peer']);
    //       String chatPath = notificationPayloadData!['path'];
    //       //
    //       Map<String, PeerUser> peers = {
    //         '${user['id']}': PeerUser(
    //           documentId: '${user['id']}',
    //           name: "${user['name']}",
    //           image: "${user['photo']}",
    //         ),
    //         '${peer['id']}': PeerUser(
    //           documentId: '${peer['id']}',
    //           name: "${peer['name']}",
    //           image: "${peer['photo']}",
    //         ),
    //       };
    //       //
    //       final peerRole = peer["role"];
    //       //
    //       final chatEntity = ChatEntity(
    //         mainUser: peers['${user['id']}'],
    //         peers: peers,
    //         //don't translate this
    //         path: chatPath,
    //         title: peer["role"] == null
    //             ? "Chat with".tr() + " ${peer['name']}"
    //             : peerRole == 'vendor'
    //                 ? "Chat with vendor".tr()
    //                 : "Chat with driver".tr(),
    //       );
    //       AppService().navigatorKey.currentContext.navigator.pushNamed(
    //             AppRoutes.chatRoute,
    //             arguments: chatEntity,
    //           );
    //     }
    //     //order
    //     else if (isOrder) {
    //       //
    //       final order = Order(
    //         id: int.parse(notificationPayloadData['order_id'].toString()),
    //       );
    //       //
    //       AppService().navigatorKey.currentContext.navigator.pushNamed(
    //             AppRoutes.orderDetailsRoute,
    //             arguments: order,
    //           );
    //     }
    //     //vendor type of notification
    //     else if (hasVendor) {
    //       //
    //       final vendor = Vendor.fromJson(
    //         jsonDecode(notificationPayloadData['vendor']),
    //       );
    //       //
    //       AppService().navigatorKey.currentContext.navigator.pushNamed(
    //             AppRoutes.vendorDetails,
    //             arguments: vendor,
    //           );
    //     }
    //     //product type of notification
    //     else if (hasProduct) {
    //       //
    //       final product = Product.fromJson(
    //         jsonDecode(notificationPayloadData['product']),
    //       );
    //       //
    //       AppService().navigatorKey.currentContext.navigator.pushNamed(
    //             AppRoutes.product,
    //             arguments: product,
    //           );
    //     }
    //     //service type of notification
    //     else if (hasService) {
    //       //
    //       final service = Service.fromJson(
    //         jsonDecode(notificationPayloadData['service']),
    //       );
    //       //
    //       AppService().navigatorKey.currentContext.push(
    //             (context) => ServiceDetailsPage(service),
    //           );
    //     }
    //     //regular notifications
    //     else {
    //       AppService().navigatorKey.currentContext.navigator.pushNamed(
    //             AppRoutes.notificationDetailsRoute,
    //             arguments: notificationModel,
    //           );
    //     }
    //   } else {
    //     AppService().navigatorKey.currentContext.navigator.pushNamed(
    //           AppRoutes.notificationDetailsRoute,
    //           arguments: notificationModel,
    //         );
    //   }
    // } catch (error) {
    //   print("Error opening Notification ==> $error");
    // }
  }

  //refresh orders list if the notification is about assigned order
  void refreshOrdersList(RemoteMessage message) async {
    if (message.data != null && message.data["is_order"] != null) {
      await Future.delayed(Duration(seconds: 3));
      AppService().refreshAssignedOrders.add(true);
    }
  }
}
