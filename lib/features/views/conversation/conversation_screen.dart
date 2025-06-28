import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maignanka_app/app/helpers/time_format.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/controllers/conversations/conversations_controller.dart';
import 'package:maignanka_app/features/controllers/conversations/socket_chat_controller.dart';
import 'package:maignanka_app/routes/app_routes.dart';
import 'package:maignanka_app/services/socket_services.dart';
import 'package:maignanka_app/widgets/custom_app_bar.dart';
import 'package:maignanka_app/widgets/custom_list_tile.dart';
import 'package:maignanka_app/widgets/custom_loader.dart';
import 'package:maignanka_app/widgets/custom_scaffold.dart';
import 'package:maignanka_app/widgets/custom_text.dart';
import 'package:maignanka_app/widgets/custom_text_field.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final ConversationsController _conversationsController = Get.find<ConversationsController>();
  final SocketChatController _socketChatController = Get.find<SocketChatController>();

  @override
  void initState() {
    _socketChatController.listenActive();
    _addScrollListener();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Chats',
        showLeading: false,
      ),
      body: Column(
        children: [
          GetBuilder<ConversationsController>(
            builder: (controller) {
              return CustomTextField(
                onChanged: (val) => controller.search(val),
                validator: (_) {
                  return null;
                },
                prefixIcon: const Icon(Icons.search,color: AppColors.primaryColor,),
                controller: _searchController,
                hintText: 'Search people to chat...',
                contentPaddingVertical: 0,
              );
            }
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: () async {
                await _conversationsController.conversationsGet();
              },
              child: GetBuilder<ConversationsController>(
                builder: (controller) {
                  if(controller.isLoading){
                    return CustomLoader();
                  }else if(controller.conversationsDataList.isEmpty){
                    return const Center(child: Text("No chat available"));
                  }
                  return ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: controller.conversationsDataList.length + 1,
                    itemBuilder: (context, index) {
                      if(index == controller.conversationsDataList.length) {
                        if (controller.page < controller.totalPage) {
                          return CustomLoader();
                        } else {
                          return const SizedBox.shrink();
                        }
                      }
                      var message = controller.conversationsDataList[index];
                      return Padding(
                        padding:  EdgeInsets.only(bottom: 8.0.h),
                        child: CustomListTile(
                          borderRadius: 8.r,
                          onTap: () {
                            Get.toNamed(AppRoutes.chatScreen,arguments: {'conversationId' : message.sId!});
                          },
                          image: message.profilePicture,
                          title: message.participantName,
                          activeColor: message.isActive == true ? Colors.green : Colors.grey,
                          subTitle: message.lastMessage,
                          trailing: CustomText(
                                text: TimeFormatHelper.timeFormat(DateTime.parse(message.lastActive ?? '')) ?? '',
                                color: AppColors.appGreyColor,
                                fontSize: 10.sp,
                              )
                        ),
                      );
                    },
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addScrollListener(){
    _scrollController.addListener(()  {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
         _conversationsController.loadMore();
        print("load more true");
      }
    });
  }


  @override
  void dispose() {
    SocketServices().socket.off('active-users');
    super.dispose();
  }
}
