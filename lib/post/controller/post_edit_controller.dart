import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/post/controller/post_controller.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class EditPostController extends GetxController {
  final RxBool isLoading = false.obs;

  final TextEditingController desController = TextEditingController();
  List<File> images = [];






  Future<void> editMyPost(BuildContext context, String postId,communityId,[String? mediaId]) async {
    try {
      if(mediaId!.isEmpty)
        ToastMessageHelper.showToastMessage('Your post is on its way, please wait a moment...');

      isLoading.value = true;

      List<MultipartBody> multipartFiles = images.map((image) {
        return MultipartBody('media', image);
      }).toList();

      final response =
      await ApiClient.patchMultipartData(ApiUrls.postEdit(postId,communityId,mediaId ?? ''), {
        'description': desController.text.trim(),
      }, multipartBody: multipartFiles,
      );
      final responseBody = response.body;

      if (response.statusCode == 200 && responseBody['success'] == true) {
        Get.find<PostController>().getPost();
        images = [];

      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }





  Future<void> deletePost(BuildContext context,String postId,communityId) async {
    try {
      isLoading.value = true;

      final response = await ApiClient.deleteData(ApiUrls.postDelete(postId,communityId));
      final responseBody = response.body;

      if (response.statusCode == 200 && responseBody['success'] == true) {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
        Get.find<PostController>().getPost();
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    desController.dispose();
    super.dispose();
  }
}
