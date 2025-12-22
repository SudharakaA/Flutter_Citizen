
import 'package:flutter/material.dart';
import '../admin _component/citizen_service_task/custom_app_bar.dart';
import '../admin _component/citizen_service_task/admin_bottom_nav.dart';
import 'citizen_management/citizen_data/citizen_data_popup.dart';
import '../admin _component/finanace_management_popup.dart';
import '../admin _component/subsidy_management_popup.dart';

class CitizenManagementPage extends StatelessWidget {
  final String accessToken;
  final String citizenCode;
  final List<String> authorizedRoleList;

  CitizenManagementPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
    required this.authorizedRoleList,
  });

  // ignore: library_private_types_in_public_api
  final List<_CitizenMenuItem> items = [
    _CitizenMenuItem('CITIZEN DATA', 'assets/admin_images/citizen_data.jpg'),
    _CitizenMenuItem('SUBSIDY MANAGEMENT', 'assets/admin_images/subsidy.jpeg'),
    _CitizenMenuItem('FINANCE MANAGEMENT', 'assets/admin_images/finance.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWithDrawer(),
      body: Column(
        children: [
          // Menu Cards Container
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: _CitizenCard(item: item, accessToken: accessToken, citizenCode: citizenCode),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 1,
        accessToken: '', // Replace with actual access token
        citizenCode: '', // Replace with actual citizen code
        authorizedRoleList: [],

      ),
    );
  }
}

class _CitizenCard extends StatelessWidget {
  final String accessToken;
  final String citizenCode;
  final _CitizenMenuItem item;

  const _CitizenCard({required this.item, required this.accessToken, required this.citizenCode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.title == 'CITIZEN DATA') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  CitizenDataPage( 
                accessToken: accessToken,
                citizenCode: citizenCode)),
          );
        } else if (item.title == 'SUBSIDY MANAGEMENT') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SubsidyManagementPopup()),
          );
        } else if (item.title == 'FINANCE MANAGEMENT') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FinanceManagementPopup()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item.imagePath,
                height: 100,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CitizenMenuItem {
  final String title;
  final String imagePath;

  _CitizenMenuItem(this.title, this.imagePath);
}
