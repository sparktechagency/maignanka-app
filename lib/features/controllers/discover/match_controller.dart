import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class MatchController extends GetxController {

  bool isLoading = false;


  void onLoveTapped(heartController, swiperController, BuildContext context) {
    final size = heartController.getSize() * 2;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final random = Random();

    for (int i = 0; i < 4; i++) {
      final offset = Offset(
        (width - size) / 1.2 + random.nextInt(100) - 40,
        height - size - 170 - random.nextInt(100),
      );
      heartController.showIcon(offset: offset);
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      swiperController.swipe(CardSwiperDirection.right);
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
      onLoveTapped(heartController,swiperController,context);
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }
}
