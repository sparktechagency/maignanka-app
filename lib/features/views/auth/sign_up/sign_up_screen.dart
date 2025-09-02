import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/menu_show_helper.dart';
import 'package:maignanka_app/app/helpers/privacy_and_terms_helper.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/auth/register_controller.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/auth_title_widgets.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final RegisterController _controller = Get.find<RegisterController>();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Sign Up'),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              AuthTitleWidgets(title: 'Make sure your account keep secure'),
              SizedBox(height: 16.h),
              CustomTextField(
                prefixIcon: Assets.icons.person.svg(),
                controller: _controller.firstnameController,
                hintText: "First Name",
                keyboardType: TextInputType.text,
              ),
              CustomTextField(
                prefixIcon: Assets.icons.person.svg(),
                controller: _controller.lastnameController,
                hintText: "Last Name",
                keyboardType: TextInputType.text,
              ),

              CustomTextField(
                prefixIcon: Assets.icons.email.svg(),
                controller: _controller.emailController,
                hintText: "E-mail",
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),
              CustomTextField(
                prefixIcon: Assets.icons.number.svg(),
                controller: _controller.numberController,
                hintText: "number",
                keyboardType: TextInputType.number,
              ),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _controller.showHeightMenu(
                    details,
                    MenuShowHelper.genderOptions,
                    _controller.genderController,
                    context,
                  );
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    readOnly: true,
                    prefixIcon: Assets.icons.gender.svg(),
                    controller: _controller.genderController,
                    hintText: "Gender",
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
                  ),
                ),
              ),
              CustomTextField(
                readOnly: true,
                prefixIcon: Assets.icons.date.svg(),
                controller: _controller.birthdayController,
                hintText: "Birthday",
                isDatePicker: true,
                suffixIcon: const Icon(Icons.date_range_outlined),
              ),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _controller.showHeightMenu(
                    details,
                    MenuShowHelper.heightOptions,
                    _controller.heightController,
                    context,
                  );
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    readOnly: true,
                    prefixIcon: Assets.icons.height.svg(),
                    controller: _controller.heightController,
                    hintText: "Height (ft)",
                    keyboardType: TextInputType.text,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
                  ),
                ),
              ),
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _controller.showHeightMenu(
                    details,
                    MenuShowHelper.weightOptions,
                    _controller.weightController,
                    context,
                  );
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    prefixIcon: Assets.icons.weight.svg(),
                    controller: _controller.weightController,
                    hintText: "Weight (kg)",
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
                  ),
                ),
              ),

              CustomTextField(
                prefixIcon: Assets.icons.password.svg(),
                controller: _controller.passwordController,
                hintText: "Password",
                isPassword: true,
              ),
              CustomTextField(
                prefixIcon: Assets.icons.password.svg(),
                controller: _controller.confirmPasswordController,
                hintText: "Confirm Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password is required';
                  } else if (value != _controller.passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              PrivacyAndTermsHelper(),
              SizedBox(height: 36.h),
              GetBuilder<RegisterController>(
                builder: (controller) {
                  return controller.isLoading ? CustomLoader() : CustomButton(
                      label: "Sign Up", onPressed: _onSignUp,
                  );
                }
              ),
              SizedBox(height: 18.h),

              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: AppColors.appGreyColor,
                    fontSize: 14.sp,
                  ),
                  text: "Already have an account? ",
                  children: [
                    TextSpan(
                      style: TextStyle(color: AppColors.primaryColor),
                      text: ' Sign In',
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(AppRoutes.loginScreen);
                            },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }

  void _onSignUp() {
    if (!_globalKey.currentState!.validate()) return;
    if (!Get.find<PrivacyController>().isChecked.value) {
      return ToastMessageHelper.showToastMessage(
        'Please confirm that you agree to the Terms of Service and Privacy Policy.',
      );
    }
      _controller.registerAccount();


  }
}
