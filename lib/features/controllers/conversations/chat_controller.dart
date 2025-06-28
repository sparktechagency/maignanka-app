import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maignanka_app/app/helpers/menu_show_helper.dart';
import 'package:maignanka_app/app/helpers/photo_picker_helper.dart';
import 'package:maignanka_app/app/helpers/show_dialog_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/features/controllers/conversations/block_controller.dart';
import 'package:maignanka_app/features/models/chat_model_data.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';

class ChatController extends GetxController {
  bool isLoading = false;
  bool isLoadingFile = false;
  List<ChatModelData> chatsData = [];
  File? image;


  String receiverId = '';

  final messageController = TextEditingController();




  int limit = 20;
  int page = 1;
  int totalPage = -1;


  void addPhoto(BuildContext context, String conversationID) {
    PhotoPickerHelper.showPicker(
      context: context,
      onImagePicked: (file) {
        image = File(file.path);
        update();
        fileSend(conversationID, receiverId);
      },
    );
  }



  Future<void> chatGet(String conversationId, {bool isInitialLoad = false}) async {
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
      receiverId = responseBody['data']?['receiver']?['_id'] ?? '';
      totalPage = responseBody['pagination']?['totalPages'] ?? totalPage;

      chatsData.addAll(chatData);
    } else {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
    }

    isLoading = false;
    update();
  }

  Future<void> fileSend(String conversationID, String receiverID) async {

    isLoadingFile = true;
    update();

    final bodyParams = {
      'conversationID': conversationID,
      'receiverID': receiverID,
    };

    List<MultipartBody>? multipartBody;
    if (image != null) {
      multipartBody = [MultipartBody('files', image ?? File(''))];
    }


      final response = await ApiClient.postMultipartData(
        ApiUrls.fileSend,
        bodyParams,
        multipartBody: multipartBody,
      );

      final responseBody = response.body;

      if (response.statusCode == 200) {
      } else {
        ToastMessageHelper.showToastMessage(
          responseBody?['message'] ?? "File upload failed. Please try again.",
        );
      }

    isLoadingFile = false;
    update();
  }



  void handleIncomingMessage(Map<String, dynamic> data) {
    final newMessage = ChatModelData.fromJson(data);
    chatsData.insert(0, newMessage);
    update();
  }


  Future<void> loadMore(String conversationId) async {

    print('============> Page $page');

    if (page < totalPage) {
      page += 1;
      update();
      print('============> Page++ $page \n=============> totalPage $totalPage');

      await chatGet(conversationId);
    }
  }


  void showTopMenu(BuildContext context,TapDownDetails details, List<String> options,String conversationId) async {
    final selected = await MenuShowHelper.showCustomMenu(
      context: context,
      details: details,
      options: options,
    );
    if (selected != null) {
      if (selected == 'Media') {
        Get.toNamed(AppRoutes.mediaScreen,arguments: {'conversationId' : conversationId});
      } else if (selected == 'Block Profile') {
        ShowDialogHelper.showDeleteORSuccessDialog(
          context,
          onTap: () {
            Get.find<BlockController>().blockUnblock(conversationId);
          },
          title: 'Block',
          message: 'Are you sure you want to block this user?',
          buttonLabel: 'Block',
        );
      } else if (selected == 'Report') {
        Get.toNamed(AppRoutes.reportScreen);
      }
      update();
    }
  }


  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}





