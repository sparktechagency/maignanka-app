import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/env/keys.dart';
import 'package:maignanka_app/features/controllers/balance/balance_controller.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class TopUpController extends GetxController {
  /// Holds the list of product maps for display
  final products = <Map<String, dynamic>>[];

  /// List of available RevenueCat packages
  List<Package> availablePackages = [];

  /// Currently selected package index
  int? selectedIndex;

  /// Loading state for UI updates
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    _initRevenueCat();
  }

  /// Initialize RevenueCat with your public SDK key
  Future<void> _initRevenueCat() async {
    try {
      await Purchases.setDebugLogsEnabled(true);
      await Purchases.setup(Keys.topUpKey);

      // Optional: Identify user (if you have user IDs)
      // await Purchases.logIn("user_${userId}");

      await fetchOfferings();
    } catch (e) {
      debugPrint("❌ RevenueCat initialization failed: $e");
      ToastMessageHelper.showToastMessage("Failed to initialize payment system.");
      isLoading = false;
      update();
    }
  }

  /// Fetch available offerings from RevenueCat
  Future<void> fetchOfferings() async {
    isLoading = true;
    update();

    try {
      final offerings = await Purchases.getOfferings();

      final currentOffering = offerings.current;
      if (currentOffering == null || currentOffering.availablePackages.isEmpty) {
        ToastMessageHelper.showToastMessage("No coin packages available right now.");
        debugPrint("⚠️ No available packages found in RevenueCat.");
        return;
      }

      availablePackages = currentOffering.availablePackages;

      // Extract clean data for UI usage
      products
        ..clear()
        ..addAll(
          availablePackages.map((pkg) {
            final id = pkg.identifier;
            final parts = id.split('_');
            final amount = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

            return {
              'id': id,
              'amount': amount,
              'price': pkg.storeProduct.priceString,
              'package': pkg,
            };
          }),
        );

      debugPrint("✅ Fetched ${products.length} packages from RevenueCat.");
    } catch (e) {
      debugPrint("❌ Error fetching offerings: $e");
      ToastMessageHelper.showToastMessage("Failed to load coin packages.");
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Purchase selected package safely
  Future<void> purchasePackage(Package package) async {
      final customerInfo = await Purchases.purchasePackage(package);

      final hasActiveEntitlement = customerInfo.entitlements.active.isNotEmpty;
      if (hasActiveEntitlement) {
        ToastMessageHelper.showToastMessage("✅ Purchase successful!");

        debugPrint("🎉 Active entitlements: ${customerInfo.entitlements.active.keys}");
      } else {
        ToastMessageHelper.showToastMessage("Purchase completed, but activation pending.");
      }
    }




  bool isLoadingCoin = false;

  Future<void> coinBuy() async {
    isLoadingCoin = true;
    update();


    final response = await ApiClient.postData(
      ApiUrls.coinBuy,
      {},
    );

    final responseBody = response.body;
    if (response.statusCode == 200) {
      ToastMessageHelper.showToastMessage(responseBody['message'] ?? "");
      Get.find<BalanceController>().balanceGet();
      Get.back();
    }
    isLoadingCoin = false;
    update();
  }
}
