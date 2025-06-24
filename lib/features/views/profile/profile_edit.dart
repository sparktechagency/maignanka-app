import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/photo_picker_helper.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/profile_details/profile_controller.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_image_avatar.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController _controller = Get.find<ProfileController>();



  @override
  void initState() {
    super.initState();

    _controller.firstnameController.text = _controller.myProfileModelData.name?.split(' ').first ?? '';
    _controller.lastnameController.text = _controller.myProfileModelData.name?.split(' ').last ?? '';
    _controller.emailController.text = _controller.myProfileModelData.email ?? '';
    _controller.numberController.text = _controller.myProfileModelData.phone ?? '';
    _controller.genderController.text = _controller.myProfileModelData.profileID?.gender ?? '';
    _controller.birthdayController.text = _controller.myProfileModelData.profileID?.dOB ?? '';
    _controller.heightController.text = _controller.myProfileModelData.profileID?.height ?? '';
    _controller.weightController.text = _controller.myProfileModelData.profileID?.weight ?? '';
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Edit Profile',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Center(
              child: GetBuilder<ProfileController>(
                  builder: (controller) {
                  return Stack(
                    children: [
                      CustomImageAvatar(
                        radius: 50.r,
                        image: controller.myProfileModelData.profilePicture ?? '',
                        fileImage: controller.profileImage,
                      ),
                      Positioned(
                        bottom: 6.h,
                        right: 8.w,
                        child: CustomContainer(
                              onTap: () {
                                if(controller.profileImage != null){

                                }else{
                                  controller.selectedImage(context);

                                }
                              },
                              height: 32.h,
                              width: 32.w,
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                              child: Center(
                                  child: Icon(controller.profileImage != null ? Icons.upload :
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18.r,
                              )),
                            ),
                      ),
                    ],
                  );
                }
              ),
            ),
            SizedBox(height: 38.h),

            CustomTextField(
              prefixIcon: Assets.icons.person.svg(),
              controller: _controller.firstnameController,
              hintText: "First Name",
              keyboardType: TextInputType.text,
            ),
            CustomTextField(
              prefixIcon: Assets.icons.person.svg(),
              controller: _controller.lastnameController,
              hintText: "Last Name",
              keyboardType: TextInputType.text,
            ),


            CustomTextField(
              readOnly: true,
              prefixIcon: Assets.icons.email.svg(),
              controller: _controller.emailController,
              hintText: "E-mail",
              keyboardType: TextInputType.emailAddress,
              isEmail: true,
            ),
            CustomTextField(
              readOnly: true,
              prefixIcon: Assets.icons.number.svg(),
              controller: _controller.numberController,
              hintText: "number",
              keyboardType: TextInputType.number,
            ),
            CustomTextField(
              readOnly: true,
              prefixIcon: Assets.icons.gender.svg(),
              controller: _controller.genderController,
              hintText: "Gender",
            ),
            CustomTextField(
              readOnly: true,
              prefixIcon: Assets.icons.date.svg(),
              controller: _controller.birthdayController,
              hintText: "Birthday",
            ),
            CustomTextField(
              readOnly: true,
              prefixIcon: Assets.icons.height.svg(),
              controller: _controller.heightController,
              hintText: "Height (cm)",
              keyboardType: TextInputType.text,
            ),
            CustomTextField(
              readOnly: true,
              prefixIcon: Assets.icons.weight.svg(),
              controller: _controller.weightController,
              hintText: "Weight (kg)",
            ),



            SizedBox(height: 44.h),
            GetBuilder<ProfileController>(
              builder: (controller) {
                return controller.isLoadingProfileImage ? CustomLoader() : CustomButton(onPressed: ()async{
                  final bool successImage = await controller.editProfileImage();
                  final bool successName = await controller.editProfileName();
                  if(successName && successImage){
                    controller.myProfileGet();
                    Get.back();
                  }
                },label: 'Update',);
              }
            ),

          ],
        ),
      ),
    );
  }
}
