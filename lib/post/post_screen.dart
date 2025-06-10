/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:shimmer/shimmer.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key, required this.id});

  final String id;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {





  final _types = [
    {'label': 'All Post', 'value': 'all'},
    {'label': 'My Post', 'value': 'my'},
  ];


  @override
  void initState() {
    super.initState();

    _addScrollListener();
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomGlobalAppBar(
        title: 'Post',
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: const Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        spacing: 16.h,
        children: [


          Obx(() {
            return TwoButtonWidget(
              fontSize: 18.sp,
              buttons: _types,
              selectedValue: _controller.type.value,
              onTap: _controller.onChangeType,
            );
          }),


          Expanded(
            child: Obx(
                  () {
                return RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                  },
                  child: _controller.isLoading.value
                      ? ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return _buildShimmer(height: 300.h);
                    },
                  )
                      : _controller.postDataList.isEmpty
                      ? Center(child: CustomText(text: 'No posts available'))
                      : ListView.builder(
                    controller: _controller.scrollController,
                    itemCount: _controller.postDataList.length + 1,
                    itemBuilder: (context, index) {
                      if(index < _controller.postDataList.length){

                        final postData = _controller.postDataList[index];
                        return PostCardWidget(
                          profileViewAction: (){
                            if(Get.find<HomeController>().userId.value == postData.user!.sId!){
                              context.pushNamed(AppRoutes.customBottomNavBar);
                              Get.find<CustomBottomNavBarController>().onChange(3);
                            }else{
                              context.pushNamed(AppRoutes.otherProfileScreen,extra: {
                                'id' : postData.user!.sId!,
                              });
                            }
                          },
                          profileImage: postData.user?.image ?? '',
                          profileName: postData.user?.name ?? '',
                          description: postData.description ?? '',
                          media: postData.media ?? [],
                          time: TimeFormatHelper.getTimeAgo(
                            DateTime.parse(postData.createdAt ?? ''),
                          ),
                          comments: postData.totalComments.toString(),
                          onCommentsView: () {
                            showModalBottomSheet(
                              isScrollControlled: true, // <-- Important!
                              context: context,
                              builder: (context) {
                                return  CommentBottomSheet(id: postData.sId!, menuItems: [
                                  'newest comments',
                                  'all coments',
                                ],);
                              },
                            );
                          },
                          isMyPost: postData.user!.sId! == Get.find<HomeController>().userId.value,

                          menuItems: ['Edit', 'Delete',],
                          onSelected: (val) {
                            if (val == 'Delete') {
                              showDeleteORSuccessDialog(context, onTap: () {
                                context.pop();
                                _editPostController.deletePost(context,postData.sId!,widget.id);
                              });
                            } else if (val == 'Edit') {
                              context.pushNamed(AppRoutes.editPostScreen,extra: {
                                'media' : postData.media ?? [],
                                'des' : postData.description ?? '',
                                'postId' : postData.sId ?? '',
                                'communityId' : widget.id ?? '',
                              });
                            }
                          },

                        );

                      }else{
                        return index < _controller.totalPage ? CustomLoader() : SizedBox.shrink();
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildShimmer({required double height}) {
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        period: const Duration(milliseconds: 800),
        child: CustomContainer(
          radiusAll: 8.r,
          height: height,
          width: double.infinity,
          color: Colors.white,
        ),
      ),
    );
  }


  void _addScrollListener() {
    _controller.scrollController.addListener(() {
      if (_controller.scrollController.position.pixels ==
          _controller.scrollController.position.maxScrollExtent) {
        _controller.loadMore();
        print("load more true");
      }
    });
  }


}
*/
