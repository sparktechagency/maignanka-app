import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/models/gallery_model_data.dart';
import 'package:maignanka_app/features/views/corp_image/corp_image_screen.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';
import '../../../app/helpers/photo_picker_helper.dart';

class GalleryController extends GetxController {
  bool isLoading = false;
  Set<int> selectedIndexes = {};

  int selectedIndex = 0;
  bool isSelectionMode = false;

  File? corpImage;


  List<GalleryModelData> galleryData = [];

  Future<void> galleryGet() async {
    galleryData.clear();

    isLoading = true;
    update();

    final response = await ApiClient.getData(ApiUrls.gallery);

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'] ?? [];

      final post = data.map((json) => GalleryModelData.fromJson(json)).toList();

      galleryData.addAll(post);
    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }

  /// ========================== > Upload photo
  bool isLoadingPost = false;
  Future<void> onePhotoUpload() async {
    ToastMessageHelper.showToastMessage(
      'Your post is on its way, please wait a moment...',
    );
    isLoadingPost = true;
    update();

    try {
      List<MultipartBody> multipartFiles = [MultipartBody('file', corpImage!)];

      final response = await ApiClient.postMultipartData(
        ApiUrls.gallery,
        {},
        multipartBody: multipartFiles,
      );

      final responseBody = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastMessageHelper.showToastMessage(
          responseBody['message'] ?? "Post created successfully.",
        );
        galleryGet();
        corpImage = null;
      } else {
        ToastMessageHelper.showToastMessage(
          responseBody['error'] ?? "Failed to create post.",
        );
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isLoadingPost = false;
      update();
    }
  }



  ///  =======================> delete photo
  bool isLoadingDelete = false;

  Future<void> galleryPhotoDeleted() async {
    isLoadingDelete = true;
    update();

    String selectedId = galleryData[selectedIndex].sId.toString();

    final response = await ApiClient.deleteData(ApiUrls.photoDeleted(selectedId));

    final responseBody = response.body;

    if (response.statusCode == 200) {
      selectedIndexes.clear();
      galleryGet();
    } else {
      ToastMessageHelper.showToastMessage(responseBody['error'] ?? "");
      selectedIndexes.clear();
    }
    isLoadingDelete = false;
    update();
  }


  void toggleSelection(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.clear();
    } else {
      selectedIndexes..clear()..add(index);
    }
    selectedIndex = index;
    update();
  }
  

  void imagesAdded(BuildContext context) {
    PhotoPickerHelper.showPicker(
      context: context,
      onImagePicked: (file) {
        Get.to(() => CropImageScreen(
          height: 400.h,
          initialImage: File(file.path),
          onCropped: (croppedImage) {
            corpImage = croppedImage;
            update();
            onePhotoUpload();
          },
        ),
        );
      },
    );
  }
}
