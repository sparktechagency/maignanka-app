import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class SettingController extends GetxController {
  RxBool isLoading = false.obs;

  RxString aboutDescription = ''.obs;
  RxString termsDescription = ''.obs;
  RxString privacyDescription = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _getAbout();
    _getTerms();
    _getPrivacy();
  }

  Future<void> _getAbout() async {
    isLoading.value = true;

    try {
      final response = await ApiClient.getData(ApiUrls.about,headers: {});

      final responseBody = response.body;

      if (response.statusCode == 200 && responseBody['success'] == true) {
        aboutDescription.value = responseBody['data']['description'] ?? '';
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> _getTerms() async {
    isLoading.value = true;

    try {
      final response = await ApiClient.getData(ApiUrls.terms,headers: {});

      final responseBody = response.body;

      if (response.statusCode == 200 && responseBody['success'] == true) {
        termsDescription.value = responseBody['data']['description'] ?? '';
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> _getPrivacy() async {
    isLoading.value = true;

    try {
      final response = await ApiClient.getData(ApiUrls.terms,headers: {});

      final responseBody = response.body;

      if (response.statusCode == 200 && responseBody['success'] == true) {
        privacyDescription.value = responseBody['data']['description'] ?? '';
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> deleteAccount(BuildContext context,String userId) async {
    try {
      isLoading.value = true;

      final response = await ApiClient.deleteData(ApiUrls.accountDelete(userId));
      final responseBody = response.body;

      if (response.statusCode == 200 && responseBody['success'] == true) {

        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
        await PrefsHelper.remove(AppConstants.bearerToken);
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
