import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/auth/profiles_controller.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({Key? key}) : super(key: key);

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {


  final AuthProfilesController _profilesController = Get.find<AuthProfilesController>();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: "Bio"),
      body: Column(
        children: [
          CustomText(
            top: 20.h,
            bottom: 28.h,
            text: "Write something about yourself",
            color: AppColors.appGreyColor,
          ),
          Form(
            key: _globalKey,
            child: CustomTextField(
              hintText: 'write something about...',
              maxLength: 200,
                minLines: 8,
                controller: _profilesController.bioController),
          ),
          Spacer(),


          GetBuilder<AuthProfilesController>(
            builder: (controller) {
              return controller.isLoadingBio ? CustomLoader() : CustomButton(
                onPressed: _nextAction,
                label: 'Next',
              );
            }
          ),
          SizedBox(height: 24.h)
        ],
      ),
    );
  }


  void _nextAction(){
    if(!_globalKey.currentState!.validate()) return;
    _profilesController.bio();
  }
}
