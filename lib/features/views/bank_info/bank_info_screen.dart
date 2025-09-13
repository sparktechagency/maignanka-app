import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/balance/balance_controller.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class BankInfoScreen extends StatefulWidget {
  const BankInfoScreen({super.key});

  @override
  State<BankInfoScreen> createState() => _BankInfoScreenState();
}

class _BankInfoScreenState extends State<BankInfoScreen> {
  final BalanceController _balanceController = Get.find<BalanceController>();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _balanceController.backInfoGet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Bank Info'),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Assets.images.paypal.image(height: 150.h),
              CustomText(
                text: _balanceController.bankNameController.text.isNotEmpty ? 'Your paypal email completed ${_balanceController.bankNameController.text}' : 'Update Your PayPal or Bank Information',
                  //fontSize: 18.sp,
              ),
              SizedBox(height: 30.h),

              // PayPal / Bank Email Field
              CustomTextField(
                enabled: _balanceController.bankNameController.text.isNotEmpty ? false : true,
                readOnly: _balanceController.bankNameController.text.isEmpty ? false : true,
                prefixIcon: Assets.images.paypal.image(height: 24.h,width: 24.w),
                controller: _balanceController.bankNameController,
                hintText: "Paypal Email",
              ),

              SizedBox(height: 40.h),

              // Submit Button
              GetBuilder<BalanceController>(
                builder: (controller) {
                  return controller.isLoadingBank
                      ? CustomLoader()
                      : CustomButton(
                        onPressed: () {
                          if (!_globalKey.currentState!.validate()) return;
                          controller.bankInfo();
                        },
                        label: 'Submit',
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
