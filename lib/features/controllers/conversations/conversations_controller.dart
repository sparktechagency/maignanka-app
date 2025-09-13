import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/models/conversation_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:maignanka_app/services/socket_services.dart';

class ConversationsController extends GetxController {
  SocketServices socketService = SocketServices();
  bool isLoading = false;
  List<ConversationModelData> _conversationsData = [];



  int limit = 20;
  int page = 1;
  int totalPage = -1;



  final TextEditingController searchController = TextEditingController();



  List<ConversationModelData> get conversationsDataList {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _conversationsData;
    return _conversationsData
        .where((chat) => (chat.participantName ?? '').toLowerCase().contains(query))
        .toList();
  }


  void search(String val){
    searchController.text = val.toLowerCase();
    update();
  }







  Future<void> conversationsGet() async {

    _conversationsData.clear();

    isLoading = true;
    update();

    final response = await ApiClient.getData(
        ApiUrls.conversation(page,limit)
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      final List data = responseBody['data'] ?? [];

      final conversationData = data.map((json) => ConversationModelData.fromJson(json)).toList();

      totalPage = responseBody['pagination']?['totalPages'] ?? totalPage;

      _conversationsData.addAll(conversationData);

    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }




  Future<void> loadMore() async {

    print('============> Page $page');

    if (page < totalPage) {
      page += 1;
      update();
      print('============> Page++ $page \n=============> totalPage $totalPage');

      await conversationsGet();
    }
  }
}





