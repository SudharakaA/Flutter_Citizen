import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../component/admin_circle_menu/fab_menu.dart';
import '../../component/admin_circle_menu/hover_tap_button.dart';
import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';
import '../../admin _component/citizen_service_task/data_table_view.dart';
import '../../admin _component/citizen_service_task/pagination_controls.dart';
import '../../admin _component/citizen_service_task/action_bar.dart';
import '../../admin _component/citizen_service_task/download_dialog.dart';

class ServiceDetailsPage extends StatefulWidget {
  final List<String> selectedServices;

  const ServiceDetailsPage({
    super.key,
    required this.selectedServices, required String accessToken, required String citizenCode,
  });

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  List<Map<String, dynamic>> taskData = [];
  List<Map<String, dynamic>> filteredTaskData = [];
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  String _sortColumn = 'reference';
  bool _sortAscending = true;
  int? _selectedRowIndex;

  final List<Map<String, dynamic>> _columnDefinitions = [
    {'key': 'reference', 'label': 'Reference', 'width': 120.0},
    {'key': 'created', 'label': 'Created', 'width': 100.0},
    {'key': 'citizen', 'label': 'Citizen', 'width': 100.0},
    {'key': 'assignType', 'label': 'Assign Type', 'width': 120.0},
    {'key': 'assignTo', 'label': 'Assign To', 'width': 100.0},
    {'key': 'assignedDate', 'label': 'Assigned Date', 'width': 130.0},
    {'key': 'serviceStatus', 'label': 'Service Status', 'width': 130.0},
    {'key': 'service', 'label': 'Service', 'width': 200.0},
  ];

  @override
  void initState() {
    super.initState();
    _generateSampleData();
    filteredTaskData = List.from(taskData);
  }

  void _generateSampleData() {
    final List<String> statuses = ['Pending', 'In Progress', 'Completed', 'Rejected'];
    final List<String> assignTypes = ['Officer', 'Department', 'Manager', 'Team'];

    for (int i = 0; i < 50; i++) {
      String service = widget.selectedServices[i % widget.selectedServices.length];
      taskData.add({
        'reference': 'REF-${10000 + i}',
        'created': '${(i % 30) + 1}/04/2025',
        'citizen': 'Citizen ${800 + i}',
        'assignType': assignTypes[i % assignTypes.length],
        'assignTo': 'User ${100 + i}',
        'assignedDate': '${(i % 30) + 1}/04/2025',
        'serviceStatus': statuses[i % statuses.length],
        'service': service,
      });
    }
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTaskData = List.from(taskData);
      } else {
        filteredTaskData = taskData
            .where((task) =>
                task['reference'].toLowerCase().contains(query.toLowerCase()) ||
                task['citizen'].toLowerCase().contains(query.toLowerCase()) ||
                task['service'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _currentPage = 1;
      _sortData();
    });
  }

  void _sortData() {
    setState(() {
      filteredTaskData.sort((a, b) {
        final aValue = a[_sortColumn].toString();
        final bValue = b[_sortColumn].toString();
        return _sortAscending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      });
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

  int get _totalPages => (filteredTaskData.length / _itemsPerPage).ceil();

  List<Map<String, dynamic>> get _paginatedData {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, filteredTaskData.length);
    return filteredTaskData.sublist(startIndex, endIndex);
  }

  void _handlePageChange(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _handleRowTap(int index) {
    setState(() {
      _selectedRowIndex = _selectedRowIndex == index ? null : index;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
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
              ActionBar(
                title: 'Citizen Services',
                searchController: _searchController,
                onSearch: _filterData,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Scrollbar(
                  controller: _verticalScrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _verticalScrollController,
                    child: Scrollbar(
                      controller: _horizontalScrollController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _horizontalScrollController,
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
              ),
              const SizedBox(height: 12),
              PaginationControls(
                currentPage: _currentPage,
                totalPages: _totalPages,
                totalItems: filteredTaskData.length,
                currentPageItems: _paginatedData.length,
                itemsPerPage: _itemsPerPage,
                onPageChange: _handlePageChange,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFabMenu(
        menuItems: [
          HoverTapButton(
            icon: Icons.add,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Add New Entry"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Details'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("New entry added!")),
                        );
                      },
                      child: const Text("Save"),
                    ),
                  ],
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
            icon: Icons.copy,
            onTap: () {
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