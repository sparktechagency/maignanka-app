import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class AuthProfilesController extends GetxController {

  bool isLoadingGoals = false;

  String selectedValue = '';



  void onChangeGoals(String value){
    selectedValue = value;
    update();
  }

  Future<void> goals() async {
    isLoadingGoals = true;
    update();

    var bodyParams = {
      "goal": selectedValue,
    };

    final response = await ApiClient.patch(
      ApiUrls.profiles,
      bodyParams,
    );

    final responseBody = response.body;
    if (response.statusCode == 200) {
      Get.toNamed(AppRoutes.interestsScreen);
    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Login failed.");
    }

    isLoadingGoals = false;
    update();
  }




/// bio Controller +++++++++++++.

  final bioController = TextEditingController();

  bool isLoadingBio = false;




  Future<void> bio() async {
    isLoadingBio = true;
    update();

    var bodyParams = {
      "bio": bioController.text.trim(),
    };

    final response = await ApiClient.patch(
      ApiUrls.profiles,
      bodyParams,
    );

    final responseBody = response.body;
    if (response.statusCode == 200) {
      Get.toNamed(AppRoutes.goalsScreen);
    } else {
      ToastMessageHelper.showToastMessage(responseBody?['message'] ?? "");
    }

    isLoadingBio = false;
    update();
  }


}
