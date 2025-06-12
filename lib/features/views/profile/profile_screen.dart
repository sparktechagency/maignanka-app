import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/prefs_helper.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/features/views/profile/controller/profile_controller.dart';
import 'package:maignanka_app/features/views/profile/widgets/profile_list_tile.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/socket_services.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_dialog.dart';
import 'package:maignanka_app/widgets/custom_image_avatar.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  
  final ProfileController _controller = Get.put(ProfileController());


  @override
  void initState() {
   // _controller.getMyProfile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Profile',),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12.h),
            // Profile Picture and Name Section
            Center(
              child:  Column(
                children: [
                  CustomImageAvatar(
                    showBorder: true,
                    radius: 50.r,
                    image:  '',
                  ),
                  SizedBox(height: 10.h),
                  CustomText(text: 'Hanif khan', fontSize: 18.h,color: AppColors.secondaryColor,),
                ],
              )
            ),
            SizedBox(height: 20.h),
            // List of Options
            ProfileListTile(
              icon: Assets.icons.profileEdit.svg(),
              title: "Edit Profile",
              onTap: () {
                Get.toNamed(AppRoutes.editProfileScreen);

              },
            ),
            ProfileListTile(
              icon: Assets.icons.wallet.svg(),

              title: "Wallet",
              onTap: () {
                Get.toNamed(AppRoutes.walletScreen);
              },
            ),
            ProfileListTile(
              noIcon: true,
              title: "Show my profile",
              onTap: () {
              },
            ),
            ProfileListTile(
              icon: Assets.icons.support.svg(),

              title: "Support",
              onTap: () {
                Get.toNamed(AppRoutes.supportScreen);
              },
            ),
            ProfileListTile(
              icon: Assets.icons.setting.svg(),

              title: "Settings",
              onTap: () {
                Get.toNamed(AppRoutes.settingScreen);
              },
            ),

            ProfileListTile(
              color: Color(0xffF5F5F5),
              icon: Assets.icons.logout.svg(),
              textColor: Colors.black,
              title: "Log Out",
              noIcon: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    title: "Do you want to log out your profile?",
                    onCancel: () {
                      Get.back();
                    },
                    onConfirm: () {
                      Get.back();
                      // await PrefsHelper.remove(AppConstants.bearerToken);
                      //final socket = SocketServices();
                     // socket.disconnect();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}