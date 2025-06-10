import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class ForgetController extends GetxController {
  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;

  Future<void> forgetPassword(BuildContext context) async {
    isLoading.value = true;

    var bodyParams = {
      "email": emailController.text.trim(),
    };

    try {
      final response = await ApiClient.postData(
        ApiUrls.forgetPassword,
        bodyParams,
        headers: {'Content-Type': 'application/json'},
      );

      final responseBody = response.body;
      if (response.statusCode == 200 && responseBody['success'] == true) {
        final String? token = responseBody['data']?['token'];
        if (token != null) {
          debugPrint('====================> response token save: $token');
          await PrefsHelper.setString(AppConstants.bearerToken, token);
          ToastMessageHelper.showToastMessage(responseBody['message'] ?? "OTP sent to your email");
        }
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Otp failed.");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
