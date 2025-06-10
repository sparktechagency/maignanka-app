import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:permission_handler/permission_handler.dart';

class EnableLocationScreen extends StatelessWidget {
  const EnableLocationScreen({Key? key}) : super(key: key);

  Future<void> _handleLocationPermission(BuildContext context) async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Location enabled: ${position.latitude}, ${position.longitude}",
          ),
        ),
      );
      // TODO: Navigate to next screen or save location
    } else if (status.isDenied) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Location permission denied")));
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Open app settings if permanently denied
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: "Location"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            top: 20.h,
            text: "Enable location permissions to discover  user nearby.",
            color: AppColors.appGreyColor,
          ),

          Assets.images.locationImage.image(width: 260.w),
          CustomButton(
            onPressed: () => _handleLocationPermission(context),
            label: 'Enable location',
          ),
        ],
      ),
    );
  }
}
