import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/utils/app_colors.dart';
import '../../../widgets/widgets.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final List<Map<String, dynamic>> _products = [
    {'amount': 100, 'price': '€4.99'},
    {'amount': 198, 'price': '€9.90',},
    {'amount': 1200, 'price': '€9.99'},
    {'amount': 2500, 'price': '€19.99'},
    {'amount': 6500, 'price': '€49.99'},
    {'amount': 14000, 'price': '€99.99'},
  ];

  // To keep track of the selected product
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Top Up'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          children: [
            // Informational text
            Text(
              'Select the amount of coins you want to purchase.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 24.h),
            // Grid of products
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.9, // Adjust ratio for better look
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  final isSelected = _selectedIndex == index;

                  return ProductCard(
                    amount: product['amount'],
                    price: product['price'],
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            // Purchase Button
            CustomButton(
              label: 'Proceed to Purchase',
              onPressed: _selectedIndex == null
                  ? null // Disable button if nothing is selected
                  : () {
                // Handle the purchase logic here
                if (_selectedIndex != null) {
                  final selectedProduct = _products[_selectedIndex!];
                  print(
                      'Purchasing ${selectedProduct['amount']} coins for ${selectedProduct['price']}');
                  // TODO: Integrate with your payment gateway (e.g., RevenueCat, in_app_purchase)
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// A reusable widget for the product card
class ProductCard extends StatelessWidget {
  final int amount;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.amount,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Coin Icon (replace with your asset)
            Icon(Icons.monetization_on,
                size: 40.sp, color: AppColors.primaryColor),
            SizedBox(height: 12.h),
            // Amount
            Text(
              '$amount Coins',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            // Price
            Text(
              price,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


