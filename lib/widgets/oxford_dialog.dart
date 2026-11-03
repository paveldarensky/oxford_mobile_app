import 'package:flutter/material.dart';
import 'package:oxford/theme/oxford_text.dart';

/// Короткий вопрос, как системное окно в оригинале: «НЕТ» и «ДА».
Future<bool> showOxfordChoice(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final answer = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        title: Text(title),
        titleTextStyle: OxfordText.dialogTitle,
        content: Text(message),
        contentTextStyle: OxfordText.dialogBody,
        actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('НЕТ', style: OxfordText.dialogAction),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('ДА', style: OxfordText.dialogAction),
          ),
        ],
      );
    },
  );
  return answer ?? false;
}
