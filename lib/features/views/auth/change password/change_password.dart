
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/auth/change_pass_controller.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePassController _controller = Get.find<ChangePassController>();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Change Password'),
      body: Form(
        key: _globalKey,
        child: Column(
          spacing: 10.h,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60.h,
            ),
            CustomTextField(
              controller: _controller.oldPassTEController,
              hintText: "Old Password",
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                } else if (_controller.oldPassTEController.text.length < 8) {
                  return 'Password must be 8+ chars';
                }
                return null;
              },
            ),
            CustomTextField(
              controller: _controller.passTEController,
              hintText: "New Password",
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                } else if (_controller.passTEController.text.length < 8) {
                  return 'Password must be 8+ chars';
                }
                return null;
              },
            ),
            CustomTextField(
              controller: _controller.rePassTEController,
              hintText: "Confirm Password",
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm password is required';
                } else if (value != _controller.passTEController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const Spacer(),
            GetBuilder<ChangePassController>(builder: (controller){
              return controller.isLoading
                  ?  CustomLoader()
                  : CustomButton(
                label: "Change Password",
                onPressed: _onChangePassword,
              );
            }),
            SizedBox(
              height: 100.h,
            ),
          ],
        ),
      ),
    );
  }

  void _onChangePassword() {
    if (!_globalKey.currentState!.validate()) return;
    _controller.changePass();
  }
}
