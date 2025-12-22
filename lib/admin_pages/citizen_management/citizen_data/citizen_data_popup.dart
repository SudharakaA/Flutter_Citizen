//import 'package:citizen_care_system/admin%20_component/citizen_data/info_request/info_request_page.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/add_citizen/form_screens.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/citizen_user_request/citizen_user_request.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/update_citizen/Update_form_screens.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/view_citizen/view_citizen.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/citizen_list/citizen_list.dart';
import 'package:flutter/material.dart';


class CitizenDataPage extends StatelessWidget {
  final String accessToken;
  final String citizenCode;

  const CitizenDataPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> options = [
      {'label': 'ADD CITIZEN', 'image': 'assets/admin_images/add.jpeg'},
      {'label': 'VIEW CITIZEN', 'image': 'assets/admin_images/view.jpeg'},
      {'label': 'UPDATE CITIZEN', 'image': 'assets/admin_images/update.jpeg'},
      {'label': 'CITIZEN LIST', 'image': 'assets/admin_images/list.jpeg'},
      {
        'label': 'CITIZEN USER REQUEST',
        'image': 'assets/admin_images/request.jpeg'
      },
      {'label': 'UPLOAD DOCUMENTS', 'image': 'assets/admin_images/upload.jpeg'},
      {
        'label': 'INFORMATION REQUESTS',
        'image': 'assets/admin_images/info.jpeg'
      },
      {
        'label': 'SME BUSINESS DETAILS',
        'image': 'assets/admin_images/sme.jpeg'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('CITIZEN DATA'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
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
                  if (item['label'] == 'ADD CITIZEN') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FormScreens(),
                      ),
                    );
                  } else if (item['label'] == 'VIEW CITIZEN') {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                            builder: (context) => const ViewCitizen(), // Navigate to viewCitizenPage
                          ),
                       );
                    
                  } else if (item['label'] == 'UPDATE CITIZEN') {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                            builder: (context) => const UpdateFormScreens(), // Navigate to UpdateCitizenPage
                          ),
                       );
                  } else if (item['label'] == 'CITIZEN LIST') {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                            builder: (context) =>  CitizenList(accessToken: accessToken, citizenCode: citizenCode, selectedLocationId: '', selectedLocationName: ''), // Navigate to CitizenList
                          ),
                       );
                  } else if (item['label'] == 'CITIZEN USER REQUEST') {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                            builder: (context) => const CitizenUserRequest() // Navigate to UpdateCitizenPage
                          ),
                       );     
                  /*} else if (item['label'] == 'INFORMATION REQUESTS') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InfoRequestPage(),
                      ),
                    );*/
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected: ${item['label']}')),
                    );
                  }
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
