import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/post/post_controller.dart';
import 'package:maignanka_app/features/models/post_model_data.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_network_image.dart';
import 'package:maignanka_app/widgets/custom_popup.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class PostCardWidget extends StatefulWidget {
  const PostCardWidget({super.key, this.isMyPost = false, required this.postData});

  final bool isMyPost;
  final PostModelData postData;

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {

  @override
  Widget build(BuildContext context) {

    final data = widget.postData;
    return CustomContainer(
      color: Color(0xffFFF9FC),
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
              Get.toNamed(
                AppRoutes.profileDetailsScreen,
                arguments: {'userId': data.userInfo?.sId ?? ''},
              );            },
            image: data.userInfo?.profilePicture ?? '',
            title: data.userInfo?.name ?? '',
            subTitle: data.userInfo?.email ?? '',
            trailing:
                widget.isMyPost
                    ? CustomPopupMenu(
                      icon: Icons.edit_note,
                      iconColor: Colors.grey.shade600,
                      items: ['Edit Post','Delete Post'],
                      onSelected: (val) {},
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
              text: data.caption ?? '',
            ),
          ),
          //if (widget.media != null && widget.media!.isNotEmpty) ...[
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: SizedBox(
              width: double.infinity,
              height: 300.h,
              child: Stack(
                children: [
                  GetBuilder<PostController>(
                    builder: (controller) {
                      return PageView.builder(
                        controller: controller.pageController,
                        itemCount: data.images?.length ?? 0,
                        onPageChanged: (index) => controller.onChangePage(index),
                        itemBuilder:
                            (context, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(13.r),
                              child: CustomNetworkImage(
                                imageUrl: '${ApiUrls.imageBaseUrl}${data.images?[index].url ?? ''}',
                              ),
                            ),
                      );
                    }
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GetBuilder<PostController>(
                      builder: (controller) {
                        return DotsIndicator(
                          position: controller.currentPage.toDouble(),
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
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),

          //],
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    spacing: 4.w,
                    children: [
                      GetBuilder<PostController>(
                        builder: (controller) {
                          return LikeButton(
                            size: 20.r,
                            isLiked: controller.isLike,
                            onTap: (bool isLiked) => controller.likeButtonAction(isLiked),
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                isLiked
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_alt_outlined,
                                color:
                                    isLiked
                                        ? AppColors.primaryColor
                                        : AppColors.appGreyColor,
                                size: 18.r,
                              );
                            },
                          );
                        }
                      ),
                      Flexible(
                        child: CustomText(
                          right: 10.w,
                          fontSize: 10.sp,
                          textAlign: TextAlign.start,
                          text: data.likesCount.toString(),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.commentScreen,arguments: {'postId' : data.sId ?? ''});
                        },
                        child: Assets.icons.comment.svg(),
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.commentScreen);
                          },
                          child: CustomText(
                            fontSize: 10.sp,
                            textAlign: TextAlign.start,
                            text: data.commentsCount.toString(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.giftsScreen);
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
}
