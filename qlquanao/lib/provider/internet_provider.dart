import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider extends ChangeNotifier {
  bool _hasInternet = false;

  bool get hasInternet => _hasInternet;

  InternetProvider() {
    checkInternetConnection();
  }

  Future checkInternetConnection() async {
    var reslt = await Connectivity().checkConnectivity();
    if (reslt == ConnectivityResult.none) {
      _hasInternet = false;
    } else {
      _hasInternet = true;
      notifyListeners();
    }
  }
}
