import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/settings/setting_controller.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:shimmer/shimmer.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  @override
  void initState() {
    Get.find<SettingController>().getAbout();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: const CustomAppBar(title: "About Us"),
      body: GetBuilder<SettingController>(builder: (controller) {
        if (controller.isLoading) {
          return Center(child: CustomLoader());
        } else {
          return ListView(
            padding: EdgeInsets.all(sizeH * .02),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: sizeH * .01),
              HtmlWidget(
                controller.aboutDescription ?? '',
                textStyle: TextStyle(fontSize: 12.sp,color: Colors.black),
              ),
            ],
          );
        }
      }),
    );
  }
}
