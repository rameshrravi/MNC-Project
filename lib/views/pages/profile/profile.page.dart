import 'package:flutter/material.dart' hide MenuItem;
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/extensions/dynamic.dart';
import 'package:midnightcity/resources/resources.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/profile.vm.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/cards/profile.card.dart';
import 'package:midnightcity/widgets/menu_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(context),
        onModelReady: (model) => model.initialise(),
        disposeViewModel: false,
        builder: (context, model, child) {
          return BasePage(
            body: VStack(
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
                    child: "Account"
                        .tr()
                        .text
                        .xl2
                        .semiBold
                        .color(Colors.black)
                        .make(),
                  ),
                ]),

                //"Profile & App Settings"
                //.tr()
                //.text
                //.lg
                //.light
                //.color(Colors.white)
                //.make(),

                //profile card
                ProfileCard(model).py12(),

                //menu
                VStack(
                  [
                    //

                    //

                    //
                    /*MenuItem(
                      title: "Version".tr(),
                      suffix:
                          model.appVersionInfo.text.color(Colors.white).make(),
                    ),*/
                  ],
                ),

                //
                /*"Copyright ©%s %s all right reserved"
                    .tr()
                    .fill([
                      "${DateTime.now().year}",
                      AppStrings.companyName,
                    ])
                    .text
                    .center
                    .sm
                    .color(Colors.white)
                    .makeCentered()
                    .py20(),
                */
                //
                //UiSpacer.verticalSpace(space: context.percentHeight * 10),
              ],
            ).p20().scrollVertical(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
