import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/models/gifts_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class GiftsController extends GetxController {

  bool isLoading = false;



  List<GiftsModelData> giftsData = [];

  Future<void> giftsGet() async {

    giftsData.clear();

    isLoading = true;
    update();

    final response = await ApiClient.getData(
        ApiUrls.gifts
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'] ?? [];

      final giftData = data.map((json) => GiftsModelData.fromJson(json)).toList();

      giftsData.addAll(giftData);

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }


  Future<void> sendGifts(String receiverId,String giftId,int senderWalletVersion,int receiverWalletVersion) async {

    isLoading = true;
    update();


    final bodyParams = {
      "receiverId":receiverId,
      "senderWalletVersion": senderWalletVersion,
      "receiverWalletVersion": receiverWalletVersion,
      "giftId" : giftId,
    };

    final response = await ApiClient.postData(
        ApiUrls.sendGifts,bodyParams,
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      Get.back();
    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }
}
