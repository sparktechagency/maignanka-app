import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Fake data for the chat list
  List<Map<String, String>> messages = [
    {"name": "John Doe", "lastMessage": "Hello! How are you?", "image": "", "lastDate": "4:30 PM "},
    {"name": "Jane Smith", "lastMessage": "Good morning!", "image": "", "lastDate": "4:30 PM "},
    {"name": "Alice Johnson", "lastMessage": "Let's meet tomorrow.", "image": "", "lastDate": "4:30 PM "},
    {"name": "Bob Lee", "lastMessage": "Are you coming today?", "image": "", "lastDate": "4:30 PM "},
  ];



  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Chats',
        showLeading: false,
      ),
      body: Column(
        children: [
          CustomTextField(
            onChanged: (val) {
              // Handle search input change if needed
            },
            validator: (_) {
              return null;
            },
           // borderRadio: 90.r,
            prefixIcon: const Icon(Icons.search,color: AppColors.primaryColor,),
            controller: _searchController,
            hintText: 'Search people to chat...',
            contentPaddingVertical: 0,
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: () async {
                // Add refresh logic if needed
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index];
                  return Padding(
                    padding:  EdgeInsets.only(bottom: 8.0.h),
                    child: CustomListTile(
                      borderRadius: 8.r,
                      borderColor: AppColors.borderColor,
                      onTap: () {
                        Get.toNamed(AppRoutes.chatScreen);
                      },
                      selectedColor: AppColors.primaryColor.withOpacity(0.8),
                      image: message['image']!,
                      title: message['name']!,
                      activeColor: Colors.green,
                      subTitle: message['lastMessage']!,
                      trailing: CustomText(
                            text: message['lastDate'] ?? '',
                            color: AppColors.appGreyColor,
                            fontSize: 10.sp,
                          )
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
