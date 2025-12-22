import 'package:citizen_care_system/admin%20_component/citizen_service_task/download_dialog.dart';
import 'package:citizen_care_system/admin_pages/training_pages/course_management_pages/add_new_course.dart';
import 'package:citizen_care_system/admin_pages/training_pages/course_management_pages/view_training_course_details.dart';
import 'package:citizen_care_system/component/admin_circle_menu/fab_menu.dart';
import 'package:citizen_care_system/component/admin_circle_menu/hover_tap_button.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingCourseManagementPage extends StatefulWidget {
  final List<String>? selectedServiceType;

  const TrainingCourseManagementPage({
    super.key,
    this.selectedServiceType,
  });

  @override
  State<TrainingCourseManagementPage> createState() => _TrainingCourseManagementPageState();
}

class _TrainingCourseManagementPageState extends State<TrainingCourseManagementPage> {
  List<Map<String, dynamic>> courseData = [];
  int? selectedRowIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool hasFiltersApplied = false;

  final List<Map<String, dynamic>> dummyCourseData = [
    {
      'createdAt': '2025-03-19',
      'createdBy': 'Sirisena',
      'courseCategory': 'Monetary regulations',
      'trainingCourse': 'State Finance',
    },
    {
      'createdAt': '2025-04-22',
      'createdBy': 'Nadee',
      'courseCategory': 'Audit Procedures',
      'trainingCourse': 'Rules Acts',
    },
    {
      'createdAt': '2025-05-03',
      'createdBy': 'Anil Kumara',
      'courseCategory': 'Leadership Skills',
      'trainingCourse': 'Language Training',
    },
  ];

  final List<String> columnLabels = [
    'Created At',
    'Created By',
    'Course Category',
    'Training Course',
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
    hasFiltersApplied = widget.selectedServiceType != null && widget.selectedServiceType!.isNotEmpty;
  }

  void _filterData() {
    if (!hasFiltersApplied && searchQuery.isEmpty) {
      courseData = [];
      return;
    }

    courseData = dummyCourseData.where((data) {
      bool matchesServiceType = true;
      if (widget.selectedServiceType != null && widget.selectedServiceType!.isNotEmpty) {
        matchesServiceType = widget.selectedServiceType!.any((type) =>
            data['trainingCourse']?.toLowerCase().contains(type.toLowerCase()) ?? false);
      }

      bool matchesSearch = searchQuery.isEmpty ||
          (data['trainingCourse']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

      return matchesServiceType && matchesSearch;
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
              'Training Course Configuration',
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

            if (hasFiltersApplied || courseData.isNotEmpty) ...[
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by Training Course',
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
                    vertical: screenHeight * 0.015,
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

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor: WidgetStateProperty.all(Colors.grey.shade300),
                  columns: columnLabels
                      .map((label) => DataColumn(
                            label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ))
                      .toList(),
                  rows: courseData.isEmpty
                      ? [
                          DataRow(cells: [
                            const DataCell(Text('-')),
                            const DataCell(Text('-')),
                            const DataCell(Text('-')),
                            const DataCell(Text('-')),
                            DataCell(
                              hasFiltersApplied
                                  ? const Text('No matching data')
                                  : const Text('_'),
                            ),
                          ])
                        ]
                      : List<DataRow>.generate(courseData.length, (index) {
                          final row = courseData[index];
                          final isSelected = selectedRowIndex == index;

                          return DataRow(
                            color: WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                return isSelected ? const Color.fromARGB(255, 202, 241, 156) : null;
                              },
                            ),
                            cells: [
                              DataCell(Text(row['createdAt'] ?? '')),
                              DataCell(Text(row['createdBy'] ?? '')),
                              DataCell(Text(row['courseCategory'] ?? '')),
                              DataCell(Text(row['trainingCourse'] ?? '')),
                              DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.description, color: Colors.blue),
                                    onPressed: () => _showDetailsDialog(context, row),
                                    tooltip: 'View Details',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _showDeleteDialog(context, index),
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
                        }),
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
                MaterialPageRoute(builder: (context) => const AddNewCourse()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.view_list,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewTrainingCourseDetails()),
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
        title: const Text('Course Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Training Course: ${data['trainingCourse']}'),
            Text('Created At: ${data['createdAt']}'),
            Text('Created By: ${data['createdBy']}'),
            Text('Course Category: ${data['courseCategory'] ?? 'Not specified'}'),
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
        title: const Text('Delete Course Entry'),
        content: const Text('Are you sure you want to delete this course entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                courseData.removeAt(index);
                if (selectedRowIndex == index) {
                  selectedRowIndex = null;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Course entry deleted successfully')),
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
