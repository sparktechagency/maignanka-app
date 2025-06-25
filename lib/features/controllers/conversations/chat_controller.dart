import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/models/chat_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class ChatController extends GetxController {
  bool isLoading = false;
  List<ChatModelData> chatsData = [];



  int limit = 50;
  int page = 1;
  int totalPage = -1;


  Future<void> ChatGet(String conversationId, {bool isInitialLoad = false}) async {
    if (isInitialLoad) {
      chatsData.clear();
      page = 1;
      totalPage = -1;
    }

    isLoading = true;
    update();

    final response = await ApiClient.getData(
      ApiUrls.message(conversationId, page, limit),
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data']?['messages'] ?? [];

      final chatData = data.map((json) => ChatModelData.fromJson(json)).toList();

      totalPage = responseBody['pagination']?['totalPages'] ?? totalPage;

      chatsData.addAll(chatData);
    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }




  Future<void> loadMore(String conversationId) async {

    print('============> Page $page');

    if (page < totalPage) {
      page += 1;
      update();
      print('============> Page++ $page \n=============> totalPage $totalPage');

      await ChatGet(conversationId);
    }
  }
}





