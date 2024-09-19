// import 'package:flutter/material.dart' hide MenuItem;
// import 'package:midnightcity/constants/app_strings.dart';
// import 'package:midnightcity/extensions/dynamic.dart';
// import 'package:midnightcity/resources/resources.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:midnightcity/view_models/profile.vm.dart';
// import 'package:midnightcity/widgets/base.page.dart';
// import 'package:midnightcity/widgets/cards/help.center.card.dart';
// import 'package:midnightcity/widgets/menu_item.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:stacked/stacked.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:whatsapp/whatsapp.dart';
// import 'dart:io';
//
// class CustomerSupportPage extends StatefulWidget {
//   const CustomerSupportPage({Key key}) : super(key: key);
//
//   @override
//   _CustomerSupportPageState createState() => _CustomerSupportPageState();
// }
//
// class _CustomerSupportPageState extends State<CustomerSupportPage>
//     with AutomaticKeepAliveClientMixin<CustomerSupportPage> {
//   WhatsApp whatsapp = WhatsApp();
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return SafeArea(
//       child: ViewModelBuilder<ProfileViewModel>.reactive(
//         viewModelBuilder: () => ProfileViewModel(context),
//         onModelReady: (model) => model.initialise(),
//         disposeViewModel: false,
//         builder: (context, model, child) {
//           return BasePage(
//             body: VStack(
//               [
//                 //
//                 HStack([
//                   Padding(
//                     padding: const EdgeInsets.only(left: 24.0, top: 20),
//                     child: GestureDetector(
//                         onTap: () => Navigator.of(context).pop(),
//                         child: Icon(
//                           Icons.arrow_back_ios,
//                           color: Colors.black,
//                         )),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 24.0, top: 20),
//                     child: "Customer Support"
//                         .tr()
//                         .text
//                         .xl2
//                         .semiBold
//                         .color(Colors.black)
//                         .make(),
//                   ),
//                 ]),
//
//                 //"Profile & App Settings"
//                 //.tr()
//                 //.text
//                 //.lg
//                 //.light
//                 //.color(Colors.white)
//                 //.make(),
//
//                 //profile card
//
//                 //menu
//
//                 Padding(
//                   padding: const EdgeInsets.only(top: 70),
//                   child: VStack(
//                     [
//                       MenuItem(
//                         suffix: Icon(
//                           Icons.phone_in_talk_rounded,
//                           color: Colors.black,
//                           size: 30,
//                         ),
//                         title: "Call us",
//                         onPressed: () async {
//                           final phoneNumber = '+2348092871393';
//                           final url = 'tel:$phoneNumber';
//
//                           if (await canLaunch(url)) {
//                             await launch(url);
//                           }
//                         },
//
//                         //  label: "Phone",
//
//                         // leadingIconUrl: ImageConstants.ALL_CATEGORIES_LOGO_URL,
//                       ),
//                       Divider(
//                         thickness: 1,
//                       ),
//                       MenuItem(
//                           suffix: Icon(
//                             Icons.whatsapp,
//                             size: 30,
//                             color: Colors.green,
//                           ),
//                           title: "Chat on WhatsApp",
//                           onPressed: () {
//                             _openwhatsapp();
//                           }
//
//                           //  label: "Phone",
//
//                           // leadingIconUrl: ImageConstants.ALL_CATEGORIES_LOGO_URL,
//                           ),
//                       Divider(
//                         thickness: 1,
//                       ),
//                       MenuItem(
//                         suffix: Icon(
//                           Icons.email_outlined,
//                           color: Colors.red,
//                           size: 30,
//                         ),
//                         title: "Send an Email",
//                         onPressed: () async {
//                           final toEmail = 'midnightcityafrica@gmail.com';
//                           final url = 'mailto:$toEmail';
//                           if (await canLaunch(url)) {
//                             await launch(url);
//                           }
//                         },
//
//                         //  label: "Phone",
//
//                         // leadingIconUrl: ImageConstants.ALL_CATEGORIES_LOGO_URL,
//                       ),
//
//                       //
//
//                       //
//
//                       //
//                       /*MenuItem(
//                         title: "Version".tr(),
//                         suffix:
//                             model.appVersionInfo.text.color(Colors.white).make(),
//                       ),*/
//                     ],
//                   ),
//                 ),
//
//                 //
//                 /*"Copyright ©%s %s all right reserved"
//                     .tr()
//                     .fill([
//                       "${DateTime.now().year}",
//                       AppStrings.companyName,
//                     ])
//                     .text
//                     .center
//                     .sm
//                     .color(Colors.white)
//                     .makeCentered()
//                     .py20(),
//                 */
//                 //
//                 //UiSpacer.verticalSpace(space: context.percentHeight * 10),
//               ],
//             ).p20().scrollVertical(),
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
//   _openwhatsapp() async {
//     var whatsapp = "+2348179705369";
//     var whatsappURl_android =
//         "whatsapp://send?phone=" + whatsapp + "&text=Hi, ";
//     var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("Hi, ")}";
//     if (Platform.isIOS) {
//       // for iOS phone only
//       if (await canLaunch(whatappURL_ios)) {
//         await launch(whatappURL_ios, forceSafariVC: false);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: new Text("Whatsapp not installed")));
//       }
//     } else {
//       // android , web
//       if (await canLaunch(whatsappURl_android)) {
//         await launch(whatsappURl_android);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: new Text("Whatsapp not installed")));
//       }
//     }
//   }
// }
