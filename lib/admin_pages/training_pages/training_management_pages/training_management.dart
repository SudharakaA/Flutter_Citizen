import 'package:citizen_care_system/admin%20_component/citizen_service_task/download_dialog.dart';
import 'package:citizen_care_system/admin_pages/training_pages/training_management_pages/view_training_management_details.dart';
import 'package:citizen_care_system/component/admin_circle_menu/fab_menu.dart';
import 'package:citizen_care_system/component/admin_circle_menu/hover_tap_button.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingManagementPage extends StatefulWidget {
  final List<String>? selectedLocations;
  final List<String>? selectedServiceType;
  final String? selectedRequestType;
  final DateTime? startDate;
  final DateTime? endDate;

  const TrainingManagementPage({
    super.key,
    this.selectedLocations,
    this.selectedServiceType,
    this.selectedRequestType,
    this.startDate,
    this.endDate,
  });

  @override
  State<TrainingManagementPage> createState() => _TrainingManagementPageState();
}

class _TrainingManagementPageState extends State<TrainingManagementPage> {
  List<Map<String, dynamic>> requestData = [];
  int? selectedRowIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool hasFiltersApplied = false;

  List<Map<String, dynamic>> dummyManagementData = [
    {
      'requestedAt': '2025-03-19',
      'requestedBy': 'Nimal Perera',
      'trainingProgramme': 'Monetary regulations',
      'resourcePerson': 'Mr. Silva',
      'lastActionAt': '2025-03-20',
      'currentStatus': 'Requested',
    },
    {
      'requestedAt': '2025-04-20',
      'requestedBy': 'Nayani',
      'trainingProgramme': 'Sports',
      'resourcePerson': 'Ms. Perera',
      'lastActionAt': '2025-04-21',
      'currentStatus': 'Rejected',
    },
    {
      'requestedAt': '2025-02-12',
      'requestedBy': 'Bandara',
      'trainingProgramme': 'Financial Management',
      'resourcePerson': 'Dr. Fernando',
      'lastActionAt': '2025-02-13',
      'currentStatus': 'Allocated',
    },
    {
      'requestedAt': '2025-01-15',
      'requestedBy': 'Amali',
      'trainingProgramme': 'State Finance',
      'resourcePerson': 'Prof. Wickramasinghe',
      'lastActionAt': '2025-01-18',
      'currentStatus': 'Participated',
    },
    {
      'requestedAt': '2025-05-10',
      'requestedBy': 'Sarani',
      'trainingProgramme': 'Computer Training',
      'resourcePerson': '',
      'lastActionAt': '',
      'currentStatus': 'Requested',
    },
  ];

  final List<String> columnLabels = [
    'Requested At',
    'Requested By',
    'Training Programme',
    'Resource Person',
    'Last Action At',
    'Current Status',
    'Actions',
  ];

  @override
  void initState() {
    super.initState();
    _checkIfFiltersApplied();
    _filterData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _checkIfFiltersApplied() {
    hasFiltersApplied = (widget.selectedServiceType != null && widget.selectedServiceType!.isNotEmpty) ||
        (widget.selectedLocations != null && widget.selectedLocations!.isNotEmpty) ||
        widget.selectedRequestType != null ||
        widget.startDate != null ||
        widget.endDate != null;
  }

  void _filterData() {
    // Only show data if filters have been applied (coming from view page)
    if (!hasFiltersApplied && searchQuery.isEmpty) {
      requestData = [];
      return;
    }

    requestData = dummyManagementData.where((data) {
      // Service Type filter - check if training programme matches any selected service type
      final matchesServiceType = widget.selectedServiceType == null ||
          widget.selectedServiceType!.isEmpty ||
          widget.selectedServiceType!.any((serviceType) => 
            data['trainingProgramme']?.toLowerCase().contains(serviceType.toLowerCase()) ?? false);

      // Request Type filter
      final matchesRequestType = widget.selectedRequestType == null ||
          widget.selectedRequestType == data['currentStatus'];

      // Location filter
      final matchesLocation = widget.selectedLocations == null ||
          widget.selectedLocations!.isEmpty ||
          (data['location'] != null && widget.selectedLocations!.contains(data['location']));

      // Date filters
      final requestedAt = DateTime.tryParse(data['requestedAt'] ?? '');
      final matchesStartDate = widget.startDate == null ||
          (requestedAt != null && requestedAt.isAfter(widget.startDate!.subtract(const Duration(days: 1))));
      final matchesEndDate = widget.endDate == null ||
          (requestedAt != null && requestedAt.isBefore(widget.endDate!.add(const Duration(days: 1))));

      // Search filter - now searches both training programme and requested by
      final matchesSearch = searchQuery.isEmpty ||
          (data['trainingProgramme']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
          (data['requestedBy']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

      return matchesServiceType && matchesRequestType && matchesLocation && matchesStartDate && matchesEndDate && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      body: Container(
        margin: EdgeInsets.all(screenWidth * 0.03),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Training Management',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(
              thickness: 1,
              color: Colors.black38,
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(height: screenHeight * 0.02),

            // Search Bar - Only visible when filters are applied or there's data
            if (hasFiltersApplied || requestData.isNotEmpty) ...[
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by Training Programme or Requested By',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenWidth * 0.035,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: const BorderSide(color: Colors.green, width: 2.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02, 
                    vertical: screenHeight * 0.015
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _filterData();
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.03),
            ],

            // Data Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor: WidgetStateProperty.all(Colors.grey.shade300),
                  columns: columnLabels
                      .map((label) => DataColumn(
                            label: Text(label,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ))
                      .toList(),
                  rows: requestData.isEmpty
                      ? [
                          DataRow(cells: [
                            const DataCell(Text('-')),
                            const DataCell(Text('-')),
                            const DataCell(Text('-')),
                            const DataCell(Text('-')),
                            const DataCell(Text('-')),
                            const DataCell(Text('-')),
                            DataCell(
                              hasFiltersApplied 
                                ? const Text('No matching data')
                                : const Text('_')
                            ),
                          ])
                        ]
                      : List<DataRow>.generate(
                          requestData.length,
                          (index) {
                            final row = requestData[index];
                            final isSelected = selectedRowIndex == index;

                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  return isSelected ? const Color.fromARGB(255, 202, 241, 156) : null;
                                },
                              ),
                              cells: [
                                DataCell(Text(row['requestedAt'] ?? '')),
                                DataCell(Text(row['requestedBy'] ?? '')),
                                DataCell(Text(row['trainingProgramme'] ?? '')),
                                DataCell(Text(row['resourcePerson'] ?? '')),
                                DataCell(Text(row['lastActionAt'] ?? '')),
                                DataCell(Text(row['currentStatus'] ?? '')),
                                DataCell(Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.description, color: Colors.blue),
                                      onPressed: () {
                                        // Handle View Details
                                        _showDetailsDialog(context, row);
                                      },
                                      tooltip: 'View Details',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        // Handle Delete
                                        _showDeleteDialog(context, index);
                                      },
                                      tooltip: 'Delete',
                                    ),
                                  ],
                                )),
                              ],
                              onSelectChanged: (_) {
                                setState(() {
                                  selectedRowIndex = index;
                                });
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFabMenu(
        menuItems: [
          HoverTapButton(
            icon: Icons.view_list,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewTrainingManagementDetails()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.download,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const DownloadDialog(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Training Management Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Training Programme: ${data['trainingProgramme']}'),
            Text('Requested At: ${data['requestedAt']}'),
            Text('Requested By: ${data['requestedBy'] ?? 'Unknown'}'),
            Text('Resource Person: ${data['resourcePerson'] ?? 'Not assigned'}'),
            Text('Last Action At: ${data['lastActionAt'] ?? 'No action taken'}'),
            Text('Current Status: ${data['currentStatus']}'),
            Text('Location: ${data['location'] ?? 'Unknown'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Training Management'),
        content: const Text('Are you sure you want to delete this training management record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                dummyManagementData.removeAt(index);
                _filterData(); // Re-filter after deletion
                if (selectedRowIndex == index) {
                  selectedRowIndex = null;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Training management record deleted successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}