import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maignanka_app/app/helpers/photo_picker_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final List<File> photos = [];
  final picker = ImagePicker();

  Future<void> addPhoto() async {
    PhotoPickerHelper.showPicker(
      context: context,
      onImagePicked: (XFile file) {
        if (photos.length < 6) {
          setState(() => photos.add(File(file.path)));
        }
      },
    );
  }

  void removePhoto(int index) {
    setState(() => photos.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Update Photos'),
      body: Column(
        children: [
          CustomText(
            top: 16.h,
            bottom: 16.h,
            text:
                'Upload at least 3 photos to complete your profile. You can change them anytime later.',
            fontWeight: FontWeight.w500,
            color: AppColors.appGreyColor,
          ),
          Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            children: List.generate(6, (index) {
              if (index < photos.length) {
                return _buildPhotoCard(index);
              } else {
                return _buildAddButton();
              }
            }),
          ),
          const Spacer(),
          CustomButton(onPressed: () {
            if(photos.length >= 3){
              Get.toNamed(AppRoutes.goalsScreen);

            }else{
              ToastMessageHelper.showToastMessage('Please upload at least 3 images to continue.');
            }
          }  ,label: 'Next',),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(int index) {
    final isMain = index == 0;

    return Stack(
      children: [
        DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(15.r),
          dashPattern: const [4, 3],
          strokeWidth: 1.5,
          color: AppColors.primaryColor,
          child: CustomContainer(
            height: 130.h,
            width: 90.w,
            radiusAll: 15.r,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.file(photos[index], fit: BoxFit.cover),
            ),
          ),
        ),
        if (isMain)
          Positioned(
            left: 20,
            right: 20,
            bottom: 0,
            child: CustomContainer(
              paddingVertical: 2.h,
                color: AppColors.secondaryColor,
              topLeftRadius: 10.r,
              topRightRadius: 10.r,
              child:  CustomText(text:
                'Main',
                fontSize: 9.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
          ),),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => removePhoto(index),
              child: Assets.icons.imageRemove.svg(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(15.r),
      dashPattern: const [4, 3],
      strokeWidth: 1.5,
      color: AppColors.primaryColor,
      child: InkWell(
        onTap: addPhoto,
        child: CustomContainer(
          height: 130.h,
          width: 90.w,
          radiusAll: 15.r,
          color: AppColors.secondaryColorShade100,
          child:  Center(child: Assets.icons.imageAdd.svg()),
        ),
      ),
    );
  }
}
