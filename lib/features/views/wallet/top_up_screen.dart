import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/wallet/topup_controller.dart';
import 'package:maignanka_app/features/views/wallet/widgets/product_card.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import '../../../widgets/widgets.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {

  final TopUpController _topUpController = Get.find<TopUpController>();


  @override
  void initState() {
    _topUpController.fetchOfferings();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return CustomScaffold(
      appBar: CustomAppBar(title: 'Top Up'),
      body: GetBuilder<TopUpController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child:
                controller.isLoading
                    ? const Center(child: CustomLoader())
                    : Column(
                      children: [
                        Text(
                          'Select the amount of coins you want to purchase.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.h,
                                  childAspectRatio: 0.9,
                                ),
                            itemCount: controller.products.length,
                            itemBuilder: (context, index) {
                              final product = controller.products[controller.products.length - 1 - index];
                              final isSelected = controller.selectedIndex == index;
                              return ProductCard(
                                amount: product['amount'],
                                price: product['price'],
                                isSelected: isSelected,
                                onTap: () {
                                  controller.selectedIndex = index;
                                  controller.update();
                                },
                              );
                            },
                          ),
                        ),
                        CustomButton(
                          label: 'Proceed to Purchase',
                          onPressed:
                              controller.selectedIndex == null
                                  ? null
                                  : () async{
                                    final package = controller.products[controller.selectedIndex!]['package'] as purchases.Package;
                                    controller.purchasePackage(package);
                              },
                        ),
                      ],
                    ),
          );
        },
      ),
    );
  }
}
