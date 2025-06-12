import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/helper_data.dart';
import 'package:maignanka_app/app/helpers/menu_show_helper.dart';
import 'package:maignanka_app/app/helpers/time_format.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/views/message/widgets/chat_card.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        actions: [
          GestureDetector(
            onTapDown: (details) {
              _showHeightMenu(details, MenuShowHelper.chatTopPopupOptions,);
            },
            child: SizedBox(
              width: 40.w,
              height: 24.h,
              child: Icon(Icons.more_vert, color: AppColors.darkColor),
            ),
          ),
        ],
        showBorder: true,
        titleWidget: GestureDetector(
          onTap: () {},
          child: CustomListTile(
            imageRadius: 14.r,
            image: '',
            title: 'Jenni Miranda',
            subTitle: 'online',
            statusColor: Colors.green,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8.h),
          Expanded(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              reverse: true,
              itemCount: HelperData.messages.length,
              itemBuilder: (context, index) {
                var message = HelperData.messages[index];
                return ChatBubbleMessage(
                  status: message['status'] ?? '',
                  isSeen: message['status'] == 'seen',
                  time: TimeFormatHelper.timeFormat(message['time']),
                  text: message['text'] ?? '',
                  isMe: message['isMe'],
                  deleteText: () {},
                );
              },
            ),
          ),
          SizedBox(height: 10.h),
          _buildMessageSender(),
        ],
      ),
    );
  }

  // Message input field and send button
  Widget _buildMessageSender() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              validator: (_) {
                return null;
              },
              controller: _messageController,
              hintText: 'Type message...',
            ),
          ),
          SizedBox(width: 10.w),
          CustomContainer(
            onTap: _sendMessage,
            paddingVertical: 12.r,
            paddingHorizontal: 12.r,
            shape: BoxShape.circle,
            color: AppColors.primaryColor,
            child: Assets.icons.massegeSend.svg(),
          ),
        ],
      ),
    );
  }

  void _showHeightMenu(TapDownDetails details, List<String> options) async {
    final selected = await MenuShowHelper.showCustomMenu(
      context: context,
      details: details,
      options: options,
    );
    if (selected != null) {
      if(selected == 'View Profile'){

      }else if(selected == 'Media'){
        Get.toNamed(AppRoutes.mediaScreen);

      }else if(selected == 'Block Profile'){

      }else if(selected == 'Report'){
        Get.toNamed(AppRoutes.reportScreen);
      }
      setState(() {});
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      HelperData.messages.insert(0, {
        'text': _messageController.text.trim(),
        'isMe': true,
        'time': DateTime.now(),
        'status': 'delivered',
      });
    });
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
