import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/profile_details/profile_controller.dart';
import 'package:maignanka_app/features/views/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class LoveScreen extends StatelessWidget {
  const LoveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = Get.arguments['imageUrl'];
    return CustomScaffold(
      paddingSide: 24.w,
      body: Column(
        children: [
          SizedBox(height: 80.h),
          SizedBox(
            height: 334.h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Male Image
                Positioned(
                  right: 40.w,
                  child: _buildRotatedImage(
                    imageUrl: '${ApiUrls.imageBaseUrl}${Get.find<ProfileController>().userImage}',
                    angle: 0.2,
                  ),
                ),
                // Female Image
                Positioned(
                  top: 100.h,
                  left: 40.w,
                  child: _buildRotatedImage(
                    imageUrl: imageUrl,
                    angle: -0.2,
                  ),
                ),
                // Love Icon 1
                Positioned(left: 44.h, bottom: 0.h, child: _buildIcon()),
                // Love Icon 2
                Positioned(right: 110.h, top: -24.h, child: _buildIcon()),
              ],
            ),
          ),
          //SizedBox(height: 10.h),
          CustomText(
            text: 'It’s a match, Jake!',
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
            fontSize: 28.sp,
          ),
          CustomText(
            text: 'Start a conversation now with each other',
            fontWeight: FontWeight.w400,
            color: AppColors.appGreyColor,
            top: 4.h,
            bottom: 32.h,
          ),
          CustomButton(onPressed: () {
            Get.toNamed(AppRoutes.customBottomNavBar);
            Get.find<CustomBottomNavBarController>().onChange(2);
          }, label: 'Say hello'),
          SizedBox(height: 12.h),
          CustomButton(
            onPressed: () {
              Get.back();
            },
            label: 'Keep swiping',
            backgroundColor: Color(0xffFCE6E8),
            foregroundColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildRotatedImage({required String imageUrl, required double angle}) {
    return Transform.rotate(
      angle: angle,
      child: CustomNetworkImage(
        elevation: true,
        borderRadius: 15.r,
        imageUrl: imageUrl,
        width: 150.w,
        height: 210.h,
      ),
    );
  }

  Widget _buildIcon() {
    return CustomContainer(
      color: Colors.white,
      elevation: true,
      shape: BoxShape.circle,
      paddingAll: 14.r,
      child: Assets.icons.love.svg(
        height: 24.r,
        width: 24.r,
        color: AppColors.primaryColor,
      ),
    );
  }
}
