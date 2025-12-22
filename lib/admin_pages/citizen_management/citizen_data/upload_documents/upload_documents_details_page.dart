import 'package:citizen_care_system/admin%20_component/citizen_service_task/download_dialog.dart';
import 'package:citizen_care_system/admin%20_component/store_admin/item_search_dialog.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/upload_documents/add_document.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/upload_documents/upload_documents_filter_page.dart';
import 'package:citizen_care_system/component/admin_circle_menu/fab_menu.dart';
import 'package:citizen_care_system/component/admin_circle_menu/hover_tap_button.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadDocumentsDetailsPage extends StatefulWidget {
  const UploadDocumentsDetailsPage({super.key});

  @override
  _UploadDocumentsDetailsPageState createState() =>
      _UploadDocumentsDetailsPageState();
}

const List<String> availableDocTypes = [
  'Sesonal Meeting Decisions(Agriculture Help)',
  'Cultivations Advice(Agriculture Help)',
  'Price Commitee Decisions(Agriculture Help)',
  'Purchasing Harvest(Agriculture Help)',
  'Farmer News(Agriculture Help)',
  'Central Government(Government Notices)',
  'Provincial Council(Government Notices)',
  'District Secretariat(Government Notices)',
  'Grama Niladari(Government Notices)',
  'Divisional Secretatriat(Government Notices)',
  'Government Sector(Carrers)',
  'Private Sector(Carrers)',
  'Foreign(Carrers)',
  'Business Advice(Bussines Assistance)',
  'Business Training(Business Assistance)',
];

class _UploadDocumentsDetailsPageState
    extends State<UploadDocumentsDetailsPage> {
  String _searchQuery = '';
  bool _isFilterActive = false;

  int _currentPage = 0;
  final int _rowsPerPage = 10;

  List<Map<String, String>> itemsData = List.generate(
    30,
    (index) => {
      'Main Category': 'Category ${(index % 3)}',
      'Document Type': availableDocTypes[index % 5],
      'Created At': '2024-05-${(index % 30 + 1).toString().padLeft(2, '0')}',
      'Created By': 'Citizen ${index + 1}',
      'Document Title': 'Title ${(index % 4)}',
      'Expired On': '2024-05-${(index % 30 + 1).toString().padLeft(2, '0')}',
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
              "CCS Document Hub",
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
                      DataColumn(label: Text("Main Category")),
                      DataColumn(label: Text("Document Type")),
                      DataColumn(label: Text("Created At")),
                      DataColumn(label: Text("Created By")),
                      DataColumn(label: Text("Document Title")),
                      DataColumn(label: Text("Expired On")),
                    ],
                    rows: _paginatedItems.map((item) {
                      return DataRow(cells: [
                        DataCell(Text(item['Main Category']!)),
                        DataCell(Text(item['Document Type']!)),
                        DataCell(Text(item['Created At']!)),
                        DataCell(Text(item["Created By"]!)),
                        DataCell(Text(item["Document Title"]!)),
                        DataCell(Text(item["Expired On"]!)),
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
                    builder: (context) => const UploadDocumentsFilterPage()),
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
                          .where((item) => item['Document Title']!
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
          HoverTapButton(
            icon: Icons.add,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const AddDocument(),
              );
            },
          ),
        ],
      ),
    );
  }
}
