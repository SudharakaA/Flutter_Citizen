import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../admin _component/project_planning/checkbox_dropdown_selector.dart';
import '../../../component/request_service/date_picker_field.dart';
import '../../../component/request_service/action_button.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/custom_app_bar.dart';
import '../../../admin_pages/projects_planning_pages/project_request_pages/view_project_details_page.dart';

class PlanningProposalPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const PlanningProposalPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<PlanningProposalPage> createState() => _PlanningProposalPageState();
}

class _PlanningProposalPageState extends State<PlanningProposalPage> {
  List<String> selectedOffices = [];
  String? selectedStatus;
  List<String> selectedProjectTypes = [];
  DateTime? startDate;
  DateTime? endDate;

  List<String> offices = []; // fetched from API
  Map<String, String> officeToIdMap = {}; // officeName -> id
  bool isLoadingOffices = true;

  final List<String> statuses = [
    'Proposal Submitted',
    'Project Assigned',
  ];

  final List<String> projectTypes = [
    'Construction',
    'Purchasing',
  ];

  @override
  void initState() {
    super.initState();
    fetchOffices(); // load offices when page starts
  }

  Future<void> fetchOffices() async {
    try {
      final response = await http.post(
        Uri.parse(
            "http://220.247.224.226:8401/CCSHubApi/api/MainApi/PrivilegedLocationsRequested?username=901920664V&viewName=proposalsubmission"), // 🔗 replace with your real endpoint
        headers: {
          "Authorization": "Bearer ${widget.accessToken}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded.containsKey('isSuccess')) {
          if (decoded['isSuccess'] == true) {
            if (decoded.containsKey('dataBundle') &&
                decoded['dataBundle'] is List) {
              final List<dynamic> data = decoded['dataBundle'];
              setState(() {
                offices.clear();
                officeToIdMap.clear();
                for (var item in data) {
                  final name = item["LOCATION"];
                  final id = item["LOCATION_ID"].toString();
                  offices.add(name);
                  officeToIdMap[name] = id;
                }
                isLoadingOffices = false;
              });
            }
          }
        }
      } else {
        debugPrint("Failed to fetch offices: ${response.statusCode}");
        setState(() => isLoadingOffices = false);
      }
    } catch (e) {
      debugPrint("Error fetching offices: $e");
      setState(() => isLoadingOffices = false);
    }
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
                      'Planning Proposals',
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

              // DS Office selector
              const Center(
                child: Text(
                  'Select the Office(s)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              isLoadingOffices
                  ? const Center(child: CircularProgressIndicator())
                  : CheckboxDropdownSelector(
                      title: 'Offices',
                      options: offices,
                      selectedItems: selectedOffices,
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          selectedOffices = newSelection;
                        });
                      },
                    ),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'Select the Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),

              SingleDropdownSelector(
                title: "Colors",
                options: statuses,
                selectedItem: selectedStatus,
                onSelectionChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
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
                  text: 'View Proposals',
                  icon: Icons.description,
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
    if (selectedOffices.isEmpty) {
      _showValidationError('Please select at least one office.');
    } else if (selectedStatus == null) {
      _showValidationError('Please select at least one status.');
    } else if (selectedProjectTypes.isEmpty) {
      _showValidationError('Please select at least one project type.');
    } else if (startDate == null) {
      _showValidationError('Please select a start date.');
    } else if (endDate == null) {
      _showValidationError('Please select an end date.');
    } else if (endDate!.isBefore(startDate!)) {
      _showValidationError('End date cannot be before start date.');
    } else {
      // Map selectedOffices to location IDs
      List<String> locationIdList =
          selectedOffices.map((office) => officeToIdMap[office]!).toList();

      // Navigate to ViewProjectDetailsPage with filter parameters
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewProjectDetailsPage(
            citizenCode: widget.citizenCode,
            accessToken: widget.accessToken,
            selectedServices: selectedProjectTypes,
            selectedOffices: locationIdList, // Pass IDs instead of names
            selectedStatus: selectedStatus, // Pass single status as a list
            startDate: startDate,
            endDate: endDate,
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

//Single Dropdown Selection Component
class SingleDropdownSelector extends StatelessWidget {
  final String? title;
  final List<String>? options;
  final String? selectedItem;
  final Function(String?)? onSelectionChanged;

  const SingleDropdownSelector({
    super.key,
    this.title,
    this.options,
    this.selectedItem,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = selectedItem != null && selectedItem!.isNotEmpty;

    return InkWell(
      onTap: () => _showSingleSelectDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hasSelection ? selectedItem! : 'Nothing Selected',
              style: TextStyle(
                fontSize: 16,
                color: hasSelection ? Colors.black : Colors.grey,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showSingleSelectDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => _StyledSingleSelectDialog(
        title: title ?? 'Select Option',
        items: options ?? [],
        initialSelection: selectedItem,
        onApply: (selected) => onSelectionChanged?.call(selected),
      ),
    );
  }
}

class _StyledSingleSelectDialog extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? initialSelection;
  final Function(String?) onApply;

  const _StyledSingleSelectDialog({
    required this.title,
    required this.items,
    required this.initialSelection,
    required this.onApply,
  });

  @override
  State<_StyledSingleSelectDialog> createState() =>
      _StyledSingleSelectDialogState();
}

class _StyledSingleSelectDialogState extends State<_StyledSingleSelectDialog> {
  String? tempSelection;

  @override
  void initState() {
    super.initState();
    tempSelection = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Select ${widget.title}'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: ListView.builder(
            controller: scrollController,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return RadioListTile<String>(
                title: Text(item),
                value: item,
                groupValue: tempSelection,
                onChanged: (String? selected) {
                  setState(() {
                    tempSelection = selected;
                  });
                },
                activeColor: const Color(0xFF3A7D44),
                dense: true,
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              tempSelection = null; // Clear selection
            });
          },
          child: const Text(
            'Clear',
            style: TextStyle(color: Color(0xFF3A7D44)),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF3A7D44)),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onApply(tempSelection);
            Navigator.of(context).pop();
          },
          child: const Text(
            'Apply',
            style: TextStyle(color: Color(0xFF3A7D44)),
          ),
        ),
      ],
    );
  }
}
