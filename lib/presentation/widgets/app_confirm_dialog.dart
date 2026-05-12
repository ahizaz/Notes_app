import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

Future<bool?> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmText,
  String cancelText = 'Cancel',
  Color confirmTextColor = AppColors.error,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(
            confirmText,
            style: TextStyle(color: confirmTextColor),
          ),
        ),
      ],
    ),
  );
}
