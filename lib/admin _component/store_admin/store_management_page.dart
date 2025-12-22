import 'package:flutter/material.dart';
import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../component/admin_circle_menu/fab_menu.dart';
import '../../component/admin_circle_menu/hover_tap_button.dart';
import '../store_admin/add_new_store_data.dart';
import '../../admin _component/citizen_service_task/download_dialog.dart';
import '../../admin _component/store_admin/edit_store_data.dart';
import '../../admin _component/store_admin/view_store_page.dart';

class StoreManagementPage extends StatefulWidget {
  final List<String>? selectedLocations;
  final String? selectedType;
  final DateTime? startDate;
  final DateTime? endDate;

  const StoreManagementPage({
    super.key,
    this.selectedLocations,
    this.selectedType,
    this.startDate,
    this.endDate,
  });

  @override
  State<StoreManagementPage> createState() => _StoreManagementPageState();
}

class _StoreManagementPageState extends State<StoreManagementPage> {
  List<Map<String, dynamic>> storeData = [];
  int? selectedRowIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  List<Map<String, dynamic>> dummyStoreData = [
    {
      'itemName': 'Paper',
      'location': 'Thamankaduwa - DS Office',
      'createdAt': '2024-12-01',
      'createdBy': 'Admin A',
      'quantity': 100,
      'updatedAt': '2025-01-01',
      'updateMethod': 'Addition',
      'issuedTo': 'Person X',
    },
    {
      'itemName': 'Books',
      'location': 'Higurakgoda - DS Office',
      'createdAt': '2025-01-15',
      'createdBy': 'Admin B',
      'quantity': 50,
      'updatedAt': '2025-02-01',
      'updateMethod': 'Removal',
      'issuedTo': 'Person Y',
    },
    {
      'itemName': 'Computer Ribbon',
      'location': 'Lankapura - DS Office',
      'createdAt': '2025-03-10',
      'createdBy': 'Admin C',
      'quantity': 80,
      'updatedAt': '2025-03-20',
      'updateMethod': 'Addition',
      'issuedTo': 'Person Z',
    },
  ];

  final List<String> columnLabels = [
    'Item Name',
    'Store Location',
    'Created At',
    'Created By',
    'Item Qty.',
    'Updated At',
    'Method of Update',
    'Issued To',
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
          widget.selectedLocations!.contains(data['location']);

      final matchesType = widget.selectedType == null ||
          widget.selectedType == data['updateMethod'];

      final createdAt = DateTime.tryParse(data['createdAt']);
      final matchesStartDate = widget.startDate == null ||
          (createdAt != null && createdAt.isAfter(widget.startDate!.subtract(const Duration(days: 1))));
      final matchesEndDate = widget.endDate == null ||
          (createdAt != null && createdAt.isBefore(widget.endDate!.add(const Duration(days: 1))));

      final matchesSearch = searchQuery.isEmpty ||
          (data['itemName']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

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
              'Store Management',
              style: GoogleFonts.inter(
                fontSize: screenWidth * 0.045,
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

            // Search Bar - Only visible when storeData is not empty
            if (storeData.isNotEmpty) ...[
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by Item Name',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenWidth * 0.035,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  filled : true,
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
                    borderSide:
                        const BorderSide(color: Colors.green, width: 2.0),
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

            // Data Table
            SingleChildScrollView(
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
                rows: storeData.isEmpty
                    ? [
                        DataRow(cells: List.generate(
                          columnLabels.length,
                          (_) => const DataCell(Text('-')),
                        ))
                      ]
                    : List<DataRow>.generate(
                        storeData.length,
                        (index) {
                          final row = storeData[index];
                          final isSelected = selectedRowIndex == index;

                          return DataRow(
                            color: WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                return isSelected ? const Color.fromARGB(255, 202, 241, 156) : null;
                              },
                            ),
                            cells: [
                              DataCell(Text(row['itemName'] ?? '')),
                              DataCell(Text(row['location'] ?? '')),
                              DataCell(Text(row['createdAt'] ?? '')),
                              DataCell(Text(row['createdBy'] ?? '')),
                              DataCell(Text(row['quantity']?.toString() ?? '')),
                              DataCell(Text(row['updatedAt'] ?? '')),
                              DataCell(Text(row['updateMethod'] ?? '')),
                              DataCell(Text(row['issuedTo'] ?? '')),
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
                        },
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
                MaterialPageRoute(builder: (context) => const AddStoreData()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.edit,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditStoreData()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.view_list,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewStoreData()),
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
