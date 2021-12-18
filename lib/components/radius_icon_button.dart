import 'package:flutter/material.dart';

class RadiusIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData iconData;
  final String? tooltip;
  final Color foregroundColor;
  final Color backgroundColor;

  const RadiusIconButton({
    Key? key,
    required this.iconData,
    this.onPressed,
    this.tooltip,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        iconSize: 36,
        padding: const EdgeInsets.all(4),
        color: foregroundColor,
        icon: Icon(
          iconData,
        ),
      ),
    );
  }
}
