import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/balance/balance_controller.dart';
import 'package:maignanka_app/features/controllers/discover/discover_controller.dart';
import 'package:maignanka_app/features/controllers/gifts/gifts_controller.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class GiftsMemberScreen extends StatefulWidget {
  const GiftsMemberScreen({super.key});

  @override
  State<GiftsMemberScreen> createState() => _GiftsMemberScreenState();
}

class _GiftsMemberScreenState extends State<GiftsMemberScreen> {
  final DiscoverController _discoverController = Get.find<DiscoverController>();
  final BalanceController _balanceController = Get.find<BalanceController>();
  final GiftsController _giftsController = Get.find<GiftsController>();

  late String giftId;

  @override
  void initState() {
    giftId = Get.arguments['giftId'] ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _discoverController.swipeProfileGet();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Send Gifts',),
      body: GetBuilder<DiscoverController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const CustomLoader();
          }

          if (controller.swipeDataList.isEmpty) {
            return Center(
              child: CustomText(text: 'No profiles found.'),
            );
          }
          return ListView.builder(
            itemCount: controller.swipeDataList.length,
            itemBuilder: (context, index) {
              final data = controller.swipeDataList[index];

              return CustomListTile(
                image: data.pictures?.first.imageURL ?? '',
                title: data.name,
                trailing: GetBuilder<GiftsController>(
                  builder: (controller) {
                    return controller.isLoading ? CustomLoader() : CustomButton(
                      fontSize: 13.sp,
                      width: 80.w,
                      height: 24.h,
                      onPressed: () async {
                        final success = await _balanceController.balanceVersionGet(data.userId ?? '');
                        if (success) {
                          final versionData = _balanceController.balanceVersionModelData;
                          final senderVersion = versionData.firstWhereOrNull((e) => e.isSender == true)?.version ?? 0;
                          final receiverVersion = versionData.firstWhereOrNull((e) => e.isSender == false)?.version ?? 0;

                          _giftsController.sendGifts(
                            data.userId ?? '',
                            giftId,
                            senderVersion,
                            receiverVersion,
                          );
                        }
                      },
                      label: 'Send',
                    );
                  }
                ),
              );
            },
          );
        }
      ),
    );
  }
}
