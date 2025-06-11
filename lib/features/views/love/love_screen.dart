import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';

class LoveScreen extends StatelessWidget {
  const LoveScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return CustomScaffold(
      body: Column(
        children: [
          SizedBox(height: 100.h),
          Expanded(
            child: Stack(
              children: [
                // Male Image
                Positioned(
                  right: 40.w,
                  child: _buildRotatedImage(
                    imageUrl: 'https://randomuser.me/api/portraits/men/6.jpg',
                    angle: 0.2,
                  ),
                ),
                // Female Image
                Positioned(
                  top: 100.h,
                  left: 40.w,
                  child: _buildRotatedImage(
                    imageUrl: 'https://randomuser.me/api/portraits/women/6.jpg',
                    angle: -0.2,
                  ),
                ),
                // Love Icon 1
                Positioned(
                  left: 42.h,
                  bottom: 180.h,
                  child: _buildIcon(),
                ),
                // Love Icon 2
                Positioned(
                  right: 110.h,
                  top: -24.h,
                  child: _buildIcon(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRotatedImage({
    required String imageUrl,
    required double angle,
  }) {
    return Transform.rotate(
      angle: angle,
      child: CustomNetworkImage(
        borderRadius: 15.r,
        imageUrl: imageUrl,
        width: 150.w,
        height: 220.h,
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
