import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class InterestsController extends GetxController {


  final bioController = TextEditingController();

  bool isLoading = false;




  Future<void> bio() async {
    isLoading = true;
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
      Get.toNamed(AppRoutes.interestsScreen);
    } else {
      ToastMessageHelper.showToastMessage(responseBody?['message'] ?? "");
    }

    isLoading = false;
    update();
  }

}
