import 'dart:async';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServices {
  static final SocketServices _socketApi = SocketServices._internal();
  late IO.Socket socket;
  static String? token;

  factory SocketServices() {
    return _socketApi;
  }

  SocketServices._internal();


  Future<void> init() async {
    token = await PrefsHelper.getString(AppConstants.bearerToken) ?? "";

    print("-------------------------------------------------------------\n Socket call \n token = $token");

    socket = IO.io(
        ApiUrls.socketUrl,
        // '${ApiConstants.imageBaseUrl}?token=$token',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({"authorization": "Bearer $token"})
            .enableReconnection()
            .build()
    );

    _setupSocketListeners(token.toString());
    socket.connect(); // Ensure connection starts
  }


  void _setupSocketListeners(String token) {
    socket.onConnect((_) {
      print('========> Socket connected: ${socket.connected}');
    });

    socket.onConnectError((err) {
      print('========> Socket connect error: $err');
    });

    socket.onDisconnect((_) {
      print('========> Socket disconnected! Attempting to reconnect...');
      Future.delayed(Duration(seconds: 2), () {
        if (!socket.connected) {
          socket.connect(); // Force reconnect if needed
        }
      });
    });


    socket.onReconnect((_) {
      print('========> Socket reconnected! $token');
    });

    socket.onError((error) {
      print('========> Socket error: $error');
    });
  }

  Future<dynamic> emitWithAck(String event, dynamic body) async {
    Completer<dynamic> completer = Completer<dynamic>();
    socket.emitWithAck(event, body, ack: (data) {
      completer.complete(data ?? 1);
    });
    return completer.future;
  }

  void emit(String event, dynamic body) {
    if (body != null) {
      socket.emit(event, body);
      print('===========> Emit $event \n $body');
    }
  }

  void disconnect({bool isManual = false}) {
    if (socket.connected) {
      socket.disconnect();
      print('🔌 Socket disconnected');
    }

    if (isManual) {
      socket.clearListeners();
      socket.destroy();
      print('🧹 Socket manually destroyed and cleaned');
    }
  }
}
