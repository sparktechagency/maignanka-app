import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/time_format.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/balance/balance_controller.dart';
import 'package:maignanka_app/features/controllers/wallet/wallet_controller.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  final WalletController _walletController = Get.find<WalletController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _walletController.transHistoryGet(isInitialLoad: true);
    _addScrollListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Wallet'),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildWalletCard(
                  title: 'Purchased Points',
                  //coin: '100',
                  buttonLabel: 'Top Up',
                  onTap: () {
                    _buildCustomDialog(isTopUp: true);
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildWalletCard(
                  title: 'Reward Points',
                  //coin: '100',
                  buttonLabel: 'Withdraw',
                  onTap: () {
                    _buildCustomDialog();

                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 44.h),
          CustomText(text: 'History'),
          Expanded(
            child: GetBuilder<WalletController>(
              builder: (controller) {
                if(controller.isLoading){
                  return CustomLoader();
                }else if(controller.walletData.isEmpty){
                  return Center(child: CustomText(text: 'No history fount.'));
                }
                return ListView.builder(
                  itemCount: controller.walletData.length,
                  itemBuilder: (context, index) {
                    final data = controller.walletData[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                        title: CustomText(
                          textAlign: TextAlign.start,
                          text: data.giftInfo?.name ?? '',
                    ),
                      subtitle: CustomText(
                        fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          textAlign: TextAlign.start,
                          text: TimeFormatHelper.formatDate(DateTime.parse(data.createdAt ?? ''))),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Assets.icons.coin.svg(height: 14.h,width: 14.w),
                          CustomText(
                            left: 4.w,
                            color: data.send == true ? AppColors.primaryColor : AppColors.successColor,
                              textAlign: TextAlign.end,
                              text: data.giftInfo?.points.toString() ?? ''),
                        ],
                      ),
                    );
                  },
                );
              }
            ),
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
                controller.isLoadingTopUp ? CustomLoader() : CustomButton(
                  onPressed: () {
                    if(controller.topUpAmountController.text.isEmpty)return;
                    controller.topUp();
                  },
                  label: isTopUp ? 'Recharge' : 'Withdraw Request',
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildWalletCard({
    required String title,
    required buttonLabel,
    required VoidCallback onTap,
  }) {
    return Stack(
      children: [
        Positioned(child: SizedBox(height: 114.h)),
        CustomContainer(
          paddingVertical: 22.h,
          paddingHorizontal: 18.w,
          bordersColor: AppColors.primaryColor,
          radiusAll: 12.r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                child: CustomText(textAlign: TextAlign.start, text: title),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.icons.coin.svg(),
                  GetBuilder<BalanceController>(
                    builder: (controller) {
                      return CustomText(
                        left: 2.w,
                        text: controller.balance,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 30.sp,
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
          child: Center(
            child: CustomButton(
              radius: 10.r,
              fontSize: 14.sp,
              width: 100.w,
              height: 28.h,
              onPressed: onTap,
              label: buttonLabel,
            ),
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
