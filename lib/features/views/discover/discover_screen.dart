import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heart_overlay/heart_overlay.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/discover/discover_controller.dart';
import 'package:maignanka_app/features/controllers/discover/match_controller.dart';
import 'package:maignanka_app/features/views/discover/widgets/filter_drawer.dart';
import 'package:maignanka_app/features/views/discover/widgets/swipe_card_widget.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
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
  final DiscoverController _discoverController = Get.find<DiscoverController>();



  @override
  void initState() {
    _discoverController.swipeProfileGet();
    super.initState();
  }

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
          icon: _actionButton(
            icon: Assets.icons.love.svg(
              height: 34.r,
              width: 34.r,
              color: Colors.white,
            ),
            color: AppColors.secondaryColor,
            onTap: () {},
          ),
          enableGestures: false,
          child: Column(
            children: [
              Expanded(
                child: GetBuilder<DiscoverController>(
                  builder: (controller) {
                    if (controller.isLoading) {
                      return const CustomLoader();
                    }

                    if (controller.swipeDataList.isEmpty) {
                      return Center(
                        child: CustomText(text: 'No profiles found.'),
                      );
                    }

                    return CardSwiper(
                      controller: _swiperController,
                      cardsCount: controller.swipeDataList.length,
                      numberOfCardsDisplayed: controller.swipeDataList.length >= 2 ? 2 : 1,

                      onSwipe: (oldIndex, newIndex, direction) {
                        if (newIndex! >= 0 && newIndex < controller.swipeDataList.length) {
                          controller.currentUserId = controller.swipeDataList[newIndex].userId ?? '';
                          controller.update();
                        }
                        return true;
                      },

                      onEnd: () async {
                        await controller.loadMore();
                      },

                      cardBuilder: (context, index, _, __) {
                        if (index < 0 || index >= controller.swipeDataList.length) {
                          return Center(child: CustomText(text: 'No profiles found.'));
                        }
                        final swipeData = controller.swipeDataList[index];
                        return SwipeCardWidget(swipeData: swipeData, onTap: () {
                          Get.toNamed(AppRoutes.profileDetailsScreen,arguments: {'userId' : swipeData.userId ?? ''});

                        },);
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(
                    icon: Assets.icons.cleanIcon.svg(height: 24.r, width: 24.r),
                    color: Colors.white,
                    onTap:
                        () => _swiperController.swipe(CardSwiperDirection.left),
                  ),

                  GetBuilder<MatchController>(
                    builder: (controller) {
                      return AvatarGlow(
                        duration: const Duration(milliseconds: 500),
                        startDelay: const Duration(microseconds: 1000),
                        glowColor: AppColors.secondaryColor,
                        glowShape: BoxShape.circle,
                        animate: controller.isLoading,
                        curve: Curves.fastOutSlowIn,
                        child:   _actionButton(
                            icon: Assets.icons.love.svg(
                              height: 34.r,
                              width: 34.r,
                              color: Colors.white,
                            ),
                            color: AppColors.secondaryColor,
                            onTap: () {
                              if(_discoverController.swipeDataList.isEmpty) return;
                              controller.matchCreate(_discoverController.currentUserId,_swiperController,_heartController,context);
                            },
                        ),
                      );
                    }
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

  Widget _actionButton({
    required Widget icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CustomContainer(
      onTap: onTap,
      color: color,
      elevation: true,
      shape: BoxShape.circle,
      paddingAll: 16.r,
      child: icon,
    );
  }
}
