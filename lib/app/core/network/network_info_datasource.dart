import 'package:flutter/services.dart';

abstract interface class NetworkInfoDatasource {
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoDatasourceImpl implements NetworkInfoDatasource {
  final EventChannel eventChannel;

  NetworkInfoDatasourceImpl(this.eventChannel);

  @override
  Stream<bool> get onConnectivityChanged =>
      eventChannel.receiveBroadcastStream().cast<bool>();
}
