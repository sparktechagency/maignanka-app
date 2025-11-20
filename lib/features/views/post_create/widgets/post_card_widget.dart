import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:maignanka_app/app/helpers/time_format.dart';
import 'package:maignanka_app/app/helpers/toast_message_helper.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/post/post_controller.dart';
import 'package:maignanka_app/features/models/post_model_data.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_delete_or_success_dialog.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_popup.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

/// Step 1: Define the Enum


class PostCardWidget extends StatefulWidget {
  const PostCardWidget({
    super.key,
    this.isMyPost = false,
    required this.postData,
    this.isSocialAction, this.onSelected,
  });

  final bool isMyPost;
  final PostModelData postData;
  final Function(String)? onSelected;

  /// Step 2: Use function with Enum
  final VoidCallback? isSocialAction;

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {

  final PageController _pageController = PageController();
  int _currentPage = 0;


  @override
  Widget build(BuildContext context) {
    final data = widget.postData;

    return CustomContainer(
      color: const Color(0xffFFF9FC),
      radiusAll: 8.r,
      verticalMargin: 6.h,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(0, 1),
          blurRadius: 2,
        ),
      ],
      child: Column(
        children: [
          SizedBox(height: 6.h),
          CustomListTile(
            onTap: () {
              widget.isSocialAction?.call();
              if (widget.isSocialAction == null) {
                Get.toNamed(
                  AppRoutes.profileDetailsScreen,
                  arguments: {'userId': data.userInfo?.sId ?? ''},
                );
              }
            },
            image: data.userInfo?.profilePicture ?? '',
            title: data.userInfo?.name ?? '',
            subTitle: TimeFormatHelper.getTimeAgo(DateTime.parse(data.createdAt ?? '')),
            trailing: widget.isMyPost
                ? CustomPopupMenu(
              icon: Icons.edit_note,
              iconColor: Colors.grey.shade600,
              items: ['Edit Post', 'Delete Post'],
              onSelected: widget.onSelected,
            )
                : null,
          ),

          /// Caption
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              color: AppColors.appGreyColor,
              maxline: 2,
              left: 12.w,
              bottom: 10.h,
              //fontSize: 16.sp,
              textAlign: TextAlign.start,
              text: data.caption ?? '',
            ),
          ),

          /// Image Gallery
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: SizedBox(
              width: double.infinity,
              height: 300.h,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: data.images?.length ?? 0,
                    onPageChanged: (index){
                      _currentPage = index;
                      setState(() {

                      });
                    },
                    itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(13.r),
                      child: CustomNetworkImage(
                        imageUrl:
                        '${ApiUrls.imageBaseUrl}${data.images?[index].url ?? ''}',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: DotsIndicator(
                      position: _currentPage.toDouble(),
                      dotsCount: data.images?.length ?? 0,
                      decorator: DotsDecorator(
                        color: Colors.white,
                        size: Size.square(5.0.r),
                        spacing: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 6.h,
                        ),
                        activeColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Social Actions (Like, Comment, Gift)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Like + Comment
                Expanded(
                  child: Row(
                    children: [
                      GetBuilder<PostController>(
                        builder: (controller) {
                          final isLiked = controller.isLiked(widget.postData.sId!);

                          return LikeButton(
                            size: 20.r,
                            isLiked: isLiked,
                            onTap: (bool currentLiked) async {
                              return await controller.likeButtonAction(currentLiked, widget.postData.sId!);
                            },
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                isLiked || widget.postData.isLiked == true ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                                color: isLiked || widget.postData.isLiked == true ? AppColors.primaryColor : AppColors.appGreyColor,
                                size: 18.r,
                              );
                            },
                          );
                        },
                      ),                      SizedBox(width: 6.w),
                      GetBuilder<PostController>(
                          builder: (controller) {
                            return CustomText(
                              right: 10.w,
                              fontSize: 10.sp,
                              textAlign: TextAlign.start,
                              text: controller.isLikeLoading(widget.postData.sId ?? '')
                                  ? '...'
                                  : data.likesCount.toString(),
                            );
                          }
                      ),

                      /// Comment Icon
                      GestureDetector(
                        onTap: () {
                          widget.isSocialAction?.call();
                          if (widget.isSocialAction == null) {
                            Get.toNamed(
                              AppRoutes.commentScreen,
                              arguments: {'postId': data.sId ?? ''},
                            );
                          }
                        },
                        child: Assets.icons.comment.svg(),
                      ),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: () {
                          widget.isSocialAction?.call();
                          if (widget.isSocialAction == null) {
                            Get.toNamed(
                              AppRoutes.commentScreen,
                              arguments: {'postId': data.sId ?? ''},
                            );
                          }
                        },
                        child: CustomText(
                          fontSize: 10.sp,
                          textAlign: TextAlign.start,
                          text: data.commentsCount.toString(),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Gift
                GestureDetector(
                  onTap: () {
                    widget.isSocialAction?.call();
                    if (widget.isSocialAction == null) {
                      Get.toNamed(AppRoutes.giftsScreen,arguments: {'userId' : data.userID!});
                    }
                  },
                  child: Assets.icons.gift.svg(),
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
    _pageController.dispose();
    super.dispose();
  }
}
