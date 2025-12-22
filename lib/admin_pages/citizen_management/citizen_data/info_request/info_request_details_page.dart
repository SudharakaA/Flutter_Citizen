import 'package:citizen_care_system/admin%20_component/citizen_service_task/download_dialog.dart';
import 'package:citizen_care_system/admin%20_component/store_admin/item_search_dialog.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/info_request/info_request_filter_page.dart';
import 'package:citizen_care_system/component/admin_circle_menu/fab_menu.dart';
import 'package:citizen_care_system/component/admin_circle_menu/hover_tap_button.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoRequestDetailsPage extends StatefulWidget {
  const InfoRequestDetailsPage({super.key});

  @override
  _InfoRequestDetailsPageState createState() => _InfoRequestDetailsPageState();
}

class _InfoRequestDetailsPageState extends State<InfoRequestDetailsPage> {
  String _searchQuery = '';
  bool _isFilterActive = false;

  int _currentPage = 0;
  final int _rowsPerPage = 10;

  List<Map<String, String>> itemsData = List.generate(
    30,
    (index) => {
      'Created at': '2024-05-${(index % 30 + 1).toString().padLeft(2, '0')}',
      'Reference': 'REQ-${(100000 + index).toString()}',
      'Citizen Name': 'Citizen ${index + 1}',
      'Contact Number': '077${(1000000 + index).toString().padLeft(7, '0')}',
      'GN Division': 'Division ${index % 5 + 1}',
      'Status': index % 3 == 0
          ? 'Delivered'
          : index % 3 == 1
              ? 'Pending'
              : 'Processing',
    },
  );

  List<Map<String, String>> _filteredItems = [];

  List<Map<String, String>> get _paginatedItems {
    final listToUse = _isFilterActive ? _filteredItems : itemsData;
    int start = _currentPage * _rowsPerPage;
    int end = start + _rowsPerPage;
    return listToUse.sublist(
      start,
      end > listToUse.length ? listToUse.length : end,
    );
  }

  int get _totalPages {
    final listToUse = _isFilterActive ? _filteredItems : itemsData;
    return (listToUse.length / _rowsPerPage).ceil();
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
              "Information Requests",
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

            // Data Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: screenWidth * 0.05,
                    columns: const [
                      DataColumn(label: Text("Created At")),
                      DataColumn(label: Text("Reference")),
                      DataColumn(label: Text("Citizen Name")),
                      DataColumn(label: Text("Contact Number")),
                      DataColumn(label: Text("GN Division")),
                      DataColumn(label: Text("Status")),
                    ],
                    rows: _paginatedItems.map((item) {
                      return DataRow(cells: [
                        DataCell(Text(item['Created at']!)),
                        DataCell(Text(item['Reference']!)),
                        DataCell(Text(item['Citizen Name']!)),
                        DataCell(Text(item['Contact Number']!)),
                        DataCell(Text(item["GN Division"]!)),
                        DataCell(Text(item["Status"]!)),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Pagination controls
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _currentPage > 0
                        ? () => setState(() => _currentPage--)
                        : null,
                  ),
                  Text(
                    'Page ${_currentPage + 1} of $_totalPages',
                    style: GoogleFonts.inter(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _currentPage < _totalPages - 1
                        ? () => setState(() => _currentPage++)
                        : null,
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
            icon: Icons.filter,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InfoRequestFilterPage()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.search,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => ItemSearchDialog(
                  onSearch: (query) {
                    setState(() {
                      _searchQuery = query;
                      _filteredItems = itemsData
                          .where((item) => item['Citizen Name']!
                              .toLowerCase()
                              .contains(_searchQuery))
                          .toList();
                      _isFilterActive = true;
                      _currentPage = 0;
                    });
                  },
                ),
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
