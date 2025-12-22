import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/view_project_details_page.dart';
import 'package:flutter/material.dart';
import '../admin _component/citizen_service_task/custom_app_bar.dart';
import '../admin _component/citizen_service_task/admin_bottom_nav.dart';
import '../admin _component/citizen_service_task/services_menu_item.dart';
import '../admin _component/citizen_service_task/services_list_container.dart';
import 'projects_planning_pages/project_request_pages/planning_proposal_page.dart'; // ✅ Import your new page
import 'projects_planning_pages/project_progress_pages/process_project_page.dart';

class ProjectsPlanningPage extends StatelessWidget {
  final String accessToken;
  final String citizenCode;

  ProjectsPlanningPage({
    super.key,
    required this.accessToken,
    required this.citizenCode});
  
  final List<ServicesMenuItem> items = [
    ServicesMenuItem('PROJECT REQUESTS', 'assets/admin_images/p1.jpeg'),
    ServicesMenuItem('PROJECT PROGRESS', 'assets/admin_images/p2.jpeg'),
    ServicesMenuItem('PROJECTS 360', 'assets/admin_images/p3.jpeg'),
    ServicesMenuItem('CITIZEN PROJECT REQUESTS', 'assets/admin_images/p4.jpeg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWithDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ServicesListContainer(
              // ignore: deprecated_member_use
              backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.8),
              items: items,
              onItemTap: (item) {
                if (item.title == 'PROJECT REQUESTS') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProjectDetailsPage(
                        accessToken: accessToken,
                        citizenCode: citizenCode,),
                    ),
                  );
                } else if (item.title == 'PROJECT PROGRESS') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProcessProjectPage(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(
        currentIndex: 2,
        accessToken: '', // Replace with actual access token
        citizenCode: '', // Replace with actual citizen code
        authorizedRoleList: [],
      ),
    );
  }
}
