import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/privacy_and_terms_helper.dart';
import 'package:maignanka_app/features/controllers/auth/otp_controller.dart';
import 'package:maignanka_app/features/controllers/auth/register_controller.dart';
import 'package:maignanka_app/features/controllers/auth/upload_photos_controller.dart';
import 'package:maignanka_app/features/views/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';

class DependencyInjection implements Bindings {
  @override
  void dependencies() {
    Get.put(CustomBottomNavBarController());
    Get.put(PrivacyController());
    Get.put(RegisterController());
    Get.put(OTPController());
    Get.put(UploadPhotosController());
  }}