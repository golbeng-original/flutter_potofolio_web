import 'package:flutter/material.dart';

import '/core/image_state.dart';

import '/components/element_add_button.dart';
import '/components/edit_image_state_widget.dart';

class AboutProfileImageWidget extends StatelessWidget {
  final ImageState profileImage;

  const AboutProfileImageWidget({
    Key? key,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Image(
        image: profileImage.getImagePovider(),
        fit: BoxFit.fitHeight,
      ),
    );
  }
}

class AboutProfileImageEditWidget extends StatelessWidget {
  final ImageState profileImageState;
  final VoidCallback? onTabAdd;
  final VoidCallback? onTabRemove;

  const AboutProfileImageEditWidget({
    Key? key,
    required this.profileImageState,
    this.onTabAdd,
    this.onTabRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (profileImageState.isEmpty) {
      return ElementAddButton(
        width: 240,
        height: 240,
        onPressed: onTabAdd,
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 240,
          child: Image(
            image: profileImageState.getImagePovider(),
            fit: BoxFit.fitHeight,
            color: Colors.grey,
            colorBlendMode: BlendMode.multiply,
          ),
        ),
        Center(
          child: EditImageStateWidget(
            imageState: profileImageState,
            onTabRemove: onTabRemove,
          ),
        )
      ],
    );
  }
}
