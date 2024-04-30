// ignore_for_file: constant_pattern_never_matches_value_type

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { WiFi, Cellular, Offline }

class ConnectivityProvider extends ChangeNotifier {
  late Connectivity _connectivity;

  ConnectivityStatus _status = ConnectivityStatus.Offline;

  ConnectivityStatus get status => _status;

  ConnectivityProvider() {
    _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen(
        _updateStatus as void Function(List<ConnectivityResult> event)?);
    _updateStatus();
  }

  Future<void> _updateStatus() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        _status = ConnectivityStatus.WiFi;
        break;
      case ConnectivityResult.mobile:
        _status = ConnectivityStatus.Cellular;
        break;
      case ConnectivityResult.none:
        _status = ConnectivityStatus.Offline;
        break;
    }
    notifyListeners();
  }
}
