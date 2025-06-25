import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/features/models/chat_model_data.dart';
import 'package:maignanka_app/services/api_urls.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class ChatBubbleMessage extends StatelessWidget {
  final String time;
  final String? text;
  final List<File>? images;
  final bool isSeen;
  final bool isMe;
  final String status;

  const ChatBubbleMessage({
    super.key,
    required this.time,
    this.text,
    this.images,
    required this.isMe,
    this.isSeen = false,
    this.status = 'offline',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: CustomContainer(
                  paddingAll: 10.r,
                  color: isMe ? const Color(0xffE20070) : const Color(0xffFCE6F1),
                  radiusAll: 10.r,
                  child: _buildMessageContent(),
                ),
              ),
            ],
          ),
          //SizedBox(height: 3.h),
          Row(
            mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              CustomText(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                text: time,
                left: isMe ? 0 : 10.w,
                right: isMe ? 10.w : 0,
                color: AppColors.appGreyColor,
              ),
              SizedBox(width: 4.w),
              _buildMessageStatusIcon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    if (text?.isNotEmpty == true) {
      return CustomText(
        maxline: 10,
        textAlign: TextAlign.left,
        fontWeight: FontWeight.w400,
        color: isMe ? Colors.white : Colors.black,
        text: text!,
      );
    } else if (images != null && images!.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: images!.map((url) {
            return Padding(
              padding: EdgeInsets.only(right: 5.h),
              child: SizedBox(
                width: 180.w,
                child: BubbleNormalImage(
                  id: url.url ?? '',
                  image: Image.network(
                    '${ApiUrls.imageBaseUrl}${url.url}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  color: Colors.transparent,
                  tail: true,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
    return const SizedBox(); // If neither text nor image, return empty
  }

  Widget _buildMessageStatusIcon() {
    if (!isMe) return const SizedBox(); // No icon for received messages

    if (isSeen) {
      return Icon(Icons.done_all, size: 10.r, color: Colors.green); // Seen
    } else if (status == 'online') {
      return Icon(Icons.done_all, size: 10.r, color: Colors.grey); // Delivered
    } else {
      return Icon(Icons.check, size: 10.r, color: Colors.grey); // Sent
    }
  }
}
