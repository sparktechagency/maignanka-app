import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/views/auth/login/controller/login_controller.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/auth_title_widgets.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = Get.put(LoginController());
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Sign In'),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            children: [
              SizedBox(height: 24.h),
              AuthTitleWidgets(
                title: 'Make sure that you already have an account.',
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                prefixIcon: Assets.icons.email.svg(),
                controller: _controller.emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),

              CustomTextField(
                prefixIcon: Assets.icons.password.svg(),
                controller: _controller.passwordController,
                hintText: "Password",
                isPassword: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.forgotScreen);
                  },
                  child: CustomText(text: "Forgot Password",decoration: TextDecoration.underline,),
                ),
              ),
              SizedBox(height: 111.h),
              CustomButton(label: "Sign In", onPressed: _onLogin),
              SizedBox(height: 18.h),
              RichText(text: TextSpan(
                style: TextStyle(
                  color: AppColors.appGreyColor,
                  fontSize: 14.sp
                ),
                text: "Don't have an account?",
                children: [
                  TextSpan(
                      style: TextStyle(
                          color: AppColors.primaryColor,
                      ),
                      text: ' Sign Up',
                      recognizer: TapGestureRecognizer()..onTap = (){
                        Get.toNamed(AppRoutes.signUpScreen);

                      }
                  )
                ]
              )),
              SizedBox(height: 16.h),

            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    if (!_globalKey.currentState!.validate()) return;
    // _controller.login(context);
    Get.offAllNamed(AppRoutes.customBottomNavBar);
  }
}
