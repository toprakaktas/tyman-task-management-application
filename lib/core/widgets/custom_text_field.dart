import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool enabled;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.label,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      enabled: enabled,
      readOnly: !enabled,
      placeholder: label,
      placeholderStyle: const TextStyle(
        color: CupertinoColors.inactiveGray,
        fontStyle: FontStyle.italic,
      ),
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 16),
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemGrey,
          width: 1,
        ),
      ),
    );
  }
}
