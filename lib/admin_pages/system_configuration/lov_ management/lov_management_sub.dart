import 'package:flutter/material.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../checkbox_dropdown_selector.dart';
import '../action_button.dart';
import 'view_lov_sub_management.dart';

class LovManagementSub extends StatefulWidget {
  const LovManagementSub({super.key});

  @override
  State<LovManagementSub> createState() => _LovManagementPage();
}

class _LovManagementPage extends State<LovManagementSub> {


  List<String> selectLovManagementSubStatuses = [];

  final List<String> lovsubmanagement = [
    'Education Level',
    'Education Institution',
    'Subsidie Type',
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
                      'Citizen LOV Management - Sub ',
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
                  'Select Management Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),

              CheckboxDropdownSelector(
                title: 'Management Type Status',
                options: lovsubmanagement,
                selectedItems: selectLovManagementSubStatuses,
                onSelectionChanged: (newSelection) {
                  setState(() {
                    selectLovManagementSubStatuses = newSelection;
                  });
                },
              ),
              const SizedBox(height: 32),

              Center(
                child: ActionButton(
                  text: 'View Data',
                  onPressed: _validateAndSubmit,

                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: ActionButton(
                    text: 'Add New',
                    onPressed: (){
                    }
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    if (selectLovManagementSubStatuses.isEmpty) {
      _showValidationError('Please select at least one DS Office.');
    } else
    {
      // ✅ Navigate to ViewProgressDetailsPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ViewLovSubManagement(
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
