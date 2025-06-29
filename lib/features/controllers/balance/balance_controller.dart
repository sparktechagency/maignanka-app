import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class BalanceController extends GetxController {

  bool isLoading = false;

  String balance = '';




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
}
