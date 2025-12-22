import 'package:flutter/material.dart';

class FormatButtonWidget extends StatelessWidget {
  final String format;
  final bool isSelected;
  final VoidCallback onTap;

  const FormatButtonWidget({
    super.key,
    required this.format,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF508D4E).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF508D4E) : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            format,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF508D4E) : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
