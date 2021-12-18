import 'package:flutter/material.dart';

class EditConfirmControlWidget extends StatelessWidget {
  final VoidCallback? onPressUpload;
  final VoidCallback? onPressCancel;

  const EditConfirmControlWidget(
      {Key? key, this.onPressUpload, this.onPressCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: onPressUpload,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          child: const Text(
            '업로드',
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          onPressed: onPressCancel,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          child: const Text(
            '취소',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
