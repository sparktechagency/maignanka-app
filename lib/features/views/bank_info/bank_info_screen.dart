import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/balance/balance_controller.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
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
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Bank Info'),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            children: [
              SizedBox(height: 80.h),
              CustomTextField(
                controller: _balanceController.bankNameController,
                hintText: "Bank Name",
              ),
              CustomTextField(
                controller: _balanceController.ibanNoController,
                hintText: "IBAN Number",
              ),
              CustomTextField(
                controller: _balanceController.accountNoController,
                hintText: "Account Number",
              ),
              CustomTextField(
                controller: _balanceController.routingNoController,
                hintText: "Routing Number",
              ),
              CustomTextField(
                controller: _balanceController.accountHolderNameController,
                hintText: "Account Holder Name",
              ),
        
              SizedBox(height: 100.h),
              GetBuilder<BalanceController>(
                builder: (controller) {
                  return controller.isLoadingBank ? CustomLoader() : CustomButton(onPressed: (){
                    if(!_globalKey.currentState!.validate()) return;
                    controller.bankInfo();
                  },label: 'Submit',);
                }
              ),
            ],
          ),
        ),
      ),
    );
  }


}
