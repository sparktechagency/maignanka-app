import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_image_avatar.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, this.title, this.subTitle, this.image, this.imageRadius = 18, this.trailing,  this.selectedColor, this.onTap, this.activeColor, this.statusColor, this.borderColor, this.borderRadius, this.titleFontSize,});

  final String? title,subTitle,image;
  final double imageRadius;
  final Widget? trailing;
  final Color? selectedColor;
  final VoidCallback? onTap;
  final Color? activeColor;
  final Color? statusColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? titleFontSize;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: selectedColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),      onTap: onTap,
      //selectedColor: selectedColor,
     // selected: selectedColor != null ? true : false,
      contentPadding: EdgeInsets.symmetric(horizontal: 6.h),
      leading:  Stack(
        children: [
          CustomImageAvatar(
            radius: imageRadius.r,
            image: image,
          ),
          if(activeColor != null)
          Positioned(
            right: 0.w,
              bottom: 0.h,
              child: CustomContainer(
                paddingAll: 1,
                shape: BoxShape.circle,
                color: Colors.white,
                  child: Icon(Icons.circle,color: activeColor,size: 12.r,))),
        ],
      ),
      title: CustomText(
        textAlign: TextAlign.left,
        text: title ?? '',
        fontSize: titleFontSize,
        fontWeight:  FontWeight.w500,
      ),
      subtitle: subTitle != null ? Row(
        children: [
          if(statusColor != null)
            Icon(Icons.circle,color: statusColor,size: 10.r,),
          Flexible(
            child: CustomText(
              left: 4,
              textAlign: TextAlign.left,
              text: subTitle??'',
              fontWeight:  FontWeight.w500,
              fontSize: 10.sp,
              color: statusColor ?? AppColors.appGreyColor,
            ),
          ),

        ],
      ) : null,
      trailing: trailing,
    );
  }
}
