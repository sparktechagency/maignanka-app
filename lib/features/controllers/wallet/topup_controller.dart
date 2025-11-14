import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/env/keys.dart';
import 'package:maignanka_app/features/controllers/balance/balance_controller.dart';
import 'package:maignanka_app/services/api_client.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class TopUpController extends GetxController {
  /// UI product list
  final products = <Map<String, dynamic>>[];

  /// RevenueCat packages
  List<Package> availablePackages = [];

  /// Selected UI index
  int? selectedIndex;

  /// UI loading
  bool isLoading = true;

  bool isLoadingCoin = false;

  @override
  void onInit() {
    super.onInit();
    _initRevenueCat();
  }

  // ---------------------------
  // 🔹 1. Initialize RevenueCat
  // ---------------------------
  Future<void> _initRevenueCat() async {
    try {
      await Purchases.setDebugLogsEnabled(true);

      await Purchases.setup(
        Platform.isAndroid ? Keys.topUpKey : Keys.topUpIosKey,
      );

      // If logged-in user exists → always login to RevenueCat
      // await Purchases.logIn(userId.toString());

      await fetchOfferings();
    } catch (e) {
      debugPrint("❌ RevenueCat initialization failed: $e");
      ToastMessageHelper.showToastMessage("Failed to initialize payment system.");
      isLoading = false;
      update();
    }
  }

  // ---------------------------
  // 🔹 2. Fetch Offerings
  // ---------------------------
  Future<void> fetchOfferings() async {
    isLoading = true;
    update();

    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;

      if (currentOffering == null || currentOffering.availablePackages.isEmpty) {
        ToastMessageHelper.showToastMessage("No coin packages available right now.");
        return;
      }

      availablePackages = currentOffering.availablePackages;

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

      debugPrint("✅ ${products.length} packages loaded.");
    } catch (e) {
      debugPrint("❌ Error fetching offerings: $e");
      ToastMessageHelper.showToastMessage("Failed to load coin packages.");
    } finally {
      isLoading = false;
      update();
    }
  }

  // ---------------------------
  // 🔹 3. Purchase Package
  // ---------------------------
  Future<void> purchasePackage(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);

      // For consumables always take latest non-subscription purchase
      final transaction = customerInfo.nonSubscriptionTransactions.isNotEmpty
          ? customerInfo.nonSubscriptionTransactions.last
          : null;

      if (transaction == null) {
        ToastMessageHelper.showToastMessage("Purchase failed (no transaction).");
        return;
      }

      final parts = package.identifier.split('_');
      final coinAmount = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

      await coinBuy(
        productId: package.identifier,
        coinAmount: coinAmount,
        transactionId: transaction.transactionIdentifier ?? '',
        revenueCatUserId: customerInfo.originalAppUserId,
        price: package.storeProduct.price,
      );
    } catch (e) {
      debugPrint("❌ Purchase error: $e");
      ToastMessageHelper.showToastMessage("Purchase failed. Try again.");
    }
  }

  // ---------------------------
  // 🔹 4. Backend Verification
  // ---------------------------
  Future<void> coinBuy({
    required String productId,
    required int coinAmount,
    required String transactionId,
    required String revenueCatUserId,
    required double price,
  }) async {
    isLoadingCoin = true;
    update();

    try {
      final response = await ApiClient.postData(
        ApiUrls.coinBuy,
        {
          'product_id': productId,
          'coin_amount': coinAmount,
          'amount': price, // Dynamic Price
          'transaction_id': transactionId,
          'revenue_cat_user_id': revenueCatUserId,
          'platform': GetPlatform.isAndroid ? 'android' : 'ios',
        },
      );

      final body = response.body;

      if (response.statusCode == 200) {
        ToastMessageHelper.showToastMessage(body['message'] ?? "Coins added successfully!");
        Get.find<BalanceController>().balanceGet();
        Get.back();
      } else {
        ToastMessageHelper.showToastMessage(body['message'] ?? "Failed to process purchase.");
      }
    } catch (e) {
      debugPrint("❌ API error: $e");
      ToastMessageHelper.showToastMessage("Network error. Try again.");
    } finally {
      isLoadingCoin = false;
      update();
    }
  }
}
