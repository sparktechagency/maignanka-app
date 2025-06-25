import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/features/views/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    isLoading = true;
    update();

    var bodyParams = {
      "email": emailController.text.trim(),
      "password": passwordController.text,
    };

    final response = await ApiClient.postData(
      ApiUrls.login,
      bodyParams,
      headers: {'Content-Type': 'application/json'},
    );

    final responseBody = response.body;
    if (response.statusCode == 200) {
      final String? token = responseBody['token'];
      final bool isEmailVerified = responseBody['data']?['isEmailVerified'] ?? false;
      final bool profilePicture = responseBody['data']?['profilePicture'] == 'uploads/man.png' ?? false;
      final int completed = responseBody['data']?['completed'] ?? 0;


      await PrefsHelper.setBool(AppConstants.isEmailVerified, isEmailVerified);
      await PrefsHelper.setBool(AppConstants.profilePicture, profilePicture);
      await PrefsHelper.setInt(AppConstants.completed, completed);

      if (token != null) {
        debugPrint('====================> response token save: $token');
        await PrefsHelper.setString(AppConstants.bearerToken, token);
      }
      if(!isEmailVerified){
        Get.toNamed(AppRoutes.otpScreen, arguments: {'screenType': 'sign-up'});
      }else if(profilePicture){
        Get.toNamed(AppRoutes.uploadPhotoScreen);

      }else if(completed == 25){
        Get.toNamed(AppRoutes.bioScreen);

      }else if(completed == 50){
        Get.toNamed(AppRoutes.goalsScreen);

      }else if(completed == 75){
        Get.toNamed(AppRoutes.interestsScreen);

      }else if(completed == 90){
        Get.toNamed(AppRoutes.enableLocationScreen);

      }
      else{
        Get.offAllNamed(AppRoutes.customBottomNavBar);
        Get.find<CustomBottomNavBarController>().onChange(0);
      }
    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Login failed.");
    }

    isLoading = false;
    update();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
