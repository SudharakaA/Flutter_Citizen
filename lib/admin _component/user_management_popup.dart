import 'package:flutter/material.dart';

import '../admin_pages/system_configuration/privilege_management/view_privilege_details.dart';
import '../admin_pages/system_configuration/subject_configuration/view_subject_management.dart';
import '../admin_pages/system_configuration/user_configuration/view_user_details.dart';
import '../admin_pages/system_configuration/user_subject/view_user_subject.dart';

class UserManagementPopup extends StatelessWidget {
  final String accessToken;
  final String citizenCode;
  final List<String> authorizedRoleList;

  const UserManagementPopup({super.key,
    required this.accessToken,
    required this.citizenCode,
    required this.authorizedRoleList,});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {
        'label': 'USER CONFIGURATION',
        'image': 'assets/admin_images/user1.jpeg',
        'route': ViewUserPage(accessToken: accessToken,
            citizenCode: citizenCode, authorizedRoleList: authorizedRoleList),
      },
      {
        'label': 'PRIVILEGE MANAGEMENTS',
        'image': 'assets/admin_images/user2.jpeg',
        'route': ViewPrivilegeDetailsPage(accessToken: accessToken,
          citizenCode: citizenCode, authorizedRoleList: authorizedRoleList, selectedUserIds: [], selectedPrivilegeIds: [], selectedLocationIds: [],),
      },
      {
        'label': 'USER SUBJECTS',
        'image': 'assets/admin_images/user3.jpeg',
        'route': const ViewUserSubjectPage(),
      },
      {
        'label': 'SUBJECT CONFIGURATION',
        'image': 'assets/admin_images/user4.jpeg',
        'route': const ViewSubjectManagent(),
      },
    ];



    return Scaffold(
      appBar: AppBar(
        title: const Text('USER MANAGEMENT'),
        centerTitle: true,
      ),
      body: Padding(

        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            itemCount: options.length,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final item = options[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => item['route']),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Image.asset(
                          item['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 1,
                        child: Text(
                          item['label']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      backgroundColor: const Color(0xFF80AF81),
    );
  }
}

