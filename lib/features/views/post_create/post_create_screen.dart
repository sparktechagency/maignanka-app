import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/photo_picker_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}


class _PostCreateScreenState extends State<PostCreateScreen> {
  final List<File> _images = [];


  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Create Post',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomListTile(
                image: '',
                title: 'Annette Black',
                trailing: CustomButton(
                  height: 28.h,
                  radius: 8.r,
                  fontSize: 12.sp,
                  width: 89.w,
                  onPressed: () {
                   // if(!_globalKey.currentState!.validate()) return;
                    Get.back();
                  },

                  label: 'Post',
                ),
              ),


              ///<=========== description text form ==============>
              SizedBox(height: 16.h),
              CustomTextField(
                labelText: 'Add Caption',
                //validator: (v) => null,
                filColor: Colors.white,
                borderColor: Colors.transparent,
                controller: _descriptionController,
                hintText: 'Write about your thought.......',
              ),


              SizedBox(height: 100.h),



              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_images.length, (index) {
                  return SizedBox(
                    height: 62.h,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: Image.file(
                            _images[index],
                            width: 66.w,
                            height: 61.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                              onTap: () {
                                _images.removeAt(index);
                                setState(() {

                                });
                              },
                              child: CustomContainer(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,

                                  child: Icon(Icons.remove,color: Colors.white,size: 16.r,)),),
                        ),
                      ],
                    ),
                  );
                }),
              ),




              const Divider(thickness: 0.4),

              ///<===========  Photo  form ==============>

              CustomText(
                left: 10.w,
                fontSize: 10.sp,
                text: 'Upload photo (Optional)',
                bottom: 10.h,
                top: 10.h,
              ),

              //CustomButton(onPressed: (){},label: 'Upload photo',),
              GestureDetector(
                  onTap: (){
                    PhotoPickerHelper.showPicker(context: context, onImagePicked: (file){
                      _images.add(File(file.path));
                      setState(() {

                      });
                    });
                  },
                  child: Assets.icons.imagePost.svg(height: 32.h)),
              SizedBox(height: 44.h),
            ],
          ),
        ),
      ),
    );
  }
}
