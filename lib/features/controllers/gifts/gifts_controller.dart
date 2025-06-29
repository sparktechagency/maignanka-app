import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/models/gifts_model_data.dart';
import 'package:maignanka_app/features/models/notification_model_data.dart';
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
}
