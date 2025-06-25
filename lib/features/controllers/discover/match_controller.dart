import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/controllers/discover/discover_controller.dart';
import 'package:maignanka_app/features/controllers/profile_details/profile_controller.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class MatchController extends GetxController {

  bool isLoading = false;
  bool isLoadingRewind = false;

  final DiscoverController _discoverController = Get.find<DiscoverController>();





  void onLoveTapped(dynamic heartController, CardSwiperController swiperController, BuildContext context, String userId,) {
    final size = heartController.getSize() * 2;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final random = Random();

    // Show 4 flying hearts at random positions
    for (int i = 0; i < 4; i++) {
      final offset = Offset(
        (width - size) / 1.2 + random.nextInt(100) - 40,
        height - size - 170 - random.nextInt(100),
      );
      heartController.showIcon(offset: offset);
    }

    // Swipe and remove the user card after animation
    Future.delayed(const Duration(milliseconds: 800), () {
      swiperController.swipe(CardSwiperDirection.right);

      final index = _discoverController.swipeDataList
          .indexWhere((item) => item.userId == userId);

      if (index != -1) {
        _discoverController.swipeDataList.removeAt(index);
        _discoverController.update();
      }
    });
  }





  Future<void> matchCreate(String userId,swiperController,heartController,context) async {

      isLoading = true;
      update();

    final response = await ApiClient.postData(
      ApiUrls.matchCreate(userId),{}
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      onLoveTapped(heartController,swiperController,context,userId);
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }
  Future<void> matchCreateDetails(String userId) async {

      isLoading = true;
      update();

    final response = await ApiClient.postData(
      ApiUrls.matchCreate(userId),{}
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      Get.find<ProfileController>().profileDetailsGet(userId);

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }


  Future<void> likeRewind(String userId) async {

      isLoadingRewind = true;
      update();

    final response = await ApiClient.postData(
      ApiUrls.likeRewind(userId),{}
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      Get.find<ProfileController>().profileDetailsGet(userId);

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

      isLoadingRewind = false;
    update();
  }
}
