import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heart_overlay/heart_overlay.dart';
import 'package:maignanka_app/app/helpers/helper_data.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/views/discover/widgets/filter_drawer.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _swiperController = CardSwiperController();
  final _drawerController = AdvancedDrawerController();
  final _heartController = HeartOverlayController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      disabledGestures: true,
      controller: _drawerController,
      animationCurve: Curves.easeOutCubic,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      childDecoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 6,
          ),
        ],
        borderRadius: BorderRadius.circular(16.r),
      ),
      drawer: FilterDrawer(_drawerController),
      child: Scaffold(
        appBar: CustomAppBar(
          leading: IconButton(
            onPressed: () => _drawerController.showDrawer(),
            icon: Assets.icons.filterIcon.svg(),
          ),
          title: 'Discover',
        ),
        body: HeartOverlay(
          controller: _heartController,
          duration: const Duration(seconds: 2),
          icon:  _actionButton(
            icon: Assets.icons.love.svg(height: 34.r, width: 34.r, color: Colors.white),
            color: AppColors.secondaryColor,
            onTap: (){},
          ),
          enableGestures: false,
          child: Column(
            children: [
              Flexible(child: _buildCardSwiper()),
             // SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(
                    icon: Assets.icons.cleanIcon.svg(height: 24.r, width: 24.r),
                    color: Colors.white,
                    onTap: () => _swiperController.swipe(CardSwiperDirection.left),
                  ),
                  _actionButton(
                    icon: Assets.icons.love.svg(height: 34.r, width: 34.r, color: Colors.white),
                    color: AppColors.secondaryColor,
                    onTap: _onLoveTapped,
                  ),
                  _actionButton(
                    icon: Assets.icons.gift.svg(height: 24.r, width: 24.r),
                    color: Colors.white,
                    onTap: () => Get.toNamed(AppRoutes.giftsScreen),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardSwiper() {
    return CardSwiper(
      controller: _swiperController,
      cardsCount: HelperData.fakeData.length,
      cardBuilder: (context, index, _, __) {
        final item = HelperData.fakeData[index];
        return CustomContainer(
          onTap: () {
            Get.toNamed(AppRoutes.profileDetailsScreen);
          },
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
                child: CustomNetworkImage(imageUrl: item['image'] ?? ''),
              ),
              Positioned(
                left: 10.w,
                right: 10.w,
                bottom: 10.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: item['title'] ?? '',
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white),
                        Flexible(
                          child: CustomText(
                            text: item['subtitle'] ?? '',
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
      },
    );
  }


  Widget _actionButton({required Widget icon, required Color color, required VoidCallback onTap}) {
    return CustomContainer(
      onTap: onTap,
      color: color,
      elevation: true,
      shape: BoxShape.circle,
      paddingAll: 16.r,
      child: icon,
    );
  }

  void _onLoveTapped()  {
    final size = _heartController.getSize() * 2;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final random = Random();

    // Show multiple hearts instantly
    for (int i = 0; i < 4; i++) {
      final offset = Offset(
        (width - size) / 1.2 + random.nextInt(100) - 40,
        height - size - 170 - random.nextInt(100),
      );

      _heartController.showIcon(offset: offset);
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      _swiperController.swipe(CardSwiperDirection.right);
    });

  }


}
