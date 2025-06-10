import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

import '../../models/other_profile_data.dart';

class OtherProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isButtonLoading = false.obs;
  final Rx<OtherProfileData> otherProfileData = OtherProfileData().obs;





  Future<void> createChat(BuildContext context,String receiverId,Map<String,dynamic>chatData) async {
    isButtonLoading.value = true;


    try {
      final response = await ApiClient.postData(
          ApiUrls.createChat(receiverId),
          {},
      );

      final responseBody = response.body;
      if ((response.statusCode == 200 || response.statusCode == 201) && responseBody['success'] == true) {

      } else {

        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isButtonLoading.value = false;
    }
  }



  Future<void> getOtherProfile(String id) async {
    try {
      isLoading.value = true;

      final response = await ApiClient.getData(ApiUrls.otherProfile(id));
      final responseBody = response.body;

      if (response.statusCode == 200 && responseBody['success'] == true) {
        otherProfileData.value = OtherProfileData.fromJson(responseBody['data']);
      } else {
        ToastMessageHelper.showToastMessage("Failed to fetch profile data");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }


}
