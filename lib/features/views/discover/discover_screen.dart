import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  final CardSwiperController _swiperController = CardSwiperController();

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: _advancedDrawerController,
      //backdropColor: AppColors.secondaryColor,
      animationCurve: Curves.easeOutCubic,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,

      childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
      drawer: FilterDrawer(_advancedDrawerController),
      // Reuse your existing FilterDrawer widget
      child: Scaffold(
        appBar: CustomAppBar(
          leading: IconButton(
            onPressed: () {
              _advancedDrawerController.showDrawer(); // open drawer
            },
            icon: Assets.icons.filterIcon.svg(),
          ),

          title: 'Discover',
        ),
        body: Column(
          children: [
            Flexible(
              child: CardSwiper(
                controller: _swiperController,
                cardsCount: HelperData.fakeData.length,
                cardBuilder: (
                  context,
                  index,
                  horizontalThresholdPercentage,
                  verticalThresholdPercentage,
                ) {
                  final discoverData = HelperData.fakeData[index];
                  return CustomContainer(
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
                            imageUrl: discoverData['image'] ?? '',
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
                                text: discoverData['title'] ?? '',
                                color: Colors.white,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.white),
                                  Flexible(
                                    child: CustomText(
                                      text: discoverData['subtitle'] ?? '',
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
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomContainer(
                  onTap:
                      () => _swiperController.swipe(CardSwiperDirection.right),
                  color: Colors.white,
                  elevation: true,
                  shape: BoxShape.circle,
                  paddingAll: 16.r,
                  child: Assets.icons.cleanIcon.svg(height: 24.r, width: 24.r),
                ),
                CustomContainer(
                  onTap: () => Get.toNamed(AppRoutes.loveScreen),
                  color: AppColors.secondaryColor,
                  elevation: true,
                  shape: BoxShape.circle,
                  paddingAll: 16.r,
                  child: Assets.icons.love.svg(
                    height: 34.r,
                    width: 34.r,
                    color: Colors.white,
                  ),
                ),
                CustomContainer(
                  onTap: () => Get.toNamed(AppRoutes.giftsScreen),
                  color: Colors.white,
                  elevation: true,
                  shape: BoxShape.circle,
                  paddingAll: 16.r,
                  child: Assets.icons.gift.svg(height: 24.r, width: 24.r),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
