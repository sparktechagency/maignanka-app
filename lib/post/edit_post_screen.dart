/*
import 'dart:io';
import 'package:courtconnect/pregentaition/screens/post/controller/post_edit_controller.dart';
import 'package:courtconnect/pregentaition/screens/post/models/post_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:courtconnect/core/widgets/custom_app_bar.dart';
import 'package:courtconnect/core/widgets/custom_button.dart';
import 'package:courtconnect/core/widgets/custom_list_tile.dart';
import 'package:courtconnect/core/widgets/custom_network_image.dart';
import 'package:courtconnect/core/widgets/custom_scaffold.dart';
import 'package:courtconnect/core/widgets/custom_text.dart';
import 'package:courtconnect/core/widgets/custom_text_field.dart';
import 'package:courtconnect/global/custom_assets/assets.gen.dart';
import 'package:courtconnect/helpers/toast_message_helper.dart';
import 'package:courtconnect/services/api_urls.dart';
import 'package:courtconnect/pregentaition/screens/home/controller/home_controller.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({super.key, required this.postData, required this.media});
  final Map<String, dynamic> postData;
  final List<Media> media;

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _controller = Get.put(EditPostController());
  final _homeController = Get.put(HomeController());
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late List<Media> _editableMedia;

  @override
  void initState() {
    super.initState();
    _editableMedia = List.from(widget.media);
    _controller.desController.text = widget.postData['des'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Edit Post'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                  onPressed: (){

                    if (_formKey.currentState!.validate()) {
                       _controller.editMyPost(
                        context,
                        widget.postData['postId'],
                        widget.postData['communityId'],
                         ''
                      );
                       context.pop();
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
                controller: _controller.desController,
                maxLine: 6,
                hintText: 'Write about your thought.......',
              ),
              if (_editableMedia.isNotEmpty || _controller.images.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      viewportFraction: 0.55,
                      enlargeCenterPage: true,
                      height: 240.h,
                    ),
                    items: [
                      ..._editableMedia.asMap().entries.map((e) => _buildNetworkImage(e.key, e.value)),
                      ..._controller.images.asMap().entries.map((e) => _buildFileImage(e.key, e.value)),
                    ],
                  ),
                ),
              SizedBox(height: (_editableMedia.isNotEmpty || _controller.images.isNotEmpty) ? 20.h : 100.h),
              const Divider(thickness: 0.4),
              CustomText(
                left: 10.w,
                fontsize: 10.sp,
                text: 'Upload photo (Optional)',
                bottom: 6.h,
                top: 10.h,
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Assets.images.photoUpload.image(
                  height: 137.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 44.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkImage(int index, Media media) {
    return _buildImageItem(
      imageWidget: CustomNetworkImage(imageUrl:'${ApiUrls.imageBaseUrl}${media.publicFileURL ?? ''}'),
        onRemove: () async {
          String mediaId = _editableMedia[index].sId ?? ''; // get media id from the object
          if (mediaId.isNotEmpty) {
            setState(() {
              _editableMedia.removeAt(index);
            });
            await _controller.editMyPost(
              context,
              widget.postData['postId'],
               widget.postData['communityId'],
              mediaId,
            );
          }
        }

    );
  }

  Widget _buildFileImage(int index, File file) {
    return _buildImageItem(
      imageWidget: Image.file(file, fit: BoxFit.cover),
        onRemove: () async {
          String mediaId = _editableMedia[index].sId ?? '';
          if (mediaId.isNotEmpty) {
            setState(() {
              _editableMedia.removeAt(index);
            });
            await _controller.editMyPost(
              context,
              widget.postData['postId'],
              widget.postData['communityId'], mediaId,
            );
          }
        }
    );
  }

  Widget _buildImageItem({required Widget imageWidget, required VoidCallback onRemove}) {
    return SizedBox(
      width: 200.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageWidget,
            Positioned(
              top: 10.h,
              right: 10.w,
              child: GestureDetector(
                onTap: onRemove,
                child: Assets.icons.removePhoto.svg(height: 20.h, width: 20.w),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (_editableMedia.length + _controller.images.length >= 5) {
      ToastMessageHelper.showToastMessage('You can select up to 5 images only.');
      return;
    }
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _controller.images.add(File(picked.path)));
    }
  }

}
*/
