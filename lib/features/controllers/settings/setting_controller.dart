import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class SettingController extends GetxController {
  bool isLoading = false;

  String aboutDescription = '';
  String termsDescription = '';
  String privacyDescription = '';

  @override
  void onInit() {
    super.onInit();
    _getAbout();
    _getTerms();
    _getPrivacy();
  }

  Future<void> _getAbout() async {
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


  Future<void> _getTerms() async {
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


  Future<void> _getPrivacy() async {
    isLoading = true;
    update();

      final response = await ApiClient.getData(ApiUrls.terms,headers: {});

      final responseBody = response.body;

      if (response.statusCode == 200 ) {
        privacyDescription = responseBody['data']['content'] ?? '';
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }

      isLoading = false;
      update();
  }


  Future<void> deleteAccount(String userId) async {
      isLoading = true;
      update();

      final response = await ApiClient.deleteData(ApiUrls.accountDelete(userId));
      final responseBody = response.body;

      if (response.statusCode == 200 && responseBody['success'] == true) {

        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
        await PrefsHelper.remove(AppConstants.bearerToken);
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
      isLoading = false;
      update();

  }

}
