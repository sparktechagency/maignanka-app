import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:maignanka_app/app/helpers/menu_show_helper.dart';
import 'package:maignanka_app/app/helpers/show_dialog_helper.dart';
import 'package:maignanka_app/app/helpers/time_format.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/conversations/block_controller.dart';
import 'package:maignanka_app/features/controllers/conversations/chat_controller.dart';
import 'package:maignanka_app/features/controllers/conversations/conversations_controller.dart';
import 'package:maignanka_app/features/controllers/conversations/socket_chat_controller.dart';
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
  final BlockController _blockController = Get.find<BlockController>();
  final SocketChatController _socketChatController = Get.find<SocketChatController>();

  late String conversationId;

  @override
  void initState() {
    conversationId = Get.arguments['conversationId'];
    _socketChatController.listenMessage(conversationId);
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
          GetBuilder<ChatController>(
            builder: (controller) {
              if (controller.chatsData.isEmpty) return SizedBox.shrink();

              var userInfo = controller.chatsData[0];

              if (userInfo.isBlocked == true) return SizedBox.shrink(); // ← FIXED

              return GestureDetector(
                onTapDown: (details) {
                  _showHeightMenu(details, MenuShowHelper.chatTopPopupOptions);
                },
                child: SizedBox(
                  width: 40.w,
                  height: 24.h,
                  child: Icon(Icons.more_vert, color: AppColors.darkColor),
                ),
              );
            },
          ),
        ],
        showBorder: true,
        titleWidget: GetBuilder<ConversationsController>(
          builder: (controller) {
            final index = controller.conversationsDataList.indexWhere(
              (e) => e.sId == conversationId,
            );
            if (index != -1) {
              var userInfo = controller.conversationsDataList[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.profileDetailsScreen,
                    arguments: {'userId': userInfo.receiverID ?? ''},
                  );
                },
                child: CustomListTile(
                  imageRadius: 14.r,
                  image: userInfo.profilePicture,
                  title: userInfo.participantName,
                  subTitle: userInfo.isActive == true ? 'online' : 'offline',
                  statusColor: userInfo.isActive == true ? Colors.green : Colors.grey,
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
                if (controller.isLoading) {
                  return CustomLoader();
                } else if (controller.chatsData.isEmpty) {
                  return const Center(child: Text("No chat available"));
                }
                return GroupedListView(
                  reverse: true,
                  controller: _scrollController,
                  elements: controller.chatsData,
                  groupBy: (message) {
                    final msgDate =
                        DateTime.tryParse(message.createdAt ?? '') ??
                        DateTime.now();
                    final now = DateTime.now();
                    final difference = now.difference(msgDate);

                    if (difference.inMinutes < 1) return 'Just now';
                    if (difference.inHours < 24 && msgDate.day == now.day)
                      return 'Today';
                    if (difference.inDays == 1 ||
                        msgDate.day ==
                            now.subtract(const Duration(days: 1)).day)
                      return 'Yesterday';

                    return TimeFormatHelper.formatDate(msgDate);
                  },
                  groupSeparatorBuilder:
                      (String group) => Padding(
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
                      isMe:
                          message.senderID ==
                          Get.find<ProfileController>().userId,
                    );
                  },
                  physics: const AlwaysScrollableScrollPhysics(),
                );
              },
            ),
          ),
          SizedBox(height: 10.h),
          GetBuilder<ChatController>(
            builder: (controller) {
              if(controller.chatsData.isEmpty) return SizedBox.shrink();
                var userInfo = controller.chatsData[0];
                final currentUserId = Get.find<ProfileController>().userId;
                if (userInfo.isBlocked == true && userInfo.isBlockedBy == currentUserId) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    child: CustomContainer(
                      width: double.infinity,
                      border: Border(top: BorderSide(color: Colors.grey.shade300)),
                      child: Center(
                        child: Column(
                          children: [
                            CustomText(
                              top: 10,
                              text: "You've blocked this user.",
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                            CustomText(
                              fontSize: 12.sp,
                              text: "You can't message or call them in this chat, and you won't receive their messages.",
                              color: Colors.grey,
                            ),
                            CustomText(
                              onTap: () {
                                ShowDialogHelper.showDeleteORSuccessDialog(
                                  context,
                                  onTap: () async {
                                    _blockController.blockUnblock(conversationId);
                                  },
                                  title: 'Unblock',
                                  message: 'Are you sure you want to unblock this user?',
                                  buttonLabel: 'Unblock',
                                );
                              },
                              top: 10,
                              text: 'Unblock',
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                else if (userInfo.isBlocked == true && userInfo.isBlockedBy != currentUserId) {
                  return CustomContainer(
                    width: double.infinity,
                    border: Border(top: BorderSide(color: Colors.grey.shade300)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      child: CustomText(
                        fontWeight: FontWeight.w600,
                        text: "You are blocked by this user.",
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                return _buildMessageSender(controller.receiverId);
              }

          ),


        ],
      ),
    );
  }

  /// Message input field and send button.
  Widget _buildMessageSender(String receiverId) {
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
            onTap: (){
          if (_messageController.text.trim().isEmpty) return;
          _socketChatController.sendMessage(_messageController.text,receiverId,conversationId);
          _messageController.clear();
          },
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
      if (selected == 'Media') {
        Get.toNamed(AppRoutes.mediaScreen,arguments: {'conversationId' : conversationId});
      } else if (selected == 'Block Profile') {
        ShowDialogHelper.showDeleteORSuccessDialog(
          context,
          onTap: () {
            _blockController.blockUnblock(conversationId);
          },
          title: 'Block',
          message: 'Are you sure you want to block this user?',
          buttonLabel: 'Block',
        );
      } else if (selected == 'Report') {
        Get.toNamed(AppRoutes.reportScreen);
      }
      setState(() {});
    }
  }


  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _chatController.loadMore(conversationId);
        print("load more true");
      }
    });
  }
}
