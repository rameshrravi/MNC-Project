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

class WalletManagementView extends StatefulWidget {
  const WalletManagementView({this.viewmodel, Key? key}) : super(key: key);

  final WalletViewModel? viewmodel;

  @override
  State<WalletManagementView> createState() => _WalletManagementViewState();
}

class _WalletManagementViewState extends State<WalletManagementView>
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
                    "${AppStrings.currencySymbol} ${vm.wallet != null ? vm.wallet!.balance : 0.00}"
                        .currencyFormat()
                        .text
                        .xl3
                        .semiBold
                        .makeCentered(),
                    UiSpacer.verticalSpace(space: 5),
                    "Wallet Balance".tr().text.makeCentered(),
                  ],
                ),

                UiSpacer.verticalSpace(),
                //buttons
                Visibility(
                  visible: true,
                  child: HStack(
                    [
                      //topup button
                      CustomButton(
                        color: AppColor.accentColor,
                        onPressed: vm.showAmountEntry,
                        child: FittedBox(
                          child: VStack(
                            [
                              Icon(
                                // Icons.add,
                                FlutterIcons.plus_ant,
                                //Icons.add,
                              ),
                              UiSpacer.verticalSpace(space: 5),
                              //
                              "Top-Up".tr().text.make(),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                          ).py8(),
                        ),
                      ).expand(),
                      Visibility(
                        visible: false,
                        //visible: AppUISettings.allowWalletTransfer,
                        child: UiSpacer.horizontalSpace(space: 5),
                      ),
                      //tranfer button
                      Visibility(
                        visible: false,
                        //visible: AppUISettings.allowWalletTransfer,
                        child: CustomButton(
                          color: Colors.amberAccent,
                          onPressed: vm.showWalletTransferEntry,
                          child: FittedBox(
                            child: VStack(
                              [
                                Icon(
                                  FlutterIcons.upload_fea,
                                ),
                                UiSpacer.verticalSpace(space: 5),
                                //
                                "SEND".tr().text.make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                            ).py8(),
                          ),
                        ).expand(),
                      ),
                      Visibility(
                        visible: AppUISettings.allowWalletTransfer,
                        child: UiSpacer.horizontalSpace(space: 5),
                      ),
                      //tranfer button
                      Visibility(
                        visible: false,
                        // visible: AppUISettings.allowWalletTransfer,
                        child: CustomButton(
                          color: Colors.amberAccent,
                          onPressed: vm.showMyWalletAddress,
                          loading: vm.busy(vm.showMyWalletAddress),
                          child: FittedBox(
                            child: VStack(
                              [
                                Icon(
                                  FlutterIcons.download_fea,
                                ),
                                UiSpacer.verticalSpace(space: 5),
                                //
                                "RECEIVE".tr().text.make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                            ).py8(),
                          ),
                        ).expand(),
                      ),
                    ],
                  ),
                ),

                // Visibility(
                //   visible: false,
                //   child: HStack(
                //     [
                //       //topup button
                //       CustomButton(
                //         color: Colors.amberAccent,
                //         onPressed: vm.showAmountEntry,
                //         child: FittedBox(
                //           child: VStack(
                //             [
                //               Icon(
                //                 // Icons.add,
                //                 FlutterIcons.plus_ant,
                //                 //Icons.add,
                //               ),
                //               UiSpacer.verticalSpace(space: 5),
                //               //
                //               "Top-Up".tr().text.make(),
                //             ],
                //             crossAlignment: CrossAxisAlignment.center,
                //           ).py8(),
                //         ),
                //       ).expand(),
                //       Visibility(
                //         visible: AppUISettings.allowWalletTransfer,
                //         child: UiSpacer.horizontalSpace(space: 5),
                //       ),
                //       //tranfer button
                //       Visibility(
                //         visible: AppUISettings.allowWalletTransfer,
                //         child: CustomButton(
                //           color: Colors.amberAccent,
                //           onPressed: vm.showWalletTransferEntry,
                //           child: FittedBox(
                //             child: VStack(
                //               [
                //                 Icon(
                //                   FlutterIcons.upload_fea,
                //                 ),
                //                 UiSpacer.verticalSpace(space: 5),
                //                 //
                //                 "SEND".tr().text.make(),
                //               ],
                //               crossAlignment: CrossAxisAlignment.center,
                //             ).py8(),
                //           ),
                //         ).expand(),
                //       ),
                //       Visibility(
                //         visible: AppUISettings.allowWalletTransfer,
                //         child: UiSpacer.horizontalSpace(space: 5),
                //       ),
                //       //tranfer button
                //       Visibility(
                //         visible: AppUISettings.allowWalletTransfer,
                //         child: CustomButton(
                //           color: Colors.amberAccent,
                //           onPressed: vm.showMyWalletAddress,
                //           loading: vm.busy(vm.showMyWalletAddress),
                //           child: FittedBox(
                //             child: VStack(
                //               [
                //                 Icon(
                //                   FlutterIcons.download_fea,
                //                 ),
                //                 UiSpacer.verticalSpace(space: 5),
                //                 //
                //                 "RECEIVE".tr().text.make(),
                //               ],
                //               crossAlignment: CrossAxisAlignment.center,
                //             ).py8(),
                //           ),
                //         ).expand(),
                //       ),
                //     ],
                //   ),
                // ),
                //
              ],
            ).p12().card.make().wFull(context);
          },
        );
      },
    );
  }
}
