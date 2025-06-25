/*
import 'package:audioplayers/audioplayers.dart';
import 'package:courtconnect/pregentaition/screens/home/controller/home_controller.dart';
import 'package:courtconnect/pregentaition/screens/message/controller/conversations_controller.dart';
import 'package:courtconnect/pregentaition/screens/message/models/chat_data.dart';
import 'package:courtconnect/pregentaition/screens/notification/controller/notification_controller.dart';
import 'package:courtconnect/services/socket_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SocketChatController extends GetxController {
  SocketServices socketService = SocketServices();
  ChatController _controller = Get.put(ChatController());
  NotificationController _notificationController = Get.put(NotificationController());
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// ===============> Listen for new messages via socket.
  void listenMessage() async {
    socketService.socket.on("new-message", (data) {
      print("=========> Response Message : $data -------------------------");

      if (data != null) {
        ChatData demoData = ChatData.fromJson(data);

        var prev = _controller.chatData.length;


        _controller.chatData.insert(0, demoData);
        //messageDelete();
        _controller.chatData.refresh();

        var next = _controller.chatData.length;

        //messageDelete();
        if (next > prev) {
          seenChat(data['chatId'] ?? '');
        }
      }
    });
  }

  /// ===============> Listen for user active status updates via socket.
  void listenActiveStatus() {
    socketService.socket.on("user-active-status", (data) {
      if (data != null) {
        print("=========> Socket active $data -------------------------");

        int index = _controller.chatListData.indexWhere((x) => x.receiver?.id == data['userId']);
        if (index != -1) {
          _controller.chatListData[index].receiver = _controller.chatListData[index].receiver?.copyWith(
            status: data["status"],
            name: data['name'],
            id: data['userId'],
          );
          _controller.chatListData.refresh();
          print('--------------------------status changed ');
        }
      }
    });
  }

  /// ===============> Listen for seen status updates via socket
  void listenSeenStatus(String chatId) {
    socketService.socket.on("check-seen", (data) async {
      print('==============> ====> ${data}');
      if (data != null) {
        int index =
            _controller.chatData.indexWhere((x) => x.sId == data['messageId']);

        if (index != -1) {
          _controller.chatData[0].seenList?.insert(0, "bmnbnnv");

          _controller.chatData.refresh();
          _controller.chatListData.refresh();

          if (_controller.chatData[0].senderId !=
              Get.find<HomeController>().userId.value) {
            await _audioPlayer.play(AssetSource('audio/seen.mp3'));
          }

          update();
        }
      }
    });
  }

  /// ================> Send a new message via socket.
  void sendMessage(String message, String receiverId, String chatId) async {
    final body = {
      "message": message,
      "receiverId": receiverId,
      "chatId": chatId,
    };
    socketService.emit('send-message', body);

    await _audioPlayer.play(AssetSource('audio/text_audio.mp3'));
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


  void notificationUnreadCount() {
    socketService.socket.on('notification', (data){
      _notificationController.unreadCount.value+=1;
      print(data);
    });
  }


  void messageDelete() {
    socketService.socket.on('message-delete', (data){
      if (data != null) {
        //_controller.chatData.removeWhere((element) => element.sId == data['_id']);
        _controller.chatData.refresh();

        print(data);
    }
    }
    );
  }

  /// ===================> Turn off specific socket events when the chat is closed
  void offSocket(String chatId) {
    socketService.socket.off("lastMessage$chatId");
    socketService.socket.off("new-message");
    socketService.socket.off("check-seen");
    socketService.socket.off("check-unseen");
    debugPrint("Socket off seen");
    debugPrint("Socket off unseen");
    debugPrint("Socket off New message");
  }
}
*/
