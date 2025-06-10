import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/post/models/post_data.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_popup.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class PostCardWidget extends StatefulWidget {
  const PostCardWidget(
      {super.key,
      this.isMyPost = false,
      });

  final bool isMyPost;


  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        color: Color(0xffFFF9FC),
        radiusAll: 8.r,
        verticalMargin: 6.h,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 1),
              blurRadius: 2)
        ],
        child: Column(
          children: [
            SizedBox(height: 6.h),
            CustomListTile(
              onTap: (){},
              imageRadius: 22.r,
              image: "https://via.placeholder.com/600x400.png?text=Image+1",
              title: 'Asif',
              subTitle: 'asif@gmail.com',
              trailing: widget.isMyPost
                  ? CustomPopupMenu(
                      icon: Icons.edit_note,
                      iconColor: Colors.grey.shade600,
                      items:  [],
                      onSelected: (val){},
                    )
                  : null,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                color: AppColors.appGreyColor,
                maxline: 2,
                left: 12.w,
                bottom: 10.h,
                fontSize: 10.sp,
                textAlign: TextAlign.start,
                text: 'ArthurHazan Quel plaisir de retrouver mes étudiants de Web 2 ! Ils ont tellement progressés depuis l’année dernière ! See More...',
              ),
            ),
           //if (widget.media != null && widget.media!.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 300.h,
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
                        itemBuilder: (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(13.r),
                          child: CustomNetworkImage(
                            imageUrl: 'https://via.placeholder.com/600x400.png?text=Image%20${index}',
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: DotsIndicator(
                          position: _currentPage.toDouble(),
                          dotsCount: 3,
                          decorator: DotsDecorator(
                            color: Colors.white,
                            size: Size.square(5.0.r),
                            spacing: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 6.h), // Space between dots
                            activeColor: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            //],


            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 12.w),
              child: GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.commentScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        spacing: 4.w,
                        children: [
                          Assets.icons.like.svg(),
                          Flexible(
                            child: CustomText(
                              right: 10.w,
                              fontSize: 10.sp,
                              textAlign: TextAlign.start,
                              text: '44,389',
                            ),
                          ),
                          Assets.icons.comment.svg(),
                          Flexible(
                            child: CustomText(
                              fontSize: 10.sp,
                              textAlign: TextAlign.start,
                              text: '26,376',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Assets.icons.gift.svg(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
