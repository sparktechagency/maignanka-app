import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/privacy_and_terms_helper.dart';
import 'package:maignanka_app/features/controllers/auth/forget_controller.dart';
import 'package:maignanka_app/features/controllers/auth/interests_controller.dart';
import 'package:maignanka_app/features/controllers/auth/location_controller.dart';
import 'package:maignanka_app/features/controllers/auth/otp_controller.dart';
import 'package:maignanka_app/features/controllers/auth/profiles_controller.dart';
import 'package:maignanka_app/features/controllers/auth/register_controller.dart';
import 'package:maignanka_app/features/controllers/auth/reset_password_controller.dart';
import 'package:maignanka_app/features/controllers/auth/upload_photos_controller.dart';
import 'package:maignanka_app/features/controllers/discover/discover_controller.dart';
import 'package:maignanka_app/features/controllers/discover/match_controller.dart';
import 'package:maignanka_app/features/controllers/notification/notification_controller.dart';
import 'package:maignanka_app/features/controllers/profile_details/profile_controller.dart';
import 'package:maignanka_app/features/controllers/settings/setting_controller.dart';
import 'package:maignanka_app/features/views/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
import 'package:maignanka_app/features/controllers/auth/change_pass_controller.dart';

class DependencyInjection implements Bindings {
  @override
  void dependencies() {
    Get.put(CustomBottomNavBarController());
    Get.put(PrivacyController());
    Get.put(RegisterController());
    Get.put(OTPController());
    Get.put(UploadPhotosController());
    Get.put(ForgetController());
    Get.put(ResetPasswordController());
    Get.put(AuthProfilesController());
    Get.put(InterestsController());
    Get.put(LocationController());
    Get.put(DiscoverController());
    Get.put(MatchController());
    Get.put(ProfileController());
    Get.put(NotificationController());
    Get.put(SettingController());
    Get.put(ChangePassController());
  }}