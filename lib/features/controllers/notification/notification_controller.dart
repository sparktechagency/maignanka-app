import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/models/notification_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class NotificationController extends GetxController {

  bool isLoading = false;
  int limit = 20;
  int page = 1;
  int totalPage = -1;


  List<NotificationModelData> notificationDataList = [];

  Future<void> notification() async {

    notificationDataList.clear();

    isLoading = true;
    update();

    final response = await ApiClient.getData(
        ApiUrls.notification(page,limit)
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'] ?? [];

      final notificationData = data.map((json) => NotificationModelData.fromJson(json)).toList();

      totalPage = responseBody['pagination']?['totalPages'] ?? totalPage;

      notificationDataList.addAll(notificationData);

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }
}
