import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class RegisterController extends GetxController {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final genderController = TextEditingController();
  final birthdayController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  final RxBool isLoading = false.obs;
  final RxBool isChecked = false.obs;

  void toggleChecked() => isChecked.toggle();

  Future<void> registerAccount(BuildContext context) async {
    isLoading.value = true;

   // String? fcmToken = await FirebaseNotificationService.getFCMToken();


    var bodyParams = {
      'name': firstnameController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text,
      //'fcmToken': fcmToken ?? '',
    };




    try {
      final response = await ApiClient.postData(
        ApiUrls.register,
        bodyParams,
        headers: {'Content-Type': 'application/json'},
      );

      final responseBody = response.body;
      if (response.statusCode == 200 && responseBody['success'] == true) {
        final String? token = responseBody['data']?['token'];
        if (token != null) {
          debugPrint('====================> response token save: $token');
          await PrefsHelper.setString(AppConstants.bearerToken, token);
          _cleanTextField();
          ToastMessageHelper.showToastMessage(responseBody['message'] ?? "OTP sent to your email");
        }
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Registration failed.");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }



  void _cleanTextField (){
    firstnameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    isChecked.value = false;
  }

  @override
  void dispose() {
    firstnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
