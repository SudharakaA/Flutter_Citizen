import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';

class PlanDetailsPage extends StatefulWidget {
  final String accessToken;
  final String planDataId;

  const PlanDetailsPage({
    super.key,
    required this.accessToken,
    required this.planDataId,
  });

  @override
  State<PlanDetailsPage> createState() => _PlanDetailsPageState();
}

class _PlanDetailsPageState extends State<PlanDetailsPage> {
  Map<String, dynamic>? planDetails;
  List<Map<String, dynamic>> sdgGoals = [];
  bool isLoading = true;
  bool isLoadingSDG = true;
  String errorMessage = '';
  String sdgErrorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPlanDetails();
    _loadSDGGoals();
  }

  Future<void> _loadPlanDetails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Create the request body with PLAN_DATA_ID
      final requestBody = {
        "basicDataId": widget.planDataId,
      };

      print('Request body: ${json.encode(requestBody)}'); // Debug print

      const url =
          'http://220.247.224.226:8401/CCSHubApi/api/MainApi/GetPlanManagementData';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
        body: json.encode(requestBody),
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['isSuccess'] == true && jsonData['dataBundle'] != null) {
          final List<dynamic> planDataArray = jsonData['dataBundle'];

          if (planDataArray.isNotEmpty) {
            final planData =
                planDataArray[0]; // Get the first (and likely only) plan object

            setState(() {
              planDetails = {
                'planDataId': planData['PLAN_DATA_ID'] ?? '',
                'projectTitle': planData['PROJECT_TITLE'] ?? '',
                'projectType': planData['PROJECT_TYPE'] ?? '',
                'estimatedCost': planData['ESTIMATED_COST'] ?? '',
                'allocatedAmount': planData['ALLOCATED_AMOUNT'] ?? '',
                'contractorDetails': planData['CONTRACTOR_DETAILS'] ?? '',
                'fundingSource': planData['FUNDING_SOURCE'] ?? '',
                'estimatedOutput': planData['ESTIMATED_OUTPUT'] ?? '',
                'planPriority': planData['PLAN_PRIORITY'] ?? '',
                'planDescription': planData['PLAN_DESCRIPTION'] ?? '',
                'currentStatus': planData['CURRENT_STATUS'] ?? '',
                'createdDtm': planData['CREATED_DTM'] ?? '',
                'createdBy': planData['CREATED_BY'] ?? '',
                'createdByName': planData['CREATED_BY_NAME'] ?? '',
                'lastUpdatedDtm': planData['LAST_UPDATED_DTM'] ?? '',
                'assignTo': planData['ASSIGN_TO'] ?? '',
                'assignToName': planData['ASSIGN_TO_NAME'] ?? '',
                'assignedDtm': planData['ASSIGNED_DTM'] ?? '',
                'assignRemark': planData['ASSIGN_REMARK'] ?? '',
                'updateRemark': planData['UPDATE_REMARK'] ?? '',
                'actionDtm': planData['ACTION_DTM'] ?? '',
                'actionBy': planData['ACTION_BY'] ?? '',
                'actionByName': planData['ACTION_BY_NAME'] ?? '',
                'endedBy': planData['ENDED_BY'] ?? '',
                'endedByName': planData['ENDED_BY_NAME'] ?? '',
                'endDtm': planData['END_DTM'] ?? '',
                'sectorName': planData['SECTOR_NAME'] ?? '',
                'gnLocation': planData['GN_LOCATION'] ?? '',
                'assignLocation': planData['ASSIGN_LOCATION'] ?? '',
                'sectorLocation': planData['SECTOR_LOCATION'] ?? '',
                'dsLocationId': planData['DS_LOCATION_ID'] ?? '',
                'gnLocationId': planData['GN_LOCATION_ID'] ?? '',
                'sectorLocationId': planData['SECTOR_LOCATION_ID'] ?? '',
                'assignLocationId': planData['ASSIGN_LOCATION_ID'] ?? '',
              };
              isLoading = false;
            });
          } else {
            setState(() {
              errorMessage = 'No plan data found in response';
              isLoading = false;
            });
          }
        } else {
          setState(() {
            errorMessage =
                'Failed to load plan details: ${jsonData['errorMessage'] ?? 'Unknown error'}';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage =
              'Failed to connect to server. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading plan details: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _loadSDGGoals() async {
    try {
      setState(() {
        isLoadingSDG = true;
        sdgErrorMessage = '';
      });

      // Create the request body with PLANID
      final requestBody = {
        "basicDataId": widget.planDataId,
      };

      print('SDG Request body: ${json.encode(requestBody)}'); // Debug print

      const url =
          'http://220.247.224.226:8401/CCSHubApi/api/MainApi/GetAllSDGGoalData';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
        body: json.encode(requestBody),
      );

      print('SDG Response status: ${response.statusCode}'); // Debug print
      print('SDG Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['isSuccess'] == true && jsonData['dataBundle'] != null) {
          final List<dynamic> sdgDataArray = jsonData['dataBundle'];

          setState(() {
            sdgGoals = sdgDataArray
                .map((sdgData) => {
                      'sdgGoalDataId': sdgData['SDG_GOAL_DATA_ID'] ?? '',
                      'sdgGoalId': sdgData['SDG_GOAL_ID'] ?? '',
                      'sdgGoal': sdgData['SDG_GOAL'] ?? '',
                      'createdDtm': sdgData['CREATED_DTM'] ?? '',
                      'createdBy': sdgData['CREATED_BY'] ?? '',
                      'createdByName': sdgData['CREATED_BY_NAME'] ?? '',
                    })
                .toList();
            isLoadingSDG = false;
          });
        } else {
          setState(() {
            sdgErrorMessage =
                'Failed to load SDG goals: ${jsonData['errorMessage'] ?? 'Unknown error'}';
            isLoadingSDG = false;
          });
        }
      } else {
        setState(() {
          sdgErrorMessage =
              'Failed to connect to server for SDG goals. Status code: ${response.statusCode}';
          isLoadingSDG = false;
        });
      }
    } catch (e) {
      setState(() {
        sdgErrorMessage = 'Error loading SDG goals: $e';
        isLoadingSDG = false;
      });
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        children: [
          Container(
            width: 120,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF80AF81),
            ),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                value.isNotEmpty ? value : 'N/A',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF80AF81),
            ),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSDGGoalsSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF80AF81),
            ),
            child: Text(
              'SDG Goals',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: isLoadingSDG
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                      ),
                    ),
                  )
                : sdgErrorMessage.isNotEmpty
                    ? Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade400,
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            sdgErrorMessage,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ],
                      )
                    : sdgGoals.isEmpty
                        ? Text(
                            'No SDG Goals assigned',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          )
                        : Column(
                            children: sdgGoals.map((goal) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.blue.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade500,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          goal['sdgGoalId'] ?? '',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        goal['sdgGoal'] ?? '',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'proposal submitted':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'must required':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                  ),
                ),
              )
            : errorMessage.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error Loading Plan Details',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _loadPlanDetails();
                              _loadSDGGoals();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4ECDC4),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      // Header with plan icon
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.assignment,
                                size: 30,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    planDetails!['projectTitle'] ??
                                        'Unknown Plan',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                              planDetails!['currentStatus'] ??
                                                  ''),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          planDetails!['currentStatus'] ?? '',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _getPriorityColor(
                                              planDetails!['planPriority'] ??
                                                  ''),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          planDetails!['planPriority'] ?? '',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),

                      // Plan details list
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildDetailRow('Project Title',
                                  planDetails!['projectTitle'] ?? ''),
                              _buildDetailRow('Project Type',
                                  planDetails!['projectType'] ?? ''),
                              _buildDetailRow('Estimated Cost',
                                  planDetails!['estimatedCost'] ?? ''),
                              _buildDetailRow('Expected Output',
                                  planDetails!['estimatedOutput'] ?? ''),
                              _buildDetailRow('GN Division',
                                  planDetails!['gnLocation'] ?? ''),
                              _buildDetailRow('Sector Name',
                                  planDetails!['sectorName'] ?? ''),
                              _buildDetailRow('Related Office',
                                  planDetails!['sectorLocation'] ?? ''),
                              _buildDetailRow('Plan Priority',
                                  planDetails!['planPriority'] ?? ''),
                              _buildDescriptionRow('Description',
                                  planDetails!['planDescription'] ?? ''),
                              _buildDetailRow('Allocated Amount',
                                  planDetails!['allocatedAmount'] ?? ''),
                              _buildDetailRow('Contractor Details',
                                  planDetails!['contractorDetails'] ?? ''),
                              _buildDetailRow('Funding Source',
                                  planDetails!['fundingSource'] ?? ''),
                              _buildDetailRow('Current Status',
                                  planDetails!['currentStatus'] ?? ''),
                              _buildDetailRow('Created at',
                                  planDetails!['createdDtm'] ?? ''),
                              _buildDetailRow('Created by',
                                  '${planDetails!['createdBy'] ?? ''}-${planDetails!['createdByName'] ?? ''}'),
                              _buildDetailRow('Last Updated at',
                                  planDetails!['lastUpdatedDtm'] ?? ''),
                              _buildSDGGoalsSection(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
