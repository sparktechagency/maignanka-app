import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/helper_data.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  final TextEditingController _topUpAmountController = TextEditingController();
  final TextEditingController _withdrawAmountController = TextEditingController();

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
                  coin: '100',
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
                  coin: '100',
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
            child: ListView.builder(
              itemCount: HelperData.historyData.length,
              itemBuilder: (context, index) {
                final data = HelperData.historyData[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                    title: CustomText(
                      textAlign: TextAlign.start,
                      text: data['title'] ?? '',
                ),
                  subtitle: CustomText(
                    fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      textAlign: TextAlign.start,
                      text: data['date'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.icons.coin.svg(height: 14.h,width: 14.w),
                      CustomText(
                        left: 4.w,
                        color: data['title'] != 'Withdraw' ? AppColors.successColor : AppColors.primaryColor,
                          textAlign: TextAlign.end,
                          text: data['points'].toString()),
                    ],
                  ),
                );
              },
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
        double points = 0;
        double amounts = 0;

        return StatefulBuilder(
          builder: (context, setState) {
            void calculateTopUp(String value) {
              final enteredAmount = double.tryParse(value) ?? 0;
              final netAmount = enteredAmount * 0.70; // after 30% store fee
              final calculatedPoints = netAmount / 0.035;
              setState(() {
                points = calculatedPoints.floorToDouble();
              });
            }

            void calculateWithdraw(String value) {
              final enteredPoints = double.tryParse(value) ?? 0;
              final grossAmount = enteredPoints * 0.035;
              final netAmount = grossAmount * 0.60; // after 40% withdrawal fee
              setState(() {
                amounts = netAmount;
              });
            }

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
                      controller: isTopUp ? _topUpAmountController : _withdrawAmountController,
                      prefixIcon: isTopUp ? Assets.icons.wallet.svg() : Assets.icons.coin.svg(height: 16.h),
                      labelText: isTopUp ? 'Amount (Dollar)' : 'Points',
                      hintText: isTopUp ? 'amount' : 'points',
                      onChanged: isTopUp ? calculateTopUp : calculateWithdraw,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        if(isTopUp)
                        Assets.icons.coin.svg(height: 16.h, width: 16.w),
                        if(!isTopUp)
                          Assets.icons.wallet.svg(height: 16.h, width: 16.w),
                        SizedBox(width: 6),
                        CustomText(text: isTopUp ? 'Points' : 'Amount (\$)'),
                        Spacer(),
                        CustomText(text: isTopUp ? '${points.toInt()}' : amounts.toStringAsFixed(2)),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                CustomButton(
                  onPressed: () {
                    Get.back();
                    _topUpAmountController.clear();
                    _withdrawAmountController.clear();
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
    required String coin,
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
                  CustomText(
                    text: coin,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 30.sp,
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




}
