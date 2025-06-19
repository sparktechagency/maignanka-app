import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/helper_data.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/auth/interests_controller.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class InterestsScreen extends StatefulWidget {
  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {


  final InterestsController _interestsController = Get.find<InterestsController>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Interests'),
      body: SingleChildScrollView(
        child: Column(
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

            /// Selected interests chips
            GetBuilder<InterestsController>(
              builder: (controller) {
                if (controller.selectedInterests.isEmpty) return SizedBox.shrink();

                return Column(
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: controller.selectedInterests.map((interest) {
                        return Chip(
                          label: CustomText(
                            text: interest,
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                          onDeleted: () => controller.onInterestTap(interest),
                          deleteIcon: Icon(Icons.close, size: 16.r, color: Colors.white),
                          backgroundColor: AppColors.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.h),
                  ],
                );
              },
            ),

            /// Suggestions
            CustomText(
              text: "You might like...",
              color: AppColors.appGreyColor,
              fontWeight: FontWeight.w300,
              fontSize: 13.sp,
              bottom: 8.h,
            ),

            // All interest options
            GetBuilder<InterestsController>(
              builder: (controller) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: HelperData.allInterests.map((interest) {
                    final isSelected = controller.selectedInterests.contains(interest);

                    return GestureDetector(
                      onTap: () => controller.onInterestTap(interest),
                      child: Chip(
                        label: CustomText(
                          text: interest,
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                        backgroundColor: isSelected
                            ? AppColors.secondaryColor
                            : AppColors.secondaryColorShade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),

      /// Bottom Button

      bottomNavigationBar: GetBuilder<InterestsController>(
        builder: (controller) {
          return controller.isLoading
              ? CustomLoader() : SafeArea(
            child: CustomContainer(
              paddingAll: 16.r,
              child: CustomButton(
                    onPressed: _completeAction,
                    label: 'Complete',
                  ),

            ),
          );
        }
      ),
    );
  }


  void _completeAction(){
    if(_interestsController.selectedInterests.isEmpty){
      ToastMessageHelper.showToastMessage('Please select your interests.');

    }else{
      _interestsController.interests();
    }
  }
}
