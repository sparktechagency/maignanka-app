import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/dependancy_injaction.dart';
import 'package:maignanka_app/app/helpers/device_utils.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/theme/app_theme.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/features/controllers/wallet/topup_controller.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/get_fcm_token.dart';
import 'package:maignanka_app/services/internet/connectivity.dart';
import 'package:maignanka_app/services/internet/no_internet_wrapper.dart';
import 'package:maignanka_app/services/socket_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ConnectivityController());
  runApp(const MaignankaApp());


  // Initialize Firebase if it's not already initialized
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Firebase already initialized: $e');
  }

  await FirebaseMessaging.instance;
  await FirebaseNotificationService.printFCMToken();
  await FirebaseNotificationService.initialize();

  String token = await PrefsHelper.getString(AppConstants.bearerToken);
  if (token.isNotEmpty) {
    await SocketServices.init();
  }


  DeviceUtils.lockDevicePortrait();
}


class MaignankaApp extends StatelessWidget {
  const MaignankaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder:
          (_, _) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.initialRoute,
            theme: AppThemeData.lightThemeData,
            darkTheme: AppThemeData.darkThemeData,
            themeMode: ThemeMode.light,
            initialBinding: DependencyInjection(),
            routes: AppRoutes.routes,
            builder: (context, child) => Scaffold(body: NoInternetWrapper(child: child!)),
          ),
    );
  }
}
