import 'package:flutter/material.dart';

class AboutProfileContantWidget extends StatelessWidget {
  final String contant;

  const AboutProfileContantWidget({
    Key? key,
    required this.contant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      contant,
      style: const TextStyle(
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

class AboutProfileContantEditWidget extends StatelessWidget {
  final TextEditingController editingController;

  const AboutProfileContantEditWidget({
    Key? key,
    required this.editingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      style: const TextStyle(
        fontWeight: FontWeight.w300,
      ),
      decoration: const InputDecoration(
        labelText: '연락처',
        border: OutlineInputBorder(),
      ),
      maxLines: 8,
      controller: editingController,
    );
  }
}
