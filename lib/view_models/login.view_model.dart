import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/models/api_response.dart';
import 'package:midnightcity/requests/auth.request.dart';
import 'package:midnightcity/services/alert.service.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/services/social_media_login.service.dart';
import 'package:midnightcity/traits/qrcode_scanner.trait.dart';
import 'package:midnightcity/views/pages/auth/register.page.dart';
import 'package:midnightcity/widgets/bottomsheets/account_verification_entry.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/services/validator.service.dart';

class LoginViewModel extends MyBaseViewModel with QrcodeScannerTrait {
  //the textediting controllers
  TextEditingController phoneTEC = new TextEditingController();
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  //
  AuthRequest authRequest = AuthRequest();
  SocialMediaLoginService socialMediaLoginService = SocialMediaLoginService();
  bool otpLogin = AppStrings.enableOTPLogin;
  late Country selectedCountry;
  late String accountPhoneNumber;

  LoginViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void initialise() {
    //
    emailTEC.text = kReleaseMode ? "" : "email@email.com";
    passwordTEC.text = kReleaseMode ? "" : "password";

    //phone login
    try {
      this.selectedCountry = Country.parse("NG");
      /* this.selectedCountry = Country.parse(AppStrings.countryCode
          .toUpperCase()
          .replaceAll("AUTO,", "")
          .split(",")[0]);*/
    } catch (error) {
      this.selectedCountry = Country.parse("NG");
    }
  }

  toggleLoginType() {
    otpLogin = !otpLogin;
    notifyListeners();
  }

  showCountryDialPicker() {
    showCountryPicker(
      context: viewContext!,
      showPhoneCode: true,
      onSelect: countryCodeSelected,
    );
  }

  countryCodeSelected(Country country) {
    selectedCountry = country;
    notifyListeners();
  }

  void processOTPLogin() async {
    //
    dynamic accountExist;
    accountPhoneNumber = "+${selectedCountry.phoneCode}${phoneTEC.text}";
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState!.validate()) {
      //
      accountExist = await authRequest.verifyPhoneAccount(accountPhoneNumber);
      print(accountExist.code.toString());
      if (accountExist.code.toString() == "200") {
        if (AppStrings.isFirebaseOtp) {
          processFirebaseOTPVerification();
        } else {
          processCustomOTPVerification();
        }
      } else {
        AlertService.error(
          title: "Invalid Account",
          text: accountExist.message.toString(),
        );
      }
    }
  }

  //PROCESSING VERIFICATION
  processFirebaseOTPVerification() async {
    setBusyForObject(otpLogin, true);
    //firebase authentication
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: accountPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // firebaseVerificationId = credential.verificationId;
        // verifyFirebaseOTP(credential.smsCode);
        print("verificationCompleted ==>  Yes");
        // finishOTPLogin(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        log("Error message ==> ${e.message}");
        if (e.code == 'invalid-phone-number') {
          viewContext!
              .showToast(msg: "Invalid Phone Number".tr(), bgColor: Colors.red);
        } else {
          viewContext!.showToast(msg: e.message!, bgColor: Colors.red);
        }
        //
        setBusyForObject(otpLogin, false);
      },
      // codeSent: (String verificationId, int resendToken) async {
      //   firebaseVerificationId = verificationId;
      //   print("codeSent ==>  $firebaseVerificationId");
      //   showVerificationEntry();
      // },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("codeAutoRetrievalTimeout called");
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        print("codeSent ==>  $verificationId");
        firebaseVerificationId = verificationId;
        showVerificationEntry();
      },
    );
    setBusyForObject(otpLogin, false);
  }

  processCustomOTPVerification() async {
    setBusyForObject(otpLogin, true);
    try {
      await authRequest.sendOTP(accountPhoneNumber);
      setBusyForObject(otpLogin, false);
      showVerificationEntry();
    } catch (error) {
      setBusyForObject(otpLogin, false);
      viewContext!.showToast(msg: "$error", bgColor: Colors.red);
    }
  }

  //
  void showVerificationEntry() async {
    //
    setBusy(false);
    //

    Navigator.push(
      viewContext!,
      MaterialPageRoute(
          builder: (context) => AccountVerificationEntry(
                vm: this,
                phone: accountPhoneNumber,
                onSubmit: (smsCode) {
                  //
                  if (AppStrings.isFirebaseOtp) {
                    verifyFirebaseOTP(smsCode);
                  } else {
                    verifyCustomOTP(smsCode);
                  }

                  //viewContext!.pop();
                },
                onResendCode: AppStrings.isCustomOtp
                    ? () async {
                        try {
                          final response = await authRequest.sendOTP(
                            accountPhoneNumber,
                          );
                          toastSuccessful(response.message!);
                        } catch (error) {
                          viewContext!
                              .showToast(msg: "$error", bgColor: Colors.red);
                        }
                      }
                    : null,
              )),
    );
  }

  //
  void verifyFirebaseOTP(String smsCode) async {
    //
    setBusyForObject(otpLogin, true);

    // Sign the user in (or link) with the credential
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: firebaseVerificationId!,
        smsCode: smsCode,
      );

      //
      await finishOTPLogin(phoneAuthCredential);
    } catch (error) {
      viewContext!.showToast(msg: "$error", bgColor: Colors.red);
    }
    //
    setBusyForObject(otpLogin, false);
  }

  void verifyCustomOTP(String smsCode) async {
    //
    setBusy(true);
    // Sign the user in (or link) with the credential
    debugger();
    try {
      final apiResponse = await authRequest.verifyOTP(
        accountPhoneNumber,
        smsCode,
        isLogin: true,
      );
      debugger();
      //
      await handleDeviceLogin(apiResponse);
    } catch (error) {
      viewContext!.showToast(msg: "$error", bgColor: Colors.red);
    }
    //
    setBusy(false);
  }

  //Login to with firebase token
  finishOTPLogin(AuthCredential authCredential) async {
    //
    setBusyForObject(otpLogin, true);
    // Sign the user in (or link) with the credential
    try {
      //
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        authCredential,
      );
      //
      String? firebaseToken = await userCredential.user!.getIdToken();
      final apiResponse = await authRequest.verifyFirebaseToken(
        accountPhoneNumber,
        firebaseToken,
      );
      //
      await handleDeviceLogin(apiResponse);
    } catch (error) {
      viewContext!.showToast(msg: "$error", bgColor: Colors.red);
    }
    //
    setBusyForObject(otpLogin, false);
  }

  //REGULAR LOGIN
  void processLogin() async {
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState!.validate()) {
      //

      setBusy(true);

      final apiResponse = await authRequest.loginRequest(
        email: emailTEC.text,
        password: passwordTEC.text,
      );

      //
      // Navigator.pop(viewContext!);
      await handleDeviceLogin(apiResponse);

      setBusy(false);
    }
  }

  //QRCode login
  void initateQrcodeLogin() async {
    //
    final loginCode = await openScanner(viewContext!);
    if (loginCode == null) {
      toastError("Operation failed/cancelled".tr());
    } else {
      setBusy(true);

      try {
        final apiResponse = await authRequest.qrLoginRequest(
          code: loginCode,
        );
        //
        await handleDeviceLogin(apiResponse);
      } catch (error) {
        print("QR Code login error ==> $error");
      }

      setBusy(false);
    }
  }

  ///
  ///
  ///
  handleDeviceLogin(ApiResponse apiResponse) async {
    try {
      if (apiResponse.hasError()) {
        //there was an error
        CoolAlert.show(
          context: viewContext!,
          type: CoolAlertType.error,
          title: "Login Failed".tr(),
          text: apiResponse.message,
        );
      } else {
        //everything works well
        //firebase auth
        setBusy(true);
        debugger();
        final fbToken = apiResponse.body["fb_token"];
        await FirebaseAuth.instance.signInWithCustomToken(fbToken);
        debugger();
        await AuthServices.saveUser(apiResponse.body["user"]);
        await AuthServices.setAuthBearerToken(apiResponse.body["token"]);
        await AuthServices.isAuthenticated();
        setBusy(false);
        //viewContext!.pop(true);
        Navigator.pop(viewContext!);
      }
    } on FirebaseAuthException catch (error) {
      CoolAlert.show(
        context: viewContext!,
        type: CoolAlertType.error,
        title: "Login Failed".tr(),
        text: "${error.message}",
      );
    } catch (error) {
      CoolAlert.show(
        context: viewContext!,
        type: CoolAlertType.error,
        title: "Login Failed".tr(),
        text: "${error}",
      );
    }
  }

  ///

  void openRegister({
    String? email = "",
    String? name = "",
    String? phone = "",
  }) async {
    // viewContext!.push(
    //   (context) => RegisterPage(
    //     email: email,
    //     name: name,
    //     phone: phone,
    //   ),
    // );

    Navigator.push(
        viewContext!,
        MaterialPageRoute(
          builder: (context) => RegisterPage(
            email: email,
            name: name,
            phone: phone,
          ),
        ));
  }

  void openForgotPassword() {
    // viewContext!.navigator.pushNamed(
    //   AppRoutes.forgotPasswordRoute,
    // );
    Navigator.pushNamed(
      viewContext!,
      AppRoutes.forgotPasswordRoute,
    );
  }
}
