import 'package:citizen_care_system/admin _component/citizen_service_task/download_dialog.dart';
import 'package:citizen_care_system/component/admin_circle_menu/fab_menu.dart';
import 'package:citizen_care_system/component/admin_circle_menu/hover_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../Subject_officer/add_new_service_details.dart';
import 'package:citizen_care_system/admin_pages/citizen_services_pages/view_service_task.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../services/subject_officer_service.dart';
import '../../../model/subject_officer_request_model.dart';

class SubjectOfficerPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;
  final List<String>? selectedServiceType;
  final String? selectedRequestType;
  final DateTime? startDate;
  final DateTime? endDate;

  const SubjectOfficerPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
    this.selectedServiceType,
    this.selectedRequestType,
    this.startDate,
    this.endDate,
  });

  @override
  State<SubjectOfficerPage> createState() => _SubjectOfficerPageState();
}

class _SubjectOfficerPageState extends State<SubjectOfficerPage> {
  final List<String> columnLabels = [
    'Reference',
    'Created',
    'Citizen',
    'Assign Type',
    'Assign To',
    'Assigned Date',
    'Service Status',
    'Actions',
  ];

  List<SubjectOfficerRequest> _requests = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSubjectOfficerRequests();
  }

  Future<void> _fetchSubjectOfficerRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Validate token before making API call
      if (widget.accessToken.isEmpty) {
        throw Exception('Authentication token is missing. Please log in again.');
      }

      print('=== Fetching Data ===');
      print('Citizen Code: ${widget.citizenCode}');
      print('Access Token Available: ${widget.accessToken.isNotEmpty}');

      final requests = await SubjectOfficerService.getSubjectOfficerRequestTypesRequested(
        username: widget.citizenCode, // Using citizenCode as username
        privilegeConfigurationId: 7,
        accessToken: widget.accessToken,
      );

      setState(() {
        _requests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      
      // Show error in a snackbar too
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateToViewPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicePage(
          accessToken: widget.accessToken,
          citizenCode: widget.citizenCode,
        ),
      ),
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectOfficerPage(
              accessToken: widget.accessToken,
              citizenCode: widget.citizenCode,
              selectedServiceType: result['selectedServiceType'],
              selectedRequestType: result['selectedRequestType'],
              startDate: result['startDate'],
              endDate: result['endDate'],
            ),
          ),
        );
      }
    });
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
              'citizen_services'.tr(),
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
            Expanded(
              child: _buildContent(screenWidth, screenHeight),
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
                MaterialPageRoute(builder: (context) => const AddServiceDetailsPage()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.view_list,
            onTap: _navigateToViewPage,
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

  Widget _buildContent(double screenWidth, double screenHeight) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchSubjectOfficerRequests,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF80AF81),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No requests found',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade300),
        columns: columnLabels
            .map((label) => DataColumn(
                  label: Text(
                    label.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ))
            .toList(),
        rows: _requests.map((request) {
          return DataRow(
            cells: [
              DataCell(Text(request.reference ?? '-')),
              DataCell(Text(request.created ?? '-')),
              DataCell(Text(request.citizen ?? '-')),
              DataCell(Text(request.assignType ?? '-')),
              DataCell(Text(request.assignTo ?? '-')),
              DataCell(Text(request.assignedDate ?? '-')),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.serviceStatus),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.serviceStatus ?? '-',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, size: 20),
                      onPressed: () {
                        // Navigate to view details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicePage(
                              accessToken: widget.accessToken,
                              citizenCode: widget.citizenCode,
                            ),
                          ),
                        );
                      },
                      tooltip: 'View',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        // Navigate to edit
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddServiceDetailsPage(),
                          ),
                        ).then((_) => _fetchSubjectOfficerRequests());
                      },
                      tooltip: 'Edit',
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
      case 'processing':
        return Colors.blue;
      case 'completed':
      case 'approved':
        return Colors.green;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}