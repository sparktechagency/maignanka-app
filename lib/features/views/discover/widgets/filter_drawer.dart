import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/discover/discover_controller.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class FilterDrawer extends StatefulWidget {
  final AdvancedDrawerController controller;

  FilterDrawer(this.controller);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {



  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.secondaryColor.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Center(
              child: CustomText(
                text: 'Filter',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24.h),
            CustomText(
              textAlign: TextAlign.start,
              text: 'Goal',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            ...[
              'Just here to explore',
              'Here to chat and vibe',
              'Nothing serious',
              'Looking for something serious',
            ].map(
              (text) => GetBuilder<DiscoverController>(
                builder: (controller) {
                  return RadioListTile<String>(
                    activeColor: AppColors.secondaryColor,

                    contentPadding: EdgeInsets.zero,
                    title: CustomText(
                      textAlign: TextAlign.start,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.appGreyColor,
                      text: text,
                    ),
                    value: text,
                    groupValue: controller.goal,
                    onChanged: (value) => controller.onChangeGoal(value!),
                  );
                }
              ),
            ),
           // SizedBox(height: 16.h),
           /* CustomText(
              textAlign: TextAlign.start,
              text: 'Interested in',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),*/
/*
            GetBuilder<DiscoverController>(
              builder: (controller) {
                return ToggleButtons(
                  constraints: BoxConstraints(minHeight: 28.h),
                  isSelected:
                      [
                        'Male',
                        'Female',
                        'Everyone',
                      ].map((e) => e == controller.interest).toList(),
                  onPressed: (index) {
                    setState(() {
                      controller.interest = ['Male', 'Female', 'Everyone'][index];
                    });
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  selectedColor: Colors.white,
                  fillColor: AppColors.secondaryColor,
                  color: AppColors.appGreyColor,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Text('Male'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Text('Female'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Text('Everyone'),
                    ),
                  ],
                );
              }
            ),
*/
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  textAlign: TextAlign.start,
                  text: 'Distance',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),

                GetBuilder<DiscoverController>(
                  builder: (controller) {
                    return CustomText(
                      textAlign: TextAlign.end,
                      text: '${controller.distance.toInt()}km',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    );
                  }
                ),
              ],
            ),
            GetBuilder<DiscoverController>(
              builder: (controller) {
                return Slider(
                  activeColor: Colors.pink,
                  value: controller.distance,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: (value) => controller.onChangeDistance(value),
                );
              }
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  textAlign: TextAlign.end,
                  text: 'Age',
                  fontSize: 16.sp,
                ),

                GetBuilder<DiscoverController>(
                  builder: (controller) {
                    return CustomText(
                      textAlign: TextAlign.end,
                      text: '${controller.ageRange.start.toInt()} - ${controller.ageRange.end.toInt()}',
                      fontSize: 12.sp,
                    );
                  }
                ),
              ],
            ),
            GetBuilder<DiscoverController>(
              builder: (controller) {
                return RangeSlider(
                  activeColor: Colors.pink,
                  values: controller.ageRange,
                  min: 0,
                  max: 60,
                  divisions: 42,
                  onChanged: (RangeValues values) => controller.onChangeAgeRange(values),
                );
              }
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: GetBuilder<DiscoverController>(
                    builder: (controller) {
                      return CustomButton(
                        backgroundColor: Color(0xffFCE6E8),
                        foregroundColor: AppColors.primaryColor,
                        height: 28.h,
                        fontSize: 14.sp,
                        onPressed: controller.clean,
                        label: 'Clear',
                      );
                    }
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: GetBuilder<DiscoverController>(
                    builder: (controller) {
                      return controller.isLoading ? CustomLoader() : CustomButton(
                        height: 28.h,
                        fontSize: 14.sp,
                        onPressed: () {
                          controller.swipeProfileGet();
                          widget.controller.hideDrawer();
                        },
                        label: 'Apply',
                      );
                    }
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
