import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/views/auth/otp/controller/otp_controller.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/auth_title_widgets.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_pin_code_text_field.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key,});



  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final OTPController _controller = Get.put(OTPController());

   final String screenType =  Get.arguments['screenType'];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Verify'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24.h),

            AuthTitleWidgets(title: 'Please enter the verification code sent to your e-mail'),
            SizedBox(height: 44.h),

            ///==============Pin code Field============<>>>>

            Form(
              key: _globalKey,
              child: CustomPinCodeTextField(
                  textEditingController: _controller.otpCtrl),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: CustomText(
                  textAlign: TextAlign.start,
                  text: 'Didn’t get the code?',top: 10.h,)),
                Obx(() => CustomText(
                  decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryColor,
                      onTap: _controller.isCountingDown.value
                          ? null
                          : () {
                              _controller.resendOTP(context);
                            },
                      top: 10.h,
                      text: _controller.isCountingDown.value
                          ? 'Resend in ${_controller.countdown.value}s'
                          : 'Resend',
                      color: _controller.isCountingDown.value
                          ? Colors.red
                          : AppColors.primaryColor,
                    )),
              ],
            ),

            SizedBox(height: 36.h),
            CustomButton(
              label: "Verify",
              onPressed: _onTapNextScreen,
            ),
            SizedBox(height: 18.h),
          ],
        ),
      ),
    );
  }

  void _onTapNextScreen()async {
    if (!_globalKey.currentState!.validate()) return;
   // final bool success = await _controller.otpSubmit();
    if(screenType == 'forgot'){
      Get.toNamed(AppRoutes.resetPasswordScreen);
    }else{
      Get.toNamed(AppRoutes.uploadPhotoScreen);

    }
  }
}
