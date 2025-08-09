import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/post/post_controller.dart';
import 'package:maignanka_app/features/views/post_create/widgets/post_card_widget.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_dialog.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/two_button_widget.dart';

class JoinGuestScreen extends StatefulWidget {
  const JoinGuestScreen({super.key});

  @override
  State<JoinGuestScreen> createState() => _JoinGuestScreenState();
}

class _JoinGuestScreenState extends State<JoinGuestScreen> {







  final PostController _postController = Get.find<PostController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _postController.postSocialGet(isInitialLoad: true);
    _addScrollListener();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 10.w,
      appBar: CustomAppBar(
        title: 'Social',
      ),

      body: RefreshIndicator(
        onRefresh: () async{
          _postController.postSocialGet(isInitialLoad: true);
        },
        child: GetBuilder<PostController>(
            builder: (controller) {
              if(controller.isLoadingSocial){
                return CustomLoader();
              }else if(controller.socialPostData.isEmpty){
                return Center(child: CustomText(text: 'No posts found.'));
              }
              return ListView.builder(
                  controller: _scrollController,
                  itemCount: controller.socialPostData.length,
                  itemBuilder: (context,index){
                    return PostCardWidget(
                        postData: controller.socialPostData[index],isSocialAction: () => showLoginBottomSheet(context,
                    )
                    );
                  });
            }
        ),
      ),
    );
  }

  void showLoginBottomSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(onPressed: (){
                    Get.back();
                  }, icon: Icon(Icons.highlight_remove_outlined)),
                ),
                CustomText(
                  text: 'Please Login',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                 SizedBox(height: 20.h),
                CustomText(text: 'You must be logged in to continue'),
                 SizedBox(height: 20.h),
                CustomButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  label: 'Login',
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _postController.loadMore();
        print("load more true");
      }
    });
  }
}



