import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/views/splash_screen/widgets/splash_loading.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _goNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.toNamed(AppRoutes.onboardingScreen);
  }

  @override
  void initState() {
   _goNextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Assets.images.splashLove.image(),
          Positioned.fill(
            child: CustomContainer(
              width: double.infinity,
              linearColors: AppColors.splashLinearColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          Center(child: Assets.images.splashLogo.image(width: 290.w, height: 290.h)),

          Positioned(
            bottom: 70.h,
            left: 0,
            right: 0,
            child: Center(
              child: const SemiCircleLoader(),
            ),
          ),
        ],
      ),
    );
  }
}
