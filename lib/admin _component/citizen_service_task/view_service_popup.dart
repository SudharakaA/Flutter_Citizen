import 'package:flutter/material.dart';
import '../../component/request_service/dropdown_selector.dart';
import '../../component/request_service/date_picker_field.dart';
import '../../component/request_service/action_button.dart';
import '../../component/request_service/multi_select_dialog.dart';
import '../../model/service_data.dart';
import '../../admin_pages/citizen_services_pages/service_details_page.dart';

class ViewServicePopup extends StatefulWidget {
  const ViewServicePopup({super.key});

  @override
  State<ViewServicePopup> createState() => _ViewServicePopupState();
}

class _ViewServicePopupState extends State<ViewServicePopup> {
  List<String> selectedServices = [];
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Citizen Services',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'Select the Services',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),

              DropdownSelector(
                hintText: selectedServices.isEmpty
                    ? 'Nothing Selected'
                    : '${selectedServices.length} services selected',
                onTap: () => _showServicesDialog(context),
                hasSelection: selectedServices.isNotEmpty,
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
                  icon: Icons.description,
                  text: 'View Task',
                  onPressed: () {
                    // Validate that services and dates are selected
                    if (selectedServices.isEmpty) {
                      _showValidationError(
                          context, 'Please select at least one service');
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
                          builder: (context) => ServiceDetailsPage(
                            selectedServices: selectedServices, accessToken: '', citizenCode: '',
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

  void _showValidationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showServicesDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: ServiceData.availableServices,
          initialSelection: selectedServices,
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedServices = newSelection;
            });
          },
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
