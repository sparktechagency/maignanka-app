import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/conversations/chat_controller.dart';
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


  /// ================> Send a new message via socket.
  void sendMessage(String message, String receiverId, String conversationId) async {
    final body = {
      "receiverID": receiverId,
      "conversationID": conversationId,
      "content": message,
    };
    socketService.emit('send-message', body);

  }


  void removeListeners(String conversationId) {
    socketService.socket.off("conversation-$conversationId");
  }


}

