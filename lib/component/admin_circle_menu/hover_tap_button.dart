import 'package:flutter/material.dart';

class HoverTapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const HoverTapButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onTap, // Directly trigger the action
      elevation: 8.0,
      fillColor: const Color(0xFF009900),
      padding: const EdgeInsets.all(5.0),
      shape: const CircleBorder(),
      child: Icon(icon, color: Colors.white),
    );
  }
}
