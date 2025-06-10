/*
import 'package:courtconnect/helpers/toast_message_helper.dart';
import 'package:courtconnect/pregentaition/screens/message/models/chat_data.dart';
import 'package:courtconnect/pregentaition/screens/message/models/chat_list_data.dart';
import 'package:courtconnect/services/api_client.dart';
import 'package:courtconnect/services/api_urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ChatController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isChatListDataLoading = false.obs;
  RxList<ChatListData> chatListData = <ChatListData>[].obs;
  RxList<ChatData> chatData = <ChatData>[].obs;




  RxString searchText = ''.obs;

  RxInt page = 1.obs;
  var totalPage = (-1);
  var currentPage = (-1);
  var totalResult = (-1);


  RxInt chatListPage = 1.obs;
  var chatListTotalPage = (-1);
  var chatListCurrentPage = (-1);
  var chatListTotalResult = (-1);






  Future<void> getChatList() async {
    if(chatListPage.value == 1){
      chatListData.clear();
      isChatListDataLoading(true);
    }
    try {
      isChatListDataLoading.value = true;

      final response = await ApiClient.getData(ApiUrls.chatList('${page.value}'));
      final responseBody = response.body;

      if (response.statusCode == 200 && responseBody['success'] == true) {
        chatListTotalPage = int.tryParse(responseBody['pagination']['totalPage'].toString()) ?? 0;
        chatListCurrentPage = int.tryParse(responseBody['pagination']['currentPage'].toString()) ?? 0;
        chatListTotalResult = int.tryParse(responseBody['pagination']['totalItem'].toString()) ?? 0;

        List  data =  responseBody['data'];

        final chatList = data.map((json) => ChatListData.fromJson(json)).toList();

        chatListData.addAll(chatList);

      } else {
        ToastMessageHelper.showToastMessage("Failed to fetch profile data");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
    } finally {
      isChatListDataLoading.value = false;
    }
  }

  Future<void> getChat(String receiverId,chatId) async {
    if(page.value == 1){
      chatData.clear();
      isLoading(true);
    }
    try {
      isLoading.value = true;

      final response = await ApiClient.getData(ApiUrls.getChatMessage(receiverId,chatId,'${page.value}'));
      final responseBody = response.body;

      if (response.statusCode == 200 && responseBody['success'] == true) {
        totalPage = int.tryParse(responseBody['pagination']['totalPage'].toString()) ?? 0;
        currentPage = int.tryParse(responseBody['pagination']['currentPage'].toString()) ?? 0;
        totalResult = int.tryParse(responseBody['pagination']['totalItem'].toString()) ?? 0;

        List  data =  responseBody['data'];


        final chatList = data.map((json) => ChatData.fromJson(json)).toList();
        chatData.addAll(chatList);

      } else {
        ToastMessageHelper.showToastMessage("Failed to fetch profile data");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> deleteMessage(BuildContext context, String id,String chatId) async {
    try {
      isLoading.value = true;

      final response = await ApiClient.deleteData(ApiUrls.deleteMessage(id,chatId));
      final responseBody = response.body;

      if (response.statusCode == 200) {
        chatData.removeWhere((chat) => chat.sId == id);
        context.pop();
        //ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      } else {
        ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage("Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }



  List<ChatListData> get filteredChatList {
    final query = searchText.value;
    if (query.isEmpty) return chatListData;
    return chatListData
        .where((chat) => (chat.receiver?.name ?? '').toLowerCase().contains(query))
        .toList();
  }


  void loadMore(String receiverId,chatId) {
    print("==========================================total page ${totalPage} page No: ${page.value} == total result ${totalResult}");
    if (totalPage > page.value) {
      page.value += 1;
      getChat(receiverId, chatId);
      print("**********************print here");
    }
    print("**********************print here**************");
  }


  void loadMoreChatList() {
    print("==========================================total page ${chatListTotalPage} page No: ${chatListPage.value} == total result ${totalResult}");
    if (chatListTotalPage > chatListPage.value) {
      chatListPage.value += 1;
      getChatList();
      print("**********************print here");
    }
    print("**********************print here**************");
  }

}
*/
