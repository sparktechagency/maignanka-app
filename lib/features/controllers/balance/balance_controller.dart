import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/models/balance_version_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class BalanceController extends GetxController {

  bool isLoading = false;
  bool isLoadingVersion = false;
  bool isLoadingBank = false;
  bool isLoadingBankGet = false;

  String balance = '0';
  String? earnedBalance = '0';


  final TextEditingController bankNameController = TextEditingController();

  final List<BalanceVersionModelData> balanceVersionModelData = [];




  Future<void> balanceGet() async {


    isLoading = true;
    update();

    final response = await ApiClient.getData(
        ApiUrls.balance
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {

      balance = responseBody['data']?['walletInfo']?['balance'].toString() ?? '';
      earnedBalance = responseBody['data']?['received'].toString() ?? '';

    } else {
      //ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }


  Future<bool> balanceVersionGet(String userId) async {


    isLoadingVersion = true;
    update();

    bool isSuccess = false;

    final response = await ApiClient.getData(
        ApiUrls.balanceVersion(userId)
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {

      final List data = responseBody['data'] ?? [];

      final versionData = data.map((json) => BalanceVersionModelData.fromJson(json)).toList();

      balanceVersionModelData.addAll(versionData);
      isSuccess = true;
    } else {
     // ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoadingVersion = false;
    update();
    return isSuccess;
  }


  Future<void> bankInfo() async {

    isLoadingBank = true;
    update();

    final bodyParams = {
      "paypalEmail":bankNameController.text.trim(),
    };


    final response = await ApiClient.postData(
        ApiUrls.bankInfo,bodyParams
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      Get.back();
    } else {
     // ToastMessageHelper.showToastMessage(responseBody['error'] ?? "");
    }

    isLoadingBank = false;
    update();
  }


  Future<void> backInfoGet() async {
    isLoadingBankGet = true;
    update();

    final response = await ApiClient.getData(ApiUrls.bankInfoGet);
    final responseBody = response.body;

    if (response.statusCode == 200) {
      final data = responseBody['data'];

      if (data != null) {
        bankNameController.text = data['paypalEmail'] ?? '';
      }

    } else {
     // ToastMessageHelper.showToastMessage(responseBody['message'] ?? "Something went wrong");
    }

    isLoadingBankGet = false;
    update();
  }




  @override
  void dispose() {
    bankNameController.dispose();
    super.dispose();
  }
}
