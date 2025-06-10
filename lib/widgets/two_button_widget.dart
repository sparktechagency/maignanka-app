import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/widgets/custom_container.dart';
import 'package:maignanka_app/widgets/custom_text.dart';

class TwoButtonWidget extends StatelessWidget {
  final List<Map<String, String>> buttons;
  final String selectedValue;
  final Function(String) onTap;
  final double? fontSize;

  const TwoButtonWidget({
    super.key,
    required this.buttons,
    required this.selectedValue,
    required this.onTap, this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: buttons.map((item) {
        final isSelected = item['value'] == selectedValue;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(item['value']!),
            child: CustomContainer(
              horizontalMargin: 6.w,
              radiusAll: 10.r,
              paddingVertical: 8.h,
              color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
              child: CustomText(
                text: item['label']!,
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: fontSize ?? 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
