import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/post/post_create_controller.dart';
import 'package:maignanka_app/features/controllers/profile_details/profile_controller.dart';
import 'package:maignanka_app/features/models/post_model_data.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({super.key});



  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final CreatePostController _createPostController = Get.find<CreatePostController>();
  final ProfileController _profileController = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();
  late PostModelData postData;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    postData = Get.arguments['postData'];
    _createPostController.editDesController.text = postData.caption ?? '';
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Editing Caption: ${postData.caption}");
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Edit Post'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomListTile(
                image: _profileController.userImage ?? '',
                title: _profileController.userName ?? '',
                trailing: CustomButton(
                  height: 28.h,
                  radius: 8.r,
                  fontSize: 12.sp,
                  width: 89.w,
                  onPressed: (){

                    if (_formKey.currentState!.validate()) {
                      _createPostController.postEdit(
                        postData.sId ?? '',
                      );
                       Get.back();
                    }
                  },
                  label: 'Update',
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                validator: (v) => v == null || v.trim().isEmpty ? 'Description required' : null,
                filColor: Colors.white,
                borderColor: Colors.transparent,
                controller: _createPostController.editDesController,
                hintText: 'Write about your thought.......',
              ),

              SizedBox(height: 24.h),

              SizedBox(
                height: 300.h,
                child: PageView.builder(
                  itemCount: postData.images?.length,
                    onPageChanged: (index){
                      _currentPage = index;
                      setState(() {

                      });
                    },
                    itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(13.r),
                      child: CustomNetworkImage(
                          imageUrl: '${ApiUrls.imageBaseUrl}${postData.images?[index].url ?? ''}'),
                    )),
              ),

              Center(
                child: DotsIndicator(
                  position: _currentPage.toDouble(),
                  dotsCount: postData.images?.length ?? 0,
                  decorator: DotsDecorator(
                    color: Colors.grey,
                    size: Size.square(5.0.r),
                    spacing: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 6.h,
                    ),
                    activeColor: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
