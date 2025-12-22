import 'package:citizen_care_system/login/login_screen.dart';
import 'package:flutter/material.dart';
//import 'package:citizen_care_system/login/login_screen.dart';

import '../admin_pages/citizen_management_page.dart';
import '../admin_pages/citizen_services_page.dart';
import '../admin_pages/internal_services_page.dart';
import '../admin_pages/projects_planning_page.dart';
import '../admin_pages/system_configuration_page.dart';
import '../admin _component/citizen_service_task/custom_app_bar.dart';
import '../admin _component/citizen_service_task/admin_bottom_nav.dart';

class HomePage extends StatelessWidget {
  final String accessToken;
  final String citizenCode;
  final List<String> authorizedRoleList;

  const HomePage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
    required this.authorizedRoleList,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Citizen Care System',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(accessToken: accessToken, citizenCode: citizenCode),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String accessToken;
  final String citizenCode;

  HomeScreen({super.key, required this.accessToken, required this.citizenCode});

  final List<_MenuItem> menuItems = [
    const _MenuItem('Citizen Management', 'assets/admin_images/a1.jpg'),
    const _MenuItem('Citizen Services', 'assets/admin_images/a3.jpg'),
    const _MenuItem('System Configuration', 'assets/admin_images/a5.jpg'),
    const _MenuItem('Projects and Planning', 'assets/admin_images/a4.jpg'),
    const _MenuItem('Internal Services', 'assets/admin_images/a2.jpg'),
  ];

  void _navigateTo(BuildContext context, String title) {
    Widget destination;
    switch (title) {
      case 'Citizen Management':
        destination = CitizenManagementPage(
          accessToken: accessToken,
          citizenCode: citizenCode,
          authorizedRoleList: [],
        );
        break;
      case 'Citizen Services':
        destination = CitizenServicesPage(
          accessToken: accessToken,
          citizenCode: citizenCode,
        );
        break;
      case 'System Configuration':
        destination = SystemConfigurationPage(
          accessToken: accessToken,
          citizenCode: citizenCode,
          authorizedRoleList: [],
        );
        break;
      case 'Projects and Planning':
        destination = ProjectsPlanningPage(
        accessToken: accessToken,
        citizenCode: citizenCode,);
        break;
      case 'Internal Services':
        destination = InternalServicesPage();
        break;
      default:
        destination = const Scaffold(
          body: Center(child: Text('Page not found')),
        );
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWithDrawer (),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF80AF81)),
              child: Text(
                'Citizen Care System',
                style: TextStyle(color: Colors.white, fontSize: 20, ),
              ),
            ),
            ListTile(
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: _HoverCard(item: item, onTap: () => _navigateTo(context, item.title)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminBottomNav(currentIndex: 0, accessToken: accessToken, citizenCode: citizenCode, authorizedRoleList: [],),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final _MenuItem item;
  final VoidCallback onTap;

  const _HoverCard({required this.item, required this.onTap});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: isHovered ? [const BoxShadow(color: Colors.black26, blurRadius: 10)] : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Image background
                Image.asset(
                  widget.item.imagePath,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                // Gradient overlay on the image
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withAlpha(100),
                          Colors.black.withAlpha(100),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Title text
                Text(
                  widget.item.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 4, color: Colors.black26),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final String imagePath;

  const _MenuItem(this.title, this.imagePath);
}
