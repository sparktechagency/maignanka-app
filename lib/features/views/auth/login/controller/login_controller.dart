import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

   bool isLoading = false;

  Future<void> login(BuildContext context) async {
    isLoading = true;

    var bodyParams = {

      "email": emailController.text.trim(),
      "password": passwordController.text,
      "role":"user"


    };

    try {
      final response = await ApiClient.postData(
        ApiUrls.login,
        bodyParams,
        headers: {'Content-Type': 'application/json'},
      );

      final responseBody = response.body;
      if (response.statusCode == 200 && responseBody['success'] == true) {

        final String? token = responseBody['data']?['token'];
        final String? userName = responseBody['data']?['user']['name'];
        final String? userImage = responseBody['data']?['user']['image'];
        final String? userId = responseBody['data']?['user']['_id'];
        final String? userEmail = responseBody['data']?['user']['email'];

        if (token != null) {
          debugPrint('====================> response token save: $token');
          debugPrint('====================> response userName save: $userName');
          await PrefsHelper.setString(AppConstants.bearerToken, token);
          await PrefsHelper.setString(AppConstants.name, userName);
          await PrefsHelper.setString(AppConstants.image, userImage);
          await PrefsHelper.setString(AppConstants.userId, userId);
          await PrefsHelper.setString(AppConstants.email, userEmail);
        }
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Login failed.");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isLoading = false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
