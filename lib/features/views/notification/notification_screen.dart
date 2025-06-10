import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:maignanka_app/app/helpers/helper_data.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_button.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';


class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: "Notifications"),
      body: GroupedListView<Map<String, dynamic>, String>(
        elements: HelperData.notifications,
        groupBy: (element) {
          final now = DateTime.now();
          final date = element['date'] as DateTime;
          if (date.day == now.day) return 'Today';
          if (date.day == now.subtract(Duration(days: 1)).day) return 'Yesterday';
          return 'Earlier';
        },
        groupSeparatorBuilder: (String group) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(group, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        itemBuilder: (context, element) => CustomListTile(
          title: element['name'],
          subTitle: element['message'],
          trailing: element['type'] == 'request'
              ? CustomButton(
            width: 88.w,
                          height: 22.h,
                          onPressed: () {},
            fontSize: 14.sp,
                          label: "Accept",
                        )
              : null,
        ),
        order: GroupedListOrder.ASC,
      ),
    );
  }
}
