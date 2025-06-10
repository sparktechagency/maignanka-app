/*
import 'package:courtconnect/core/utils/app_constants.dart';
import 'package:courtconnect/core/widgets/custom_app_bar.dart';
import 'package:courtconnect/core/widgets/custom_container.dart';
import 'package:courtconnect/core/widgets/custom_delete_or_success_dialog.dart';
import 'package:courtconnect/core/widgets/custom_image_avatar.dart';
import 'package:courtconnect/core/widgets/custom_scaffold.dart';
import 'package:courtconnect/core/widgets/custom_text.dart';
import 'package:courtconnect/helpers/prefs_helper.dart';
import 'package:courtconnect/pregentaition/screens/home/controller/home_controller.dart';
import 'package:courtconnect/pregentaition/screens/message/controller/block_unblock_controller.dart';
import 'package:courtconnect/pregentaition/screens/message/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatProfileViewScreen extends StatefulWidget {
  const ChatProfileViewScreen(
      {super.key, required this.index, required this.chatId});

  final int index;
  final String chatId;

  @override
  State<ChatProfileViewScreen> createState() => _ChatProfileViewScreenState();
}

class _ChatProfileViewScreenState extends State<ChatProfileViewScreen> {
  final  _blockUnblockController = Get.put(BlockUnblockController());
  final _controller = Get.put(ChatController());


  String userId = '';

  @override
  void initState() {
    myId();
    super.initState();
  }

  void myId()async{
    userId = await PrefsHelper.getString(AppConstants.userId);

  }

  @override
  Widget build(BuildContext context) {
    var receiver = _controller.chatListData[widget.index].receiver;
    final bool isBlocked = _controller.chatData.isNotEmpty? _controller.chatData[0].messageType == 'block' : false;

    return CustomScaffold(
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomImageAvatar(
              image: receiver?.image ?? '',
              radius: 54.r,
            ),
          ),
          Center(
            child: CustomText(
              text: receiver?.name ?? '',
              top: 16.h,
              fontsize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'Status: ',
                  top: 6.h,
                  fontsize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                Flexible(
                  child: Obx(
                     () {
                       var receiver = _controller.chatListData[widget.index].receiver;

                       return CustomText(
                        text: isBlocked ? 'a moment age' :' ${receiver?.status ?? ''}',
                        top: 6.h,
                        fontsize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: !isBlocked && receiver?.status == 'online'
                            ? Colors.green
                            : Colors.amber,
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Divider(
            thickness: 0.2,
            color: Colors.black,
          ),
          SizedBox(height: 24.h),
          CustomText(
            text: 'Bio : ',
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            text: Get.find<HomeController>().bio.value,
            fontsize: 13.sp,
          ),
          SizedBox(height: 24.h),
          CustomText(
            text: 'Email : ',
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            text: receiver?.email ?? '',
            fontsize: 13.sp,
          ),
          SizedBox(height: 44.h),

          Obx(() {

            if (_controller.chatData.isNotEmpty) {
              final bool isBlocked = _controller.chatData[0].messageType == 'block';
              final bool isBlockedByMe = _controller.chatData[0].senderId == userId;
              if (isBlocked) {
                if (isBlockedByMe) {
                  return GestureDetector(
                    onTap: () {
                      showDeleteORSuccessDialog(
                        context,
                        title: 'Block ${receiver?.name}',
                        buttonLabel: 'Unblock',
                        message: 'Are you sure you want to unblock ${receiver?.name}? They will be able to contact you again.',
                        onTap: () {
                            _blockUnblockController.unblockUser(
                                receiver!.id!, widget.chatId);

                          Navigator.of(context).pop();
                        },
                      );
                    },
                    child: CustomText(
                      text: 'Unblock ${receiver?.name}',
                      color: Colors.red,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                } else {
                  return Center(
                    child: CustomContainer(
                      radiusAll: 16,
                      paddingAll: 10,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.red.withOpacity(0.1),
                            offset: Offset(4, 4),
                            blurRadius: 20),
                        BoxShadow(
                            color: Colors.red.withOpacity(0.1),
                            offset: Offset(-4, -4),
                            blurRadius: 20),
                      ],
                      child: CustomText(
                        text: "You are restricted by other user",
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                }
              }
            }
            return GestureDetector(
              onTap: () {
                showDeleteORSuccessDialog(
                  context,
                  title: 'Block ${receiver?.name}',
                  buttonLabel: 'Block',
                  message: 'Are you sure you want to block ${receiver?.name}? They will no longer be able to contact you.',
                  onTap: () {
                      _blockUnblockController.blockUser(
                          receiver!.id!, widget.chatId);

                    Navigator.of(context).pop();
                  },
                );
              },
              child: CustomText(
                text: 'Block ${receiver?.name}',
                color: Colors.red,
                fontWeight: FontWeight.w800,
              ),
            );
          }),
        ],
      ),
    );
  }
}
*/
