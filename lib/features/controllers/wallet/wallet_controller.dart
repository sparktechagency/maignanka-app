import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/controllers/balance/balance_controller.dart';
import 'package:maignanka_app/features/models/wallet_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletController extends GetxController {

  bool isLoading = false;
  bool isLoadingMy = false;
  bool isLoadingTopUp = false;
  bool isLoadingWithdraw = false;
  int limit = 20;
  int page = 1;
  int totalPage = -1;

  double amounts = 0;
  String selectedValueType = 'gifts';


  void onChangeType(String newType) {
    selectedValueType = newType;
    if(newType == 'my'){
      transHistoryMyGet(isInitialLoad: true);
    }else{
      transHistoryGet(isInitialLoad: true);
    }
  }


  final TextEditingController topUpAmountController = TextEditingController();
  final TextEditingController withdrawAmountController = TextEditingController();


  List<WalletModelData> giftHistory = [];
  List<MyHistoryModelData> topUpHistory = [];





  void calculateWithdraw(String value) {
    final enteredPoints = double.tryParse(value) ?? 0;
    final grossAmount = enteredPoints * 0.035;
    final netAmount = grossAmount * 0.60;
      amounts = netAmount;
      update();
  }





  Future<void> transHistoryGet({bool isInitialLoad = false}) async {

    if (isInitialLoad) {
      giftHistory.clear();
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

      giftHistory.addAll(walletData);

    } else {
      //ToastMessageHelper.showToastMessage(responseBody['error'] ?? "");
    }

    isLoading = false;
    update();
  }
  Future<void> transHistoryMyGet({bool isInitialLoad = false}) async {

    if (isInitialLoad) {
      topUpHistory.clear();
      page = 1;
      totalPage = -1;
    }

    isLoadingMy = true;
    update();

    final response = await ApiClient.getData(
      ApiUrls.myTransHistory(page,limit),
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'] ?? [];

      final walletData = data.map((json) => MyHistoryModelData.fromJson(json)).toList();

      totalPage = responseBody['pagination']?['totalPages'] ?? totalPage;

      topUpHistory.addAll(walletData);

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoadingMy = false;
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
        launchUrl(Uri.parse(url));
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Top up failed.");
      } else {
        ToastMessageHelper.showToastMessage(responseBody['error'] ?? "Top up failed.");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
    } finally {
      topUpAmountController.clear();
      amounts = 0;
      Get.back();
      isLoadingTopUp = false;
      update();
    }
  }


  Future<void> withdraw() async {
    isLoadingWithdraw = true;
    update();

    final bodyParams = {
      "points": int.tryParse(withdrawAmountController.text.trim()) ?? 0,
    };

    try {
      final response = await ApiClient.postData(
        ApiUrls.withdraw,
        bodyParams,
      );

      final responseBody = response.body;

      if (response.statusCode == 200) {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
        Get.find<BalanceController>().balanceGet();
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
    } finally {
      Get.back();
      withdrawAmountController.clear();
      amounts = 0;
      isLoadingWithdraw = false;
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
