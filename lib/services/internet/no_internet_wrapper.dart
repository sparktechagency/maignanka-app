
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';



import 'connectivity.dart';

class NoInternetWrapper extends StatelessWidget {
  final Widget child;

  const NoInternetWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Access the ConnectivityController instance
    final ConnectivityController connectivityController = Get.find<ConnectivityController>();

    return Stack(
      children: [
        child,
        Obx(() {
          // Show full-screen "No Internet" animation if not connected
          if (!connectivityController.isConnected.value) {
            return Container(
              color: Colors.white, // Background color for the "No Internet" screen
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Lottie animation for "No Internet" message
                      //Assets.lottie.noInternet.lottie(),
                      SizedBox(height: 20.h),
                      Text(
                        'No Internet Connection',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Please check your connection and try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }
}
