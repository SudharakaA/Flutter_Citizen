import 'package:citizen_care_system/admin_pages/internal_services/postal_management/postal_administration/postal_management_filter_page.dart';
import 'package:citizen_care_system/admin_pages/internal_services/postal_management/postal_tasks/postal_process_details.dart';
import 'package:flutter/material.dart';

class PostalManagementPopup extends StatelessWidget {
  const PostalManagementPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> options = [
      {
        'label': 'POSTAL ADMINISTRATION',
        'image': 'assets/admin_images/postal1.jpeg'
      },
      { 'label': 'POSTAL TASKS', 
        'image': 'assets/admin_images/postal2.jpeg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('POSTAL MANAGEMENT'),
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
                  if (item['label'] == 'POSTAL ADMINISTRATION') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostalManagementFilterPage(),
                      ),
                    );
                  } else if (item['label'] == 'POSTAL TASKS') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostalProcessDetails(),
                      ),
                    );
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
      backgroundColor: Colors.white,
    );
  }
}
