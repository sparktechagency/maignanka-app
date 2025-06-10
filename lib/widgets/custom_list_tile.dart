import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/widgets/custom_image_avatar.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, this.title, this.subTitle, this.image, this.imageRadius = 24, this.trailing,  this.selectedColor, this.onTap, this.activeColor, this.statusColor, this.borderColor, this.borderRadius});

  final String? title,subTitle,image;
  final double imageRadius;
  final Widget? trailing;
  final Color? selectedColor;
  final VoidCallback? onTap;
  final Color? activeColor;
  final Color? statusColor;
  final Color? borderColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),      onTap: onTap,
      selectedColor: selectedColor,
      selected: selectedColor != null ? true : false,
      contentPadding: EdgeInsets.symmetric(horizontal: 6.h),
      leading:  Stack(
        children: [
          CustomImageAvatar(
            radius: imageRadius.r,
            image: '',
          ),
          if(activeColor != null)
          Positioned(
            right: 5.w,
              bottom: 2.h,
              child: Icon(Icons.circle,color: activeColor,size: 14.r,)),
        ],
      ),
      title: CustomText(
        textAlign: TextAlign.left,
        text: title ?? '',
        fontWeight: FontWeight.w500,
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
              fontWeight: FontWeight.w500,
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
