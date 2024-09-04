import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/features/constants/constants.dart';
import '../controllers/splash_page_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashPageController controller;

  @override
  void initState() {
    controller = Get.find<SplashPageController>();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC8102E),
      body: Center(
        child: FadeTransition(
          opacity: controller.fadeAnimation,
          child: ScaleTransition(
            scale: controller.scaleAnimation,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: AssetImage(Constants.marvelLogo),
                  color: Colors.white,
                  width: 350,
                ),
                SizedBox(height: 20),
                Text(
                  'Mottu Marvel',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
