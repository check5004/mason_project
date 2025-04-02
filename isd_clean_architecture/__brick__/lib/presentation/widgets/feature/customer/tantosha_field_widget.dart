import 'package:flutter/material.dart';

class TantoshaFieldWidget extends StatelessWidget {
  final String id;
  final TextEditingController controller;

  const TantoshaFieldWidget({super.key, required this.id, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
