import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:maignanka_app/app/helpers/helper_data.dart';
import 'package:maignanka_app/app/helpers/menu_show_helper.dart';
import 'package:maignanka_app/app/helpers/time_format.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/conversations/chat_controller.dart';
import 'package:maignanka_app/features/controllers/conversations/conversations_controller.dart';
import 'package:maignanka_app/features/controllers/profile_details/profile_controller.dart';
import 'package:maignanka_app/features/views/conversation/widgets/chat_card.dart';
import 'package:maignanka_app/global/custom_assets/assets.gen.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final ChatController _chatController = Get.find<ChatController>();


  late String conversationId;

  @override
  void initState() {
    conversationId = Get.arguments['conversationId'];
    _chatController.ChatGet(conversationId, isInitialLoad: true);
    _addScrollListener();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 0,
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
        titleWidget: GetBuilder<ConversationsController>(
          builder: (controller) {
            final index = controller.conversationsDataList.indexWhere((e) => e.sId == conversationId);
            if (index != -1) {
              var userInfo = controller.conversationsDataList[index];
              return GestureDetector(
                onTap: () {},
                child: CustomListTile(
                  imageRadius: 14.r,
                  image: userInfo.profilePicture,
                  title: userInfo.participantName,
                  subTitle: 'online',
                  statusColor: Colors.green,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8.h),
          Expanded(
            child: GetBuilder<ChatController>(
              builder: (controller) {
                if(controller.isLoading){
                  return CustomLoader();
                }else if(controller.chatsData.isEmpty){
                  return const Center(child: Text("No chat available"));
                }
                return GroupedListView(
                  reverse: true,
                  controller: _scrollController,
                  elements: controller.chatsData,
                  groupBy: (message) {
                    final msgDate = DateTime.tryParse(message.createdAt ?? '') ?? DateTime.now();
                    final now = DateTime.now();
                    final difference = now.difference(msgDate);

                    if (difference.inMinutes < 1) return 'Just now';
                    if (difference.inMinutes < 60) return '${difference.inMinutes} minutes ago';
                    if (difference.inHours < 24 && msgDate.day == now.day) return 'Today';
                    if (difference.inDays == 1 || msgDate.day == now.subtract(const Duration(days: 1)).day) return 'Yesterday';

                    return TimeFormatHelper.formatDate(msgDate);
                  },
                  groupSeparatorBuilder: (String group) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Center(
                      child: CustomText(
                        text: group,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ),
                  itemBuilder: (context, message) {
                    return ChatBubbleMessage(
                      images: message.file ?? [],
                      isSeen: message.seenBy!.length > 1,
                      time: '',
                      text: message.content ?? '',
                      isMe: message.senderID == Get.find<ProfileController>().userId,
                    );
                  },
                  physics: const AlwaysScrollableScrollPhysics(),
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

  /// Message input field and send button.
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


  void _addScrollListener(){
    _scrollController.addListener(()  {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _chatController.loadMore(conversationId);
        print("load more true");
      }
    });
  }

}
