import 'package:citizen_care_system/admin_pages/training_pages/course_management_pages/training_course_management.dart';
import 'package:citizen_care_system/admin_pages/training_pages/material_management_pages/training_material_management.dart';
import 'package:citizen_care_system/admin_pages/training_pages/resource_person_pages/training_resource_person.dart';
import 'package:citizen_care_system/admin_pages/training_pages/training_knowledge_hub_pages/training_knowledge_hub.dart';
import 'package:citizen_care_system/admin_pages/training_pages/training_management_pages/training_management.dart';
import 'package:citizen_care_system/admin_pages/training_pages/training_request_pages/training_request.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';

class TrainingPopup extends StatelessWidget {
  const TrainingPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {'label': 'TRAINING REQUEST', 'image': 'assets/admin_images/t1.jpeg', 'page': const TrainingRequestPage()},
      {'label': 'TRAINING MANAGEMENT', 'image': 'assets/admin_images/t2.jpeg', 'page': const TrainingManagementPage()},
      {'label': 'MATERIAL MANAGEMENT', 'image': 'assets/admin_images/t3.jpeg', 'page': const TrainingMaterialManagementPage()},
      {'label': 'KNOWLEDGE HUB', 'image': 'assets/admin_images/t4.jpeg', 'page': const TrainingKnowledgeHubPage()},
      {'label': 'RESOURCE PERSON', 'image': 'assets/admin_images/t5.jpeg', 'page': const TrainingResourcePersonPage()},
      {'label': 'COURSE MANAGEMENT', 'image': 'assets/admin_images/t6.jpeg', 'page': const TrainingCourseManagementPage()},
    ];

    return Scaffold(
       backgroundColor: const Color(0xFF80AF81),
       appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
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
                    MaterialPageRoute(builder: (context) => item['page']),
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
    );
  }
}

