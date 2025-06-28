import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/conversations/chat_controller.dart';
import 'package:maignanka_app/features/controllers/conversations/conversations_controller.dart';
import 'package:maignanka_app/services/socket_services.dart';

class SocketChatController extends GetxController {
  SocketServices socketService = SocketServices();
  final ChatController _chatController = Get.find<ChatController>();
  final ConversationsController _conversationsController = Get.find<ConversationsController>();




  /// ===============> Listen for new messages via socket.
  void listenMessage(String conversationId) async {
    socketService.socket.on("conversation-$conversationId", (data) {

      print("=========> Response Message : $data -------------------------");

      if(data != null){

        _chatController.handleIncomingMessage(data);

        //seen(conversationId);
      }

    });
  }


  void listenSeen(String conversationId) async {
    socketService.socket.on("seen-$conversationId", (data) {

      print("=========> Response Message : $data -------------------------");

      if(data != null){

        //_chatController.handleIncomingMessage(data);
      }

    });
  }


  void listenActive() async {
    socketService.socket.on("active-users", (data) {
      print("=========> Response Message : $data -------------------------");

      if (data != null) {
        int index = _conversationsController.conversationsDataList
            .indexWhere((x) => x.sId == data['id']);

        if (index != -1) {
          _conversationsController.conversationsDataList[index] =
              _conversationsController.conversationsDataList[index].copyWith(
                isActive: data['isActive'],
                id: data['id'],
              );
          _conversationsController.update();
        }
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


  void seen(String conversationId) async {
    final body = {
      "conversationID": conversationId,
    };
    socketService.emit('seen', body);



    print('seen ==============> $body');

  }


  void removeListeners(String conversationId) {
    socketService.socket.off("conversation-$conversationId");
    socketService.socket.off("seen-$conversationId");
  }


}

