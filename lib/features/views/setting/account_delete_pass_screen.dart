import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/auth/forget_controller.dart';
import 'package:maignanka_app/features/controllers/settings/setting_controller.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/auth_title_widgets.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_dialog.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';


class AccountDeletePassScreen extends StatefulWidget {
  const AccountDeletePassScreen({super.key});

  @override
  State<AccountDeletePassScreen> createState() => _AccountDeletePassScreenState();
}

class _AccountDeletePassScreenState extends State<AccountDeletePassScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final SettingController _controller = Get.find<SettingController>();


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Confirm Password'),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              AuthTitleWidgets(title: 'Please enter your current password.'),
              SizedBox(height: 56.h),
              CustomTextField(
                autofocus: true,
                controller: _controller.confirmPassController,
                hintText: "password",
              ),
              SizedBox(height: 44.h),
            CustomButton(
              label: "Delete Account",
              onPressed: _deleteAccount,
            ),
            SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }


  void _deleteAccount(){
    if(!_globalKey.currentState!.validate()) return;
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Do you want to delete your account ?",
        confirmButtonText: 'Delete',
        confirmButtonColor: Colors.red,
        onCancel: () {
          Get.back();
        },
        onConfirm: () {
          _controller.accountDelete();
          Get.back();
        },
      ),
    );
  }


}
