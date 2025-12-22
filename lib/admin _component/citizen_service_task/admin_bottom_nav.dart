import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart'; // Make sure to add iconly to your pubspec.yaml

import '../../admin_pages/citizen_management_page.dart';
import '../../admin_pages/home_page.dart';
import '../../admin_pages/internal_services_page.dart';
import '../../admin_pages/system_configuration_page.dart';
import '../../admin_pages/citizen_services_page.dart';

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  final String accessToken;
  final String citizenCode;
  final List<String> authorizedRoleList;

  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.accessToken,
    required this.citizenCode,
    required this.authorizedRoleList,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF3A7D44),
          unselectedItemColor: Colors.black54,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == currentIndex) return;

            switch (index) {
              case 0:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage(accessToken: accessToken,
                    citizenCode: citizenCode,   authorizedRoleList: authorizedRoleList )));
                break;
              case 1:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CitizenManagementPage(accessToken: accessToken,
                    citizenCode: citizenCode, authorizedRoleList: authorizedRoleList )));
                break;
              case 2:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CitizenServicesPage(accessToken: accessToken,
                  citizenCode: citizenCode,)));
                break;
              case 3:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => InternalServicesPage()));
                break;
              case 4:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SystemConfigurationPage(accessToken: accessToken,
                    citizenCode: citizenCode, authorizedRoleList: authorizedRoleList)));
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(currentIndex == 0 ? IconlyBold.home : IconlyLight.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(currentIndex == 1 ? IconlyBold.user_3 : IconlyLight.user),
              label: 'Citizen',
            ),
            BottomNavigationBarItem(
              icon: Icon(currentIndex == 2 ? IconlyBold.setting : IconlyLight.setting),
              label: 'Service',
            ),
            BottomNavigationBarItem(
              icon: Icon(currentIndex == 3 ? IconlyBold.chart : IconlyLight.chart),
              label: 'Internal',
            ),
            BottomNavigationBarItem(
              icon: Icon(currentIndex == 4 ? IconlyBold.profile : IconlyLight.profile),
              label: 'User',
            ),
          ],
        ),
      ),
    );
  }
}
