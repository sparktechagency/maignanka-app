/*
import 'dart:io';
import 'package:courtconnect/core/widgets/custom_app_bar.dart';
import 'package:courtconnect/core/widgets/custom_button.dart';
import 'package:courtconnect/core/widgets/custom_list_tile.dart';
import 'package:courtconnect/core/widgets/custom_scaffold.dart';
import 'package:courtconnect/core/widgets/custom_text.dart';
import 'package:courtconnect/core/widgets/custom_text_field.dart';
import 'package:courtconnect/global/custom_assets/assets.gen.dart';
import 'package:courtconnect/helpers/toast_message_helper.dart';
import 'package:courtconnect/pregentaition/screens/home/controller/home_controller.dart';
import 'package:courtconnect/pregentaition/screens/post/controller/create_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key, required this.userInfo});

  final Map<String,dynamic> userInfo;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  final CreatePostController _controller = Get.put(CreatePostController());
  final HomeController _homeController = Get.put(HomeController());



  final ImagePicker _picker = ImagePicker();



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
                image: _homeController.userImage.value,
                    title: _homeController.userName.value,
                    trailing: CustomButton(
                      height: 28.h,
                      radius: 8.r,
                      fontSize: 12.sp,
                      width: 89.w,
                      onPressed: () {
                        if (_controller.descriptionController.text.trim().isEmpty) {
                          ToastMessageHelper.showToastMessage('Description is required.');
                          return;
                        } else {
                          _controller.createPost(context, widget.userInfo['id']);
                          context.pop();
                        }
                      },
        
                      label: 'Post',
                    ),
                  ),
        
        
              ///<=========== description text form ==============>
              SizedBox(height: 16.h),
              CustomTextField(
                validator: (v) => null,
                filColor: Colors.white,
                borderColor: Colors.transparent,
                controller: _controller.descriptionController,
                maxLine: 8,
                hintText: 'Write about your thought.......',
              ),


              SizedBox(height: 100.h),



              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_controller.images.length, (index) {
                  return SizedBox(
                    height: 62.h,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: Image.file(
                            _controller.images[index],
                            width: 66.w,
                            height: 61.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Assets.icons.removePhoto
                                  .svg(height: 14.h, width: 14.w)),
                        ),
                      ],
                    ),
                  );
                }),
              ),



        
              const Divider(
                thickness: 0.4,
              ),
        
              ///<===========  Photo  form ==============>
        
              CustomText(
                left: 10.w,
                fontsize: 10.sp,
                text: 'Upload photo (Optional)',
                bottom: 6.h,
                top: 10.h,
              ),
        
              GestureDetector(
                  onTap: _pickImage,
                  child: Assets.images.photoUpload
                      .image(height: 137.h, width: double.infinity)),
              SizedBox(height: 44.h),
            ],
          ),
        ),
      ),
    );
  }


  ///<=========== image Picker button ==============>

  Future<void> _pickImage() async {
    if (_controller.images.length >= 5) {
      ToastMessageHelper.showToastMessage('You can select up to 5 images only.');
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _controller.images.add(File(pickedFile.path));
      });
    }
  }



  void _removeImage(int index) {
    setState(() {
      _controller.images.removeAt(index);
    });
  }


  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }
}
*/
