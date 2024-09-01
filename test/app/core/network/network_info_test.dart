import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:im_mottu_mobile/app/core/network/network_info.dart';
import 'package:im_mottu_mobile/app/core/network/network_info_datasource.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkInfoDatasource extends Mock implements NetworkInfoDatasource {}

void main() {
  late NetworkInfo networkInfo;
  late MockNetworkInfoDatasource mockNetworkInfoDatasource;
  late StreamController<bool> controller;

  setUp(() {
    mockNetworkInfoDatasource = MockNetworkInfoDatasource();
    networkInfo = NetworkInfo(mockNetworkInfoDatasource);
    controller = StreamController<bool>();
  });

  tearDown(() {
    controller.close();
  });

  test('should initialize connectivity and listen for changes', () async {
    when(() => mockNetworkInfoDatasource.onConnectivityChanged)
        .thenAnswer((_) => Stream.value(true));

    networkInfo.onInit();
    await Future.delayed(const Duration(milliseconds: 200));

    expect(networkInfo.hasConnection.value, true);
  });

  test('should cancel subscription on close', () async {
    when(() => mockNetworkInfoDatasource.onConnectivityChanged)
        .thenAnswer((_) => Stream.value(true));
    networkInfo.onInit();
    networkInfo.onClose();
    verify(() => mockNetworkInfoDatasource.onConnectivityChanged).called(1);
  });
}
