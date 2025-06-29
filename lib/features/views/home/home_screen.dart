import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/features/controllers/post/post_controller.dart';
import 'package:maignanka_app/features/views/post_create/widgets/post_card_widget.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
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


  final PostController _postController = Get.find<PostController>();
  final ScrollController _scrollController = ScrollController();

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

        Expanded(
            child: RefreshIndicator(
              onRefresh: () async{
                _postController.postGet(isInitialLoad: true);
              },
              child: GetBuilder<PostController>(
                        builder: (controller) {
              if(controller.isLoading){
                return CustomLoader();
              }else if(controller.postData.isEmpty){
                return CustomText(text: 'No posts found.');
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: controller.postData.length,
                  itemBuilder: (context,index){
                return PostCardWidget(
                  isMyPost: controller.selectedValueType == 'my' ? true : false, postData: controller.postData[index],
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



