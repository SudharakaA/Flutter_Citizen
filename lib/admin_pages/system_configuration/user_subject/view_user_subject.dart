import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../component/admin_circle_menu/fab_menu.dart';
import '../../../component/admin_circle_menu/hover_tap_button.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../data_table_view.dart';
import '../download_dialog.dart';
import '../pagination_controls.dart';
import 'action_bar.dart';
import 'add_new_subject.dart';


class ViewUserSubjectPage extends StatefulWidget {
  const ViewUserSubjectPage({super.key});

  @override
  State<ViewUserSubjectPage> createState() => _ViewUserSubjectPage();
}

class _ViewUserSubjectPage extends State<ViewUserSubjectPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  List<Map<String, dynamic>> projectData = [];
  List<Map<String, dynamic>> filteredData = [];

  int _currentPage = 1;
  final int _itemsPerPage = 10;
  String _sortColumn = 'created_at';
  bool _sortAscending = true;
  int? _selectedRowIndex;

  final List<Map<String, dynamic>> _columnDefinitions = [
    {'key': 'created_at', 'label': 'Created At', 'width': 150.0},
    {'key': 'created_by', 'label': 'Created By', 'width': 200.0},
    {'key': 'username', 'label': 'Username', 'width': 150.0},
    {'key': 'subject', 'label': 'Subject Code', 'width': 200.0},
  ];

  @override
  void initState() {
    super.initState();
    _generateMockData();
    filteredData = List.from(projectData);
  }

  void _generateMockData() {
    for (int i = 0; i < 40; i++) {
      projectData.add({
        'created_at': 'Created At ${i % 4 + 1}',
        'created_by': 'Created By ${i + 1}',
        'username': 'Username ${i % 5 + 1}',
        'subject': 'Subject Code ${i + 2}',
      });
    }
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = List.from(projectData);
      } else {
        filteredData = projectData
            .where((item) => item.values.any((value) =>
            value.toString().toLowerCase().contains(query.toLowerCase())))
            .toList();
      }
      _currentPage = 1;
      _sortData();
    });
  }

  void _sortData() {
    filteredData.sort((a, b) {
      final aValue = a[_sortColumn].toString();
      final bValue = b[_sortColumn].toString();
      return _sortAscending
          ? aValue.compareTo(bValue)
          : bValue.compareTo(aValue);
    });
  }

  void _handleSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
      _sortData();
    });
  }

  void _handleRowTap(int index) {
    setState(() {
      _selectedRowIndex = _selectedRowIndex == index ? null : index;
    });
  }

  int get _totalPages => (filteredData.length / _itemsPerPage).ceil();

  List<Map<String, dynamic>> get _paginatedData {
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, filteredData.length);
    return filteredData.sublist(start, end);
  }

  void _handlePageChange(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ ActionBar replaces previous title + search bar
              ActionBar(
                title: 'User Subject',
                searchController: _searchController,
                onSearch: _filterData,
              ),

              const SizedBox(height: 12),

              // Data Table
              Expanded(
                child: Scrollbar(
                  controller: _verticalScrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _verticalScrollController,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: screenWidth),
                        child: DataTableView(
                          data: _paginatedData,
                          sortColumn: _sortColumn,
                          sortAscending: _sortAscending,
                          onSort: _handleSort,
                          selectedRowIndex: _selectedRowIndex,
                          onRowTap: _handleRowTap,
                          horizontalScrollController: _horizontalScrollController,
                          columnDefinitions: _columnDefinitions,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Pagination Controls
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: PaginationControls(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  totalItems: filteredData.length,
                  currentPageItems: _paginatedData.length,
                  itemsPerPage: _itemsPerPage,
                  onPageChange: _handlePageChange,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFabMenu(
        menuItems: [
          // ADD BUTTON
          HoverTapButton(
            icon: Icons.add,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => const AddNewSubject()
              );
            },
          ),

          // DOWNLOAD BUTTON
          /*HoverTapButton(
      icon: Icons.download,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Download"),
            content: const Text("Are you sure you want to download the data?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Replace with your download logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Download started.")),
                  );
                },
                child: const Text("Download"),
              ),
            ],
          ),
        );
      },
    ),*/
          HoverTapButton(
            icon: Icons.download,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const DownloadDialog(),
              );
            },
          ),

          // COPY BUTTON
          HoverTapButton(
            icon: Icons.copy,
            onTap: () {
              // Sample copy logic
              const copiedText = "Sample data copied!";
              Clipboard.setData(const ClipboardData(text: copiedText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Data copied to clipboard")),
              );
            },
          ),
        ],
      ),
    );
  }
}
