import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class ResetPasswordController extends GetxController {
  final  passController = TextEditingController();
  final  confirmPassController = TextEditingController();

   bool isLoading = false;

  Future<bool> resetPassword() async {
    isLoading = true;
    update();

   bool  isSuccess =  false;

    var bodyParams = {
      "password": passController.text,
      "confirmPassword": confirmPassController.text,
    };

      final response = await ApiClient.postData(
        ApiUrls.resetPassword,
        bodyParams,
      );

      final responseBody = response.body;
      if (response.statusCode == 200) {
        isSuccess = true;
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "failed.");
      }
      isLoading = false;
      update();

      return isSuccess;
  }

  @override
  void dispose() {
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}
