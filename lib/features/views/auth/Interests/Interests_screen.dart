import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/helper_data.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class InterestsScreen extends StatefulWidget {
  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final List<String> selectedInterests = [];

  void _onInterestTap(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        if (selectedInterests.length < 5) {
          selectedInterests.add(interest);
        } else {
          // Show Toast
          ToastMessageHelper.showToastMessage(
            "You can select up to 5 interests.",
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Interests'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          CustomText(
            text: "Choose up to 5 Interests to Highlight Your Profile!",
            color: AppColors.appGreyColor,
            fontWeight: FontWeight.w300,
            fontSize: 13.sp,
          ),
          SizedBox(height: 30.h),


          if (selectedInterests.isNotEmpty) ...[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: selectedInterests.map((interest) {
                return Chip(
                  label: CustomText(
                    text: interest,
                    color: Colors.white,
                    fontSize: 13.sp,
                  ),
                  backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.h),
          ],

          CustomText(
            text: "You might like...",
            color: AppColors.appGreyColor,
            fontWeight: FontWeight.w300,
            fontSize: 13.sp,
            bottom: 8.h,
          ),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                HelperData.allInterests.map((interest) {
                  final isSelected = selectedInterests.contains(interest);
                  return GestureDetector(
                    onTap: () => _onInterestTap(interest),
                    child: Chip(
                      label: CustomText(
                        text: interest,
                        color: Colors.white,
                        fontSize: 13.sp,
                      ),
                      backgroundColor:
                          isSelected
                              ? AppColors.secondaryColor
                              : AppColors.secondaryColorShade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  );
                }).toList(),
          ),
          Spacer(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: CustomContainer(
          paddingAll: 16.r,
          child: CustomButton(
            onPressed: () {
              if (selectedInterests.isEmpty) {
                ToastMessageHelper.showToastMessage(
                  "Please select at least one interest.",
                );
              } else {
                Get.toNamed(AppRoutes.enableLocationScreen);
              }
            },
            label: 'Complete',
          ),
        ),
      ),
    );
  }
}
