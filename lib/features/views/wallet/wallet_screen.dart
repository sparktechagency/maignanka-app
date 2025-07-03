import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/time_format.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/balance/balance_controller.dart';
import 'package:maignanka_app/features/controllers/wallet/wallet_controller.dart';
import 'package:maignanka_app/features/models/wallet_model_data.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';
import 'package:maignanka_app/widgets/two_button_widget.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  final WalletController _walletController = Get.find<WalletController>();
  final BalanceController _balanceController = Get.find<BalanceController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _balanceController.balanceGet();
    _walletController.transHistoryGet(isInitialLoad: true);
    _addScrollListener();
    super.initState();
  }

  final _historyTypes = [
    {'label': 'Gifts History', 'value': 'gifts'},
    {'label': 'My History', 'value': 'my'},
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Wallet',actions: [
        Padding(
          padding:  EdgeInsets.all(8.0.r),
          child: CustomButton(onPressed: (){
            Get.toNamed(AppRoutes.bankInfoScreen);

          },label: 'Bank info',height: 24.h,width: 100.w,fontSize: 12.sp,),
        ),

      ],),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          _buildWalletCard(),
          SizedBox(height: 44.h),
          CustomText(text: 'History',bottom: 10.h),
          GetBuilder<WalletController>(
            builder: (controller) {
              return TwoButtonWidget(buttons: _historyTypes, selectedValue: controller.selectedValueType, onTap: (val) => controller.onChangeType(val),fontSize: 12.sp,);
            }
          ),
          Expanded(
            child: GetBuilder<WalletController>(
              builder: (controller) {
                if(controller.selectedValueType == 'gifts') {
                  if(controller.isLoading) return CustomLoader();
                  if(controller.giftHistory.isEmpty) {
                    return Center(child: CustomText(text: 'No gift history found.'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: controller.giftHistory.length,
                    itemBuilder: (context, index) {
                      final data = controller.giftHistory[index];
                      return _buildGiftHistoryTile(data);
                    },
                  );
                } else {
                  if(controller.isLoadingMy) return CustomLoader();
                  if(controller.topUpHistory.isEmpty) {
                    return Center(child: CustomText(text: 'No top-up history found.'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: controller.topUpHistory.length,
                    itemBuilder: (context, index) {
                      final data = controller.topUpHistory[index];
                      return _buildMyHistoryTile(data);
                    },
                  );
                }
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildGiftHistoryTile(WalletModelData data) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomText(
        textAlign: TextAlign.start,
        text: data.giftInfo?.name ?? 'N/A',
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            top: 2.h,
            bottom: 2.h,
            text: 'SendBy : ${data.sendBy?.name ?? ''}',
            fontSize: 12.sp,
          ),
          CustomText(
            fontWeight: FontWeight.w400,
            fontSize: 10.sp,
            textAlign: TextAlign.start,
            text: TimeFormatHelper.formatDate(DateTime.parse(data.createdAt ?? '')),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.coin.svg(height: 14.h, width: 14.w),
          CustomText(
            left: 4.w,
            color: data.send == true
                ? AppColors.primaryColor
                : AppColors.successColor,
            textAlign: TextAlign.end,
            text: data.giftInfo?.points?.toString() ?? '',
          ),
        ],
      ),
    );
  }
  Widget _buildMyHistoryTile(MyHistoryModelData data) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomText(
        color: data.type == 'withdraw' ? AppColors.primaryColor : (data.isAccepted == true && data.type == 'withdraw') ? Colors.amber : AppColors.successColor,
        textAlign: TextAlign.start,
        text: data.type == 'withdraw' ? 'Withdraw' : (data.isAccepted == true && data.type == 'withdraw') ? 'Withdraw Progressing' : 'Top-up',
      ),
      subtitle: CustomText(
        fontWeight: FontWeight.w400,
        fontSize: 12.sp,
        textAlign: TextAlign.start,
        text: TimeFormatHelper.formatDate(DateTime.parse(data.createdAt ?? '')),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.coin.svg(height: 14.h, width: 14.w),
          CustomText(
            left: 4.w,
            color: data.type == 'withdraw' ? AppColors.primaryColor : (data.isAccepted == true && data.type == 'withdraw') ? Colors.amber : AppColors.successColor,
            textAlign: TextAlign.end,
            text: '${data.amount?.toString() ?? ''}',
          ),
        ],
      ),
    );
  }



  _buildCustomDialog({bool isTopUp = false}) {
    return showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<WalletController>(
          builder: (controller) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: CustomText(
                text: isTopUp ? 'Top Up' : 'Withdraw',
                fontWeight: FontWeight.w700,
                fontSize: 22.sp,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      controller: isTopUp ? controller.topUpAmountController : controller.withdrawAmountController,
                      prefixIcon:  Assets.icons.coin.svg(height: 16.h),
                      labelText: 'Points',
                      hintText:  'points',
                      onChanged: (value) => isTopUp ? controller.calculateTopUp(value) : controller.calculateWithdraw(value),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                          Assets.icons.wallet.svg(height: 16.h, width: 16.w),
                        SizedBox(width: 6),
                        CustomText(text: 'Amount (\$)'),
                        Spacer(),
                        CustomText(text:  controller.amounts.toStringAsFixed(2)),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                if(isTopUp)...[
                  controller.isLoadingTopUp ? CustomLoader() : CustomButton(
                    onPressed: () {
                      if(controller.topUpAmountController.text.isEmpty)return;
                      controller.topUp();
                    },
                    label: 'Recharge',
                  ),
                ],
                if(!isTopUp)...[
                  controller.isLoadingWithdraw ? CustomLoader() : CustomButton(
                    onPressed: () {
                      if(controller.withdrawAmountController.text.isEmpty)return;
                      controller.withdraw();
                    },
                    label: 'Withdraw Request',
                  ),
                ],

              ],
            );
          },
        );
      },
    );
  }

  Widget _buildWalletCard() {
    return Stack(
      children: [
        Positioned(child: SizedBox(height: 114.h)),
        CustomContainer(
          paddingVertical: 24.h,
          paddingHorizontal: 18.w,
          bordersColor: AppColors.primaryColor,
          radiusAll: 12.r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                child: CustomText(textAlign: TextAlign.start, text: 'Purchased Points'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.icons.coin.svg(),
                  GetBuilder<BalanceController>(
                    builder: (controller) {
                      return FittedBox(
                        child: CustomText(
                          left: 2.w,
                          text: controller.balance,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 26.sp,
                        ),
                      );
                    }
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                radius: 10.r,
                fontSize: 14.sp,
                width: 100.w,
                height: 28.h,
                onPressed: (){
                  _buildCustomDialog(isTopUp: true);

                },
                label: 'Top Up',
              ),
              CustomButton(
                radius: 10.r,
                fontSize: 14.sp,
                width: 100.w,
                height: 28.h,
                onPressed: (){
                  _buildCustomDialog();

                },
                label: 'Withdraw',
              ),
            ],
          ),
        ),
      ],
    );
  }



  void _addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _walletController.loadMore();
        print("load more true");
      }
    });
  }

}
