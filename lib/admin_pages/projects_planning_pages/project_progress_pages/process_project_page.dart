import 'package:flutter/material.dart';
import '../../../component/request_service/date_picker_field.dart';
import '../../../component/request_service/action_button.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/custom_app_bar.dart';
import '../../../admin _component/project_planning/checkbox_dropdown_selector.dart';
import '../../../admin_pages/projects_planning_pages/project_progress_pages/view_progress_details.dart';

class ProcessProjectPage extends StatefulWidget {
  const ProcessProjectPage({super.key});

  @override
  State<ProcessProjectPage> createState() => _ProcessProjectPageState();
}

class _ProcessProjectPageState extends State<ProcessProjectPage> {
  List<String> selectedProjectTypes = [];
  List<String> selectedProjectStatuses = [];
  DateTime? startDate;
  DateTime? endDate;

  final List<String> projectTypes = [
    'Construction',
    'Purchasing',
  ];

  final List<String> projectStatuses = [
    'Project Assigned',
    'Project Ongoing',
    'Project Completed',
    'Project In Hold',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Process Projects',
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
                  'Select Project Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              CheckboxDropdownSelector(
                title: 'Project Type',
                options: projectTypes,
                selectedItems: selectedProjectTypes,
                onSelectionChanged: (newSelection) {
                  setState(() {
                    selectedProjectTypes = newSelection;
                  });
                },
              ),
              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'Select Project Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              CheckboxDropdownSelector(
                title: 'Project Status',
                options: projectStatuses,
                selectedItems: selectedProjectStatuses,
                onSelectionChanged: (newSelection) {
                  setState(() {
                    selectedProjectStatuses = newSelection;
                  });
                },
              ),
              const SizedBox(height: 24),

              const Center(
                child: Text(
                  'Select Time Period',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              DatePickerField(
                label: 'Start Date',
                selectedDate: startDate,
                onDateSelected: (date) {
                  setState(() {
                    startDate = date;
                  });
                },
              ),
              const SizedBox(height: 16),
              DatePickerField(
                label: 'End Date',
                selectedDate: endDate,
                onDateSelected: (date) {
                  setState(() {
                    endDate = date;
                  });
                },
              ),
              const SizedBox(height: 32),

              Center(
                child: ActionButton(
                  text: 'View Projects',
                  //icon: Icons.task_alt,
                  onPressed: _validateAndSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    if (selectedProjectTypes.isEmpty) {
      _showValidationError('Please select at least one project type.');
    } else if (selectedProjectStatuses.isEmpty) {
      _showValidationError('Please select at least one project status.');
    } else if (startDate == null) {
      _showValidationError('Please select a start date.');
    } else if (endDate == null) {
      _showValidationError('Please select an end date.');
    } else if (endDate!.isBefore(startDate!)) {
      _showValidationError('End date cannot be before start date.');
    } else {
      // ✅ Navigate to ViewProgressDetailsPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ViewProgressDetailsPage(
          
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
