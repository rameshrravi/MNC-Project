import 'package:cool_alert/cool_alert.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:midnightcity/constants/app_routes.dart';
import 'package:midnightcity/constants/app_strings.dart';
import 'package:midnightcity/requests/auth.request.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/widgets/bottomsheets/account_verification_entry.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:midnightcity/services/alert.service.dart';
import 'dart:io';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:midnightcity/services/toast.service.dart';
import 'package:midnightcity/view_models/base.view_model.dart';
import 'package:midnightcity/views/pages/payment/custom_webview.page.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterViewModel extends MyBaseViewModel {
  //
  AuthRequest _authRequest = AuthRequest();
  // FirebaseAuth auth = FirebaseAuth.instance;
  //the textediting controllers
  TextEditingController nameTEC =
      new TextEditingController(text: !kReleaseMode ? "" : "");
  TextEditingController emailTEC =
      new TextEditingController(text: !kReleaseMode ? "" : "");
  TextEditingController phoneTEC =
      new TextEditingController(text: !kReleaseMode ? "" : "");
  TextEditingController passwordTEC =
      new TextEditingController(text: !kReleaseMode ? "" : "");
  TextEditingController referralCodeTEC = new TextEditingController();
  late Country selectedCountry;
  late String accountPhoneNumber;
  late String accountEmailId;
  bool agreed = false;

  RegisterViewModel(BuildContext context) {
    this.viewContext = context;
    try {
      this.selectedCountry = Country.parse("NG");
      /*this.selectedCountry =

          Country.parse(AppStrings.countryCode
          .toUpperCase()
          .replaceAll("AUTO,", "")
          .split(",")[0]);*/
    } catch (error) {
      this.selectedCountry = Country.parse("NG");
    }
  }

  //
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

  void processRegister() async {
    //
    //accountPhoneNumber = "+${selectedCountry.phoneCode}${phoneTEC.text}";
    accountPhoneNumber = "+234${phoneTEC.text}";
    accountEmailId = emailTEC.text;
    //
    // Validate returns true if the form is valid, otherwise false.
    if (!formKey.currentState!.validate()) {
    } else {
      if (!agreed) {
        AlertService.error(
            title: "Terms & Conditions",
            text: "Please agree with Terms & Conditions");
      }
    }

    if (formKey.currentState!.validate() && agreed) {
      //
      if (AppStrings.isFirebaseOtp) {
        processFirebaseOTPVerification();
      } else if (AppStrings.isCustomOtp) {
        processCustomOTPVerification();
      } else {
        finishAccountRegistration();
      }
    }
  }

  //PROCESSING VERIFICATION
  processFirebaseOTPVerification() async {
    setBusy(true);
    //firebase authentication
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: accountPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // firebaseVerificationId = credential.verificationId;
        // verifyFirebaseOTP(credential.smsCode);
        finishAccountRegistration();
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          viewContext!
              .showToast(msg: "Invalid Phone Number".tr(), bgColor: Colors.red);
        } else {
          viewContext!.showToast(msg: e.message!, bgColor: Colors.red);
        }
        //
        setBusy(false);
      },
      // codeSent: (String verificationId, int resendToken) async {
      //   firebaseVerificationId = verificationId;
      //   showVerificationEntry();
      // },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("codeAutoRetrievalTimeout called");
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        firebaseVerificationId = verificationId;
        showVerificationEntry();
      },
    );
  }

  processCustomOTPVerification() async {
    dynamic accountExist;
    setBusy(true);
    accountExist = await _authRequest.verifyPhoneAccount(accountPhoneNumber);

    if (accountExist.code.toString() == "401") {
      setBusy(false);
      AlertService.error(
        title: "Invalid Phone number",
        text: accountExist.message.toString(),
      );
    } else if (accountExist.code.toString() == "200") {
      setBusy(false);
      AlertService.error(
        title: "Phone number Exists",
        text:
            "This phone number already associated with an account. Please check.",
      );
    } else {
      try {
        await _authRequest.sendOTPNew(accountPhoneNumber, accountEmailId);
        setBusy(false);
        showVerificationEntry();
      } catch (error) {
        setBusy(false);
        viewContext!.showToast(msg: "$error", bgColor: Colors.red);
      }
    }
  }

  //
  void showVerificationEntry() async {
    //
    setBusy(false);
    //
    // await viewContext!.push(
    //   (context) => AccountVerificationEntry(
    //     vm: this,
    //     phone: accountPhoneNumber,
    //     email: accountEmailId,
    //
    //     onSubmit: (smsCode) {
    //       //
    //       if (AppStrings.isFirebaseOtp) {
    //         verifyFirebaseOTP(smsCode);
    //       } else if (AppStrings.isCustomOtp) {
    //         verifyCustomOTP(smsCode);
    //       }
    //
    //       viewContext!.pop();
    //     },
    //
    //     onResendCode: AppStrings.isCustomOtp
    //         ? () async {
    //             try {
    //               final response = await _authRequest.sendOTPNew(
    //                 accountPhoneNumber,accountEmailId
    //               );
    //               toastSuccessful(response.message);
    //             } catch (error) {
    //               viewContext!.showToast(msg: "$error", bgColor: Colors.red);
    //             }
    //           }
    //         : null,
    //   ),
    // );
  }

  //
  void verifyFirebaseOTP(String smsCode) async {
    //
    setBusyForObject(firebaseVerificationId, true);

    // Sign the user in (or link) with the credential
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: firebaseVerificationId!,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      await finishAccountRegistration();
    } catch (error) {
      viewContext!.showToast(msg: "$error", bgColor: Colors.red);
    }
    //
    setBusyForObject(firebaseVerificationId, false);
  }

  void verifyCustomOTP(String smsCode) async {
    //
    //  setBusyForObject(firebaseVerificationId, true);
    setBusy(true);
    // Sign the user in (or link) with the credential
    try {
      await _authRequest.verifyOTP(accountPhoneNumber, smsCode);
      //  print("ssss");
      await finishAccountRegistration();
      //  print("dafdsfdsf");
    } catch (error) {
      // print(error.toString());
      viewContext!.showToast(msg: "$error", bgColor: Colors.red);
    }
    //
    setBusy(false);
    //setBusyForObject(firebaseVerificationId, false);
  }

///////
  ///
  Future<void> finishAccountRegistration() async {
    setBusy(true);
    // print("gfjklgjdfkgjdf");
    final apiResponse = await _authRequest.registerRequest(
      name: nameTEC.text,
      email: emailTEC.text,
      phone: accountPhoneNumber,
      countryCode: selectedCountry.countryCode,
      password: passwordTEC.text,
      code: referralCodeTEC.text ?? "",
    );
    // print("vvvvvvv");
    //  print(apiResponse.body);
    //  print(apiResponse.message);
    //  print(apiResponse.errors.toString());

    try {
      if (apiResponse.hasError()) {
        //there was an error
        CoolAlert.show(
          context: viewContext!,
          type: CoolAlertType.error,
          title: "Registration Failed".tr(),
          text: apiResponse.message,
        );
      } else {
        //everything works well
        //firebase auth
        final fbToken = apiResponse.body["fb_token"];
        await FirebaseAuth.instance.signInWithCustomToken(fbToken);
        await AuthServices.saveUser(apiResponse.body["user"]);
        await AuthServices.setAuthBearerToken(apiResponse.body["token"]);
        await AuthServices.isAuthenticated();
        setBusy(false);
        // viewContext!.navigator.pushNamedAndRemoveUntil(
        //   AppRoutes.chooseVendorRoute,
        //   (_) => false,
        // );
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
        // text: "${error!['message'] ?? error}",
      );
    }
  }

  void openLogin() async {
    // viewContext!.pop();
  }

  // verifyRegistrationOTP(String text) {}
}
