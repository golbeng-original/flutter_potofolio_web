import 'package:flutter/material.dart';

import '/core/image_state.dart';

import 'radius_icon_button.dart';

class EditImageStateWidget extends StatelessWidget {
  final ImageState imageState;
  final VoidCallback? onTabRemove;

  const EditImageStateWidget({
    Key? key,
    required this.imageState,
    this.onTabRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageState.isLocal == false) {
      return RadiusIconButton(
        iconData: Icons.delete,
        tooltip: '제거',
        onPressed: onTabRemove,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RadiusIconButton(
          iconData: Icons.delete,
          tooltip: '제거',
          onPressed: onTabRemove,
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: const Text('새로 올린 이미지'),
        ),
      ],
    );
  }
}
