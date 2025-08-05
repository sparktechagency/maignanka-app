import 'dart:async';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServices {
  // Singleton instance
  static final SocketServices _socketApi = SocketServices._internal();
  static String? token;

  IO.Socket? socket; // nullable socket

  factory SocketServices() {
    return _socketApi;
  }

  SocketServices._internal();

  /// Initialize socket connection
  Future<void> init() async {
    token = await PrefsHelper.getString(AppConstants.bearerToken) ?? "";

    print("-------------------------------------------------------------\n🔌 Socket init called \n🪪 token = $token");

    socket = IO.io('${ApiUrls.socketUrl}',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({"authorization": "Bearer $token"})
          .enableReconnection()
          .build(),
    );

    _setupSocketListeners(token.toString());

    socket!.connect();
  }

  /// Setup listeners for socket events
  void _setupSocketListeners(String token) {
    socket?.onConnect((_) {
      print('✅ Socket connected: ${socket?.connected}');
    });

    socket?.onConnectError((err) {
      print('❌ Socket connect error: $err');
    });

    socket?.onDisconnect((_) {
      print('⚠️ Socket disconnected! Attempting to reconnect...');
      Future.delayed(const Duration(seconds: 2), () {
        if (socket != null && !socket!.connected) {
          socket!.connect();
        }
      });
    });

    socket?.onReconnect((_) {
      print('🔄 Socket reconnected! token: $token');
    });

    socket?.onError((error) {
      print('🚫 Socket error: $error');
    });
  }

  /// Emit event with acknowledgement
  Future<dynamic> emitWithAck(String event, dynamic body) async {
    final completer = Completer<dynamic>();

    if (socket == null || !socket!.connected) {
      print("⚠️ emitWithAck failed: socket not connected or initialized");
      completer.completeError("Socket not initialized or connected");
      return completer.future;
    }

    socket!.emitWithAck(event, body, ack: (data) {
      print("📨 Ack received for $event: $data");
      completer.complete(data ?? 1);
    });

    return completer.future;
  }

  /// Emit event without acknowledgment
  void emit(String event, dynamic body) {
    if (socket != null && socket!.connected) {
      socket!.emit(event, body);
      print('📤 Emit: $event\n➡️ Data: $body');
    } else {
      print("⚠️ Emit failed: socket not connected");
    }
  }

  /// Disconnect socket (optionally clean up)
  void disconnect({bool isManual = false}) {
    if (socket != null && socket!.connected) {
      socket!.disconnect();
      print('🔌 Socket disconnected');
    }

    if (isManual && socket != null) {
      socket!.clearListeners();
      socket!.destroy();
      socket = null;
      print('🧹 Socket manually destroyed and cleaned');
    }
  }
}
