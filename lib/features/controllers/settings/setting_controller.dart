import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:maignanka_app/services/socket_services.dart';

class SettingController extends GetxController {
  bool isLoading = false;
  bool isLoadingAccountDelete = false;

  String aboutDescription = '';
  String termsDescription = '';
  String privacyDescription = '';



  Future<void> getAbout() async {
    isLoading = true;
    update();

      final response = await ApiClient.getData(ApiUrls.about,headers: {});

      final responseBody = response.body;

      if (response.statusCode == 200) {
        aboutDescription = responseBody['data']['content'] ?? '';
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
      isLoading = false;
      update();
  }


  Future<void> getTerms() async {
    isLoading = true;
    update();


      final response = await ApiClient.getData(ApiUrls.terms,headers: {});

      final responseBody = response.body;

      if (response.statusCode == 200) {
        termsDescription = responseBody['data']['content'] ?? '';
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    isLoading = false;
    update();
  }


  Future<void> getPrivacy() async {
    isLoading = true;
    update();

      final response = await ApiClient.getData(ApiUrls.privacy,headers: {});

      final responseBody = response.body;

      if (response.statusCode == 200 ) {
        privacyDescription = responseBody['data']['content'] ?? '';
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }

      isLoading = false;
      update();
  }


  final confirmPassController = TextEditingController();

  Future<void> accountDelete() async {
    ToastMessageHelper.showToastMessage("Please wait...");

    isLoadingAccountDelete = true;
    update();

      final response = await ApiClient.deleteData(ApiUrls.accountDelete(confirmPassController.text));

      final responseBody = response.body;

      if (response.statusCode == 200 ) {
        final socket = SocketServices();
        socket.disconnect();
        await PrefsHelper.remove(AppConstants.bearerToken);
        Get.offAllNamed(AppRoutes.onboardingScreen);
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    isLoadingAccountDelete = false;
      update();
    confirmPassController.clear();

  }


  @override
  void dispose() {
    confirmPassController.dispose();
    super.dispose();
  }



}
