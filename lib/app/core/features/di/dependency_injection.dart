import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../marvel_controller.dart';
import '../http_client/http_client.dart';
import '../../network/network_info.dart';
import '../../network/network_info_datasource.dart';

class DependencyInjection {
  static void init() {
    Get.lazyPut<HttpClient>(() => DioHttpClient());

    Get.lazyPut<NetworkInfoDatasource>(
      () => NetworkInfoDatasourceImpl(
        const EventChannel('com.mottu.marvel.im_mottu_mobile/connectivity/status'),
      ),
    );

    Get.lazyPut<NetworkInfo>(
      () => NetworkInfo(Get.find<NetworkInfoDatasource>()),
    );

    Get.lazyPut<MarvelController>(
      () => MarvelController(Get.find<HttpClient>()),
    );
  }
}
