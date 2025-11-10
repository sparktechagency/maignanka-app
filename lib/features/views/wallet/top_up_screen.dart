import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../app/utils/app_colors.dart';
import '../../../widgets/widgets.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  List<Map<String, dynamic>> _products = [];
  List<Package> _availablePackages = [];
  int? _selectedIndex;
  bool _isLoading = true;

  // Fetch Offerings from RevenueCat
  void fetchOfferings() async {
    setState(() => _isLoading = true);
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        _availablePackages = offerings.current!.availablePackages;

        // Map RevenueCat packages to _products list for UI
        _products = _availablePackages.map((package) {
          final parts = package.identifier.split('_');
          final amount = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
          final price = package.storeProduct.priceString;
          return {
            'amount': amount,
            'price': price,
            'package': package,
          };
        }).toList();

        setState(() {});
      }
    } catch (e) {
      print("Error fetching offerings: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Purchase a package
  void purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);

      // For consumable, purchase is successful if no exception
      print("Purchase successful: ${package.identifier}");

      // TODO: Update user coin balance locally or on your server
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully purchased ${package.storeProduct.priceString} for ${package.identifier}")),
      );
    } catch (e) {
      print("Purchase failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Purchase failed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Top Up'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Text(
              'Select the amount of coins you want to purchase.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: Colors.black54),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.9,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[_products.length - 1 - index];
                  final isSelected = _selectedIndex == index;

                  return ProductCard(
                    amount: product['amount'],
                    price: product['price'],
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedIndex = index);
                    },
                  );
                },
              ),
            ),
            CustomButton(
              label: 'Proceed to Purchase',
              onPressed: _selectedIndex == null
                  ? null
                  : () {
                final package =
                _products[_selectedIndex!]['package'] as Package;
                purchasePackage(package);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Product Card widget
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
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade100,
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.01),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on,
                size: 40.sp, color: AppColors.primaryColor),
            SizedBox(height: 12.h),
            Text(
              '$amount Coins',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
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
