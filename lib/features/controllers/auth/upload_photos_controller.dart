import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maignanka_app/app/helpers/photo_picker_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/views/corp_image/corp_image_screen.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class UploadPhotosController extends GetxController {
  bool isLoading = false;
  List<File> images = [];




  Future<void> addPhoto(BuildContext context) async {
    PhotoPickerHelper.showPicker(
      context: context,
      onImagePicked: (XFile file) {
        if (images.length < 6) {
          Get.to(() => CropImageScreen(
            height: 400.h,
            initialImage: File(file.path),
            onCropped: (croppedImage) {
              images.add(croppedImage);
              update();
            },
          ));
        }


      },
    );
  }

  void removePhoto(int index) {
    images.removeAt(index);
update();
  }



  Future<void> uploadPhotos() async {
    isLoading = true;
    update();


      try {
        List<MultipartBody> multipartFiles = images.map((image) {
          return MultipartBody('files', image);
        }).toList();

        final response = await ApiClient.postMultipartData(
          ApiUrls.uploadPhoto,
          {},
          multipartBody: multipartFiles,
        );

        final responseBody = response.body;
        if (response.statusCode == 200) {
          ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");

          _cleanField();
        } else {
          ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
        }
      } catch (e) {
        ToastMessageHelper.showToastMessage("Error: $e");
      } finally {
        isLoading = false;
        update();
      }
    }


  void _cleanField() {
    images = [];
  }
}
