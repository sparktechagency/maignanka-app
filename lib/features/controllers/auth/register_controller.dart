import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/menu_show_helper.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/routes/app_routes.dart';
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

  bool isLoading = false;


  void showHeightMenu(
      TapDownDetails details,
      List<String> options,
      TextEditingController controller,
      BuildContext context,
      ) async {
    final selected = await MenuShowHelper.showCustomMenu(
      context: context,
      details: details,
      options: options,
    );
    if (selected != null) {
      controller.text = selected;
      update();
    }
  }

  Future<void> registerAccount( ) async {

    isLoading = true;
    update();




    var requestBodyParams = {
      "name": "${firstnameController.text.trim()} ${lastnameController.text.trim()}",
      "password": passwordController.text,
      "email": emailController.text.trim(),
      "phone": numberController.text.trim(),
      "gender": genderController.text.trim().toLowerCase(),
      "dOB": birthdayController.text.trim(),
      "height": heightController.text.trim(),
      "weight": weightController.text.trim(),
    };

    final response = await ApiClient.postData(
      ApiUrls.register,
      requestBodyParams,
      headers: {'Content-Type': 'application/json'},
    );

    final responseBody = response.body;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final String? token = responseBody['token'];
      if (token != null) {
        debugPrint('====================> response token save: $token');
        await PrefsHelper.setString(AppConstants.bearerToken, token);
        _cleanTextField();
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "OTP sent to your email",
        );

      }
      Get.toNamed(AppRoutes.otpScreen, arguments: {'screenType': 'sign-up'});

    } else {
      ToastMessageHelper.showToastMessage(
        responseBody['message'] ?? "Registration failed.",
      );
    }

    isLoading = false;
    update();
  }

  void _cleanTextField() {
    firstnameController.clear();
    lastnameController.clear();
    emailController.clear();
    numberController.clear();
    genderController.clear();
    birthdayController.clear();
    heightController.clear();
    weightController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    numberController.dispose();
    genderController.dispose();
    birthdayController.dispose();
    heightController.dispose();
    weightController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
