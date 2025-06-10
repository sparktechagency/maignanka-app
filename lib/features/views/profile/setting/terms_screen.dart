import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/views/profile/setting/controller/setting_controller.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:shimmer/shimmer.dart';


class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final SettingController controller = Get.put(SettingController());

    return Scaffold(
      appBar: const CustomAppBar(title: "Terms & Condition"),
      body: Obx(() {
        if (controller.isLoading.value) {
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
                'By using Fab & Fit, you agree to be bound by the following Terms and Conditions. Please read them carefully before accessing or using our services. If you do not agree to these terms, please do not use our app. 1. Acceptance of Terms By downloading, installing, or using Fab & Fit (the "App"), you agree to comply with and be bound by these Terms and Conditions. If you do not agree with any part of these terms, you should immediately discontinue using the App. 2. Account Registration To use certain features of the App, you may be required to create an account. You agree to: Provide accurate, current, and complete information during the registration process. Maintain the confidentiality of your account and password. Notify us immediately of any unauthorized use of your account. You are responsible for all activities that occur under your account. 3. Use of the App You agree to use the App only for lawful purposes and in accordance with these Terms. You agree not to: Violate any applicable laws or regulations. Engage in any conduct that could damage, disable, or interfere with the App’s functionality. Upload or transmit any viruses, malware, or harmful code through the App. Attempt to reverse engineer, decompile, or otherwise manipulate the App’s code or functionality. 4. Privacy and Data Collection By using the App, you consent to our Privacy Policy, which outlines how we collect, use, and protect your personal data. Please review our Privacy Policy to understand our practices. 5. Subscription and Payments If you are using a subscription service provided by Fab & Fit (such as premium features), you agree to pay the fees as specified. All subscription payments are non-refundable, except as required by law. Prices and availability are subject to change. 6. User Content By submitting any content (such as meal logs, photos, comments, or reviews) to the App, you grant Fab & Fit a non-exclusive, royalty-free, worldwide license to use, display, and distribute your content as part of the service. You agree that you will not submit any content that is: Inaccurate, misleading, or harmful. Obscene, offensive, or defamatory. In violation of any intellectual property rights. 7. Limitation of Liability To the fullest extent permitted by law, Fab & Fit and its affiliates shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits, revenue, or data, arising out of or related to your use of the App. The App is provided "as is," and Fab & Fit does not warrant that the App will be free from errors, interruptions, or other issues. 8. Termination We may suspend or terminate your access to the App at any time, without notice, for any reason, including if you violate these Terms and Conditions. Upon termination, you must stop using the App and delete any copies of the App from your device. 9. Changes to Terms We reserve the right to modify or update these Terms and Conditions at any time. When we do, we will post the revised terms on this page with an updated “Effective Date.” Your continued use of the App after any such changes constitutes your acceptance of the new terms. 10. Governing Law These Terms and Conditions are governed by and construed in accordance with the laws of [Insert Jurisdiction], without regard to its conflict of law principles. Any disputes arising out of or in connection with these Terms will be subject to the exclusive jurisdiction of the courts located in [Insert Jurisdiction].A',
                textStyle: TextStyle(fontSize: 14.sp),
              ),
            ],
          );
        }
      }),
    );
  }

}
