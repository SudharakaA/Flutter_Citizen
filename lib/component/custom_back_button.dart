import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE3E3E3),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(5),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
