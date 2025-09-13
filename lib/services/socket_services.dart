import 'dart:async';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketServices {
//
//   // Singleton instance
//   static final SocketServices _socketApi = SocketServices._internal();
//   static String? token;
//
//   IO.Socket? socket;
//   bool _isManualDisconnect = false; // <-- added flag
//
//   factory SocketServices() {
//     return _socketApi;
//   }
//
//   SocketServices._internal();
//
//   /// Initialize socket connection
//   Future<void> init() async {
//
//     if (socket != null) {
//       if (socket!.connected && token == await PrefsHelper.getString(AppConstants.bearerToken)) {
//         print("⚠️ Socket already connected with the same token, skipping init");
//         return;
//       } else {
//         print("♻️ Closing old socket to reinitialize with new token...");
//         socket?.disconnect();
//         socket?.destroy();
//         socket = null;
//       }
//     }
//     // if (socket != null) {
//     //   if (socket!.connected) {
//     //     print("⚠️ Socket already connected, skipping init");
//     //     return;
//     //   } /*else {
//     //     print("⚠️ Socket instance exists but not connected, reconnecting...");
//     //     socket!.connect();
//     //     return;
//     //   }*/
//     // }
//
//     _isManualDisconnect = false;
//     token = await PrefsHelper.getString(AppConstants.bearerToken) ?? "";
//
//     print("-------------------------------------------------------------\n🔌 Socket init called \n🪪 token = $token");
//
//
// print("  Socket url called ${ApiUrls.socketUrl}?token=${token}");
// String apiUrl = "${ApiUrls.socketUrl}?token=${token}";
//     // socket = IO.io(
//     //   ApiUrls.socketUrl,
//     //   IO.OptionBuilder()
//     //       .setTransports(['websocket'])
//     //   .
//     //       // .setExtraHeaders({"authorization": "Bearer $token"})
//     //       .enableReconnection()
//     //       .build(),
//     // );
//
//     // socket = IO.io(
//     //   "${apiUrl}",
//     //   IO.OptionBuilder()
//     //       .setTransports(['websocket'])
//     //       .enableReconnection()
//     //   //     .setQuery({
//     //   //   "token": token,   // 👈 your token here
//     //   //   // "userId": userId, // optional, add extra params if needed
//     //   // })
//     //       .build(),
//     // );
//
//     _setupSocketListeners(token.toString());
//     //socket!.connect();
//   }
//
//   /// Setup listeners for socket events
//   void _setupSocketListeners(String token) {
//     socket?.clearListeners(); // <-- important: clear old listeners
//
//     socket?.onConnect((_) {
//       print('$token');
//       print('✅ Socket connected: ${socket?.connected}');
//     });
//
//     socket?.onConnectError((err) {
//       print('❌ Socket connect error: $err');
//     });
//
//     socket?.onDisconnect((_) {
//       print('⚠️ Socket disconnected');
//       if (!_isManualDisconnect) {
//         print('🔄 Attempting to reconnect...');
//         Future.delayed(const Duration(seconds: 2), () {
//           if (socket != null && !socket!.connected) {
//             socket!.connect();
//           }
//         });
//       } else {
//         print('🛑 Manual disconnect: no auto-reconnect');
//       }
//     });
//
//     socket?.onReconnect((_) {
//       print('🔄 Socket reconnected! token: $token');
//     });
//
//     socket?.onError((error) {
//       print('🚫 Socket error: $error');
//     });
//   }
//
//   /// Emit with acknowledgment
//   Future<dynamic> emitWithAck(String event, dynamic body) async {
//     final completer = Completer<dynamic>();
//
//     if (socket == null || !socket!.connected) {
//       print("⚠️ emitWithAck failed: socket not connected or initialized");
//       completer.completeError("Socket not initialized or connected");
//       return completer.future;
//     }
//
//     socket!.emitWithAck(event, body, ack: (data) {
//       print("📨 Ack received for $event: $data");
//       completer.complete(data ?? 1);
//     });
//
//     return completer.future;
//   }
//   void reset() {
//     _isManualDisconnect = true;
//     socket?.disconnect();
//     socket?.destroy(); // 👈 very important
//     socket = null;
//     token = null;
//     print('♻️ Socket reset: cleared old instance and token');
//   }
//   /// Emit without acknowledgment
//   void emit(String event, dynamic body) {
//     if (socket != null && socket!.connected) {
//       socket!.emit(event, body);
//       print('📤 Emit: $event\n➡️ Data: $body');
//     } else {
//       print("⚠️ Emit failed: socket not connected");
//     }
//   }
//
//   /// Disconnect socket
//   void disconnect() {
//     _isManualDisconnect = true; // <-- mark as manual
//     socket?.disconnect();
//     print('🔌 Socket manually disconnected');
//   }
// }



import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';






class SocketServices {
  static String token = '';
  static IO.Socket? socket;


  static Future<void> init() async {
    // Fetch the token from preferences
    token = await PrefsHelper.getString(AppConstants.bearerToken);

    // Check if the token is available
    if (token.isEmpty) {
      print("Token is missing! Cannot initialize the socket connection.");
      return;  // Return early if token is missing
    }

    print("Initializing socket with token: $token  \n time${DateTime.now()}");

    // Disconnect the existing socket if connected
    if (socket?.connected ?? false) {
      socket?.disconnect();
      socket = null;
    }

    // Setup the socket connection with the token in the headers
    socket = IO.io(
      ApiUrls.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])  // Use websocket transport
          .setExtraHeaders({"authorization": token})  // Ensure token is passed correctly
          .enableReconnection()
          .enableForceNew()
          .build(),
    );
    print("Socket initialized with token: $token  \n time${DateTime.now()}");

    // Setup event listeners
    socket?.onConnect((_) => print('✅ Socket connected successfully'));
    socket?.onConnectError((err) => print('❌ Socket connection error: $err'));
    socket?.onError((err) => print('❌ Socket error: $err'));
    socket?.onDisconnect((reason) => print('⚠️ Socket disconnected. Reason: $reason'));

    // Connect the socket after the token is set
    socket?.connect();
  }

  void on(String event, Function(dynamic) handler) {
    socket?.on(event, handler);
  }

  void off(String event, Function(dynamic) handler) {
    socket?.off(event, handler);
  }

  static Future<dynamic> emitWithAck(String event, dynamic body) async {
    Completer<dynamic> completer = Completer<dynamic>();
    socket?.emitWithAck(event, body, ack: (data) {
      if (data != null) {
        completer.complete(data);
      } else {
        completer.complete(1);
      }
    });
    return completer.future;
  }

  /// Emit without acknowledgment
  void emit(String event, dynamic body) {
    if (socket != null && socket!.connected) {
      socket!.emit(event, body);
      print('📤 Emit: $event\n➡️ Data: $body');
    } else {
      print("⚠️ Emit failed: socket not connected");
    }
  }

  /// Disconnect socket
  void disconnect() {

    socket?.disconnect();
    print('🔌 Socket manually disconnected');
  }
}


