import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/admin_circle_menu/fab_menu.dart';
import '../../../component/admin_circle_menu/hover_tap_button.dart';
import '../../../admin _component/citizen_service_task/download_dialog.dart';
import '../header_configuration/add_header.dart';

class FinanceHeaderPage extends StatefulWidget {
  const FinanceHeaderPage({super.key});

  @override
  State<FinanceHeaderPage> createState() => _FinanceHeaderPageState();
}

class _FinanceHeaderPageState extends State<FinanceHeaderPage> {
  List<Map<String, dynamic>> storeData = [];
  int? selectedRowIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool showTable = false;

  final List<Map<String, dynamic>> headerStoreData = [
    {
      "createdAt": "2024-12-05",
      "createdBy": "Admin",
      "headerCode": "FIN001",
      "headerName": "Finance Header 1",
      "defaultAmount": 100,
    },
    {
      "createdAt": "2025-02-05",
      "createdBy": "Admin",
      "headerCode": "FIN002",
      "headerName": "Finance Header 2",
      "defaultAmount": 50,
    },
    {
      "createdAt": "2024-05-05",
      "createdBy": "Admin",
      "headerCode": "FIN003",
      "headerName": "Finance Header 3",
      "defaultAmount": 10,
    }
  ];

  final List<String> columnLabels = [
    'Created Dtm',
    'Created',
    'Header Code',
    'Header Name',
    'Default Amount',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterData() {
    storeData = headerStoreData.where((data) {
      if (searchQuery.isEmpty) return true;

      // Search all columns
      return data.values.any(
        (value) => value
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
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
              "Finance Header Configuration",
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

            if (showTable) ...[
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by any field',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenWidth * 0.035,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                rows: showTable
                    ? (storeData.isEmpty
                        ? [
                            DataRow(
                              cells: List.generate(
                                columnLabels.length,
                                (_) => const DataCell(Text('-')),
                              ),
                            )
                          ]
                        : List<DataRow>.generate(
                            storeData.length,
                            (index) {
                              final row = storeData[index];
                              final isSelected = selectedRowIndex == index;

                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                    return isSelected
                                        ? const Color.fromARGB(255, 202, 241, 156)
                                        : null;
                                  },
                                ),
                                cells: [
                                  DataCell(Text(row['createdAt'] ?? '')),
                                  DataCell(Text(row['createdBy'] ?? '')),
                                  DataCell(Text(row['headerCode'] ?? '')),
                                  DataCell(Text(row['headerName'] ?? '')),
                                  DataCell(Text(row['defaultAmount']?.toString() ?? '')),
                                ],
                                onSelectChanged: (_) {
                                  setState(() {
                                    selectedRowIndex = index;
                                  });
                                },
                              );
                            },
                          ))
                    : [
                        DataRow(
                          cells: List.generate(
                            columnLabels.length,
                            (_) => const DataCell(Text('-')),
                          ),
                        ),
                      ],
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
                MaterialPageRoute(builder: (context) => const AddHeaderPage()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.view_list,
            onTap: () {
              setState(() {
                showTable = !showTable;
                if (showTable) {
                  _filterData();
                }
              });
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
          )
        ],
      ),
    );
  }
}
