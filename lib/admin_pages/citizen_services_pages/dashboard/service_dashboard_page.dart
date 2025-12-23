import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/request_service/date_picker_field.dart';
import '../../../component/request_service/action_button.dart';
import '../../../services/subject_officer_service.dart';
import 'widgets/kpi_card.dart';
import 'widgets/status_chart.dart';

class ServiceDashboardPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const ServiceDashboardPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<ServiceDashboardPage> createState() => _ServiceDashboardPageState();
}

class _ServiceDashboardPageState extends State<ServiceDashboardPage> {
  // Filter variables
  List<String> selectedServices = [];
  DateTime? startDate;
  DateTime? endDate;

  // Data variables
  List<Map<String, dynamic>> serviceData = [];
  bool isLoading = false;
  String? errorMessage;

  // KPI values
  int totalPending = 0;
  int totalCompleted = 0;
  int totalRejected = 0;
  int totalInProgress = 0;

  // Chart data
  List<Map<String, dynamic>> chartData = [];

  // Available services list
  final List<String> availableServices = [
    'All Services',
    'Thamankaduwa - DS Office',
    'Higurakgoda - DS Office',
    'Medirigiriya - DS Office',
    'Dimbulagala - DS Office',
    'Lankapura - DS Office',
    'Welikanda - DS Office',
    'Elehera - DS Office',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with empty state
    _initializeEmptyState();
  }

  void _initializeEmptyState() {
    setState(() {
      totalPending = 0;
      totalCompleted = 0;
      totalRejected = 0;
      totalInProgress = 0;
      chartData = [];
      serviceData = [];
    });
  }

  Future<void> _fetchDashboardData() async {
    if (startDate == null || endDate == null) {
      _showErrorSnackbar('Please select both start and end dates');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch data from API
      final requests = await SubjectOfficerService.getSubjectOfficerRequestTypesRequested(
        username: widget.citizenCode,
        privilegeConfigurationId: 7,
        accessToken: widget.accessToken,
      );

      // Convert the list of requests to map format for dashboard
      final List<Map<String, dynamic>> data = requests.map((request) => {
        'id': request.id,
        'reference': request.reference,
        'status': request.serviceStatus,
        'created': request.created,
        'citizen': request.citizen,
        'assignType': request.assignType,
        'assignTo': request.assignTo,
        'assignedDate': request.assignedDate,
      }).toList();

      if (data.isNotEmpty) {
        
        setState(() {
          serviceData = data.cast<Map<String, dynamic>>();
          _processData();
          isLoading = false;
        });

        _showSuccessSnackbar('Data loaded successfully');
      } else {
        setState(() {
          isLoading = false;
          _initializeEmptyState();
        });
        _showErrorSnackbar('No data available');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
        _initializeEmptyState();
      });
      _showErrorSnackbar('Failed to load data: ${e.toString()}');
    }
  }

  void _processData() {
    // Reset counters
    totalPending = 0;
    totalCompleted = 0;
    totalRejected = 0;
    totalInProgress = 0;

    // Count statuses
    for (var item in serviceData) {
      final status = (item['status'] ?? '').toString().toLowerCase();
      
      if (status.contains('pending')) {
        totalPending++;
      } else if (status.contains('completed') || status.contains('approved')) {
        totalCompleted++;
      } else if (status.contains('rejected') || status.contains('cancelled')) {
        totalRejected++;
      } else if (status.contains('progress') || status.contains('processing')) {
        totalInProgress++;
      }
    }

    // Generate chart data (grouped by date)
    _generateChartData();
  }

  void _generateChartData() {
    // Group data by date
    Map<String, Map<String, int>> dateGrouped = {};

    for (var item in serviceData) {
      final dateStr = item['created_date'] ?? item['date'] ?? '';
      final status = (item['status'] ?? '').toString().toLowerCase();

      if (!dateGrouped.containsKey(dateStr)) {
        dateGrouped[dateStr] = {
          'pending': 0,
          'completed': 0,
          'rejected': 0,
        };
      }

      if (status.contains('pending')) {
        dateGrouped[dateStr]!['pending'] = (dateGrouped[dateStr]!['pending'] ?? 0) + 1;
      } else if (status.contains('completed') || status.contains('approved')) {
        dateGrouped[dateStr]!['completed'] = (dateGrouped[dateStr]!['completed'] ?? 0) + 1;
      } else if (status.contains('rejected') || status.contains('cancelled')) {
        dateGrouped[dateStr]!['rejected'] = (dateGrouped[dateStr]!['rejected'] ?? 0) + 1;
      }
    }

    // Convert to chart data
    chartData = dateGrouped.entries.map((e) => {
      'date': e.key,
      'pending': e.value['pending'],
      'completed': e.value['completed'],
      'rejected': e.value['rejected'],
    }).toList();

    // Sort by date
    chartData.sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));
  }

  void _showErrorSnackbar(String message) {
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

  void _showSuccessSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Service Dashboard',
              style: GoogleFonts.inter(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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

            // Main Content - Everything scrollable
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          // Global Filters & Navigation Section
                          _buildFiltersSection(screenWidth, screenHeight),
                          
                          SizedBox(height: screenHeight * 0.03),
                          
                          // KPI Cards Section
                          _buildKPISection(screenWidth, screenHeight),
                          
                          SizedBox(height: screenHeight * 0.03),

                          // Charts Section
                          _buildChartsSection(screenWidth, screenHeight),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection(double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Service Selector
          _buildServiceSelector(screenWidth),
          
          SizedBox(height: screenHeight * 0.02),

          // Date Range Pickers
          Row(
            children: [
              Expanded(
                child: DatePickerField(
                  label: 'Start Date',
                  selectedDate: startDate,
                  onDateSelected: (date) {
                    setState(() {
                      startDate = date;
                    });
                  },
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: DatePickerField(
                  label: 'End Date',
                  selectedDate: endDate,
                  onDateSelected: (date) {
                    setState(() {
                      endDate = date;
                    });
                  },
                ),
              ),
            ],
          ),
          
          SizedBox(height: screenHeight * 0.02),

          // View Data Button
          ActionButton(
            text: 'View Data',
            onPressed: _fetchDashboardData,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelector(double screenWidth) {
    return InkWell(
      onTap: () => _showMultiSelectDialog(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedServices.isEmpty
                    ? 'Nothing selected'
                    : selectedServices.join(', '),
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.035,
                  color: selectedServices.isEmpty ? Colors.grey : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showMultiSelectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Select DS Offices',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: availableServices.map((service) {
                    final isSelected = selectedServices.contains(service);
                    return CheckboxListTile(
                      title: Text(
                        service,
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                      value: isSelected,
                      onChanged: (bool? checked) {
                        setDialogState(() {
                          if (checked == true) {
                            selectedServices.add(service);
                          } else {
                            selectedServices.remove(service);
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedServices.clear();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.inter(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A7D44),
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildKPISection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Performance Indicators',
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: screenHeight * 0.015),
        
        // KPI Cards Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: screenHeight * 0.015,
          crossAxisSpacing: screenWidth * 0.03,
          childAspectRatio: 1.2,
          children: [
            KPICard(
              title: 'Pending',
              value: totalPending,
              color: const Color(0xFFFFC0CB), // Pink
              icon: Icons.pending_outlined,
            ),
            KPICard(
              title: 'Completed',
              value: totalCompleted,
              color: const Color(0xFF4ECDC4), // Cyan
              icon: Icons.check_circle_outline,
            ),
            KPICard(
              title: 'Rejected',
              value: totalRejected,
              color: const Color(0xFFFFD700), // Yellow
              icon: Icons.cancel_outlined,
            ),
            KPICard(
              title: 'In Progress',
              value: totalInProgress,
              color: const Color(0xFF9B59B6), // Purple
              icon: Icons.autorenew_outlined,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartsSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Visualization',
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: screenHeight * 0.015),

        // Status Distribution Chart
        StatusChart(
          title: 'Status Distribution',
          chartData: chartData,
          height: screenHeight * 0.35,
        ),

        SizedBox(height: screenHeight * 0.02),

        // Secondary Chart
        StatusChart(
          title: 'Trend Analysis',
          chartData: chartData,
          height: screenHeight * 0.25,
          showLegend: false,
        ),
      ],
    );
  }
}
