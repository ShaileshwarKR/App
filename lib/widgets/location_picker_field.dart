import 'package:flutter/material.dart';

class LocationPickerField extends StatelessWidget {
  const LocationPickerField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: const Icon(Icons.location_on_outlined),
          ),
        ),
      ],
    );
  }
}
