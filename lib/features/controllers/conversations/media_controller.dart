import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/models/chat_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class MediaController extends GetxController {
  bool isLoading = false;
  List<FileData> mediaData = [];



  int limit = 20;
  int page = 1;
  int totalPage = -1;


  Future<void> conversationMedia(String conversationId, {bool isInitialLoad = false}) async {
    if (isInitialLoad) {
      mediaData.clear();
      page = 1;
      totalPage = -1;
    }

    isLoading = true;
    update();

    final response = await ApiClient.getData(
      ApiUrls.conversationMedia(conversationId, page, limit),
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'] ?? [];

      final media = data.map((json) => FileData.fromJson(json)).toList();

      totalPage = responseBody['pagination']?['totalPages'] ?? totalPage;

      mediaData.addAll(media);
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

      await conversationMedia(conversationId);
    }
  }
}





