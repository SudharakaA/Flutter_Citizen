import 'package:flutter/material.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../checkbox_dropdown_selector.dart';
import '../action_button.dart';
import 'view_user_subject.dart';

class UserSubjectPage extends StatefulWidget {
  const UserSubjectPage ({super.key});

  @override
  State<UserSubjectPage > createState() => _UserSubjectPage();
}

class _UserSubjectPage extends State<UserSubjectPage> {
  List<String> selectedDSOfficeStatuses = [];
  List<String> selecteddsOfficeUserStatuses = [];

  final List<String> dsOfficeStatuses = [
    'Polonnaruwa - District Office',
    'Thamankaduwa - DS Office',
    'Higurakgoda - DS Office',
    'Medirigiriya - DS Office',
    'Dimbulagala - DS Office',
    'Lankapura - DS Office',
    'Welikanda - DS Office',
    'Elehera - DS Office',
  ];

  final List<String> dsOfficeUserStatuses = [
    '',
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
          color: const Color(0xFFFFFFFF),
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
                      'User Subject',
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
                  'Select DS Office',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              CheckboxDropdownSelector(
                title: 'DS Office Status',
                options: dsOfficeStatuses,
                selectedItems: selectedDSOfficeStatuses,
                onSelectionChanged: (newSelection) {
                  setState(() {
                    selectedDSOfficeStatuses = newSelection;
                  });
                },
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Select DS Office User',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              CheckboxDropdownSelector(
                title: 'DS Office User Status',
                options: dsOfficeUserStatuses,
                selectedItems: selecteddsOfficeUserStatuses,
                onSelectionChanged: (newSelection) {
                  setState(() {
                    selecteddsOfficeUserStatuses = newSelection;
                  });
                },
              ),
              const SizedBox(height: 42),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    text: 'View subject',
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
    if (selectedDSOfficeStatuses.isEmpty) {
      _showValidationError('Please select at least one DS Office.');
    } else
    {
      // ✅ Navigate to ViewProgressDetailsPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ViewUserSubjectPage(
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
