import 'package:get/get.dart';

class AppNavigator {
  static final splash = _SplashNavigator();
  static final home = _HomeNavigator();
  static final characterOverview = _CharOverviewNavigator();
}

class _SplashNavigator {
  call() => Get.offNamed(
        '/',
      );
}

class _HomeNavigator {
  call() => Get.offNamed(
        '/home',
      );
}

class _CharOverviewNavigator {
  Future<void> call({required int characterId}) async => await Get.toNamed(
        '/character_overview',
        arguments: characterId,
      );
}
