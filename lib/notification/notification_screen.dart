import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/time_format.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/notification/controller/notification_controller.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController _controller = Get.put(NotificationController());

  @override
  void initState() {
    _controller.getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Notification',
      ),
      body: Obx(() {
        if (_controller.isNotiLoading.value) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) => buildSimpleShimmer(),
          );
        }

        return ListView.builder(
          itemCount: _controller.notificationData.length,
          itemBuilder: (context, index) {
            if (_controller.notificationData.isEmpty) {
              return buildEmptyNotification();
            }
            return buildNotificationCard(index);
          },
        );
      }),
    );
  }

  Widget buildNotificationCard(int index) {
    return CustomContainer(
      border: Border(
          bottom: BorderSide(
              color: _controller.notificationData[index].isReadable == true
                  ? Colors.transparent
                  : AppColors.primaryColor)),
      radiusAll: 8.r,
      marginAll: 6.r,
      paddingAll: 10.r,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notifications_active_outlined,
            color: AppColors.primaryColor,
            size: 28.r,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Notification',
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                    if (_controller.notificationData[index].isReadable == false)
                      CustomContainer(
                          verticalMargin: 4,
                          radiusAll: 8.r,
                          color: Colors.amber,
                          child: CustomText(
                            text: 'new',
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                            color: Colors.black,
                          )),
                  ],
                ),
                CustomText(
                  maxline: 5,
                  textAlign: TextAlign.start,
                  text: _controller.notificationData[index].msg ?? '',
                  fontSize: 10.sp,
                ),
                CustomText(
                  top: 6,
                  maxline: 5,
                  textAlign: TextAlign.start,
                  text: TimeFormatHelper.formatDate(DateTime.parse(
                      _controller.notificationData[index].createdAt ?? '')),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyNotification() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/noti_emt.png',
            height: 220.h,
            width: 220.w,
          ),
          CustomText(
            top: 16.h,
            maxline: 2,
            text: 'There Are No Notifications Available',
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
          ),
          CustomText(
            top: 16.h,
            maxline: 4,
            text:
                'No notifications available at the moment, once it’s available, it will appear here.',
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }



  Widget buildSimpleShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            // Profile Circle
            Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),

            // Comment Box
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12.h,
                  width: 100.w,
                  color: Colors.white,
                ),
                SizedBox(height: 6.h),
                Container(
                  height: 10.h,
                  width: 180.w,
                  color: Colors.white,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
