import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase_storekit/src/store_kit_wrappers/sk_payment_queue_delegate_wrapper.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:maignanka_app/app/helpers/time_format.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/balance/balance_controller.dart';
import 'package:maignanka_app/features/controllers/wallet/wallet_controller.dart';
import 'package:maignanka_app/features/models/wallet_model_data.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';
import 'package:maignanka_app/widgets/two_button_widget.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

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
    {'label': 'Gifts History', 'value': 'gifts'},
    {'label': 'My History', 'value': 'my'},
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Wallet',actions: [
        Padding(
          padding:  EdgeInsets.all(8.0.r),
          child: CustomButton(onPressed: (){
            Get.toNamed(AppRoutes.bankInfoScreen);

          },label: 'Bank info',height: 24.h,width: 100.w,fontSize: 12.sp,),
        ),

      ],),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          _buildWalletCard(),
          SizedBox(height: 44.h),
          CustomText(text: 'History',bottom: 10.h),
          GetBuilder<WalletController>(
            builder: (controller) {
              return TwoButtonWidget(buttons: _historyTypes, selectedValue: controller.selectedValueType, onTap: (val) => controller.onChangeType(val),fontSize: 12.sp,);
            }
          ),
          Expanded(
            child: GetBuilder<WalletController>(
              builder: (controller) {
                if(controller.selectedValueType == 'gifts') {
                  if(controller.isLoading) return CustomLoader();
                  if(controller.giftHistory.isEmpty) {
                    return Center(child: CustomText(text: 'No gift history found.'));
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
                  if(controller.isLoadingMy) return CustomLoader();
                  if(controller.topUpHistory.isEmpty) {
                    return Center(child: CustomText(text: 'No top-up history found.'));
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

  Widget _buildGiftHistoryTile(WalletModelData data) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomText(
        textAlign: TextAlign.start,
        text: data.giftInfo?.name ?? 'N/A',
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            top: 2.h,
            bottom: 2.h,
            text: 'SendBy : ${data.sendBy?.name ?? ''}',
            fontSize: 12.sp,
          ),
          CustomText(
            fontWeight: FontWeight.w400,
            fontSize: 10.sp,
            textAlign: TextAlign.start,
            text: TimeFormatHelper.formatDate(DateTime.parse(data.createdAt ?? '')),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.coin.svg(height: 14.h, width: 14.w),
          CustomText(
            left: 4.w,
            color: data.send == true
                ? AppColors.primaryColor
                : AppColors.successColor,
            textAlign: TextAlign.end,
            text: data.giftInfo?.points?.toString() ?? '',
          ),
        ],
      ),
    );
  }
  Widget _buildMyHistoryTile(MyHistoryModelData data) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomText(
        color: data.type == 'withdraw' ? AppColors.primaryColor : (data.isAccepted == true && data.type == 'withdraw') ? Colors.amber : AppColors.successColor,
        textAlign: TextAlign.start,
        text: data.type == 'withdraw' ? 'Withdraw' : (data.isAccepted == true && data.type == 'withdraw') ? 'Withdraw Progressing' : 'Top-up',
      ),
      subtitle: CustomText(
        fontWeight: FontWeight.w400,
        fontSize: 12.sp,
        textAlign: TextAlign.start,
        text: TimeFormatHelper.formatDate(DateTime.parse(data.createdAt ?? '')),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.coin.svg(height: 14.h, width: 14.w),
          CustomText(
            left: 4.w,
            color: data.type == 'withdraw' ? AppColors.primaryColor : (data.isAccepted == true && data.type == 'withdraw') ? Colors.amber : AppColors.successColor,
            textAlign: TextAlign.end,
            text: '${data.amount?.toString() ?? ''}',
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
                      keyboardType: TextInputType.number,
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
                if(isTopUp)...[
                  controller.isLoadingTopUp ? CustomLoader() : CustomButton(
                    onPressed: () {
                      if(controller.topUpAmountController.text.isEmpty)return;
                     Get.to(() => CoinPurchaseScreen());
                    },
                    label: 'Recharge',
                  ),
                ],
                if(!isTopUp)...[
                  controller.isLoadingWithdraw ? CustomLoader() : CustomButton(
                    onPressed: () {
                      if(controller.withdrawAmountController.text.isEmpty)return;
                      controller.withdraw();
                    },
                    label: 'Withdraw Request',
                  ),
                ],

              ],
            );
          },
        );
      },
    );
  }

  Widget _buildWalletCard() {
    return Stack(
      children: [
        Positioned(child: SizedBox(height: 114.h)),
        CustomContainer(
          paddingVertical: 24.h,
          paddingHorizontal: 18.w,
          bordersColor: AppColors.primaryColor,
          radiusAll: 12.r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                child: CustomText(textAlign: TextAlign.start, text: 'Purchased Points'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.icons.coin.svg(),
                  GetBuilder<BalanceController>(
                    builder: (controller) {
                      return FittedBox(
                        child: CustomText(
                          left: 2.w,
                          text: controller.balance,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 26.sp,
                        ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                radius: 10.r,
                fontSize: 14.sp,
                width: 100.w,
                height: 28.h,
                onPressed: (){
                  _buildCustomDialog(isTopUp: true);

                },
                label: 'Top Up',
              ),
              CustomButton(
                radius: 10.r,
                fontSize: 14.sp,
                width: 100.w,
                height: 28.h,
                onPressed: (){
                  _buildCustomDialog();

                },
                label: 'Withdraw',
              ),
            ],
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


// lib/services/coin_purchase_service.dart



class CoinPurchaseService {
  static final CoinPurchaseService _instance = CoinPurchaseService._internal();
  factory CoinPurchaseService() => _instance;
  CoinPurchaseService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Purchase state callbacks
  Function(int coins, String productId)? onCoinsAdded;
  Function(String message)? onPurchaseError;
  Function()? onPurchasePending;

  bool _isInitialized = false;
  List<CoinPackage> _coinPackages = [];

  // Getters
  bool get isInitialized => _isInitialized;
  List<CoinPackage> get coinPackages => _coinPackages;

  /// Initialize the purchase service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    final available = await _iap.isAvailable();
    if (!available) {
      debugPrint('IAP not available');
      return false;
    }

    // Setup purchase listener
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => debugPrint('Purchase stream done'),
      onError: (error) => debugPrint('Purchase stream error: $error'),
    );

    // iOS specific setup
    if (Platform.isIOS) {
      final iosPlatform = _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatform.setDelegate(PaymentQueueDelegate());
    }

    _isInitialized = true;
    debugPrint('Coin Purchase Service initialized');
    return true;
  }

  /// Load coin packages from store
  Future<bool> loadCoinPackages() async {
    if (!_isInitialized) {
      debugPrint('Service not initialized');
      return false;
    }

    // Define your coin package product IDs
    final Set<String> productIds = {
      'coins_100',    // 100 coins - $0.99
      'coins_500',    // 500 coins - $4.99
      'coins_1000',   // 1000 coins - $9.99
      'coins_5000',   // 5000 coins - $49.99
      'coins_10000',  // 10000 coins - $99.99
    };

    try {
      final response = await _iap.queryProductDetails(productIds);

      if (response.error != null) {
        debugPrint('Error loading products: ${response.error}');
        return false;
      }

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Products not found: ${response.notFoundIDs}');
      }

      // Convert to CoinPackage objects
      _coinPackages = response.productDetails.map((product) {
        return CoinPackage.fromProductDetails(product);
      }).toList();

      // Sort by coin amount
      _coinPackages.sort((a, b) => a.coinAmount.compareTo(b.coinAmount));

      debugPrint('Loaded ${_coinPackages.length} coin packages');
      return true;
    } catch (e) {
      debugPrint('Exception loading products: $e');
      return false;
    }
  }

  /// Purchase a coin package
  Future<bool> buyCoinPackage(CoinPackage package) async {
    if (!_isInitialized) {
      debugPrint('Service not initialized');
      return false;
    }

    try {
      final purchaseParam = PurchaseParam(productDetails: package.productDetails);

      // Coins are consumable products
      return await _iap.buyConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('Error purchasing coins: $e');
      onPurchaseError?.call('Failed to purchase coins: $e');
      return false;
    }
  }

  /// Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      debugPrint('Purchase status: ${purchaseDetails.status}');

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          onPurchasePending?.call();
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _handleSuccessfulPurchase(purchaseDetails);
          break;
        case PurchaseStatus.error:
          onPurchaseError?.call(purchaseDetails.error?.message ?? 'Purchase failed');
          break;
        case PurchaseStatus.canceled:
          debugPrint('Purchase canceled');
          break;
      }

      // Complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        _iap.completePurchase(purchaseDetails);
      }
    }
  }

  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) {
    debugPrint('Purchase successful: ${purchaseDetails.productID}');

    // Verify purchase
    _verifyPurchase(purchaseDetails).then((verified) {
      if (verified) {
        // Get coin amount from product ID
        final coinAmount = _getCoinAmountFromProductId(purchaseDetails.productID);

        // Add coins to user account
        onCoinsAdded?.call(coinAmount, purchaseDetails.productID);

        debugPrint('Added $coinAmount coins to user account');
      } else {
        debugPrint('Purchase verification failed');
        onPurchaseError?.call('Purchase verification failed');
      }
    });
  }

  /// Get coin amount from product ID
  int _getCoinAmountFromProductId(String productId) {
    final package = _coinPackages.firstWhere(
          (p) => p.productDetails.id == productId,
      orElse: () => _coinPackages.first,
    );
    return package.coinAmount;
  }

  /// Verify purchase with your server
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // TODO: Implement server-side verification
    // Send purchase data to your backend
    /*
    final response = await http.post(
      Uri.parse('YOUR_API_ENDPOINT/verify-purchase'),
      body: {
        'purchaseToken': purchaseDetails.verificationData.serverVerificationData,
        'productId': purchaseDetails.productID,
        'platform': Platform.isAndroid ? 'android' : 'ios',
      },
    );
    return response.statusCode == 200;
    */

    // For now, return true (NOT RECOMMENDED FOR PRODUCTION)
    return true;
  }

  /// Dispose the service
  void dispose() {
    _subscription.cancel();
    _isInitialized = false;
    debugPrint('Coin Purchase Service disposed');
  }
}

// iOS Payment Queue Delegate
class PaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}

// lib/models/coin_package.dart

class CoinPackage {
  final String id;
  final int coinAmount;
  final String price;
  final double rawPrice;
  final String currencyCode;
  final String title;
  final String description;
  final ProductDetails productDetails;
  final bool isBestValue;
  final int? bonusCoins;

  CoinPackage({
    required this.id,
    required this.coinAmount,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
    required this.title,
    required this.description,
    required this.productDetails,
    this.isBestValue = false,
    this.bonusCoins,
  });

  factory CoinPackage.fromProductDetails(ProductDetails details) {
    // Extract coin amount from product ID (e.g., "coins_100" -> 100)
    final coinAmount = int.parse(details.id.replaceAll('coins_', ''));

    // Calculate bonus coins (10% bonus for packages >= 1000)
    final bonusCoins = coinAmount >= 1000 ? (coinAmount * 0.1).toInt() : null;

    // Mark best value (usually the biggest package)
    final isBestValue = coinAmount >= 5000;

    return CoinPackage(
      id: details.id,
      coinAmount: coinAmount,
      price: details.price,
      rawPrice: details.rawPrice,
      currencyCode: details.currencyCode,
      title: details.title,
      description: details.description,
      productDetails: details,
      isBestValue: isBestValue,
      bonusCoins: bonusCoins,
    );
  }

  int get totalCoins => coinAmount + (bonusCoins ?? 0);

  String get displayText {
    if (bonusCoins != null && bonusCoins! > 0) {
      return '$coinAmount + $bonusCoins Bonus';
    }
    return '$coinAmount Coins';
  }
}


class CoinPurchaseScreen extends StatefulWidget {
  final int currentCoins;

  const CoinPurchaseScreen({
    Key? key,
    this.currentCoins = 0,
  }) : super(key: key);

  @override
  State<CoinPurchaseScreen> createState() => _CoinPurchaseScreenState();
}

class _CoinPurchaseScreenState extends State<CoinPurchaseScreen> {
  final _coinService = CoinPurchaseService();
  bool _isLoading = true;
  String? _errorMessage;
  int _userCoins = 0;

  @override
  void initState() {
    super.initState();
    _userCoins = widget.currentCoins;
    _initializePurchases();
  }

  Future<void> _initializePurchases() async {
    setState(() => _isLoading = true);

    // Setup callbacks
    _coinService.onCoinsAdded = _onCoinsAdded;
    _coinService.onPurchaseError = _onPurchaseError;
    _coinService.onPurchasePending = _onPurchasePending;

    // Initialize
    final initialized = await _coinService.initialize();
    if (!initialized) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'In-app purchases not available';
      });
      return;
    }

    // Load coin packages
    final loaded = await _coinService.loadCoinPackages();
    setState(() {
      _isLoading = false;
      if (!loaded) {
        _errorMessage = 'Failed to load coin packages';
      }
    });
  }

  void _onCoinsAdded(int coins, String productId) {
    setState(() {
      _userCoins += coins;
    });

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Purchase Successful! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64.sp),
            SizedBox(height: 16.h),
            Text(
              '+$coins Coins',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Current Balance: $_userCoins coins',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onPurchaseError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _onPurchasePending() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Purchase pending...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handlePurchase(CoinPackage package) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Purchase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.monetization_on, color: Colors.amber, size: 48.sp),
            SizedBox(height: 16.h),
            Text(
              package.displayText,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'Price: ${package.price}',
              style: TextStyle(fontSize: 18.sp, color: Colors.green),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _coinService.buyCoinPackage(package);
      if (!success) {
        _onPurchaseError('Failed to initiate purchase');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Coins'),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.amber, size: 24.sp),
                SizedBox(width: 4.w),
                Text(
                  '$_userCoins',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(_errorMessage!, style: TextStyle(fontSize: 16.sp)),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _initializePurchases,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade300, Colors.amber.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.stars, size: 64.sp, color: Colors.white),
                SizedBox(height: 12.h),
                Text(
                  'Get More Coins!',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Use coins to unlock premium features',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // Coin Packages List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _coinService.coinPackages.length,
              itemBuilder: (context, index) {
                final package = _coinService.coinPackages[index];
                return _buildCoinPackageCard(package);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinPackageCard(CoinPackage package) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: package.isBestValue ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: package.isBestValue
            ? BorderSide(color: Colors.amber, width: 2.w)
            : BorderSide.none,
      ),
      child: Stack(
        children: [
          // Best Value Badge
          if (package.isBestValue)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                  ),
                ),
                child: Text(
                  'BEST VALUE',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // Package Content
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Coin Icon
                Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.monetization_on,
                    color: Colors.amber,
                    size: 40.sp,
                  ),
                ),

                SizedBox(width: 16.w),

                // Package Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.displayText,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (package.bonusCoins != null)
                        Text(
                          'Total: ${package.totalCoins} coins',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),

                // Purchase Button
                ElevatedButton(
                  onPressed: () => _handlePurchase(package),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    package.price,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Don't dispose the service if it's used globally
    super.dispose();
  }
}


