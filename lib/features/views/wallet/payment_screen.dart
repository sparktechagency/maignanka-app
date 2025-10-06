import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/payment_configurations.dart';
import 'package:pay/pay.dart';
import '../../../widgets/widgets.dart';

class GpayApplepayScreen extends StatefulWidget {
  const GpayApplepayScreen({
    super.key,
    required this.coin,
    required this.doller,
  });

  final String coin;
  final String doller;

  @override
  State<GpayApplepayScreen> createState() => _GpayApplepayScreenState();
}

class _GpayApplepayScreenState extends State<GpayApplepayScreen> {
  @override
  Widget build(BuildContext context) {
    final paymentItem = PaymentItem(
      label: 'Total',
      amount: widget.doller,
      status: PaymentItemStatus.final_price,
    );

    return CustomScaffold(
      appBar: CustomAppBar(title: 'Pay Now'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100.h),
          // Coin Icon
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Assets.icons.coin.svg(height: 100.h, width: 100.w),
          ),

          SizedBox(height: 20.h),

          // Coin Amount
          CustomText(
            text: '${widget.coin} Coins',
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
          CustomText(
            text: '${widget.doller} \$',
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),

          const SizedBox(height: 40),

          // Payment Buttons Card
          Column(
            children: [
              if (Platform.isIOS)
                SizedBox(
                  width: double.infinity,
                  child: ApplePayButton(
                    paymentConfiguration: PaymentConfiguration.fromJsonString(
                      defaultApplePay,
                    ),
                    paymentItems: [paymentItem],
                    style: ApplePayButtonStyle.black,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 15.0),
                    type: ApplePayButtonType.buy,
                    onPaymentResult: (result) {
                      debugPrint('Apple Pay Result: $result');
                    },
                    loadingIndicator: const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                ),
              if (Platform.isAndroid)
                SizedBox(
                  width: double.infinity,
                  child: GooglePayButton(
                    width: double.infinity,
                    paymentConfiguration: PaymentConfiguration.fromJsonString(
                      defaultGooglePay,
                    ),
                    paymentItems: [paymentItem],
                    type: GooglePayButtonType.pay,
                    margin: const EdgeInsets.only(top: 15.0),
                    onPaymentResult: (result) {
                      debugPrint('Google Pay Result: $result');
                    },
                    loadingIndicator: const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}