import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class BlockController extends GetxController {
  bool isLoading = false;

  Future<void> blockUnblock(String conversationId) async {

    isLoading = true;
    update();

    final response = await ApiClient.postData(
      ApiUrls.block(conversationId),{}
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      Get.back();
      //Get.back();
    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }

}





