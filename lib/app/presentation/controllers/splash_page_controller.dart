import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_mottu_mobile/app/core/features/routes/app_navigator.dart';

class SplashPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void onInit() async {
    super.onInit();
    try {
      animationController = AnimationController(
        duration: const Duration(milliseconds: 350),
        vsync: this,
      );

      fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeIn,
        ),
      );

      scaleAnimation = Tween(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
      );

      animationController.forward();

      await Future.delayed(const Duration(seconds: 3));
      AppNavigator.home();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
