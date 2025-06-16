import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maignanka_app/app/helpers/helper_data.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {


  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 2.w,
      appBar: CustomAppBar(
        title: 'Profile Details',
      ),

      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: 400.h,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: 3,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder:
                      (context, index) => CustomNetworkImage(
                        borderRadius: 13.r,
                        imageUrl:
                        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=800&q=80',
                      ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: DotsIndicator(
                    position: _currentPage.toDouble(),
                    dotsCount: 3,
                    decorator: DotsDecorator(
                      color: Colors.white,
                      size: Size.square(5.0.r),
                      spacing: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 6.h,
                      ),
                      // Space between dots
                      activeColor: AppColors.primaryColor,
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
                        text:  'Alisha 21',
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white),
                          Flexible(
                            child: CustomText(
                              text:' 40 Km',
                              color: Colors.white,
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
          ),





          /// details sections


          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: 'Bio',            textAlign: TextAlign.start,top: 10.h,),


                CustomText(
                  color: AppColors.appGreyColor,
                  textAlign: TextAlign.start,
                  text: 'I am a skilled UI/UX designer specializing in creating user-friendly and visually appealing apps and websites. With experience working on various projects, including dating apps and helpline platforms, I bring creativity and functionality together to deliver exceptional designs tailored to client needs.',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  bottom: 10.h,
                ),


                CustomText(text: 'Basic Info',            textAlign: TextAlign.start,bottom: 10.h,
                ),



                infoRow(
                  icon: Assets.icons.person.svg(height: 16.h,width: 16.w),
                  label: 'Name',
                  value: 'Janet Haniya',
                ),
                SizedBox(height: 12.h),
                infoRow(
                  icon: Assets.icons.gender.svg(height: 16.h,width: 16.w),
                  label: 'Gender',
                  value: 'Female',
                ),

                SizedBox(height: 12.h),
                infoRow(
                  icon: Assets.icons.height.svg(height: 16.h,width: 16.w),
                  label: 'Height',
                  value: '5\'7"',
                ),
                SizedBox(height: 12.h),

                infoRow(
                  icon: Assets.icons.weight.svg(height: 16.h,width: 16.w),
                  label: 'Weight',
                  value: '57 kg',
                ),
                SizedBox(height: 12.h),

                infoRow(
                  icon: Assets.icons.goal.svg(height: 16.h,width: 16.w),
                  label: 'Goal',
                  value: 'Here to chat and vibe',
                ),
                SizedBox(height: 12.h),




                CustomText(text: 'Interest',            textAlign: TextAlign.start,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                  HelperData.interests.map((interest) {
                    return GestureDetector(
                      child: Chip(
                        label: CustomText(
                          text: interest,
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                        backgroundColor: AppColors.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

        ],
      ),
    );
  }


  Widget infoRow({
    required Widget icon,
    required String label,
    required String value,
    double fontSize = 13,
  }) {
    return Row(
      children: [
        icon,
        SizedBox(width: 8.w),
        CustomText(text: '$label:', fontSize: fontSize.sp,color: Colors.grey.shade700,),
        Spacer(),
        CustomText(text: value, fontSize: fontSize.sp,color: AppColors.appGreyColor,),
      ],
    );
  }

}
