import 'package:flutter/material.dart';

class HeaderTitleWidget extends StatelessWidget {
  final String headerTitle;

  const HeaderTitleWidget({
    Key? key,
    required this.headerTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    var color = Colors.grey; //Theme.of(context).colorScheme.error;

    return Container(
      width: mediaQuery.size.width,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: const EdgeInsets.only(bottom: 4, left: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: color,
            width: 2.0,
          ),
        ),
      ),
      child: Text(
        headerTitle,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: color,
        ),
      ),
    );
  }
}
