import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/time_format.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/comment/comment_controller.dart';
import 'package:maignanka_app/features/controllers/profile_details/profile_controller.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_image_avatar.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {


  final CommentController _commentController = Get.find<CommentController>();
  final ScrollController _scrollController = ScrollController();

  late String postId;

  @override
  void initState() {
    postId = Get.arguments['postId'];
    _commentController.commentGet(postId,isInitialLoad: true);
    _addScrollListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Comments'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async{
                  _commentController.commentGet(postId,isInitialLoad: true);
                },
                child: GetBuilder<CommentController>(
                  builder: (controller) {
                    if(controller.isLoading){
                      return CustomLoader();
                    }else if(controller.commentData.isEmpty){
                      Center(child: CustomText(text: 'No Comment found.'),);
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: controller.commentData.length,
                      itemBuilder: (context, index) {

                        final data = controller.commentData[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomListTile(
                                image: data.userID?.profilePicture ?? '',
                                title: data.userID?.name ?? '',
                                subTitle: TimeFormatHelper.getTimeAgo(DateTime.parse(data.createdAt ?? '')),
                              ),
                              CustomText(
                                left: 60.w,
                                fontSize: 12.sp,
                                textAlign: TextAlign.start,
                                color: AppColors.darkColor,
                                text: data.comment ?? '',
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                  fontSize: 9.sp,
                                  textAlign: TextAlign.start,
                                  color: AppColors.appGreyColor,
                                  text: TimeFormatHelper.getTimeAgo(DateTime.parse(data.createdAt ?? ''))
                                ),
                              ),
                              SizedBox(height: 12.h),
                            ],
                          ),
                        );
                      },
                    );
                  }
                ),
              ),
            ),

            _buildCommentSender(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSender() {
    return CustomContainer(
      color: Color(0xffFFF9FC),
      paddingTop: 30.h,
      paddingBottom: 20.h,
      topLeftRadius: 20.r,
      topRightRadius: 20.r,
      border: Border(top: BorderSide(color: AppColors.primaryColor)),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            CustomImageAvatar(radius: 18.r, right: 8.w,image: Get.find<ProfileController>().userImage,),
            Expanded(
              child: CustomTextField(
                validator: (_) {
                  return null;
                },
                controller: _commentController.commentController,
                hintText: 'Your comment...',
              ),
            ),
            SizedBox(width: 10.w),
            GetBuilder<CommentController>(
              builder: (controller) {
                return controller.isLoadingCreate ? CustomLoader() : GestureDetector(
                  onTap: () {
                    if(controller.commentController.text.isEmpty) return;
                    controller.createComment(postId);
                  } ,
                  child: CustomText(
                    text: 'Post',
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
  void _addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _commentController.loadMore(postId);
        print("load more true");
      }
    });
  }

}
