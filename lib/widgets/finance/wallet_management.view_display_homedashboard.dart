import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/constants/app_ui_settings.dart';
import 'package:midnightcity/extensions/string.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/utils/ui_spacer.dart';
import 'package:midnightcity/view_models/wallet.vm.dart';
import 'package:midnightcity/widgets/busy_indicator.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class WalletManagementViewHomeDashboard extends StatefulWidget {
  const WalletManagementViewHomeDashboard({this.viewmodel, Key? key})
      : super(key: key);

  final WalletViewModel? viewmodel;

  @override
  State<WalletManagementViewHomeDashboard> createState() =>
      _WalletManagementViewState();
}

class _WalletManagementViewState
    extends State<WalletManagementViewHomeDashboard>
    with WidgetsBindingObserver {
  WalletViewModel? mViewmodel;
  @override
  void initState() {
    super.initState();

    mViewmodel = widget.viewmodel;
    mViewmodel ??= WalletViewModel(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //
      mViewmodel!.initialise();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding?.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mViewmodel != null) {
      mViewmodel!.initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletViewModel>.reactive(
      viewModelBuilder: () => mViewmodel!,
      disposeViewModel: widget.viewmodel == null,
      builder: (context, vm, child) {
        return StreamBuilder(
          stream: AuthServices.listenToAuthState(),
          builder: (ctx, snapshot) {
            //
            if (!snapshot.hasData) {
              return UiSpacer.emptySpace();
            }
            //view
            return VStack(
              [
                //
                Visibility(
                  visible: vm.isBusy,
                  child: BusyIndicator(),
                ),

                VStack(
                  [
                    //
                    Row(
                      children: [
                        Icon(
                          FlutterIcons.wallet_outline_mco,
                          color: AppColor.primaryColor,
                        ),

                        Text(
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            " ${vm.wallet != null ? vm.formatAmount(vm.wallet!.balance!.toInt()) : 0.00}")
                        // "${AppStrings.currencySymbol} ${vm.wallet != null ? vm.formatAmount(vm.wallet!.balance!.toInt()) : 0.00}"
                        //     .currencyFormat()
                        //     .text
                        //     // .xl3
                        //     .semiBold
                        //     .color(context.primaryColor)
                        //     .makeCentered(),
                      ],
                    )

                    // UiSpacer.verticalSpace(space: 1),
                    // "Wallet Balance".tr().text.makeCentered(),
                  ],
                ),
              ],
            ).p12();
          },
        );
      },
    );
  }
}
