import 'package:flutter/material.dart';

class ElementAddButton extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onPressed;

  const ElementAddButton({
    Key? key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '추가',
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.black,
          ),
          child: const Icon(
            Icons.add,
            size: 88,
            color: Colors.black,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
