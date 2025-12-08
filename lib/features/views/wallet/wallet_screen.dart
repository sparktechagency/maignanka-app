import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/time_format.dart';
import 'package:maignanka_app/features/controllers/balance/balance_controller.dart';
import 'package:maignanka_app/features/controllers/profile_details/profile_controller.dart';
import 'package:maignanka_app/features/controllers/wallet/wallet_controller.dart';
import 'package:maignanka_app/features/models/wallet_model_data.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/widgets.dart';

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
    {'label': 'Received Gifts', 'value': 'gifts'},
    {'label': 'My Transactions', 'value': 'my'},
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Wallet',
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: CustomButton(
              onPressed: () {
                Get.toNamed(AppRoutes.bankInfoScreen);
              },
              label: 'Bank info',
              height: 24.h,
              width: 100.w,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),

          Row(
            children: [
              Flexible(
                child: _buildWalletCard(
                  title: 'Purchased Points',
                  coinGetter: () => _balanceController.balance,
                  buttonLabel: 'Buy More',
                  onTap: () => Get.toNamed(AppRoutes.topUpScreen),
                  cardColor: Colors.blue.shade50,
                  borderColor: Colors.blue.shade300,
                  iconColor: Colors.blue.shade700,
                  isPurchased: true,
                ),
              ),
              SizedBox(width: 10.w),
              Flexible(
                child: _buildWalletCard(
                  title: 'Earned Points',
                  coinGetter: () => _balanceController.earnedBalance ?? '0',
                  buttonLabel: 'Withdraw',
                  onTap: () => _buildCustomDialog(),
                  cardColor: Colors.green.shade50,
                  borderColor: Colors.green.shade300,
                  iconColor: Colors.green.shade700,
                  isPurchased: false,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          _buildNoteSection(),

          SizedBox(height: 10.h),

          // History Section
          CustomText(
            text: 'Transaction History',
            bottom: 10.h,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          GetBuilder<WalletController>(
            builder: (controller) {
              return TwoButtonWidget(
                buttons: _historyTypes,
                selectedValue: controller.selectedValueType,
                onTap: (val) => controller.onChangeType(val),
                fontSize: 12.sp,
              );
            },
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: GetBuilder<WalletController>(
              builder: (controller) {
                if (controller.selectedValueType == 'gifts') {
                  if (controller.isLoading) return CustomLoader();
                  if (controller.giftHistory.isEmpty) {
                    return Center(
                      child: CustomText(text: 'No gifts received yet'),
                    );
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
                  if (controller.isLoadingMy) return CustomLoader();
                  if (controller.topUpHistory.isEmpty) {
                    return Center(
                      child: CustomText(text: 'No transactions yet'),
                    );
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

  Widget _buildNoteSection() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.amber.shade300, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.amber.shade800,
                size: 18.sp,
              ),
              SizedBox(width: 6.w),
              CustomText(
                text: 'Important Information',
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: Colors.amber.shade900,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _buildNoteItem(
            '• Purchased Points: Used to send gifts. Cannot be withdrawn or refunded.',
          ),
          SizedBox(height: 4.h),
          _buildNoteItem(
            '• Earned Points: Received from gifts. Can be withdrawn via PayPal.',
          ),
          SizedBox(height: 4.h),
          _buildNoteItem(
            '• Minimum withdrawal: 120 points (\$2.52)',
          ),
        ],
      ),
    );
  }

  Widget _buildNoteItem(String text) {
    return CustomText(
      textAlign: TextAlign.start,
      text: text,
      fontSize: 10.sp,
      color: Colors.amber.shade900,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildWalletCard({
    required String title,
    required String Function() coinGetter,
    required VoidCallback onTap,
    required String buttonLabel,
    required Color cardColor,
    required Color borderColor,
    required Color iconColor,
    required bool isPurchased,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomContainer(
          width: double.infinity,
          paddingVertical: 20.h,
          paddingHorizontal: 12.w,
          bordersColor: borderColor,
          radiusAll: 12.r,
          color: cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Icon(
                isPurchased ? Icons.shopping_bag_outlined : Icons.card_giftcard,
                color: iconColor,
                size: 20.sp,
              ),
              SizedBox(height: 4.h),

              // Title
              FittedBox(
                child: CustomText(
                  textAlign: TextAlign.center,
                  text: title,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
              SizedBox(height: 8.h),

              // Coin Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.icons.coin.svg(),
                  GetBuilder<BalanceController>(
                    builder: (controller) {
                      return FittedBox(
                        child: CustomText(
                          left: 4.w,
                          text: coinGetter(),
                          color: iconColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 22.sp,
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.h), // Space for button
            ],
          ),
        ),

        // Button at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: -8.h,
          child: Center(
            child: CustomButton(
              radius: 10.r,
              fontSize: 12.sp,
              width: 120.w,
              height: 32.h,
              onPressed: onTap,
              label: buttonLabel,
              backgroundColor: iconColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGiftHistoryTile(WalletModelData data) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.card_giftcard, color: Colors.green.shade700, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: data.giftInfo?.name ?? 'Gift',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  text: data.sendBy?.sId  == Get.find<ProfileController>().userId ? 'From: me' : 'From: ${data.sendBy?.name ?? 'Someone'}',
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                ),
                CustomText(
                  text: TimeFormatHelper.formatDate(
                    DateTime.parse(data.createdAt ?? ''),
                  ),
                  fontSize: 10.sp,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Assets.icons.coin.svg(height: 16.h,width: 16.w),
              CustomText(
                left: 4.w,
                color: Colors.green.shade700,
                text: '${data.giftInfo?.points?.toString() ?? '0'}',
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyHistoryTile(MyHistoryModelData data) {
    final isWithdraw = data.type == 'withdraw';
    final color = isWithdraw ? Colors.red.shade600 : Colors.blue.shade600;
    final bgColor = isWithdraw ? Colors.red.shade50 : Colors.blue.shade50;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(
              isWithdraw ? Icons.download : Icons.add_shopping_cart,
              color: color,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: isWithdraw ? 'Withdrawal' : 'Purchase',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                if (isWithdraw && data.isAccepted == true)
                  CustomText(
                    text: 'Processing...',
                    fontSize: 10.sp,
                    color: Colors.orange.shade700,
                  ),
                CustomText(
                  text: TimeFormatHelper.formatDate(
                      DateTime.parse(data.createdAt ?? '')
                  ),
                  fontSize: 10.sp,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
          Row(
            children: [
              CustomText(
                left: 4.w,
                color: color,
                text: '\$${isWithdraw ? '-' : '+'}${data.amount?.toString() ?? '0'}',
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildCustomDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<WalletController>(
          builder: (controller) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.green.shade700),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: 'Withdraw Earnings',
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Available Balance
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: 'Available:', fontSize: 11.sp),
                          Row(
                            children: [
                              GetBuilder<BalanceController>(
                                builder: (balController) {
                                  return CustomText(
                                    text: balController.earnedBalance ?? '0',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                    color: Colors.green.shade700,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Amount Input
                    CustomTextField(
                      keyboardType: TextInputType.number,
                      controller: controller.withdrawAmountController,
                      labelText: 'Points',
                      hintText: 'Min: 120 coins',
                      onChanged: (value) => controller.calculateWithdraw(value),
                    ),
                    SizedBox(height: 10.h),

                    // Conversion Display
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Assets.icons.wallet.svg(height: 16.h, width: 16.w),
                          SizedBox(width: 6.w),
                          CustomText(text: 'You\'ll Receive:', fontSize: 11.sp),
                          Spacer(),
                          CustomText(
                            text: '\$${controller.amounts.toStringAsFixed(2)}',
                            fontWeight: FontWeight.w700,
                            color: Colors.green.shade700,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Important Warning
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.blue.shade300),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, size: 14.sp, color: Colors.blue.shade700),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: CustomText(
                              textAlign: TextAlign.start,
                              text: 'Only earned points from gifts can be withdrawn. Purchased points cannot be converted to cash per App Store policy.',
                              fontSize: 9.sp,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: CustomText(text: 'Cancel', color: Colors.grey),
                ),
                controller.isLoadingWithdraw
                    ? CustomLoader()
                    : CustomButton(
                  width: 120.w,
                  height: 36.h,
                  onPressed: () {
                    if (controller.withdrawAmountController.text.isEmpty) {
                      Get.snackbar('Error', 'Enter amount');
                      return;
                    }

                    final amount = int.tryParse(
                        controller.withdrawAmountController.text
                    ) ?? 0;

                    if (amount < 120) {
                      Get.snackbar('Error', 'Minimum 120 points required');
                      return;
                    }

                    final earnedBalance = int.tryParse(
                        _balanceController.earnedBalance ?? '0'
                    ) ?? 0;

                    if (amount > earnedBalance) {
                      Get.snackbar(
                          'Error',
                          'Insufficient earned points (${earnedBalance} available)'
                      );
                      return;
                    }

                    controller.withdraw();
                  },
                  label: 'Confirm',
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _walletController.loadMore();
      }
    });
  }
}