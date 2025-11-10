import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/env/keys.dart';
import 'package:maignanka_app/features/models/comment_model_data.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class TopUpController extends GetxController {

  List<Map<String, dynamic>> products = [];
  List<Package> availablePackages = [];
  int? selectedIndex;
  bool isLoading = true;



  @override
  void onInit() {
    _initRevenueCat();
    super.onInit();
  }

  void _initRevenueCat() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(Keys.topUpKey);
  }




  void fetchOfferings() async {
    isLoading = true;
    update();
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        availablePackages = offerings.current!.availablePackages;

        // Map RevenueCat packages to _products list for UI
        products = availablePackages.map((package) {
          final parts = package.identifier.split('_');
          final amount = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
          final price = package.storeProduct.priceString;
          return {
            'amount': amount,
            'price': price,
            'package': package,
          };
        }).toList();

        update();
      }
    } catch (e) {
      print("Error fetching offerings: $e");
    } finally {
      isLoading = false;
      update();
    }
  }




  void purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);
      print("Purchase successful: ${package.identifier}");
    } catch (e) {
      print("Purchase failed: $e");

    }
  }
}
