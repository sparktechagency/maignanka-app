import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

String _itemSelected = '';

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Report'),

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

          ...[
            'Inappropriate content',
            'Harassment or bullying',
            'Spam or fake account',
            'Impersonation',
            'Something else',
          ].map((item) => Padding(
            padding:  EdgeInsets.symmetric(vertical: 4.h),
            child: RadioListTile<String>(
              tileColor: Color(0xffFFF9FC),
              activeColor: AppColors.secondaryColor,
              contentPadding: EdgeInsets.zero,
              value: item,
              groupValue: _itemSelected,
              onChanged: (val) => setState(() => _itemSelected = val!),
              title: CustomText(text: item,textAlign: TextAlign.start,),
            ),
          ),
          ),
          Spacer(),
          CustomButton(onPressed: (){
            Get.toNamed(AppRoutes.reportDetailsScreen,arguments: {'selected' : _itemSelected});

          },label: 'Next'),

        ],
      ),
    );
  }
}
