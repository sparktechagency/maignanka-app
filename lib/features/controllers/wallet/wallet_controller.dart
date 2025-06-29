import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/controllers/profile_details/profile_controller.dart';
import 'package:maignanka_app/features/models/post_model_data.dart';
import 'package:maignanka_app/features/models/wallet_model_data.dart';
import 'package:maignanka_app/features/views/wallet/payment_web_screeen.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class WalletController extends GetxController {

  bool isLoading = false;
  bool isLoadingTopUp = false;
  int limit = 20;
  int page = 1;
  int totalPage = -1;

  double amounts = 0;


  final TextEditingController topUpAmountController = TextEditingController();
  final TextEditingController withdrawAmountController = TextEditingController();


  List<WalletModelData> walletData = [];



  void calculateTopUp(String value) {
    final enteredPoints = double.tryParse(value) ?? 0;
    final grossAmount = enteredPoints * 0.035;
    final netAmount = grossAmount * 0.70;
      amounts = netAmount;
      update();
  }


  void calculateWithdraw(String value) {
    final enteredPoints = double.tryParse(value) ?? 0;
    final grossAmount = enteredPoints * 0.035;
    final netAmount = grossAmount * 0.60;
      amounts = netAmount;
      update();
  }





  Future<void> transHistoryGet({bool isInitialLoad = false}) async {

    if (isInitialLoad) {
      walletData.clear();
      page = 1;
      totalPage = -1;
    }

    isLoading = true;
    update();

    final response = await ApiClient.getData(
      ApiUrls.transHistory(page,limit),
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'] ?? [];

      final walletData = data.map((json) => WalletModelData.fromJson(json)).toList();

      totalPage = responseBody['pagination']?['totalPages'] ?? totalPage;

      walletData.addAll(walletData);

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }


  Future<void> topUp() async {
    isLoadingTopUp = true;
    update();

    final bodyParams = {
      "points": int.tryParse(topUpAmountController.text.trim()) ?? 0,
      "amount": amounts.toInt(),
    };

    try {
      final response = await ApiClient.postData(
        ApiUrls.topUp,
        bodyParams,
      );

      final responseBody = response.body;

      if (response.statusCode == 200) {
        final url = responseBody['data']?['paymentIntent'] ?? '';
        Get.to(() => PaymentWebScreen(url: url));
        topUpAmountController.clear();
        withdrawAmountController.clear();
        amounts = 0;
        ToastMessageHelper.showToastMessage("Top up successful!");
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Top up failed.");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
    } finally {
      isLoadingTopUp = false;
      update();
    }
  }

  Future<void> loadMore() async {

    print('============> Page $page');

    if (page < totalPage) {
      page += 1;
      update();
      print('============> Page++ $page \n=============> totalPage $totalPage');

      await transHistoryGet();
    }
  }

}
