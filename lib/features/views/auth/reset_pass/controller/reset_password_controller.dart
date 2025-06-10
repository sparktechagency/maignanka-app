import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class ResetPasswordController extends GetxController {
  final  passController = TextEditingController();
  final  confirmPassController = TextEditingController();

  final RxBool isLoading = false.obs;

  Future<void> resetPassword(BuildContext context) async {
    isLoading.value = true;

    var bodyParams = {
      "password": passController.text,
    };

    try {
      final response = await ApiClient.postData(
        ApiUrls.resetPassword,
        bodyParams,
      );

      final responseBody = response.body;
      if (response.statusCode == 200 && responseBody['success'] == true) {
          ToastMessageHelper.showToastMessage(responseBody['message'] ?? "change your password successfully");
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "failed.");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}
