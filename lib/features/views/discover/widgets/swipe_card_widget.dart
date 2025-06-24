import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/models/swipe_data_model.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class SwipeCardWidget extends StatelessWidget {
  const SwipeCardWidget({
    super.key,
    required this.swipeData, required this.onTap,
  });

  final SwipeDataModel swipeData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: onTap,
      color: AppColors.secondaryColor,
      width: double.infinity,
      height: double.infinity,
      radiusAll: 16.r,
      bordersColor: AppColors.secondaryColor,
      borderWidth: 0.5,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: CustomNetworkImage(
              imageUrl:
              '${ApiUrls.imageBaseUrl}${swipeData.pictures?.first.imageURL}',
            ),
          ),
          Positioned(
            left: 10.w,
            right: 10.w,
            bottom: 10.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: '${swipeData.name?.split(' ').first} ${swipeData.age}',
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    Flexible(
                      child: CustomText(
                        text: '${swipeData.distance?.toStringAsFixed(2) ?? ''} km',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
