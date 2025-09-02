import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/views/profile/widgets/profile_list_tile.dart';
import 'package:maignanka_app/features/views/setting/account_delete_pass_screen.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_dialog.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          ProfileListTile(
            icon: Assets.icons.password.svg(),
            title: "Change Password",
            onTap: () {
              Get.toNamed(AppRoutes.changePassScreen);
            },
          ),
          ProfileListTile(
            icon: Assets.icons.terms.svg(),
            title: "Terms & Conditions",
            onTap: () {
              Get.toNamed(AppRoutes.termsScreen);
            },
          ),
          ProfileListTile(
            icon: Assets.icons.policy.svg(),
            title: "Privacy Policy",
            onTap: () {
              Get.toNamed(AppRoutes.policyScreen);
            },
          ),
        ProfileListTile(
          icon: Assets.icons.about.svg(),
          title: "About Us",
            onTap: () {
            Get.toNamed(AppRoutes.aboutScreen);
            },
          ),

          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h),
            child: ProfileListTile(
                icon: Assets.icons.delete.svg(),
                title: 'Delete Account',
                onTap: () {
                  Get.to(() => AccountDeletePassScreen());
                },
                noIcon: true,
                color: Color(0xffF5F5F5),
            ),
          ),
        ],
      ),
    );
  }
}