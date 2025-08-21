import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/discover/match_controller.dart';
import 'package:maignanka_app/features/controllers/profile_details/profile_controller.dart';
import 'package:maignanka_app/features/models/profile_details_model_data.dart' show ProfileDetailsModelData;
import 'package:maignanka_app/features/views/bottom_nav_bar/controller/custom_bottom_nav_bar_controller.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final _controller = Get.find<ProfileController>();
  final _matchController = Get.find<MatchController>();
  final _pageController = PageController();
  int _currentPage = 0;

  late String userId;

  @override
  void initState() {
    super.initState();
    userId = Get.arguments['userId'] ?? '';
    _controller.profileDetailsGet(userId);
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        final data = controller.profileDetailsModelData;

        return CustomScaffold(
          paddingSide: 2.w,
          appBar: const CustomAppBar(title: 'Profile Details'),
          body: controller.isLoading
              ? const CustomLoader()
              : ListView(
            children: [
              _buildImageSlider(data.pictures),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Bio'),
                    _sectionText(data.bio),
                    _sectionTitle('Basic Info'),
                    infoRow(icon: Assets.icons.person.svg(), label: 'Name', value: data.name ?? 'N/A'),
                    infoRow(icon: Assets.icons.gender.svg(), label: 'Gender', value: data.gender ?? 'N/A'),
                    infoRow(icon: Assets.icons.height.svg(), label: 'Height', value: data.height ?? 'N/A'),
                    infoRow(icon: Assets.icons.weight.svg(), label: 'Weight', value: data.weight ?? 'N/A'),
                    infoRow(icon: Assets.icons.goal.svg(), label: 'Goal', value: data.goal ?? 'N/A'),
                    SizedBox(height: 16.h),
                    _sectionTitle('Interest'),
                    if (data.interest?.isNotEmpty == true)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: data.interest!
                            .map(
                              (interest) => Chip(
                            label: CustomText(
                              text: interest,
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                            backgroundColor: AppColors.secondaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                          ),
                        )
                            .toList(),
                      ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),



              buildMatchActionSection(data),
            ],
          ),
        );
      },
    );
  }

  Widget buildMatchActionSection(ProfileDetailsModelData data) {
    final isLoading = _matchController.isLoading;
    final padding = EdgeInsets.symmetric(horizontal: 16.w);

    switch (data.status) {
      case 'nothing':
        return Padding(
          padding: padding,
          child: isLoading
              ? const CustomLoader()
              : CustomButton(
            onPressed: () => _matchController.matchCreateDetails(userId),
            label: 'Love',
          ),
        );

      case 'liked_by_me':
        return Padding(
          padding: padding,
          child: isLoading
              ? const CustomLoader()
              : CustomButton(
            onPressed: () => _matchController.likeRewind(userId),

            label: 'Cancel',
          ),
        );

      case 'liked_by_opponent':
        return Padding(
          padding: padding,
          child: isLoading
              ? const CustomLoader()
              : CustomButton(
            height: 38.h,
            onPressed: () => _matchController.matchCreateDetails(userId,isAccept: true,imageUrl: '${ApiUrls.imageBaseUrl}${data.pictures?.first.imageURL}'),
            label: 'Accept',
          ),
        );

      case 'both':
        return Padding(
          padding: padding,
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  backgroundColor: AppColors.primaryColor.withOpacity(0.08),
                  foregroundColor: AppColors.primaryColor,
                  height: 38.h,
                  onPressed: () => Get.toNamed(AppRoutes.giftsScreen),
                  label: 'Gift',
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: isLoading
                    ? const CustomLoader()
                    : CustomButton(
                  height: 38.h,
                  onPressed: () {
                    Get.toNamed(AppRoutes.customBottomNavBar);
                    Get.find<CustomBottomNavBarController>().onChange(2);
                  },
                  label: 'Messages',
                ),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }


  Widget _buildImageSlider(List? pictures) {
    return SizedBox(
      width: double.infinity,
      height: 400.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pictures?.length ?? 0,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              debugPrint(' ===========>> ${ApiUrls.imageBaseUrl}${pictures?[index].imageURL}');
              return CustomNetworkImage(
              borderRadius: 13.r,
              imageUrl: '${ApiUrls.imageBaseUrl}${pictures?[index].imageURL}' ?? '',
            );}
          ),
          if ((pictures?.length ?? 0) > 1)
            Positioned(
              top: 10.h,
              left: 0,
              right: 0,
              child: DotsIndicator(
                position: _currentPage.toDouble(),
                dotsCount: pictures?.length ?? 0,
                decorator: DotsDecorator(
                  color: Colors.white,
                  activeColor: AppColors.primaryColor,
                  size: Size.square(5.0.r),
                  spacing: EdgeInsets.symmetric(horizontal: 4.w),
                ),
              ),
            ),
          Positioned(
            left: 10.w,
            right: 10.w,
            bottom: 10.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: '${_controller.profileDetailsModelData.name?.split(' ').first ?? ''} ${_controller.profileDetailsModelData.age ?? ''}',
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                  bottom: 6.h,
                ),
                Row(
                  children: [
                     Icon(Icons.location_on, color: Colors.white, size: 18.r),
                    Flexible(
                      child: CustomText(
                        textAlign: TextAlign.start,
                        text: '${_controller.profileDetailsModelData.address?.split(',').last ?? ''}',
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return CustomText(
      text: title,
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      top: 10.h,
      bottom: 6.h,
    );
  }

  Widget _sectionText(String? text) {
    return CustomText(
      text: text ?? '',
      fontSize: 11.sp,
      color: AppColors.appGreyColor,
      fontWeight: FontWeight.w400,
      bottom: 10.h,
    );
  }

  Widget infoRow({
    required Widget icon,
    required String label,
    required String value,
    double fontSize = 13,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          icon,
          SizedBox(width: 8.w),
          CustomText(
            text: '$label:',
            fontSize: fontSize.sp,
            color: Colors.grey.shade700,
          ),
          const Spacer(),
          CustomText(
            text: value,
            fontSize: fontSize.sp,
            color: AppColors.appGreyColor,
          ),
        ],
      ),
    );
  }
}
