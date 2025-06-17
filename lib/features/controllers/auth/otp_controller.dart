import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class OTPController extends GetxController {
  final otpCtrl = TextEditingController();

  bool isLoading = false;

  /// <==================otpSubmit function hare====================>

  Future<bool> otpSubmit() async {
    bool isSuccess = false;
    isLoading = true;
    update();

    var bodyParams = {
      'code': otpCtrl.text.trim(),
    };

    try {
      final response = await ApiClient.postData(
        ApiUrls.verifyOtp,
        bodyParams,
      );

      final responseBody = response.body;
      if (response.statusCode == 200) {
        final String? token = responseBody['token'];

        if (token != null) {
          debugPrint('====================> response token save: $token');
          await PrefsHelper.setString(AppConstants.bearerToken, token);
        }
        isSuccess = true;
        otpCtrl.clear();
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "OTP failed.");
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "OTP failed.");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isLoading = false;
      update();
    }
    return isSuccess;
  }

  /// <==================resendOTP function hare====================>

  Future<void> resendOTP(
      BuildContext context,
      ) async {
    _startCountdown();
    try {
      final response = await ApiClient.postData(ApiUrls.resendOtp, {});

      final responseBody = response.body;
      if (response.statusCode == 200) {
        ToastMessageHelper.showToastMessage(
            responseBody['message'] ?? "OTP sent to your email");
      } else {
        ToastMessageHelper.showToastMessage(
            responseBody['message'] ?? "Otp failed.");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {}
  }

  /// <==================time count function hare====================>
  final RxInt countdown = 180.obs;

  final RxBool isCountingDown = false.obs;

  void _startCountdown() {
    isCountingDown.value = true;
    countdown.value = 180;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
        isCountingDown.value = false;
      }
    });
  }

  @override
  void dispose() {
    otpCtrl.dispose();
    super.dispose();
  }
}
