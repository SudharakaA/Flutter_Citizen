import 'package:flutter/material.dart';

class FormDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const FormDatePicker({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: "Start Date",
            suffixIcon: Icon(Icons.calendar_today),
          ),
          controller: TextEditingController(
            text: selectedDate != null
                ? "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}"
                : '',
          ),
        ),
      ),
    );
  }
}
