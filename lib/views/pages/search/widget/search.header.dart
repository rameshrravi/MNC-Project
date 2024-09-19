// import 'package:flutter/material.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:midnightcity/view_models/search.vm.dart';
// import 'package:midnightcity/widgets/inputs/search_bar.input.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class SearchHeader extends StatelessWidget {
//   const SearchHeader(
//     this.model, {
//     Key? key,
//     this.subtitle,
//     this.showCancel = true,
//   }) : super(key: key);
//
//   final SearchViewModel model;
//   final bool showCancel;
//   final String subtitle;
//   @override
//   Widget build(BuildContext context) {
//     return VStack(
//       [
//         //Appbar
//         HStack(
//           [
//             /*d showCancel
//                 ? Icon(
//                     FlutterIcons.ios_arrow_back_ion,
//                     color: Colors.black,
//                   ).p4().onInkTap(context.pop)
//                 : UiSpacer.emptySpace(),*/
//
//             VStack(
//               [
//                 //"Search".tr().text.color(Colors.black).xl2.make(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Icon(
//                           Icons.arrow_back_ios_new,
//                           color: Colors.black,
//                         )),
//                     Container(
//                       //  width: 400,
//                       alignment: Alignment.center,
//                       child: Visibility(
//                         visible: subtitle != null && subtitle.isNotEmpty,
//                         child: "Search in $subtitle".text.black.make(),
//                       ),
//                     ),
//                   ],
//                 ),
//                 /* Visibility(
//                   visible: subtitle == null,
//                   child: "Ordered by Nearby first".tr().text.color(Colors.white).make(),
//                 ),*/
//               ],
//             ).expand(),
//
//             //
//           ],
//         ).pOnly(bottom: 10),
//         //
//         Padding(
//           padding: const EdgeInsets.only(top: 28.0),
//           child: SearchBarInput(
//             readOnly: false,
//             showFilter: false,
//             onSubmitted: (keyword) {
//               model.keyword = keyword;
//               model.startSearch();
//             },
//             onFilterPressed: () => model.showFilterOptions(),
//           ),
//         ),
//       ],
//     );
//   }
// }
