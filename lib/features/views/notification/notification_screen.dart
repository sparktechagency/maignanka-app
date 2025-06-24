import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:maignanka_app/features/controllers/notification/notification_controller.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';


class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  final NotificationController _notificationController = Get.find<NotificationController>();


  @override
  void initState() {
    _notificationController.notification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: "Notifications"),
      body: GetBuilder<NotificationController>(
        builder: (controller) {
          if(controller.isLoading){
            return CustomLoader();
          }else if(controller.notificationDataList.isEmpty){
            return Center(
              child: CustomText(text: 'No Notification found.'),
            );}

          return GroupedListView(
            elements: controller.notificationDataList,
            groupBy: (element) {
              final now = DateTime.now();
              final date = DateTime.parse(element.createdAt ?? '');
              if (date.day == now.day) return 'Today';
              if (date.day == now.subtract(Duration(days: 1)).day) return 'Yesterday';
              return 'Earlier';
            },
            groupSeparatorBuilder: (String group) => CustomText(
              textAlign: TextAlign.start,
                text: group, fontWeight: FontWeight.bold),
            itemBuilder: (context, element) => CustomListTile(
              onTap: (){
                Get.toNamed(AppRoutes.profileDetailsScreen,arguments: {'userId' : element.notificationFrom?.sId?? ''});
              },
              title: element.notificationFrom?.name ?? '',
              image: element.notificationFrom?.profilePicture ?? '',
              subTitle: element.message ?? '',
            ),
            order: GroupedListOrder.ASC,
          );
        }
      ),
    );
  }
}
