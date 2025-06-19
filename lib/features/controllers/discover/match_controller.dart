import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class MatchController extends GetxController {

  bool isLoading = false;

  Future<void> matchCreate(String userId) async {

      isLoading = true;
      update();

    final response = await ApiClient.postData(
      ApiUrls.matchCreate(userId),{}
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }
}
