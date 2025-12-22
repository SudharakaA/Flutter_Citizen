import 'package:citizen_care_system/admin%20_component/citizen_service_task/action_button.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/upload_documents/add_document.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/upload_documents/upload_documents_details_page.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:citizen_care_system/component/request_service/date_picker_field.dart';
import 'package:citizen_care_system/component/request_service/dropdown_selector.dart';
import 'package:citizen_care_system/component/request_service/multi_select_dialog.dart';
import 'package:flutter/material.dart';

class UploadDocumentsFilterPage extends StatefulWidget {
  const UploadDocumentsFilterPage({super.key});

  @override
  State<UploadDocumentsFilterPage> createState() =>
      _UploadDocumentsFilterPageState();
}

class _UploadDocumentsFilterPageState extends State<UploadDocumentsFilterPage> {
  DateTime? startDate;
  DateTime? endDate;
  List<String> selectedDocTypes = []; //initial
  List<String> availableDocTypes = [
    'Sesonal Meeting Decisions(Agriculture Help)',
    'Cultivations Advice(Agriculture Help)',
    'Price Commitee Decisions(Agriculture Help)',
    'Purchasing Harvest(Agriculture Help)',
    'Farmer News(Agriculture Help)',
    'Central Government(Government Notices)',
    'Provincial Council(Government Notices)',
    'District Secretariat(Government Notices)',
    'Grama Niladari(Government Notices)',
    'Divisional Secretatriat(Government Notices)',
    'Government Sector(Carrers)',
    'Private Sector(Carrers)',
    'Foreign(Carrers)',
    'Business Advice(Bussines Assistance)',
    'Business Training(Business Assistance)',
  ];

  @override
  void initState() {
    super.initState();
  }

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
          // ignore: deprecated_member_use
          color: const Color(0xFFE3E3E3).withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Column(
                children: [
                  Center(
                    child: Text(
                      'CCS Document HUB',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Service Dropdown
              const Center(
                child: Text(
                  'Select Document type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DropdownSelector(
                hintText: selectedDocTypes.isEmpty
                    ? 'Nothing Selected'
                    : '${selectedDocTypes.length} Types selected',
                onTap: () => _showDocTypesDialog(context),
                hasSelection: selectedDocTypes.isNotEmpty,
              ),
              const SizedBox(height: 24),

              // Time Period Section
              const Center(
                child: Text(
                  'Select Time Period',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Start Date
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

              // End Date
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

              // View Task Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionButton(
                    text: 'View Data',
                    icon: Icons.description,
                    onPressed: () {
                      // Validate that services and dates are selected
                      if (selectedDocTypes.isEmpty) {
                        _showValidationError(
                            context, 'Please select at least one DOC Type');
                      } else if (startDate == null) {
                        _showValidationError(
                            context, 'Please select a start date');
                      } else if (endDate == null) {
                        _showValidationError(
                            context, 'Please select an end date');
                      } else if (endDate!.isBefore(startDate!)) {
                        _showValidationError(
                            context, 'End date cannot be before start date');
                      } else {
                        // If validation passes, navigate to the service details page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const UploadDocumentsDetailsPage(),
                          ),
                        );
                      }
                    },
                  ),
                  ActionButton(
                      text: 'Add Data',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddDocument(),
                          ),
                        );
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show a validation error message
  void _showValidationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showDocTypesDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: 'Select a Document Type',
          items: availableDocTypes,
          initialSelection: selectedDocTypes,
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedDocTypes = newSelection;
            });
          },
        );
      },
    );
  }
}
