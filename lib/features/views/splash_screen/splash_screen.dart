import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/features/views/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
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



  void _goNextScreen() {
    Future.delayed(const Duration(seconds: 2), () async {
      String token = await PrefsHelper.getString(AppConstants.bearerToken);
      bool isEmailVerified = await PrefsHelper.getBool(AppConstants.isEmailVerified);
      bool profilePicture = await PrefsHelper.getBool(AppConstants.profilePicture);
      int completed = await PrefsHelper.getInt(AppConstants.completed);

      if (token.isEmpty || !isEmailVerified || profilePicture) {
        Get.offAllNamed(AppRoutes.onboardingScreen);
      }
      else if (completed == 0 && token.isNotEmpty) {
        Get.offAllNamed(AppRoutes.customBottomNavBar);
        Get.find<CustomBottomNavBarController>().onChange(0);
      }
    });
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
