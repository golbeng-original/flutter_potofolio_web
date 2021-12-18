import 'package:flutter/material.dart';

class DialogUtil {
  static void showOkDialog({
    required BuildContext context,
    required String title,
    required String content,
    VoidCallback? onTabOk,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            title,
            textAlign: TextAlign.start,
          ),
          content: Text(
            content,
            textAlign: TextAlign.start,
          ),
          actions: [
            ElevatedButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.pop(context);
                onTabOk?.call();
              },
            ),
          ],
        );
      },
    );
  }

  static void showOkCancelDialog({
    required BuildContext context,
    required String title,
    required String content,
    VoidCallback? onTabOk,
    VoidCallback? onTabCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.topCenter,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            title,
            textAlign: TextAlign.start,
          ),
          content: Text(
            content,
            textAlign: TextAlign.start,
          ),
          actions: [
            ElevatedButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.pop(context);
                onTabOk?.call();
              },
            ),
            ElevatedButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.pop(context);
                onTabCancel?.call();
              },
            ),
          ],
        );
      },
    );
  }
}
