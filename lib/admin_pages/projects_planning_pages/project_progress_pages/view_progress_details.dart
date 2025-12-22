import 'package:flutter/material.dart';

import '../../../component/custom_back_button.dart';
import '../../../component/custom_app_bar.dart';
import '../../../admin _component/citizen_service_task/action_bar.dart';
import '../../../admin _component/project_planning/project_data_table_view.dart';
import '../../../admin _component/citizen_service_task/pagination_controls.dart';

class ViewProgressDetailsPage extends StatefulWidget {
  const ViewProgressDetailsPage({super.key});

  @override
  State<ViewProgressDetailsPage> createState() => _ViewProgressDetailsPageState();
}

class _ViewProgressDetailsPageState extends State<ViewProgressDetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  List<Map<String, dynamic>> projectData = [];
  List<Map<String, dynamic>> filteredData = [];

  int _currentPage = 1;
  final int _itemsPerPage = 10;
  String _sortColumn = 'sector';
  bool _sortAscending = true;
  int? _selectedRowIndex;

  final List<Map<String, dynamic>> _columnDefinitions = [
    {'key': 'sector', 'label': 'Sector Name', 'width': 150.0},
    {'key': 'project', 'label': 'Project Name', 'width': 200.0},
    {'key': 'type', 'label': 'Project Type', 'width': 150.0},
    {'key': 'location', 'label': 'GN Location', 'width': 150.0},
    {'key': 'assigned', 'label': 'Assign To', 'width': 150.0},
    {'key': 'status', 'label': 'Current Status', 'width': 150.0},
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
        'sector': 'Sector ${i % 4 + 1}',
        'project': 'Project ${i + 1}',
        'type': i % 2 == 0 ? 'Construction' : 'Purchasing',
        'location': 'GN Area ${i % 5 + 1}',
        'assigned': 'Officer ${i + 10}',
        'status': ['Project Assigned', 'Project Ongoing', 'Project Completed', 'Project In Hold'][i % 4],
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
    final double totalTableWidth = _columnDefinitions.fold(
        0, (sum, column) => sum + (column['width'] as double));
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: ActionBar(
                    title: 'Project Progress Details',
                    searchController: _searchController,
                    onSearch: _filterData,
                    //onDownload: () => showDownloadOptions(context),
                    //showAddButton: false,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: _verticalScrollController,
              thumbVisibility: true,
              child: Scrollbar(
                controller: _horizontalScrollController,
                thumbVisibility: true,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalScrollController,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenWidth,
                        maxWidth: totalTableWidth > screenWidth ? totalTableWidth : screenWidth,
                      ),
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
          ),
          PaginationControls(
            currentPage: _currentPage,
            totalPages: _totalPages,
            totalItems: filteredData.length,
            currentPageItems: _paginatedData.length,
            itemsPerPage: _itemsPerPage,
            onPageChange: _handlePageChange,
          ),
        ],
      ),
    );
  }
}
