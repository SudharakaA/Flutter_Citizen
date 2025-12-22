// Enhanced Project Details Page with improved UI and functionality
import 'package:citizen_care_system/admin%20_component/citizen_service_task/download_dialog.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_page.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/add_new_project.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/plan_details.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/planning_proposal_page.dart';
import 'package:citizen_care_system/admin_pages/projects_planning_pages/project_request_pages/services/project_delete_service.dart';
import 'package:citizen_care_system/component/admin_circle_menu/fab_menu.dart';
import 'package:citizen_care_system/component/admin_circle_menu/hover_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

// Main View Project Details Page
class ViewProjectDetailsPage extends StatefulWidget {
  final List<String>? selectedServices;
  final List<String>? selectedOffices;
  final String? selectedStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final String accessToken;
  final String citizenCode;

  const ViewProjectDetailsPage({
    super.key,
    this.selectedServices,
    this.selectedOffices,
    this.selectedStatus,
    this.startDate,
    this.endDate,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<ViewProjectDetailsPage> createState() => _ViewProjectDetailsPageState();
}

class _ViewProjectDetailsPageState extends State<ViewProjectDetailsPage> {
  // Controllers and data
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> projectData = [];
  List<Map<String, dynamic>> filteredProjectData = [];

  // State management
  bool isLoading = true;
  bool isProcessing = false;
  bool isDeleting = false;
  String searchQuery = '';

  // Pagination
  int currentPage = 1;
  int itemsPerPage = 8;
  List<Map<String, dynamic>> paginatedProjects = [];

  @override
  void initState() {
    super.initState();
    _loadProjectData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text.toLowerCase();
      currentPage = 1;
      _filterProjects();
      _updatePaginatedProjects();
    });
  }

  void _filterProjects() {
    if (searchQuery.isEmpty) {
      filteredProjectData = List.from(projectData);
    } else {
      filteredProjectData = projectData.where((project) {
        return (project['SECTOR_NAME']?.toLowerCase().contains(searchQuery) ??
                false) ||
            (project['PROJECT_TITLE']?.toLowerCase().contains(searchQuery) ??
                false) ||
            (project['PROJECT_TYPE']?.toLowerCase().contains(searchQuery) ??
                false) ||
            (project['GN_LOCATION']?.toLowerCase().contains(searchQuery) ??
                false) ||
            (project['ASSIGN_TO_NAME']?.toLowerCase().contains(searchQuery) ??
                false);
      }).toList();
    }
  }

  void _updatePaginatedProjects() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    if (endIndex > filteredProjectData.length) {
      endIndex = filteredProjectData.length;
    }

    paginatedProjects = filteredProjectData.sublist(startIndex, endIndex);
  }

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      _updatePaginatedProjects();
    });
  }

  int get totalPages => (filteredProjectData.length / itemsPerPage).ceil();

  Future<void> _loadProjectData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final dateFormat = DateFormat('yyyy/MM/dd');
      final response = await http.post(
        Uri.parse(
            'http://220.247.224.226:8401/CCSHubApi/api/MainApi/PlanningDataListRequested'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
        body: jsonEncode({
          'startDate': widget.startDate != null
              ? dateFormat.format(widget.startDate!)
              : null,
          'endDate': widget.endDate != null
              ? dateFormat.format(widget.endDate!)
              : null,
          'locationIdList': widget.selectedOffices ?? [],
          'currentStatus': widget.selectedStatus?.isNotEmpty ?? false
              ? widget.selectedStatus!
              : null,
          'projectTypeList': widget.selectedServices ?? [],
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['isSuccess'] == true && decoded['dataBundle'] != null) {
          final List<dynamic> data = decoded['dataBundle'];
          setState(() {
            projectData =
                data.map((item) => Map<String, dynamic>.from(item)).toList();
            _filterProjects();
            _updatePaginatedProjects();
            isLoading = false;
          });
        } else {
          _showError(
              'Failed to load projects: ${decoded['errorMessage'] ?? 'Unknown error'}');
        }
      } else {
        _showError(
            'Failed to connect to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error loading projects: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Project Delete Function
  Future<void> _deleteProject(basicDId) async {
    // Start submission
    setState(() {
      isDeleting = true;
    });

    try {
      final response = await ProjectDeleteService.deleteProject(
        accessToken: widget.accessToken,
        username: widget.citizenCode,
        callingName: 'Sandun',
        basicDataId: basicDId,
      );

      if (response['isSuccess'] == true) {
        _showSuccessMessage('Project Deleted successfully!');

        // Reload project data after successful deletion
        await _loadProjectData();

        // Navigate back after successful submission
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        _showValidationError(response['errorMessage'] ??
            'Failed to delete project. Please try again.');
      }
    } catch (e) {
      _showValidationError('Error deleting project: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          isDeleting = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showValidationError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Results Summary Widget
  Widget _buildResultsSummary() {
    if (isLoading) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    String summaryText;
    if (searchQuery.isNotEmpty) {
      summaryText =
          'Found ${filteredProjectData.length} projects matching "$searchQuery"';
    } else {
      summaryText = 'Total ${projectData.length} projects';
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            summaryText,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showProjectActions(Map<String, dynamic> project) {
    ProjectActionsComponent.showProjectActions(
      context: context,
      project: project,
      accessToken: widget.accessToken,
      onViewDetails: () {
        Navigator.pop(context);
        // Navigate to plan details page
        print('View project details: ${project['PROJECT_TITLE']}');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanDetailsPage(
              accessToken:
                  widget.accessToken, // or however you access your token
              planDataId: project['PLAN_DATA_ID'].toString(),
            ),
          ),
        );
      },
      onEditProject: () {
        Navigator.pop(context);
        // Navigate to edit project page
        print('Edit project: ${project['PROJECT_TITLE']}');
      },
      onDeleteProject: () {
        Navigator.pop(context);
        ProjectActionsComponent.showDeleteConfirmation(
          context: context,
          project: project,
          isProcessing: isDeleting,
          onConfirm: () {
            Navigator.pop(context);
            // Handle delete project with actual basicDId
            _deleteProject(project['PLAN_DATA_ID']);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: AppBar(
        backgroundColor: const Color(0xFF80AF81),
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectsPlanningPage(
                        accessToken: widget.accessToken,
                        citizenCode: widget.citizenCode),
                  ));
            }),
        title: Text(
          'Project Management',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Project Planning & Management',
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
              const SizedBox(height: 12),

              // Search Bar Component
              ProjectSearchComponent(
                searchController: _searchController,
                searchQuery: searchQuery,
                onClear: () {
                  _searchController.clear();
                },
              ),

              // Results Summary
              _buildResultsSummary(),

              // Loading overlay
              if (isProcessing || isDeleting)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // Projects Data Table
              Expanded(
                child: !isLoading &&
                        filteredProjectData.isEmpty &&
                        searchQuery.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No projects found matching "$searchQuery"',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                              },
                              child: Text(
                                'Clear Search',
                                style: GoogleFonts.inter(
                                  color: Colors.blue.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : !isLoading && projectData.isEmpty
                        ? const Center(
                            child: Text(
                              'No projects found.\nPlease apply filters or add new projects.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Column(
                            children: [
                              Flexible(
                                child: ProjectDataTableComponent(
                                  paginatedProjects: paginatedProjects,
                                  isLoading: isLoading,
                                  isProcessing: isProcessing || isDeleting,
                                  onProjectActions: _showProjectActions,
                                ),
                              ),
                              // Pagination Component
                              if (!isLoading && filteredProjectData.isNotEmpty)
                                ProjectPaginationComponent(
                                  currentPage: currentPage,
                                  totalPages: totalPages,
                                  totalItems: filteredProjectData.length,
                                  itemsPerPage: itemsPerPage,
                                  onPageChanged: _onPageChanged,
                                ),
                            ],
                          ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewProjectPage(
                    username: widget.citizenCode,
                    accessToken: widget.accessToken,
                  ),
                ),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.view_list,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlanningProposalPage(
                    accessToken: widget.accessToken,
                    citizenCode: widget.citizenCode,
                  ),
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

// Project Search Component
class ProjectSearchComponent extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final VoidCallback onClear;

  const ProjectSearchComponent({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText:
              'Search projects by sector, title, type, location, or assignee...',
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: GoogleFonts.inter(fontSize: 14),
      ),
    );
  }
}

// Project Data Table Component
class ProjectDataTableComponent extends StatelessWidget {
  final List<Map<String, dynamic>> paginatedProjects;
  final bool isLoading;
  final bool isProcessing;
  final Function(Map<String, dynamic>) onProjectActions;

  const ProjectDataTableComponent({
    super.key,
    required this.paginatedProjects,
    required this.isLoading,
    required this.isProcessing,
    required this.onProjectActions,
  });

  final List<String> columnLabels = const [
    'Actions',
    'Sector Name',
    'Project Title',
    'Project Type',
    'DS Location',
    'Assign To',
  ];

  // Skeleton Loading Row Widget
  DataRow _buildSkeletonRow() {
    return DataRow(
      cells: columnLabels.map((label) {
        if (label == 'Actions') {
          return DataCell(
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        } else {
          double skeletonWidth;
          switch (label) {
            case 'Sector Name':
              skeletonWidth = 100;
              break;
            case 'Project Title':
              skeletonWidth = 120;
              break;
            case 'Project Type':
              skeletonWidth = 90;
              break;
            case 'DS Location':
              skeletonWidth = 100;
              break;
            case 'Assign To':
              skeletonWidth = 85;
              break;
            default:
              skeletonWidth = 80;
          }

          return DataCell(
            Container(
              width: skeletonWidth,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade300),
        columns: columnLabels
            .map((label) => DataColumn(
                  label: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        rows: isLoading
            ? List.generate(8, (index) => _buildSkeletonRow())
            : paginatedProjects
                .map((project) => DataRow(
                      cells: [
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: isProcessing
                                ? null
                                : () => onProjectActions(project),
                          ),
                        ),
                        DataCell(Text(
                          project['SECTOR_NAME']?.toString() ?? '',
                          style: GoogleFonts.inter(fontSize: 13),
                        )),
                        DataCell(Text(
                          project['PROJECT_TITLE']?.toString() ?? '',
                          style: GoogleFonts.inter(fontSize: 13),
                        )),
                        DataCell(Text(
                          project['PROJECT_TYPE']?.toString() ?? '',
                          style: GoogleFonts.inter(fontSize: 13),
                        )),
                        DataCell(Text(
                          project['GN_LOCATION']?.toString() ?? '',
                          style: GoogleFonts.inter(fontSize: 13),
                        )),
                        DataCell(Text(
                          project['ASSIGN_TO_NAME']?.toString() ?? '',
                          style: GoogleFonts.inter(fontSize: 13),
                        )),
                      ],
                    ))
                .toList(),
      ),
    );
  }
}

// Project Actions Component
class ProjectActionsComponent {
  static void showProjectActions({
    required BuildContext context,
    required Map<String, dynamic> project,
    required String accessToken,
    required Function() onViewDetails,
    required Function() onEditProject,
    required Function() onDeleteProject,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Actions for ${project['PROJECT_TITLE']}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              _buildActionTile(
                icon: Icons.visibility,
                iconColor: Colors.blue.shade600,
                backgroundColor: Colors.blue.shade50,
                title: 'View Details',
                subtitle: 'View complete project information',
                onTap: onViewDetails,
              ),
              _buildActionTile(
                icon: Icons.edit,
                iconColor: Colors.green.shade600,
                backgroundColor: Colors.green.shade50,
                title: 'Edit Project',
                subtitle: 'Modify project information',
                onTap: onEditProject,
              ),
              _buildActionTile(
                icon: Icons.delete,
                iconColor: Colors.red.shade600,
                backgroundColor: Colors.red.shade50,
                title: 'Delete Project',
                subtitle: 'Remove project from system',
                onTap: onDeleteProject,
              ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      onTap: onTap,
    );
  }

  static void showDeleteConfirmation({
    required BuildContext context,
    required Map<String, dynamic> project,
    required bool isProcessing,
    required Function() onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: !isProcessing,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning,
                color: Colors.red,
                size: 30,
              ),
              const SizedBox(width: 10),
              Text(
                'Delete Project',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete project "${project['PROJECT_TITLE']}"?\n\nThis action cannot be undone.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: isProcessing ? null : () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: isProcessing
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
              ),
            ),
            TextButton(
              onPressed: isProcessing ? null : onConfirm,
              style: TextButton.styleFrom(
                backgroundColor:
                    isProcessing ? Colors.grey.shade300 : Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isProcessing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// Project Pagination Component
class ProjectPaginationComponent extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final Function(int) onPageChanged;

  const ProjectPaginationComponent({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    int startItem = (currentPage - 1) * itemsPerPage + 1;
    int endItem = currentPage * itemsPerPage;
    if (endItem > totalItems) endItem = totalItems;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // Info text
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Showing $startItem-$endItem of $totalItems projects',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Pagination controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button
              Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(right: 8),
                  child: ElevatedButton.icon(
                    onPressed: currentPage > 1
                        ? () => onPageChanged(currentPage - 1)
                        : null,
                    icon: Icon(
                      Icons.chevron_left,
                      size: 18,
                      color:
                          currentPage > 1 ? Colors.white : Colors.grey.shade400,
                    ),
                    label: Text(
                      'Previous',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentPage > 1
                          ? Colors.green.shade400
                          : Colors.grey.shade300,
                      foregroundColor:
                          currentPage > 1 ? Colors.white : Colors.grey.shade500,
                      elevation: currentPage > 1 ? 2 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ),

              // Current page indicator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  '$currentPage / $totalPages',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              // Next button
              Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 8),
                  child: ElevatedButton.icon(
                    onPressed: currentPage < totalPages
                        ? () => onPageChanged(currentPage + 1)
                        : null,
                    icon: Text(
                      'Next',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    label: Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: currentPage < totalPages
                          ? Colors.white
                          : Colors.grey.shade400,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentPage < totalPages
                          ? Colors.green.shade400
                          : Colors.grey.shade300,
                      foregroundColor: currentPage < totalPages
                          ? Colors.white
                          : Colors.grey.shade500,
                      elevation: currentPage < totalPages ? 2 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
