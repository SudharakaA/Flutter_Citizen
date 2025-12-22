import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Made nullable
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width; // Added width parameter

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.width, required TextOverflow overflow, // Optional width parameter
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, // Use custom width or full width
      child: ElevatedButton(
        onPressed: onPressed, // Now accepts null
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF508D4E),
          disabledBackgroundColor: Colors.grey.shade300, // Color when disabled
          padding: padding ?? const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 25),
          ),
          elevation: onPressed != null ? 3 : 0, // No elevation when disabled
          minimumSize: Size(width ?? double.infinity, 50), // Ensures minimum height
        ),
        child: Text(
          text,
          style: TextStyle(
            color: onPressed != null
                ? (textColor ?? Colors.white)
                : Colors.grey.shade600, // Different color when disabled
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}