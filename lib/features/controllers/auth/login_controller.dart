import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/features/views/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:maignanka_app/services/get_fcm_token.dart';
import 'package:maignanka_app/services/socket_services.dart';

class LoginController extends GetxController {
  // SocketServices socketService = SocketServices();
  final TextEditingController emailController = TextEditingController(text: kDebugMode ? 'support@kisdates.com' : '',);

  final TextEditingController passwordController = TextEditingController(text: kDebugMode ? 'Ka32Ni22' : '');
  //
   //final emailController = TextEditingController();
   //final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    // Prevent multiple simultaneous login attempts
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      // Add timeout for FCM token
      String? fcmToken;
      try {
        fcmToken = await FirebaseNotificationService.getFCMToken()
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        debugPrint('FCM Token error: $e');
        fcmToken = null; // Continue without FCM token
      }

      var bodyParams = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
        'fcm': fcmToken,
      };

      // Add timeout for API call
      final response = await ApiClient.postData(
        ApiUrls.login,
        bodyParams,
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );

      final responseBody = response.body;

      if (response.statusCode == 200) {
        final String? token = responseBody['token'];
        final bool isEmailVerified = responseBody['data']?['isEmailVerified'] ?? false;

        // Fixed: This was checking string equality wrong
        final bool needsProfilePicture =
            responseBody['data']?['profilePicture'] == 'uploads/man.png';

        final int completed = responseBody['data']?['completed'] ?? 0;

        // Save preferences
        await PrefsHelper.setBool(AppConstants.isEmailVerified, isEmailVerified);
        await PrefsHelper.setBool(AppConstants.profilePicture, needsProfilePicture);
        await PrefsHelper.setInt(AppConstants.completed, completed);

        if (token != null && token.isNotEmpty) {
          debugPrint('====================> response token save: $token');
          await PrefsHelper.setString(AppConstants.bearerToken, token);
        } else {
          throw Exception('Invalid token received');
        }

        // Navigation logic - fixed the order
        if (!isEmailVerified) {
          Get.toNamed(AppRoutes.otpScreen, arguments: {'screenType': 'sign-up'});
        } else if (needsProfilePicture) {
          Get.toNamed(AppRoutes.uploadPhotoScreen);
        } else if (completed == 25) {
          Get.toNamed(AppRoutes.bioScreen);
        } else if (completed == 50) {
          Get.toNamed(AppRoutes.goalsScreen);
        } else if (completed == 75) {
          Get.toNamed(AppRoutes.interestsScreen);
        } else if (completed == 90) {
          Get.toNamed(AppRoutes.enableLocationScreen);
        } else {
          // Navigate to home
          Get.offAllNamed(AppRoutes.customBottomNavBar);
          Get.find<CustomBottomNavBarController>().onChange(0);

          // Initialize socket with error handling
          try {
            String savedToken = await PrefsHelper.getString(AppConstants.bearerToken);
            if (savedToken.isNotEmpty) {
              await SocketServices.init();
            }
          } catch (socketError) {
            debugPrint('Socket initialization error: $socketError');
            // Don't block navigation due to socket error
          }
        }
      } else if (response.statusCode == 401) {
        ToastMessageHelper.showToastMessage("Invalid email or password");
      } else if (response.statusCode == 500) {
        ToastMessageHelper.showToastMessage("Server error. Please try again later.");
      } else {
        ToastMessageHelper.showToastMessage(
            responseBody['message'] ?? "Login failed. Please try again."
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');

      // Better error messages for users
      String errorMessage = "Login failed. Please try again.";

      if (e.toString().contains('timeout')) {
        errorMessage = "Connection timeout. Please check your internet.";
      } else if (e.toString().contains('SocketException')) {
        errorMessage = "No internet connection. Please check your network.";
      } else if (e.toString().contains('FormatException')) {
        errorMessage = "Invalid server response. Please contact support.";
      }

      ToastMessageHelper.showToastMessage(errorMessage);
    } finally {
      // ALWAYS reset loading state
      isLoading = false;
      update();
    }
  }

  Future<void> logout() async {
    isLoading = true;
    update();

   String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    final response = await ApiClient.postData(
      ApiUrls.logout,
      {},
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $bearerToken',},
    );

    final responseBody = response.body;
    if (response.statusCode == 200) {
     // ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Logout out failed.");
      final socket = SocketServices();
      // socket.reset();
      socket.disconnect();
      await PrefsHelper.clear();
      Get.offAllNamed(AppRoutes.onboardingScreen);
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
