import 'package:flutter/material.dart';

class AboutProfileNameWidget extends StatelessWidget {
  final String profileName;
  const AboutProfileNameWidget({Key? key, required this.profileName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      profileName,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class AboutProfileNameEditWidget extends StatelessWidget {
  final TextEditingController editingController;

  const AboutProfileNameEditWidget({
    Key? key,
    required this.editingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      decoration: const InputDecoration(
        labelText: '이름',
        border: OutlineInputBorder(),
      ),
      controller: editingController,
    );
  }
}
