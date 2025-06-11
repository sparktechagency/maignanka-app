import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/views/discover/discover_screen.dart';
import 'package:maignanka_app/features/views/home/home_screen.dart';
import 'package:maignanka_app/features/views/message/message_screen.dart';
import 'package:maignanka_app/features/views/profile/profile_screen.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import '../bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key});

  final CustomBottomNavBarController _navBarController = Get.find<CustomBottomNavBarController>();


  final List<Widget> _screens = const [
    HomeScreen(),
    DiscoverScreen(),
    MessageScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _screens[_navBarController.selectedIndex.value],
          bottomNavigationBar: CustomContainer(
            paddingTop: 10.h,
            elevation: true,
            elevationColor: AppColors.primaryColor.withOpacity(0.2),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                    _navItems.length, (index) => _buildNavItem(index)),
              ),
            ),
          ),
        ));
  }

  Widget _buildNavItem(int index) {
    bool isSelected = _navBarController.selectedIndex.value == index;
    return GestureDetector(
      onTap: () => _navBarController.onChange(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            _navItems[index]["icon"],
            color: isSelected ? AppColors.primaryColor : Colors.grey,
            width: 24.w,
            height: 24.h,
          ),
          SizedBox(height: 4.h),
          Text(
            _navItems[index]["label"],
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primaryColor : Colors.grey,
            ),
          ),
/*          SizedBox(height: 3.h),
          Container(
            height: 4.h,
            width: 30.w,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),*/
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> _navItems = [
    {"icon": Assets.icons.home.path, "label": "Home"},
    {"icon": Assets.icons.love.path, "label": "Discover"},
    {"icon": Assets.icons.chat.path, "label": "Chat"},
    {"icon": Assets.icons.profile.path, "label": "Profile"},
  ];
}
