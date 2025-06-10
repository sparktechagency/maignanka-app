import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/views/auth/reset_pass/controller/reset_password_controller.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/auth_title_widgets.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});


  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {


  final ResetPasswordController _controller = Get.put(ResetPasswordController());
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Reset Password',),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              AuthTitleWidgets(title: 'Password  must have 8 characters.'),
              SizedBox(height: 56.h),
        
              CustomTextField(
                prefixIcon: Assets.icons.password.svg(),
                controller: _controller.passController,
                hintText: "New Password",
                isPassword: true,
              ),

              CustomTextField(
                prefixIcon: Assets.icons.password.svg(),
                controller: _controller.confirmPassController,
                hintText: "Confirm Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password is required';
                  } else if (value != _controller.passController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
        
        
              SizedBox(height: 36.h),
              CustomButton(
                label: "Reset",
                onPressed: _onResetPassword,
              ),
              SizedBox(height: 18.h),
        
            ],
          ),
        ),
      ),
    );
  }



  void _onResetPassword(){
    if(_globalKey.currentState!.validate()) return;
    //_controller.resetPassword(context);
    showDialog(
      barrierDismissible: false,
      context: context, builder: (context) =>
        Dialog(
          child: Padding(
            padding:  EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.successPopupIcon.svg(),
                CustomText(text: 'Password changed',fontSize: 18.sp,top: 16.h,bottom: 16.h,),
                CustomText(text: 'Your password has been changed successfully',color: AppColors.appGreyColor,bottom: 16.h,),
                CustomButton(onPressed: (){
                  Get.offAllNamed(AppRoutes.loginScreen);
                },label: 'Back to Sign In',),
              ],
            ),
          ),
        ),
    );
  }

}
