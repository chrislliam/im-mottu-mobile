import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/features/di/dependency_injection.dart';
import 'app/core/features/local_storage/local_storage.dart';
import 'app/core/network/network_info.dart';
import 'app/presentation/pages/character_overview_page.dart';
import 'app/presentation/pages/home_page.dart';
import 'app/presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  DependencyInjection.init();
  runApp(const AppWidget());
}

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    Get.find<NetworkInfo>().onInit();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      LocalStorage.clearCache();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mottu Marvel',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white)),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashPage()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(
            name: '/character_overview',
            page: () => const CharacterOverviewPage())
      ],
    );
  }
}
