import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maignanka_app/app/helpers/menu_show_helper.dart';
import 'package:maignanka_app/app/helpers/photo_picker_helper.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/views/profile/controller/profile_controller.dart';
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
  final ProfileController _controller = Get.put(ProfileController());



  @override
  void initState() {
    /*_controller.nameTEController.text = _controller.profileData.name ?? '';
    _controller.phoneTEController.text = _controller.profileData.phone ?? '';
    _controller.addressTEController.text = _controller.profileData.address ?? '';
    _controller.bioTEController.text = _controller.profileData.bio ?? '';*/
    super.initState();
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
              child: Stack(
                children: [
                  CustomImageAvatar(
                    radius: 50.r,
                    image: _controller.profileData.image ?? '',
                    fileImage: _controller.profileImage.value,
                  ),
                  Positioned(
                    bottom: 6.h,
                    right: 8.w,
                    child: CustomContainer(
                      onTap: (){
                        PhotoPickerHelper.showPicker(
                          context: context,
                          onImagePicked: (file){
                            _controller.profileImage.value = File(file.path);
                            setState(() {
                            });
                          },
                        );
                      },
                      height: 32.h,
                      width: 32.w,
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      child: Center(
                          child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18.r,
                      )),
                    ),
                  ),
                ],
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
              prefixIcon: Assets.icons.email.svg(),
              controller: _controller.emailController,
              hintText: "E-mail",
              keyboardType: TextInputType.emailAddress,
              isEmail: true,
            ),
            CustomTextField(
              prefixIcon: Assets.icons.number.svg(),
              controller: _controller.numberController,
              hintText: "number",
              keyboardType: TextInputType.number,
            ),
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                _showHeightMenu(details,MenuShowHelper.genderOptions,_controller.genderController);
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  readOnly: true,
                  prefixIcon: Assets.icons.gender.svg(),
                  controller: _controller.genderController,
                  hintText: "Gender",
                  suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
                ),
              ),
            ),
            CustomTextField(
              readOnly: true,
              prefixIcon: Assets.icons.date.svg(),
              controller: _controller.birthdayController,
              hintText: "Birthday",
              isDatePicker: true,
              suffixIcon: const Icon(Icons.date_range_outlined),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                _showHeightMenu(details,MenuShowHelper.heightOptions,_controller.heightController);
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  readOnly: true,
                  prefixIcon: Assets.icons.height.svg(),
                  controller: _controller.heightController,
                  hintText: "Height (cm)",
                  keyboardType: TextInputType.text,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
                ),
              ),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                _showHeightMenu(details,MenuShowHelper.weightOptions,_controller.weightController);
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  prefixIcon: Assets.icons.weight.svg(),
                  controller: _controller.weightController,
                  hintText: "Weight (kg)",
                  suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
                ),
              ),
            ),



            SizedBox(height: 44.h),
            CustomButton(onPressed: (){
              Get.back();
            },label: 'Update',),

          ],
        ),
      ),
    );
  }

  void _showHeightMenu(TapDownDetails details,List<String>options,TextEditingController controller) async {
    final selected = await MenuShowHelper.showCustomMenu(
      context: context,
      details: details,
      options: options,
    );
    if (selected != null) {
      setState(() {
        controller.text = selected;
      });
    }
  }

}
