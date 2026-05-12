import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class AppTextFormField extends StatefulWidget {
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
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.prefixIconPadding == null
        ? widget.prefixIcon
        : Padding(padding: widget.prefixIconPadding!, child: widget.prefixIcon);

    final suffixIcon = widget.obscureText
        ? IconButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            icon: Icon(
              _obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          )
        : null;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      validator: widget.validator,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      style: widget.style,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: icon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor:
            widget.fillColor ??
            Theme.of(context).inputDecorationTheme.fillColor,
        alignLabelWithHint: widget.alignLabelWithHint,
        contentPadding: widget.contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.enabledBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.focusedBorderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.errorBorderColor),
        ),
      ),
    );
  }
}
