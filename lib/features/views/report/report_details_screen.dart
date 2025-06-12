import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class ReportDetailsScreen extends StatefulWidget {
  const ReportDetailsScreen({super.key});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {

  final TextEditingController _desController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final selected = Get.arguments['selected'];
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Report',
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Why are you reporting this user?',
            fontSize: 16.sp,
            top: 10.h,
          ),
          CustomText(
            text:
            'Help us keep the community safe by telling us what happened.',
            fontSize: 9.sp,
            top: 10.h,
            color: AppColors.appGreyColor,
          ),

          SizedBox(height: 24.w),

          RadioListTile<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
              side: BorderSide(color: AppColors.secondaryColor,width: 0.5)
            ),
            tileColor: Color(0xffFFF9FC),
            activeColor: AppColors.secondaryColor,
            contentPadding: EdgeInsets.zero,
            value: selected,
            groupValue: selected,
            onChanged: (val) {},
            title: CustomText(text: selected,textAlign: TextAlign.start,),
          ),


          SizedBox(height: 28.h),
          CustomTextField(
            hintText: 'Type your message...',
            minLines: 8,
            labelText: 'Describe the issue',
              controller: _desController),
          
          Spacer(),
          CustomButton(onPressed: (){
            Get.back();
            Get.back();
          },label: 'Submit',)
        ],
      ),
    );
  }
}
