import 'package:citizen_care_system/admin_pages/system_configuration/change_password/change_password.dart';
import 'package:citizen_care_system/admin_pages/system_configuration/lov_%20management/lov_management.dart';
import 'package:flutter/material.dart';
import '../admin _component/user_management_popup.dart';
//import '../admin_pages/citizen_management_page.dart';
//import '../admin_pages/citizen_services_page.dart';
//import '../admin_pages/home_page.dart';
//import '../admin_pages/internal_services_page.dart';
import '../admin _component/citizen_service_task/custom_app_bar.dart';
import '../admin _component/citizen_service_task/admin_bottom_nav.dart';
import '../admin _component/citizen_service_task/services_list_container.dart';
import '../admin _component/citizen_service_task/services_menu_item.dart'; // Import the correct ServicesMenuItem class

class SystemConfigurationPage extends StatelessWidget {
  final String accessToken;
  final String citizenCode;
  final List<String> authorizedRoleList;


  // ignore: library_private_types_in_public_api
  final List<ServicesMenuItem> items = [
    ServicesMenuItem('USER MANAGEMENT', 'assets/admin_images/c1.jpeg'),
    ServicesMenuItem('LOV MANAGEMENT', 'assets/admin_images/c2.jpeg'),
    ServicesMenuItem('CHANGE PASSWORD', 'assets/admin_images/c3.jpeg'),
  ];

  SystemConfigurationPage({super.key,
    required this.accessToken,
    required this.citizenCode,
    required this.authorizedRoleList,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWithDrawer(), // Using the custom app bar
      body: Column(
        children: [
          // Menu Cards
          Expanded(
            child: ServicesListContainer(
              // ignore: deprecated_member_use
              backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.8),
              items: items,
              onItemTap: (item) {
                if (item.title == 'USER MANAGEMENT') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserManagementPopup(accessToken: accessToken,
                        citizenCode: citizenCode, authorizedRoleList: authorizedRoleList)),
                  );
                } else if (item.title == 'LOV MANAGEMENT') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LovManagementPage()),
                  );
                } else if (item.title == 'CHANGE PASSWORD') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                  );
                }
                // Add navigation for other menu items if needed
              },
            ),
          ),
        ],
      ),
      // Bottom NavBar
      bottomNavigationBar: const AdminBottomNav(currentIndex: 4,
        accessToken: '', // Replace with actual access token
        citizenCode: '', authorizedRoleList: [], // Replace with actual citizen code

      ), // Assuming 'User' is at index 4
    );
  }
}

// Removed _ConfigurationMenuItem class as it is no longer needed.
