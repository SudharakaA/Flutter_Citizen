import 'package:flutter/material.dart';
import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_item_page.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../component/admin_circle_menu/fab_menu.dart';
import '../../component/admin_circle_menu/hover_tap_button.dart';
import '../../admin _component/citizen_service_task/download_dialog.dart';
import '../store_admin/item_search_dialog.dart';

class ItemConfigurationPage extends StatefulWidget {
  const ItemConfigurationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ItemConfigurationPageState createState() => _ItemConfigurationPageState();
}

class _ItemConfigurationPageState extends State<ItemConfigurationPage> {
  List<String> _selectedItems = [];
  String _searchQuery = '';
  bool _isFilterActive = false;

  final List<String> _items = [
    'Paper',
    'Books',
    'Pens and Pencils',
    'Computer Ribbon',
    'Electrical Items',
    'Cleaning Materials'
  ];

  int _currentPage = 0;
  final int _rowsPerPage = 10;

  List<Map<String, String>> itemsData = List.generate(
    27,
    (index) => {
      'createdAt': '2024-05-${(index % 30 + 1).toString().padLeft(2, '0')}',
      'createdBy': index % 2 == 0 ? 'Admin' : 'User$index',
      'category': index % 3 == 0 ? 'Paper' : 'Cleaning Materials',
      'name': 'Item ${index + 1}',
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
              "Store Configuration",
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

            // Row: Dropdown + View Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MultiSelectDialogField(
                    items: _items
                        .map((item) => MultiSelectItem<String>(item, item))
                        .toList(),
                    title: Text(
                      "Item Categories",
                      style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selectedColor: Colors.green,
                    buttonText: Text(
                      _selectedItems.isEmpty
                          ? "Select item categories"
                          : "${_selectedItems.length} items selected",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 5, 52, 90),
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                    buttonIcon: const Icon(Icons.arrow_drop_down),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    dialogHeight: screenHeight * 0.5,
                    dialogWidth: screenWidth * 0.8,
                    cancelText: const Text("Cancel",
                        style: TextStyle(color: Colors.red)),
                    confirmText: const Text("Apply",
                        style: TextStyle(color: Colors.blue)),
                    onConfirm: (values) {
                      setState(() {
                        _selectedItems = values.cast<String>();
                      });
                    },
                    chipDisplay: MultiSelectChipDisplay.none(),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: screenHeight * 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _filteredItems = itemsData
                            .where((item) => _selectedItems.isEmpty
                                ? true
                                : _selectedItems.contains(item['category']))
                            .toList();
                        _isFilterActive = true;
                        _currentPage = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A7D44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Color(0xFF3A7D44)),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02),
                      child: Text(
                        "View Data",
                        style: GoogleFonts.inter(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

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
                      DataColumn(label: Text("Created By")),
                      DataColumn(label: Text("Category Type")),
                      DataColumn(label: Text("Good Name")),
                      DataColumn(label: Text("")),
                    ],
                    rows: _paginatedItems.map((item) {
                      return DataRow(cells: [
                        DataCell(Text(item['createdAt']!)),
                        DataCell(Text(item['createdBy']!)),
                        DataCell(Text(item['category']!)),
                        DataCell(Text(item['name']!)),
                        DataCell(IconButton(
                          icon: const Icon(Icons.description,
                              color: Color.fromARGB(255, 126, 115, 13)),
                          onPressed: () {},
                        )),
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
            icon: Icons.add,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddItemPage()),
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
                          .where((item) => item['name']!
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
