import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.style,
    this.fillColor,
    this.borderRadius = 8,
    this.borderColor = Colors.transparent,
    this.enabledBorderColor = Colors.transparent,
    this.focusedBorderColor = AppColors.primary,
    this.errorBorderColor = AppColors.error,
    this.contentPadding = const EdgeInsets.all(AppSpacing.md),
    this.alignLabelWithHint = false,
    this.prefixIconPadding,
  });

  final TextEditingController controller;
  final String hintText;
  final Widget prefixIcon;
  final String? Function(String? value) validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final TextStyle? style;
  final Color? fillColor;
  final double borderRadius;
  final Color borderColor;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final EdgeInsetsGeometry contentPadding;
  final bool alignLabelWithHint;
  final EdgeInsetsGeometry? prefixIconPadding;

  @override
  Widget build(BuildContext context) {
    final icon = prefixIconPadding == null
        ? prefixIcon
        : Padding(
            padding: prefixIconPadding!,
            child: prefixIcon,
          );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      style: style,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon,
        filled: true,
        fillColor: fillColor ?? Theme.of(context).inputDecorationTheme.fillColor,
        alignLabelWithHint: alignLabelWithHint,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: enabledBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: errorBorderColor),
        ),
      ),
    );
  }
}
