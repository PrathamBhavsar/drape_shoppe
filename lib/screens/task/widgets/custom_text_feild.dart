import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.isEnabled = true, // Default is true
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final bool isEnabled; // Non-nullable with a default value

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        enabled: isEnabled,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          disabledBorder: const UnderlineInputBorder(),
          focusedBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey), // Border color when focused
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Default border color
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
