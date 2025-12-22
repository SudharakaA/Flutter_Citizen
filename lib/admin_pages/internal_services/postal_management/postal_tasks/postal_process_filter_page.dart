import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/info_request/office_data.dart';
import 'package:citizen_care_system/admin_pages/internal_services/postal_management/postal_tasks/postal_process_details.dart';
import 'package:citizen_care_system/component/request_service/action_button.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:citizen_care_system/component/request_service/date_picker_field.dart';
import 'package:citizen_care_system/component/request_service/dropdown_selector.dart';
import 'package:citizen_care_system/component/request_service/multi_select_dialog.dart';
import 'package:flutter/material.dart';

class PostalProcessFilterPage extends StatefulWidget {
  const PostalProcessFilterPage({super.key});

  @override
  State<PostalProcessFilterPage> createState() =>
      _PostalProcessFilterPageState();
}

class _PostalProcessFilterPageState extends State<PostalProcessFilterPage> {
  List<String> selectedOffices = [];
  List<String> selectedReqStatus = []; //Inital ReqStatus
  List<String> availableReqStatus = [
    //Available ReqStatus
    'Request Pending',
    'Request Completed',
    'Request Rejected'
  ];

  List<String> selectedReplyStatus = [];
  List<String> availableReplyStatus = [
    'Replied less than 3 days',
    'Replied 3 - 7 days',
    'Replied 7 - 30 days',
    'Replied after 30 days',
    'Never replied'
  ];

  String? selectedStatus;
  DateTime? startDate;
  DateTime? endDate;

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
                      'Postal Process',
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

              // Offices Dropdown
              const Center(
                child: Text(
                  'Select the Offices',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DropdownSelector(
                hintText: selectedOffices.isEmpty
                    ? 'Nothing Selected'
                    : '${selectedOffices.length} offices selected',
                onTap: () => _showOfficesDialog(context),
                hasSelection: selectedOffices.isNotEmpty,
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

              // Status Dropdown - Request Status
              const Center(
                child: Text(
                  'Select Request status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DropdownSelector(
                hintText: selectedReqStatus.isEmpty
                    ? 'Nothing Selected'
                    : '${selectedReqStatus.length} selected',
                onTap: () => _showReqStatusDialog(context),
                hasSelection: selectedReqStatus.isNotEmpty,
              ),
              const SizedBox(height: 24),

              // Status Dropdown - Reply Status
              const Center(
                child: Text(
                  'Select Reply status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DropdownSelector(
                hintText: selectedReplyStatus.isEmpty
                    ? 'Nothing Selected'
                    : '${selectedReplyStatus.length} selected',
                onTap: () => _showReplyStatusDialog(context),
                hasSelection: selectedReplyStatus.isNotEmpty,
              ),
              const SizedBox(height: 24),

              // View Task Button
              Column(
                children: [
                  Center(
                    child: ActionButton(
                      text: 'View Data',
                      icon: Icons.description,
                      onPressed: () {
                        // Validate that services and dates are selected
                        if (selectedOffices.isEmpty) {
                          _showValidationError(
                              context, 'Please select at least one office');
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
                                  const PostalProcessDetails(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
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

  Future<void> _showOfficesDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: 'Select Offices',
          items: OfficeData.availableOffcies,
          initialSelection: selectedOffices,
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedOffices = newSelection;
            });
          },
        );
      },
    );
  }

  Future<void> _showReqStatusDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: 'Select Request Status',
          items: availableReqStatus,
          initialSelection: selectedReqStatus,
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedReqStatus = newSelection;
            });
          },
        );
      },
    );
  }

  Future<void> _showReplyStatusDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: 'Select Reply Status',
          items: availableReplyStatus,
          initialSelection: selectedReplyStatus,
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedReplyStatus = newSelection;
            });
          },
        );
      },
    );
  }
}
