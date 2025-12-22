import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

class CustomFabMenu extends StatelessWidget {
  final List<Widget> menuItems;

  const CustomFabMenu({
    super.key,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;

    // Scale sizes based on screen size
    final double fabSize = screenWidth * 0.12;
    final double ringDiameter = screenWidth * 0.75;
    final double ringWidth = screenWidth * 0.22;

    return FabCircularMenu(
      alignment: Alignment.bottomRight,
      ringColor: Colors.green.withAlpha(30),
      ringDiameter: ringDiameter,
      ringWidth: ringWidth,
      fabSize: fabSize,
      fabElevation: 6.0,
      fabColor: const Color(0xFF3A7D44),
      fabOpenIcon: const Icon(Icons.menu, color: Colors.white),
      fabCloseIcon: const Icon(Icons.close, color: Colors.white),
      fabIconBorder: const CircleBorder(),
      children: menuItems,
    );
  }
}
