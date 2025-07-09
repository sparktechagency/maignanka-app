import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomContainer(
        width: double.infinity,
        linearColors: AppColors.splashLinearColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 60.h),
              Assets.icons.logoSvg.svg(),
              Assets.images.onboardingImage.image(),
            ],
          ),
        ),
      ),
      bottomSheet: _buildCustomBottomSheet(),
    );
  }

  Widget _buildCustomBottomSheet() {
    return CustomContainer(
      paddingHorizontal: 16.w,
      paddingVertical: 32.h,
      width: double.infinity,
      height: 300.h,
      border: Border(top: BorderSide(color: AppColors.primaryColor)),
      topLeftRadius: 20.r,
      topRightRadius: 20.r,
      child: SafeArea(
        child: Column(
          children: [
            CustomText(text: 'Welcome to Our app', fontSize: 18.sp),
            SizedBox(height: 32.h),
            CustomButton(onPressed: () {
              Get.toNamed(AppRoutes.loginScreen);

            }, label: 'Sign In'),
            SizedBox(height: 14.h),
            CustomButton(
              onPressed: () {
                Get.toNamed(AppRoutes.signUpScreen);
              },
              label: 'Sign Up',
              backgroundColor: AppColors.primaryShade100,
              foregroundColor: AppColors.primaryColor,
            ),
            SizedBox(height: 14.h),
            CustomText(text: 'Or'),
            SizedBox(height: 14.h),
            GestureDetector(
              onTap: (){
                Get.toNamed(AppRoutes.joinGuestScreen);
              },
              child: CustomText(
                text: 'Join as Guest',
                fontSize: 18.sp,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
