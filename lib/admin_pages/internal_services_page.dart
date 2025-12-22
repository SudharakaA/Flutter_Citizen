import 'package:flutter/material.dart';
import '../admin _component/postal_management_popup.dart';
import '../admin _component/stores_popup.dart';
import '../admin _component/training_popup.dart';
import '../admin _component/character_certificate_popup.dart';
import '../admin _component/file_management_popup.dart';
import '../admin _component/record_room_popup.dart';
//import '../admin_pages/home_page.dart';
import '../admin _component/citizen_service_task/custom_app_bar.dart';
import '../admin _component/citizen_service_task/admin_bottom_nav.dart';
import '../admin _component/citizen_service_task/services_list_container.dart';
import '../admin _component/citizen_service_task/services_menu_item.dart'; // Import the correct ServicesMenuItem class

class InternalServicesPage extends StatelessWidget {
  // ignore: library_private_types_in_public_api

  final List<ServicesMenuItem> items = [
    ServicesMenuItem('FILE MANAGEMENT', 'assets/admin_images/i1.jpeg'),
    ServicesMenuItem('POSTAL MANAGEMENT', 'assets/admin_images/i2.jpeg'),
    ServicesMenuItem('RECORD ROOM', 'assets/admin_images/i3.jpeg'),
    ServicesMenuItem('STORES', 'assets/admin_images/i4.jpeg'),
    ServicesMenuItem('TRAINING', 'assets/admin_images/i5.jpeg'),
    ServicesMenuItem('CHARACTER CERTIFICATE', 'assets/admin_images/i6.jpeg'),
    ServicesMenuItem('INCOME STATEMENT', 'assets/admin_images/i7.jpeg'),
    ServicesMenuItem('BUSINESS REGISTRATION', 'assets/admin_images/i8.jpeg'),
  ];


  InternalServicesPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWithDrawer(), // Using a custom app bar
      body: Column(
        children: [
          // Menu Cards
          Expanded(
            child: ServicesListContainer(
              // ignore: deprecated_member_use
              backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.8),
              items: items,
              onItemTap: (item) {
                if (item.title == 'POSTAL MANAGEMENT') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PostalManagementPopup()),
                  );
                } else if (item.title == 'STORES') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StoresPopup()),
                  );
                } else if (item.title == 'TRAINING') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TrainingPopup()),
                  );
                }else if (item.title == 'CHARACTER CERTIFICATE') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CharacterCertificatePopup()),
                  );
                }
                else if (item.title == 'FILE MANAGEMENT') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FileManagementPopup()),
                  );
                }else if (item.title == 'RECORD ROOM') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RecordRoomPopup()),
                  );
                }
              },
            ),
          ),
        ],
      ),
      // Bottom NavBar
      bottomNavigationBar: const AdminBottomNav(currentIndex: 3,
        accessToken: '', // Replace with actual access token
        citizenCode: '',  // Replace with actual citizen code
        authorizedRoleList: [],
      ),
    );
  }
}

// ignore: unused_element
class _IServicesCard extends StatelessWidget {
  final ServicesMenuItem item;

  const _IServicesCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.title == 'POSTAL MANAGEMENT') {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostalManagementPopup()),
          );
        } else if (item.title == 'STORES') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StoresPopup()),
          );
        } else if (item.title == 'TRAINING') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TrainingPopup()),
          );
        }else if (item.title == 'CHARACTER CERTIFICATE') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CharacterCertificatePopup()),
          );
        }
        else if (item.title == 'FILE MANAGEMENT') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FileManagementPopup()),
                  );
                }else if (item.title == 'RECORD ROOM') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RecordRoomPopup()),
                  );
                }
      },
      child: Container(

        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [

            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 4)),

          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item.imagePath,

                height: 80,
                width: 100,

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
// Removed duplicate ServicesMenuItem class definition.
// Ensure the correct ServicesMenuItem class is imported.