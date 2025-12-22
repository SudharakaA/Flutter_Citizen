import 'package:flutter/material.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../checkbox_dropdown_selector.dart';
import '../action_button.dart';
import 'view_subject_management.dart';

class SubjectManagementPage extends StatefulWidget {
  const SubjectManagementPage ({super.key});

  @override
  State<SubjectManagementPage > createState() => _SubjectManagementPage();
}

class _SubjectManagementPage  extends State<SubjectManagementPage> {
  List<String> selectedSubjectManagementStatuses = [];

  final List<String> dsOfficeStatuses = [
    'Management',
    'Administrative',
    'Human Resource Management',
    'Financial Resource Management',
    'Permit',
    'Land',
    'Planning',
    'Social Service',
    'Samurdhi',
    'Identity card',
    'Registrar',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF).withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Subject Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Select Subject',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              CheckboxDropdownSelector(
                title: 'Subject Management Status',
                options: dsOfficeStatuses,
                selectedItems: selectedSubjectManagementStatuses,
                onSelectionChanged: (newSelection) {
                  setState(() {
                    selectedSubjectManagementStatuses = newSelection;
                  });
                },
              ),
              const SizedBox(height: 34),

              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    text: 'View Subject',
                    onPressed: _validateAndSubmit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    if (selectedSubjectManagementStatuses.isEmpty) {
      _showValidationError('Please select at least one DS Office.');
    } else
    {
      // ✅ Navigate to ViewProgressDetailsPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ViewSubjectManagent(
          ),
        ),
      );
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
