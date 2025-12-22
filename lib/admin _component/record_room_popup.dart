import 'package:flutter/material.dart';
import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../component/admin_circle_menu/fab_menu.dart';
import '../../component/admin_circle_menu/hover_tap_button.dart';
import '../../admin _component/record_room_admin/add_record_room_page.dart';
import '../../admin _component/record_room_admin/edit_record_room_page.dart';
import '../../admin _component/record_room_admin/view_record_room_page.dart';
import '../../admin _component/citizen_service_task/download_dialog.dart';

// Temporary stub imports for missing pages
// Replace these with your actual page imports
// Example: import 'package:your_app/screens/add_file_data.dart';
class RecordRoomPopup extends StatefulWidget {
  final List<String>? selectedLocations;
  final String? selectedType;
  final DateTime? startDate;
  final DateTime? endDate;

  const RecordRoomPopup({
    super.key,
    this.selectedLocations,
    this.selectedType,
    this.startDate,
    this.endDate,
  });

  @override
  State<RecordRoomPopup> createState() => _RecordRoomPopupState();
}

class _RecordRoomPopupState extends State<RecordRoomPopup> {
  List<Map<String, dynamic>> storeData = [];
  int? selectedRowIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  List<Map<String, dynamic>> dummyStoreData = [
    {
      'recordTitle': 'ABED',
      'recordLocation': 'Larkspur - DS Office',
      'createdAt': '2025-04-15',
      'Reference': 'Admin C',
      'recordNumber': 'Available',
      'Status': 'Person Z',
    },
    {
      'recordTitle': 'Computer Ribbon',
      'recordLocation': 'Larkspur - DS Office',
      'createdAt': '2025-03-10',
      'Reference': 'Admin C',
      'recordNumber': 'Not Available',
      'Status': 'Person A',
    },
    {
      'recordTitle': 'Computer Ribbon',
      'recordLocation': 'Larkspur - DS Office',
      'createdAt': '2025-03-10',
      'Reference': 'Admin C',
      'recordNumber': 'Available',
      'Status': 'Person M',
    },
  ];

  final List<String> columnLabels = [
    'Record Title',
    'Record Location',
    'Created At',
    'Reference',
    'Record Number',
    'Status',
    '',
  ];

  @override
  void initState() {
    super.initState();
    _filterData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterData() {
    if ((widget.selectedLocations == null || widget.selectedLocations!.isEmpty) &&
        widget.selectedType == null &&
        widget.startDate == null &&
        widget.endDate == null &&
        searchQuery.isEmpty) {
      storeData = [];
      return;
    }

    storeData = dummyStoreData.where((data) {
      final matchesLocation = widget.selectedLocations == null ||
          widget.selectedLocations!.contains(data['Record location']);

      final matchesType = widget.selectedType == null ||
          widget.selectedType == data['Record Number'];

      final createdAt = DateTime.tryParse(data['createdAt']);
      final matchesStartDate = widget.startDate == null ||
          (createdAt != null && createdAt.isAfter(widget.startDate!.subtract(const Duration(days: 1))));
      final matchesEndDate = widget.endDate == null ||
          (createdAt != null && createdAt.isBefore(widget.endDate!.add(const Duration(days: 1))));

      final matchesSearch = searchQuery.isEmpty ||
          (data['Record Title']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

      return matchesLocation && matchesType && matchesStartDate && matchesEndDate && matchesSearch;
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
              'Record Management',
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

            if (storeData.isNotEmpty) ...[
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by file',
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
                  contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.015),
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

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade300),
                columns: columnLabels.map((label) => DataColumn(
                  label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                )).toList(),
                rows: storeData.isEmpty
                    ? [DataRow(cells: List.generate(columnLabels.length, (_) => const DataCell(Text('-'))))]
                    : List<DataRow>.generate(storeData.length, (index) {
                  final row = storeData[index];
                  final isSelected = selectedRowIndex == index;

                  return DataRow(
                    color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                      return isSelected ? const Color.fromARGB(255, 202, 241, 156) : null;
                    }),
                    cells: [
                      DataCell(Text(row['Record Title'] ?? '')),
                      DataCell(Text(row['Record location'] ?? '')),
                      DataCell(Text(row['createdAt'] ?? '')),
                      DataCell(Text(row['Reference'] ?? '')),
                      DataCell(Text(row['Record Number']?.toString() ?? '')),
                      DataCell(Text(row['Status'] ?? '')),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.description),
                            onPressed: () {
                              // Handle Edit
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Handle Delete
                            },
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
                MaterialPageRoute(builder: (context) => const AddRecordRoomPage()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.edit,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditRecordRoomPage()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.view_list,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewRecordRoomPage()),
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
}
