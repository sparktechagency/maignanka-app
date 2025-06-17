import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/post/controller/post_controller.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class UploadPhotosController extends GetxController {
  bool isLoading = false;
  List<File> images = [];




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
