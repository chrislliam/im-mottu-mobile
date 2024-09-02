import 'dart:io';

import 'package:flutter/services.dart';

abstract interface class NetworkInfoDatasource {
  Stream<bool> get onConnectivityChanged;

  Future<bool> get isConnected;
}

class NetworkInfoDatasourceImpl implements NetworkInfoDatasource {
  final EventChannel eventChannel;
  final MethodChannel methodChannel;

  NetworkInfoDatasourceImpl(this.eventChannel, this.methodChannel);

  @override
  Stream<bool> get onConnectivityChanged {
    if (Platform.isAndroid) {
      return eventChannel.receiveBroadcastStream().cast<bool>();
    } else {
      return Stream.value(true);
    }
  }

  @override
  Future<bool> get isConnected async {
    if (Platform.isAndroid) {
      final bool result = await methodChannel.invokeMethod('isConnected');
      return result;
    } else {
      return true;
    }
  }
}
