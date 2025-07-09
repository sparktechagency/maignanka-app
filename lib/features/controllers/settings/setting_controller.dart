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



}
