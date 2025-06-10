import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/notification/models/notification_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isNotiLoading = false.obs;
  RxBool isUnread = false.obs;

  RxInt unreadCount = 0.obs;


  RxList<NotificationData> notificationData = <NotificationData>[].obs;


  Future<void> getNotification() async {
    isNotiLoading.value = true;

    try {
      final response = await ApiClient.getData(
        ApiUrls.notification,
      );

      final responseBody = response.body;
      if (response.statusCode == 200 && responseBody['success'] == true) {
        final List data = responseBody['data']!['notifications'];
        notificationData.value = data.map((json) => NotificationData.fromJson(json)).toList();
        isUnread.value = true;
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isNotiLoading.value = false;
    }
  }


  Future<void> getNotificationBadge() async {
    isLoading.value = true;

    try {
      final response = await ApiClient.getData(
        ApiUrls.notificationBadge,
      );

      final responseBody = response.body;
      if (response.statusCode == 200 && responseBody['success'] == true) {
        unreadCount.value = responseBody['data']['unreadCount'];
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
