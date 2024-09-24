import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:midnightcity/models/vendor_type.dart';
import 'package:midnightcity/requests/vendor_type.request.dart';
import 'package:midnightcity/services/auth.service.dart';
import 'package:midnightcity/view_models/base.view_model.dart';

class WelcomeViewModel extends MyBaseViewModel {
  //
  WelcomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  Widget? selectedPage;
  List<VendorType>? vendorTypes = [];
  VendorTypeRequest? vendorTypeRequest = VendorTypeRequest();
  bool showGrid = true;
  StreamSubscription? authStateSub;

  //
  //
  initialise() async {
    await getVendorTypes();
    listenToAuth();
  }

  listenToAuth() {
    authStateSub = AuthServices.listenToAuthState().listen((event) {
      genKey = GlobalKey();
      notifyListeners();
    });
  }

  getVendorTypes() async {
    setBusy(true);
    try {
      vendorTypes = await vendorTypeRequest!.index();

      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }
}
