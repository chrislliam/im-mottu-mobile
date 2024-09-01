import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/core/network/network_info.dart';
import 'app/core/network/network_info_datasource.dart';

class DependencyInjection {
  static void init() {
    Get.lazyPut<NetworkInfoDatasource>(
      () => NetworkInfoDatasourceImpl(
       const EventChannel('com.mottu.marvel.im_mottu_mobile/connectivity/status'),
      ),
    );

    Get.lazyPut<NetworkInfo>(
      () => NetworkInfo(Get.find<NetworkInfoDatasource>()),
    );
  }
}
