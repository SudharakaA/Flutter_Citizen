import 'package:flutter/material.dart';

class CustomAppBarWithDrawer extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogos;

  const CustomAppBarWithDrawer({
    super.key,
    this.title,
    this.showLogos = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu icon
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),

          // Title
          Column(
            children: [
              Text(
                title ?? 'CITIZEN CARE SYSTEM',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                'DISTRICT SECRETARIAT - POLONNARUWA',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          // Logo
          if (showLogos)
            Image.asset('assets/admin_images/logo_left.png', height: 40)
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}
