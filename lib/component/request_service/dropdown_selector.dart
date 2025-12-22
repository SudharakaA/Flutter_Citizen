import 'package:flutter/material.dart';

class DropdownSelector extends StatelessWidget {
  final String hintText;
  final VoidCallback onTap;
  final bool hasSelection;

  const DropdownSelector({
    super.key,
    required this.hintText,
    required this.onTap,
    required this.hasSelection,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hintText,
              style: TextStyle(
                color: hasSelection ? Colors.black : Colors.grey,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
