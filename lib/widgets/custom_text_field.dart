import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maignanka_app/app/helpers/time_format.dart';
import 'package:maignanka_app/app/utils/app_colors.dart';
import 'package:maignanka_app/app/utils/app_constants.dart';
import 'package:maignanka_app/global/custom_assets/fonts.gen.dart';
import 'package:maignanka_app/widgets/custom_text.dart';


class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscure;
  final Color? filColor;
  final Color? borderColor;
  final Color? hintextColor;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final double? hintextSize;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final bool isPassword;
  final bool? isEmail;
  final bool? readOnly;
  final double? borderRadio;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Color? cursorColor;
  final int? maxLength;
  final int? maxLines;
  final bool? enabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool isDatePicker;
  final String? fontFamily;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatter;
  final int? minLines;

  const CustomTextField(
      {super.key,
      this.contentPaddingHorizontal,
      this.contentPaddingVertical,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.hintextColor,
      this.borderColor,
      this.isEmail = false,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.isObscureText = false,
      this.obscure = '*',
      this.filColor,
      this.hintextSize,
      this.labelText,
      this.isPassword = false,
      this.readOnly = false,
      this.borderRadio,
      this.onTap,
      this.onChanged,
      this.cursorColor,
      this.maxLength,
      this.enabled,
      this.focusNode,
      this.autofocus = false,
      this.isDatePicker = false,
      this.fontFamily,
      this.textInputAction,
      this.inputFormatter,
      this.minLines, this.maxLines});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void _selectDate(BuildContext context) {
    BottomPicker.date(
      onSubmit: (pickedDate) {
        final localDate = pickedDate.toLocal();
        final formattedDate = TimeFormatHelper.formatDate(localDate);

        if (widget.controller != null) {
          widget.controller!.text = formattedDate;
        }

        print("Selected date: $formattedDate");
      },
      pickerTitle: CustomText(
        textAlign: TextAlign.start,
        fontName: FontFamily.inter,
        fontSize: 20.sp,
        text: 'Set date',
      ),
      dateOrder: DatePickerDateOrder.mdy,
      itemExtent: 30.sp,
      pickerTextStyle: TextStyle(
        color: AppColors.darkColor,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
      buttonSingleColor: AppColors.primaryColor,
      buttonContent: CustomText(
        color: Colors.white,
          fontWeight: FontWeight.w500,
          fontName: FontFamily.inter,
          text: 'Select'),
      bottomPickerTheme: BottomPickerTheme.plumPlate,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          CustomText(
            text: widget.labelText ?? '',
            fontName: FontFamily.inter,
            color: AppColors.appGreyColor,
            bottom: 4.h,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        SizedBox(
          height: 4.h,
        ),
        TextFormField(
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          onTap: () {
            if (widget.isDatePicker) {
              _selectDate(context);
            } else {
              widget.onTap?.call();
            }
          },
          readOnly: widget.readOnly!,
          controller: widget.controller ?? TextEditingController(),
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatter,
          textInputAction: widget.textInputAction,
          obscuringCharacter: widget.obscure!,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          minLines: widget.isPassword ? 1 : (widget.minLines ?? 1),
          maxLines: widget.isPassword ? 1 : (widget.maxLines ?? 8),


          validator: widget.validator ??
              (value) {
                if (widget.isEmail == false) {
                  if (value!.isEmpty) {
                    return "Please enter ${widget.hintText!.toLowerCase()}";
                  } else if (widget.isPassword) {
                    if (value.isEmpty) {
                      return "Please enter ${widget.hintText!.toLowerCase()}";
                    } else if (value.length < 8) {
                      return "Password: 8 characters min!";
                    }
                  }
                } else {
                  bool data = AppConstants.emailValidate.hasMatch(value!);
                  if (value.isEmpty) {
                    return "Please enter ${widget.hintText!.toLowerCase()}";
                  } else if (!data) {
                    return "Please check your email!";
                  }
                }
                return null;
              },

          cursorColor: widget.cursorColor ?? AppColors.appGreyColor,
          obscureText: widget.isPassword ? obscureText : false,
          style: TextStyle(
              color: widget.hintextColor ?? AppColors.appGreyColor,
              fontSize: widget.hintextSize ?? 12.h,
              fontFamily: widget.fontFamily),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.contentPaddingHorizontal ?? 20.w,
                  vertical: widget.contentPaddingVertical ?? 10.h),
              fillColor: widget.filColor ?? Colors.transparent,
              filled: true,
              prefixIcon: widget.prefixIcon != null ? Padding(
                padding:  EdgeInsets.only(left: 14.w,right: 4.w),
                child: widget.prefixIcon,
              ) : null,
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: toggle,
                      child: _suffixIcon(obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                    )
                  : widget.suffixIcon,
              prefixIconConstraints:
                  BoxConstraints(minHeight: 24.w, minWidth: 24.w),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                  color: widget.hintextColor ?? AppColors.appGreyColor,
                  fontSize: widget.hintextSize ?? 12.h,
                  fontWeight: FontWeight.w400),
              focusedBorder: focusedBorder(),
              enabledBorder: enabledBorder(),
              errorBorder: errorBorder(),
              border: focusedBorder(),
              focusedErrorBorder: errorBorder(),
              errorStyle:
                  TextStyle(fontSize: 12.h, fontWeight: FontWeight.w400)),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  _suffixIcon(IconData icon) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Icon(icon, color: AppColors.darkColor));
  }

  OutlineInputBorder focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 10.r),
      borderSide: BorderSide(
          width: 0.8, color: widget.borderColor ?? AppColors.borderColor),
    );
  }

  OutlineInputBorder enabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 10.r),
      borderSide: BorderSide(
          width: 1, color: widget.borderColor ?? AppColors.borderColor),
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 10.r),
      borderSide:
          BorderSide(color: widget.borderColor ?? Colors.red, width: 1),
    );
  }
}
