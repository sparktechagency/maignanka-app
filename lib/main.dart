import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/dependancy_injaction.dart';
import 'package:maignanka_app/app/helpers/device_utils.dart';
import 'package:maignanka_app/app/theme/app_theme.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/socket_services.dart';

void main() {
  runApp(const MaignankaApp());



  DeviceUtils.lockDevicePortrait();

  SocketServices socketServices = SocketServices();
  socketServices.init();
}


class MaignankaApp extends StatelessWidget {
  const MaignankaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_,_) =>
          GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.initialRoute,
            theme: AppThemeData.lightThemeData,
            darkTheme: AppThemeData.darkThemeData,
            themeMode: ThemeMode.light,
            initialBinding: DependencyInjection(),
            routes: AppRoutes.routes,

          )
    );
  }
}

