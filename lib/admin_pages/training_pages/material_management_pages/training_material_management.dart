import 'package:citizen_care_system/admin%20_component/citizen_service_task/download_dialog.dart';
import 'package:citizen_care_system/admin_pages/training_pages/material_management_pages/add_new_material.dart';
import 'package:citizen_care_system/admin_pages/training_pages/material_management_pages/view_training_material_management_details.dart';
import 'package:citizen_care_system/component/admin_circle_menu/fab_menu.dart';
import 'package:citizen_care_system/component/admin_circle_menu/hover_tap_button.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingMaterialManagementPage extends StatefulWidget {
  final List<String>? selectedLocations;
  final List<String>? selectedServiceType;
  final DateTime? startDate;
  final DateTime? endDate;

  const TrainingMaterialManagementPage({
    super.key,
    this.selectedServiceType,
    this.selectedLocations,
    this.startDate,
    this.endDate,
  });

  @override
  State<TrainingMaterialManagementPage> createState() => _TrainingMaterialManagementPageState();
}

class _TrainingMaterialManagementPageState extends State<TrainingMaterialManagementPage> {
  List<Map<String, dynamic>> materialData = [];
  int? selectedRowIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool hasFiltersApplied = false;

  List<Map<String, dynamic>> dummyMaterialData = [
    {
      'enteredAt': '2025-03-19',
      'enteredBy': 'Amal',
      'trainingProgramme': 'state Finance',
      'materialTitle': 'Financial Regulations Handbook',
      'accessLink': 'https://example.com/monetary-regs',
    },
    {
      'enteredAt': '2025-04-20',
      'enteredBy': 'Kanthi',
      'trainingProgramme': 'Audit Training',
      'materialTitle': 'Audit Procedures Guide',
      'accessLink': 'https://example.com/audit-guide',
    },
    {
      'enteredAt': '2025-02-12',
      'enteredBy': 'Munasinghe',
      'trainingProgramme': 'Financial Management',
      'materialTitle': 'Budget Planning Manual',
      'accessLink': 'https://example.com/budget-manual',
    },
    {
      'enteredAt': '2025-01-15',
      'enteredBy': 'Nimal',
      'trainingProgramme': 'State Finance',
      'materialTitle': 'Government Finance Basics',
      'accessLink': 'https://example.com/state-finance',
    },
    {
      'enteredAt': '2025-05-10',
      'enteredBy': 'Asela',
      'trainingProgramme': 'Computer Training',
      'materialTitle': 'Computer Training Basics',
      'accessLink': 'https://example.com/computer-training',
    },
  ];

  final List<String> columnLabels = [
    'Entered At',
    'Entered By',
    'Training Programme',
    'Material Title',
    'Access Link',
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
        widget.startDate != null ||
        widget.endDate != null;
  }

  void _filterData() {
    // If no filters are applied and no search query, show empty
    if (!hasFiltersApplied && searchQuery.isEmpty) {
      materialData = [];
      return;
    }

    // If filters are applied, start with all data and filter it
    materialData = dummyMaterialData.where((data) {
      // Service Type filter - if no service types selected, show all
      // if service types are selected, check if training programme matches
      bool matchesServiceType = true;
      if (widget.selectedServiceType != null && widget.selectedServiceType!.isNotEmpty) {
        matchesServiceType = widget.selectedServiceType!.any((serviceType) => 
          data['trainingProgramme']?.toLowerCase().contains(serviceType.toLowerCase()) ?? false);
      }

      // Location filter - since there's no location field, always match
      bool matchesLocation = true;

      // Date filters
      bool matchesStartDate = true;
      bool matchesEndDate = true;
      if (widget.startDate != null || widget.endDate != null) {
        final enteredAt = DateTime.tryParse(data['enteredAt'] ?? '');
        if (enteredAt != null) {
          if (widget.startDate != null) {
            matchesStartDate = enteredAt.isAfter(widget.startDate!.subtract(const Duration(days: 1)));
          }
          if (widget.endDate != null) {
            matchesEndDate = enteredAt.isBefore(widget.endDate!.add(const Duration(days: 1)));
          }
        } else {
          // If can't parse date, exclude from results when date filters are applied
          matchesStartDate = false;
          matchesEndDate = false;
        }
      }

      // Search filter - search in both training programme and material title
      bool matchesSearch = true;
      if (searchQuery.isNotEmpty) {
        matchesSearch = (data['trainingProgramme']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
                      (data['materialTitle']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      }

      return matchesServiceType && matchesLocation && matchesStartDate && matchesEndDate && matchesSearch;
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
              'Training Material Management',
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
            if (hasFiltersApplied || materialData.isNotEmpty) ...[
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by Training Programme or Material Title',
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
                  rows: materialData.isEmpty
                      ? [
                          DataRow(cells: [
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
                          materialData.length,
                          (index) {
                            final row = materialData[index];
                            final isSelected = selectedRowIndex == index;

                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  return isSelected ? const Color.fromARGB(255, 202, 241, 156) : null;
                                },
                              ),
                              cells: [
                                DataCell(Text(row['enteredAt'] ?? '')),
                                DataCell(Text(row['enteredBy'] ?? '')),
                                DataCell(Text(row['trainingProgramme'] ?? '')),
                                DataCell(Text(row['materialTitle'] ?? '')),
                                DataCell(Text(row['accessLink'] ?? '')),
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
            icon: Icons.add,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddNewMaterial()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.view_list,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewTrainingMaterialManagementDetails()),
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
        title: const Text('Training Material Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Training Programme: ${data['trainingProgramme']}'),
            Text('Entered At: ${data['enteredAt']}'),
            Text('Entered By: ${data['enteredBy']}'),
            Text('Material Title: ${data['materialTitle']?.isEmpty ?? true ? 'Not provided' : data['materialTitle']}'),
            Text('Access Link: ${data['accessLink']?.isEmpty ?? true ? 'Not provided' : data['accessLink']}'),
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
        title: const Text('Delete Training Material'),
        content: const Text('Are you sure you want to delete this training material?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                materialData.removeAt(index);
                if (selectedRowIndex == index) {
                  selectedRowIndex = null;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Training material deleted successfully')),
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