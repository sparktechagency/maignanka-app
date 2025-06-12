import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class GiftsScreen extends StatefulWidget {
  const GiftsScreen({super.key});

  @override
  State<GiftsScreen> createState() => _GiftsScreenState();
}

class _GiftsScreenState extends State<GiftsScreen> {

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Gifts',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          children: [
            CustomTextField(
              onChanged: (val) {},
              validator: (_) => null,
              prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
              controller: _searchController,
              hintText: 'Search',
              contentPaddingVertical: 0,
            ),
            SizedBox(height: 10.h),
            // ✅ Wrap GridView in Expanded to take remaining space safely
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(bottom: 16.h),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return CustomContainer(
                    radiusAll: 8.r,
                    color: const Color(0xffFFF9FC),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4.r),
                          child: CustomNetworkImage(
                            borderRadius: 6.r,
                            imageUrl: '',
                            height: 110.h,
                            width: 150.w,
                          ),
                        ),
                        CustomText(text: 'Dimond Ring'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.coin.svg(height: 16.h),
                            SizedBox(width: 4.w),
                            CustomText(
                              text: '100',
                              color: AppColors.secondaryColor,
                              fontSize: 11.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
