import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_image_avatar.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _notificationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Comments'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        CustomListTile(
                          image: '',
                          title: 'Annette Black',
                          subTitle: 'abc@gmail.com',
                        ),
                        CustomText(
                          left: 8.w,
                          fontSize: 11.sp,
                          textAlign: TextAlign.start,
                          color: AppColors.appGreyColor,
                          text:
                              'Nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomText(
                            fontSize: 9.sp,
                            textAlign: TextAlign.start,
                            color: AppColors.appGreyColor,
                            text: '6 hours ago',
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  );
                },
              ),
            ),

            _buildCommentSender(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSender() {
    return CustomContainer(
      color: Color(0xffFFF9FC),
      paddingTop: 30.h,
      paddingBottom: 20.h,
      topLeftRadius: 20.r,
      topRightRadius: 20.r,
      border: Border(top: BorderSide(color: AppColors.primaryColor)),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            CustomImageAvatar(radius: 18.r, right: 8.w),
            Expanded(
              child: CustomTextField(
                validator: (_) {
                  return null;
                },
                controller: _notificationController,
                hintText: 'Your comment...',
              ),
            ),
            SizedBox(width: 10.w),
            CustomText(
              text: 'Post',
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
