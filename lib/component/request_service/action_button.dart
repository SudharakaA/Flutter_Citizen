import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final IconData? icon;  // Make the icon parameter nullable
  final VoidCallback onPressed;
  final Color backgroundColor;

  const ActionButton({
    super.key,
    required this.text,
    this.icon, // icon is now optional
    required this.onPressed,
    this.backgroundColor = const Color(0xFF3A7D44),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75, // Ensures the button fills available width
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center icon and text
          mainAxisSize: MainAxisSize.min,
          children: [
            // Conditionally render icon if it's not null
            if (icon != null) 
              Icon(icon, size: 20, color: Colors.white),
            if (icon != null) const SizedBox(width: 8), // Add space only if icon is present
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
