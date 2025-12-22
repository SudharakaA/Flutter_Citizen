import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../admin _component/citizen_service_task/custom_app_bar.dart';
import '../admin _component/citizen_service_task/admin_bottom_nav.dart';
import '../admin _component/citizen_service_task/services_menu_item.dart';
import '../admin _component/citizen_service_task/services_list_container.dart';
import '../admin_pages/citizen_services_pages/service_details_page.dart';
import '../../model/service_data.dart';
import 'citizen_services_pages/Subject_officer/subject_officer_page.dart';

class CitizenServicesPage extends StatelessWidget {
  final String accessToken;
  final String citizenCode;

  CitizenServicesPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  final List<ServicesMenuItem> items = [
    ServicesMenuItem('SUBJECT_OFFICER'.tr(), 'assets/admin_images/d1.jpeg'),
    ServicesMenuItem('SERVICE_TASKS'.tr(), 'assets/admin_images/d2.jpeg'),
    ServicesMenuItem('SERVICE_DASHBOARD'.tr(), 'assets/admin_images/d3.jpeg'),
  ];

  final List<String> selectedServices = [
    'Preparation of NIC- one day service',
    'NIC - Initial',
    'NIC - Amendment',
    'NIC - Missing',
    'Submission of grievances',
    'Transportation of timber',
    'Transportation of animal',
    'Issuarance of income certificates/ asset certificates',
    'Issuarance of excise permits',
    'Registration of voluntary organizations',
    'Business name registration',
    'Obtain copies of business names taking',
    'Business name amendment',
    'Cancellation of business name',
    'Application for land kachcheri(regularization of unauthorized)',
    'Designation of post inheritance',
    'Grant of original rights(Grant)',
    'Lifetime registration',
    'Exclusion of manapatra lands',
    'Separation of schedules',
    'Processing of long term tax permits',
    'Transfer of land to departments',
    'Entry of schedules into the eslims systems',
    'Exemption to a leased land issuarance of a warrant',
    'Free directory setup(not available on lease)',
    'Wild elephant damage claim(property)',
    'Compensation for wild elephant damage(physical harm)',
    'Wild elephant damage compensation(life damage)',
    'Technical training programs',
    'Provision of food stamps',
    'Disability allowance',
    'Public assistance',
    'Sickness application',
    'Application for full disability benefits',
    'Senior allowance(above 70 years)',
    'Applying for twin benefits',
    'Applying for disabled equipment',
    'Application for family rehabilitation where mother/father/guardian died of kidney diseases',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWithDrawer(),
      body: Column(
        children: [
          // Menu Cards
          Expanded(
            child: ServicesListContainer(
              backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.8),
              items: items,
              onItemTap: (item) {
                // Handle navigation based on item title
                if (item.title == 'SERVICE_TASKS'.tr()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailsPage(
                        selectedServices: ServiceData.availableServices,
                        accessToken: accessToken,
                        citizenCode: citizenCode,
                      ),
                    ),
                  );
                } else if (item.title == 'SUBJECT_OFFICER'.tr()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubjectOfficerPage(
                        accessToken: accessToken,
                        citizenCode: citizenCode,
                      ),
                    ),
                  );
                } else if (item.title == 'SERVICE_DASHBOARD'.tr()) {
                  // TODO: Implement navigation to Service Dashboard page
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('service_dashboard_not_implemented'.tr()),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminBottomNav(
        currentIndex: 2,
        accessToken: accessToken,
        citizenCode: citizenCode,
        authorizedRoleList: [],
      ),
    );
  }
}