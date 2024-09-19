import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/app_images.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:midnightcity/widgets/base.page.dart';
import 'package:midnightcity/widgets/buttons/custom_button.dart';
import 'package:midnightcity/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:velocity_x/velocity_x.dart';

class AccountVerificationEntry extends StatefulWidget {
  const AccountVerificationEntry({
    this.onSubmit,
    this.onResendCode,
    this.vm,
    Key? key,
    this.phone = "",
    this.email = "",
  }) : super(key: key);

  final Function(String)? onSubmit;
  final Function? onResendCode;
  final MyBaseViewModel? vm;
  final String? phone;
  final String? email;

  @override
  _AccountVerificationEntryState createState() =>
      _AccountVerificationEntryState();
}

class _AccountVerificationEntryState extends State<AccountVerificationEntry> {
  TextEditingController pinTEC = new TextEditingController();
  String? smsCode;
  int resendSecs = 120;
  int maxResendSeconds = 30;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    //
    startCountDown();
  }

  @override
  Widget build(BuildContext context) {
    //

    return BasePage(
      backgroundColor: Color(0xff121422),
      /*  showAppBar: true,
      showLeadingAction: true,
      appBarColor: Color(0xff121422),
      elevation: 0,
      leading: IconButton(
        icon: Icon(FlutterIcons.ios_arrow_back_ion,
            color: AppColor.white, size: 28),
        onPressed: () => Navigator.pop(context),
      ),*/
      body: SafeArea(
        child: VStack(
          [
            // IconButton(
            //   icon: Icon(FlutterIcons.ios_arrow_back_ion,
            //       color: AppColor.white, size: 28),
            //   onPressed: () => Navigator.pop(context),
            // ),
            IconButton(
              icon:
                  Icon(Icons.import_contacts, color: AppColor.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),

            //
            /*    Image.asset(
              AppImages.otpImage,
              width: 200,
              height: 200,
            ).centered(),*/
            //

            Center(
              child: Text("OTP Verification",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0),
                  textAlign: TextAlign.center),
            ),
            // "Verify your phone number".tr().text.bold.xl2.makeCentered(),
            /*   "Enter otp sent to your provided phone number"
                .tr()
                .text
                .makeCentered(),*/
            // OTP has been sent to +2348025773807
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      style: const TextStyle(
                          color: AppColor.formText,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      text: "OTP has been sent to "),
                  TextSpan(
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      text: "(${widget.phone})"),
                  widget.email!.isNotEmpty
                      ? TextSpan(
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          text: " and ")
                      : TextSpan(
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          text: ""),
                  widget.email!.isNotEmpty
                      ? TextSpan(
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          text: "(${widget.email})")
                      : TextSpan(
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          text: ""),
                ])),
              ),
            ),

            // Edit phone number
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Center(
                  child: Text("Edit phone number",
                      style: const TextStyle(
                          color: AppColor.butterscotch,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.center),
                ),
              ),
            ),

            //   "(${widget.phone})".text.lg.semiBold.makeCentered().py4(),
            //pin code
            Padding(
              padding: const EdgeInsets.only(
                top: 28.0,
              ),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * .8,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    textStyle: context.textTheme.bodyLarge!
                        .copyWith(fontSize: 20, color: Colors.white),
                    controller: pinTEC,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        fieldHeight: context.percentWidth * (80 / 8),
                        fieldWidth: (context.percentWidth * 65) / 7,
                        activeFillColor: AppColor.midnightCityYellow,
                        selectedColor: AppColor.midnightCityYellow,
                        inactiveColor: AppColor.midnightCityYellow,
                        borderRadius: BorderRadius.circular(5)),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: false,
                    onCompleted: (pin) {
                      print("Completed");
                      print("Pin ==> $pin");
                      smsCode = pin;
                    },
                    onChanged: (value) {
                      smsCode = value;
                    },
                  ),
                ),
              ),
            ),

            // 02:00

            // Haven’t got the code?
            /*         Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Center(
                child: Text("Haven’t got the code?",
                    style: const TextStyle(
                        color: AppColor.formText,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.center),
              ),
            ),
*/
            /*  Center(
              child: Visibility(
                visible: widget.onResendCode != null,
                child: HStack(
                  [
                    Visibility(
                      visible: resendSecs ==  0,
                      child: CustomTextButton(
                        titleColor: AppColor.midnightCityYellow,
                        loading: loading,
                        title: "Resend code via SMS".tr(),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await widget.onResendCode();

                          setState(() {
                            loading = false;
                            resendSecs = maxResendSeconds;
                          });
                          //
                          startCountDown();
                        },
                      ),
                    ),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                  alignment: MainAxisAlignment.center,
                ).py12(),
              ),
            ),*/
            //submit
            Visibility(
              visible: widget.onResendCode != null,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: VStack(
                    [
                      "Haven’t got the code?".tr().text.white.make(),
                      Visibility(
                        visible: resendSecs > 0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Center(
                            child: TweenAnimationBuilder<Duration>(
                              duration: Duration(seconds: resendSecs),
                              tween: Tween(
                                  begin: Duration(seconds: resendSecs),
                                  end: Duration.zero),
                              onEnd: () {
                                setState(() {
                                  resendSecs = 0;
                                });
                              },
                              builder: (BuildContext context, Duration value,
                                  Widget? child) {
                                final minutes = value.inMinutes;
                                final seconds = value.inSeconds % 60;
                                return Text('$minutes:$seconds',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.butterscotch,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0));
                              },
                              //builder:

                              //       builder: (BuildContext context, Duration value,
                              //       Widget child) {
                              // final minutes = value.inMinutes;
                              // final seconds = value.inSeconds % 60;
                              // return Text('$minutes:$seconds',
                              // textAlign: TextAlign.center,
                              // style: TextStyle(
                              // color: AppColor.butterscotch,
                              // fontWeight: FontWeight.w600,
                              // fontFamily: "Poppins",
                              // fontStyle: FontStyle.normal,
                              // fontSize: 16.0));
                              // }
                            ),
                          ),
                        ),

                        /* "($resendSecs)"
                            .text
                            .bold
                            .color(AppColor.midnightCityYellow)
                            .make()
                            .px4(),*/
                      ),
                      Visibility(
                        visible: resendSecs == 0,
                        child: CustomTextButton(
                          titleColor: AppColor.midnightCityYellow,
                          loading: loading,
                          title: "Resend OTP".tr(),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            await widget!.onResendCode!();
                            setState(() {
                              loading = false;
                              resendSecs = maxResendSeconds;
                            });
                            //
                            startCountDown();
                          },
                        ),
                      ),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                    alignment: MainAxisAlignment.center,
                  ).py12(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 30.0, right: 30, left: 30),
              child: CustomButton(
                color: AppColor.midnightCityLightBlue,
                height: 35,
                title: "Verify".tr(),
                loading: widget.vm!.busy(widget.vm!.firebaseVerificationId!),
                onPressed: () {
                  //
                  if (smsCode == null || smsCode!.length != 6) {
                    widget.vm!.toastError("Verification code required".tr());
                  } else {
                    widget!.onSubmit!(smsCode!);
                  }
                },
              ),
            ),

            //
          ],
        ).p20().hFull(context),
      ),
    );
  }

  //
  void startCountDown() async {
    //
    if (resendSecs > 0) {
      setState(() {
        resendSecs -= 1;
      });

      //
      await Future.delayed(1.seconds);
      startCountDown();
    }
  }
}
