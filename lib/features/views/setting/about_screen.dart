import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/settings/setting_controller.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:shimmer/shimmer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: const CustomAppBar(title: "About Us"),
      body: GetBuilder<SettingController>(builder: (controller) {
        if (controller.isLoading) {
          return Padding(
            padding: EdgeInsets.all(sizeH * .02),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              period: const Duration(milliseconds: 800),
              child: Center(
                child: Container(
                  height: sizeH * 0.8,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else {
          return ListView(
            padding: EdgeInsets.all(sizeH * .02),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: sizeH * .01),
              HtmlWidget(
                controller.aboutDescription ?? '',
                textStyle: TextStyle(fontSize: 14.sp),
              ),
            ],
          );
        }
      }),
    );
  }
}
