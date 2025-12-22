import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/info_request/office_data.dart';
import 'package:citizen_care_system/component/popup_select_dropdown.dart';
import 'package:citizen_care_system/component/request_service/action_button.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:citizen_care_system/component/request_service/date_picker_field.dart';
import 'package:citizen_care_system/component/request_service/dropdown_selector.dart';
import 'package:citizen_care_system/component/request_service/multi_select_dialog.dart';
import 'package:flutter/material.dart';

import 'info_request_details_page.dart';

class InfoRequestFilterPage extends StatefulWidget {
  const InfoRequestFilterPage({super.key});

  @override
  State<InfoRequestFilterPage> createState() => _InfoRequestPageState();
}

class _InfoRequestPageState extends State<InfoRequestFilterPage> {
  List<String> selectedOffices = [];
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
      backgroundColor: Colors.white,
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFFE3E3E3),
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
                      'Information Request',
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

              // Status Dropdown
              const Center(
                child: Text(
                  'Select status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              PopupSelectDropdown(
                  items: const ["Requested", "Delivered"],
                  selectedValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  }),

              const SizedBox(height: 16),

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
                          builder: (context) => const InfoRequestDetailsPage(
                              // requestDetails:mockRequestDetails,
                              //selectedOffices: selectedOffices,
                              ),
                        ),
                      );
                    }
                  },
                ),
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
}
