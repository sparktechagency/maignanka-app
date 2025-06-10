import 'package:get/get.dart';
import 'package:maignanka_app/features/views/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';

class DependencyInjection implements Bindings {
  @override
  void dependencies() {
    Get.put(CustomBottomNavBarController());
  }}