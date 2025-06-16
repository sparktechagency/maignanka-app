import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile(
      {super.key,
      this.color,
      this.textColor,
      this.noIcon,
      required this.title,
      required this.onTap,  this.icon, this.trailing, this.paddingVertical});

  final Color? color;
  final Color? textColor;
  final bool? noIcon;
  final String title;
  final VoidCallback onTap;
   final Widget? icon;
   final Widget? trailing;
   final double? paddingVertical;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      boxShadow: [
        BoxShadow(
          color: Color(0xff0000001A).withOpacity(0.1),
          offset: Offset(0, 4),
          blurRadius: 4,
        )
      ],
      onTap: onTap,
      paddingVertical: paddingVertical ?? 12.h,
      paddingHorizontal: 8.w,
      verticalMargin: 7.h,
      color: color ?? const Color(0xFFFCE6E8),
      radiusAll: 8.r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? SizedBox.shrink(),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomText(
              text: title,
              textAlign: TextAlign.start,
              color: textColor ?? AppColors.darkColor,
            ),
          ),
          if (noIcon != true)
            Icon(
              Icons.arrow_right,
              color: Colors.black,
            ),
          if(trailing != null)
          trailing!
        ],
      ),
    );
  }
}
