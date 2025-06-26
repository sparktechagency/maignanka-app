import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/conversations/chat_controller.dart';
import 'package:maignanka_app/features/models/chat_model_data.dart';
import 'package:maignanka_app/services/socket_services.dart';

class SocketChatController extends GetxController {
  SocketServices socketService = SocketServices();
  final ChatController _chatController = Get.find<ChatController>();

  /// ===============> Listen for new messages via socket.
  void listenMessage(String conversationId) async {
    socketService.socket.on("conversation-$conversationId", (data) {

      print("=========> Response Message : $data -------------------------");

      if(data != null){

        _chatController.handleIncomingMessage(data);
      }

    });
  }

  /// ===============> Listen for user active status updates via socket.
  void listenActiveStatus() {
    socketService.socket.on("user-active-status", (data) {
      if (data != null) {

      }
    });
  }

  /// ===============> Listen for seen status updates via socket
  void listenSeenStatus(String chatId) {
    socketService.socket.on("check-seen", (data) async {
      print('==============> ====> ${data}');
      if (data != null) {

      }
    });
  }

  /// ================> Send a new message via socket.
  void sendMessage(String message, String receiverId, String conversationId) async {
    final body = {
      "receiverID": receiverId,
      "conversationID": conversationId,
      "content": message,
    };
    socketService.emit('send-message', body);

  }

  /// ================> Handle seen chat.
  void seenChat(String chatId) {
    final body = {"chatId": chatId};
    if (socketService.socket.connected) {
      socketService.emit('check-seen', body);
    } else {
      socketService.socket.on('connect', (_) {
        socketService.emit('check-seen', body);
      });
    }
  }





  /// ===================> Turn off specific socket events when the chat is closed
  void offSocket() {

  }
}

