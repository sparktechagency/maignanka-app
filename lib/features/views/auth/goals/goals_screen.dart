import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/helper_data.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/auth/profiles_controller.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {


  final ProfilesController _profilesController = Get.find<ProfilesController>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Goals',
      ),
      body: Column(
        children: [
          SizedBox(height: 24.h),
          CustomText(
            text: 'Select your goal, why you use this app?',
            color: AppColors.appGreyColor,
          ),
          SizedBox(height: 30.h),

          // Dynamic Options
          ...HelperData.goalOptions.map((item) {
            final value = item['value'];
            final title = item['title'];

            return GetBuilder<ProfilesController>(
              builder: (controller) {
                final isSelected = _profilesController.selectedValue == value;

                return GestureDetector(
                  onTap: () => controller.onChangeGoals(value ?? ''),
                  child: CustomContainer(
                    verticalMargin:  4.h,
                    paddingHorizontal: 20.w,
                    paddingVertical: 14.h,
                      color: isSelected
                          ? AppColors.secondaryColor
                          : AppColors.secondaryColorShade300,
                      radiusAll: 50.r,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text:
                          title!,
                          color: Colors.white,
                        ),
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
              }
            );
          }).toList(),

          Spacer(),

          // Next Button
          GetBuilder<ProfilesController>(
            builder: (controller) {
              return controller.isLoadingGoals ? CustomLoader() :  CustomButton(
                onPressed:() {
                  if(_profilesController.selectedValue != ''){
                    controller.goals();
                  }else{
                    ToastMessageHelper.showToastMessage('Please select an option to proceed.');

                  }
                },
                label: 'Next',
              );
            }
          ),

        ],
      ),
    );
  }
}
