import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/photo_picker_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/controllers/post/post_controller.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class CreatePostController extends GetxController {
  bool isLoading = false;
  List<File> images = [];
  final TextEditingController descriptionController = TextEditingController();

  /// Remove image from preview list
  void removeImages(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      update();
    }
  }

  /// Show image picker
  void imagesAdded(BuildContext context) {
    PhotoPickerHelper.showPicker(
      context: context,
      onImagePicked: (file) {
        images.add(File(file.path));
        update();
      },
    );
  }

  /// Create post with caption and selected images
  Future<void> createPost() async {
    if (descriptionController.text.trim().isEmpty && images.isEmpty) {
      ToastMessageHelper.showToastMessage("Please write something or add images.");
      return;
    }

    ToastMessageHelper.showToastMessage('Your post is on its way, please wait a moment...');
    isLoading = true;
    update();

    var bodyParams = {
      "caption": descriptionController.text.trim(),
    };

    try {
      List<MultipartBody> multipartFiles = images.map((image) {
        return MultipartBody('images', image);
      }).toList();

      final response = await ApiClient.postMultipartData(
        ApiUrls.postCreate,
        bodyParams,
        multipartBody: multipartFiles,
      );

      final responseBody = response.body;
      if ((response.statusCode == 200 || response.statusCode == 201) && responseBody['success'] == true) {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Post created successfully.");
        Get.find<PostController>().postGet(isInitialLoad: true);
        _cleanField();
        //Get.back(); // optionally close post screen
      } else {
        ToastMessageHelper.showToastMessage(responseBody['error'] ?? "Failed to create post.");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      _cleanField();
      isLoading = false;
      update();
    }
  }

  /// Clear form fields
  void _cleanField() {
    descriptionController.clear();
    images.clear();
    update();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
