import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  bool isLoading = false;

  Future<void> handleLocationPermission() async {
    final status = await Permission.locationWhenInUse.request(); // Use this on iOS

    if (status.isGranted) {
      try {
        isLoading = true;
        update();

        bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!isServiceEnabled) {
          ToastMessageHelper.showToastMessage("Location services are disabled.");
          return;
        }

        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        await _sendLocation(
          position.latitude.toString(),
          position.longitude.toString(),
        );
      } catch (e) {
        ToastMessageHelper.showToastMessage("Failed to get location: $e");
      } finally {
        isLoading = false;
        update();
      }
    } else if (status.isDenied) {
      ToastMessageHelper.showToastMessage('Location permission denied');
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      ToastMessageHelper.showToastMessage(
          'Permission permanently denied. Please enable it from Settings.');
      openAppSettings();
    }
  }



  Future<void> _sendLocation(String latitude, String longitude) async {
    final bodyParams = {
      "latitude": latitude,
      "longitude": longitude,
    };

    final response = await ApiClient.patch(ApiUrls.location, bodyParams);

    final responseBody = response.body;
    if (response.statusCode == 200) {
      Get.offAllNamed(AppRoutes.loginScreen);
    } else {
      ToastMessageHelper.showToastMessage(
        responseBody?['message'] ?? "Something went wrong.",
      );
    }
  }
}
