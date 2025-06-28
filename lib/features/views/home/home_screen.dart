import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/post/widgets/post_card_widget.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
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


  String selectedValueType = 'all';



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
        TwoButtonWidget(buttons: _postTypes,
          selectedValue: selectedValueType,
          onTap: (String  value) {
          selectedValueType = value;
          setState(() {
          });
          },),

        SizedBox(height: 8.h),

        Expanded(child: ListView.builder(
          itemCount: 3,
            itemBuilder: (context,index){
          return PostCardWidget(

          );
        })),
      ],
      ),
    );
  }
}



