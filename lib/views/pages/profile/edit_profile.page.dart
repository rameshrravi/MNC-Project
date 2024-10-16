// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flag/flag.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:midnightcity/constants/app_images.dart';
// import 'package:midnightcity/services/validator.service.dart';
// import 'package:midnightcity/utils/ui_spacer.dart';
// import 'package:midnightcity/view_models/edit_profile.vm.dart';
// import 'package:midnightcity/widgets/base.page.dart';
// import 'package:midnightcity/widgets/busy_indicator.dart';
// import 'package:midnightcity/widgets/buttons/custom_button.dart';
// import 'package:midnightcity/widgets/custom_text_form_field.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:stacked/stacked.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class EditProfilePage extends StatelessWidget {
//   const EditProfilePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<EditProfileViewModel>.reactive(
//       viewModelBuilder: () => EditProfileViewModel(context),
//       onModelReady: (model) => model.initialise(),
//       builder: (context, model, child) {
//         return BasePage(
//           showLeadingAction: true,
//           showAppBar: true,
//           title: "Edit Profile".tr(),
//           body: SafeArea(
//               top: true,
//               bottom: false,
//               child:
//                   //
//                   VStack(
//                 [
//                   //
//                   Stack(
//                     children: [
//                       //
//                       model.currentUser == null
//                           ? BusyIndicator()
//                           : model.newPhoto == null
//                               ? CachedNetworkImage(
//                                   imageUrl: model.currentUser?.photo ?? "",
//                                   progressIndicatorBuilder:
//                                       (context, url, progress) {
//                                     return BusyIndicator();
//                                   },
//                                   errorWidget: (context, imageUrl, progress) {
//                                     return Image.asset(
//                                       AppImages.user,
//                                     );
//                                   },
//                                   fit: BoxFit.cover,
//                                 )
//                                   .wh(
//                                     Vx.dp64 * 1.3,
//                                     Vx.dp64 * 1.3,
//                                   )
//                                   .box
//                                   .rounded
//                                   .clip(Clip.antiAlias)
//                                   .make()
//                               : Image.file(
//                                   model.newPhoto,
//                                   fit: BoxFit.cover,
//                                 )
//                                   .wh(
//                                     Vx.dp64 * 1.3,
//                                     Vx.dp64 * 1.3,
//                                   )
//                                   .box
//                                   .rounded
//                                   .clip(Clip.antiAlias)
//                                   .make(),
//
//                       //
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Icon(
//                           FlutterIcons.camera_ant,
//                           size: 16,
//                         )
//                             .p8()
//                             .box
//                             .color(context.theme.backgroundColor)
//                             .roundedFull
//                             .shadow
//                             .make()
//                             .onInkTap(model.changePhoto),
//                       ),
//                     ],
//                   ).box.makeCentered(),
//
//                   //form
//                   Form(
//                     key: model.formKey,
//                     child: VStack(
//                       [
//                         //
//                         CustomTextFormField(
//                           labelText: "Name".tr(),
//                           textEditingController: model.nameTEC,
//                           validator: FormValidator.validateName,
//                         ).py12(),
//                         //
//                         CustomTextFormField(
//                           labelText: "Email".tr(),
//                           keyboardType: TextInputType.emailAddress,
//                           textEditingController: model.emailTEC,
//                           validator: FormValidator.validateEmail,
//                         ).py12(),
//                         //
//                         CustomTextFormField(
//                           prefixIcon: HStack(
//                             [
//                               //icon/flag
//                               Flag.fromString(
//                                 model.selectedCountry.countryCode,
//                                 width: 20,
//                                 height: 20,
//                               ),
//                               UiSpacer.horizontalSpace(space: 5),
//                               //text
//                               ("+" + model.selectedCountry.phoneCode)
//                                   .text
//                                   .make(),
//                             ],
//                           ).px8(),
//                           labelText: "Phone",
//                           keyboardType: TextInputType.phone,
//                           textEditingController: model.phoneTEC,
//                           validator: FormValidator.validatePhone,
//                         ).py12(),
//
//                         //
//                         CustomButton(
//                           title: "Update Profile".tr(),
//                           loading: model.isBusy,
//                           onPressed: model.processUpdate,
//                         ).centered().py12(),
//                       ],
//                     ),
//                   ).py20(),
//                 ],
//               ).p20().scrollVertical()),
//         );
//       },
//     );
//   }
// }
