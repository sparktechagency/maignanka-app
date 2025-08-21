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
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';
import 'package:maignanka_app/widgets/two_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {




  final _postTypes = [
    {'label': 'All Post', 'value': 'all'},
    {'label': 'My Post', 'value': 'my'},
  ];


  final PostController  _postController = Get.find<PostController>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _addScrollListener();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 10.w,
      appBar: CustomAppBar(
        centerTitle: false,
        titleWidget: Padding(
          padding:  EdgeInsets.only(left: 8.0.w),
          child: Assets.icons.logoSvg.svg(height: 48,width: 47),
        ),
        actions: [
          IconButton(onPressed: (){
            Get.toNamed(AppRoutes.postCreateScreen);
          }, icon: Assets.icons.postUpload.svg()),
          Padding(
            padding:  EdgeInsets.only(right: 8.0.w),
            child: IconButton(onPressed: (){
              Get.toNamed(AppRoutes.notificationScreen);

            }, icon: badges.Badge(
              position: badges.BadgePosition.topEnd(top: -6, end: -2),
              showBadge: false,
              badgeContent: CustomText(
                text: '12',
                color: Colors.black,
                fontSize: 4.sp,
              ),
              child: Assets.icons.notification.svg(),
    )),
          ),
        ],
      ),

      body: Column(children: [

        SizedBox(height: 8.h),

        GetBuilder<PostController>(
          builder: (controller) {
            return TwoButtonWidget(buttons: _postTypes,
              selectedValue: controller.selectedValueType,
              onTap: (String  value) => controller.onChangeType(value),
            );
          }
        ),

        SizedBox(height: 8.h),


        CustomTextField(
          readOnly: true,
                onTap: (){
            showModalBottomSheet(
              useSafeArea: true,
             // useRootNavigator: true,
              isScrollControlled: true,
                context: context, builder: (context) => Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.w),
                  child: GetBuilder<PostController>(
                      builder: (controller) {
                      return Column(
                        children: [
                          SizedBox(height: 24.h),
                          CustomTextField( onChanged: (val) {},
                              validator: (_) {
                                return null;
                              },
                              suffixIcon:  IconButton(onPressed: (){
                                controller.postSearchGet(_searchController.text.trim());
                              }, icon: Icon(controller.isLoadingSearch ? Icons.wifi_protected_setup_rounded : Icons.search,color: AppColors.primaryColor,)) ,
                              hintText: 'Search people to chat...',
                              contentPaddingVertical: 0,
                              controller: _searchController),
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.searchPostData.length,
                              itemBuilder: (context, index) => CustomListTile(
                                onTap: (){
                                  Get.toNamed(AppRoutes.profileDetailsScreen,arguments: {'userId' : controller.searchPostData[index].sId ?? ''});
                                },
                                image: controller.searchPostData[index].profilePicture ?? '',
                                title: controller.searchPostData[index].name ?? '',
                              ),),
                          ),
                        ],
                      );
                    }
                  ),
                )
            );
                },
                onChanged: (val) {},
                validator: (_) {
                  return null;
                },
                prefixIcon: const Icon(Icons.search,color: AppColors.primaryColor,),
                controller: _searchController,
                hintText: 'Search people to chat...',
                contentPaddingVertical: 0,
              ),


        SizedBox(height: 8.h),

        Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _postController.onRefresh(),
              child: GetBuilder<PostController>(
                        builder: (controller) {
              if(controller.isLoading){
                return CustomLoader();
              }else if(controller.postData.isEmpty){
                return Center(child: CustomText(text: 'No posts found.'));
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: controller.postData.length,
                  itemBuilder: (context,index){
                return PostCardWidget(
                 isMyPost: controller.selectedValueType == 'my' ? true : false,
                  postData: controller.postData[index],
                );
              });
                        }
                      ),
            )),
      ],
      ),
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



