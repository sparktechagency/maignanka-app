import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/models/balance_version_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class BalanceController extends GetxController {

  bool isLoading = false;
  bool isLoadingVersion = false;

  String balance = '';

  final List<BalanceVersionModelData> balanceVersionModelData = [];




  Future<void> balanceGet() async {


    isLoading = true;
    update();

    final response = await ApiClient.getData(
        ApiUrls.balance
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {

      balance = responseBody['data']?['balance'].toString() ?? '';

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
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
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoadingVersion = false;
    update();
    return isSuccess;
  }
}
