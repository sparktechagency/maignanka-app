import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/views/auth/forget/controller/forget_controller.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/auth_title_widgets.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';


class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final ForgetController _controller = Get.put(ForgetController());


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Forget Password'),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              AuthTitleWidgets(title: 'Please enter your email to reset your password.'),
              SizedBox(height: 56.h),
              CustomTextField(
                autofocus: true,
                controller: _controller.emailController,
                hintText: "Email",
                isEmail: true,
              ),
              SizedBox(height: 44.h),
              CustomButton(
                label: "Get Verification Code",
                onPressed: _onGetVerificationCode,
              ),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }


  void _onGetVerificationCode(){
    if(_globalKey.currentState!.validate()) return;
    //_controller.forgetPassword(context);
    Get.toNamed(AppRoutes.otpScreen,arguments: {'screenType' : 'forgot'});
  }


}
