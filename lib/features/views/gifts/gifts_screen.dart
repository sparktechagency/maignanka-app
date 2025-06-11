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
      body: Column(
        children: [
          SizedBox(height: 10.h),
          CustomTextField(
            onChanged: (val) {
              // Handle search input change if needed
            },
            validator: (_) {
              return null;
            },
            // borderRadio: 90.r,
            prefixIcon: const Icon(Icons.search,color: AppColors.primaryColor,),
            controller: _searchController,
            hintText: 'Search',
            contentPaddingVertical: 0,
          ),

          Expanded(
            child: GridView.builder(

              shrinkWrap: true,
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return CustomContainer(
                  radiusAll: 8.r,
                  color: Color(0xffFFF9FC),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 2)
                  ],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:  EdgeInsets.all(4.r),
                          child: CustomNetworkImage(
                            borderRadius: 6.r,
                            imageUrl: '',
                            height: 110.h,
                            width: 150.w,
                          ),
                        ),
                        CustomText(text: 'Dimond Ring'),
                        Row(
                          children: [
                            Assets.icons.coin.svg(height: 16.h),
                            CustomText(text: '100',color: AppColors.secondaryColor,fontSize: 11.sp,),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
