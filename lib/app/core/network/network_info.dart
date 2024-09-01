import 'dart:async';

import 'package:get/get.dart';
import 'network_info_datasource.dart';

/// [NetworkInfo] is a controller that monitors the network connectivity status of the device.
/// It uses the [NetworkInfoDatasource] to receive the connectivity status from the native code.
class NetworkInfo extends GetxController {
  static late StreamSubscription<bool> connectivitySubscription;

  final NetworkInfoDatasource _networkInfoDatasource;

  NetworkInfo(this._networkInfoDatasource);

  final hasConnection = Rx<bool>(false);

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
  }

  void _initializeConnectivity() {
    connectivitySubscription =
        _networkInfoDatasource.onConnectivityChanged.listen((status) {
      hasConnection.value = status;
    });
  }

  @override
  void onClose() {
    connectivitySubscription.cancel();
    super.onClose();
  }
}
