import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/env/keys.dart';
import 'package:maignanka_app/features/models/comment_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class TopUpController extends GetxController {




  @override
  void onInit() {
    _initRevenueCat();
    super.onInit();
  }

  void _initRevenueCat() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(Keys.topUpKey);
  }
}
