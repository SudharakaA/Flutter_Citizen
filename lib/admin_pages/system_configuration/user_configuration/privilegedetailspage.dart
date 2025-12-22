import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';

class PrivilegeDetailsPage extends StatefulWidget {
  final String accessToken;
  final String username;

  const PrivilegeDetailsPage({
    super.key,
    required this.accessToken,
    required this.username,
  });

  @override
  State<PrivilegeDetailsPage> createState() => _PrivilegeDetailsPageState();
}

class _PrivilegeDetailsPageState extends State<PrivilegeDetailsPage> {
  List<Map<String, dynamic>> allPrivileges = [];
  List<Map<String, dynamic>> privilegeTypes = [];
  List<Map<String, dynamic>> userPrivileges = [];
  Map<String, List<Map<String, dynamic>>> groupedPrivileges = {};
  Map<String, bool> privilegeStates = {};
  Set<String> expandedSections = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPrivilegeData();
  }

  Future<void> _loadPrivilegeData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Load all data concurrently
      await Future.wait([
        _loadAllPrivileges(),
        _loadPrivilegeTypes(),
        _loadUserPrivileges(),
      ]);

      _groupPrivilegesByType();
      _initializePrivilegeStates();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading privilege data: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _loadAllPrivileges() async {
    final url = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi/AllUserPrivileges';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['isSuccess'] == true && jsonData['dataBundle'] != null) {
        allPrivileges = List<Map<String, dynamic>>.from(jsonData['dataBundle']);
      }
    } else {
      throw Exception('Failed to load all privileges');
    }
  }

  Future<void> _loadPrivilegeTypes() async {
    final url = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi/AllPrivilegeTypes';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['isSuccess'] == true && jsonData['dataBundle'] != null) {
        privilegeTypes = List<Map<String, dynamic>>.from(jsonData['dataBundle']);
      }
    } else {
      throw Exception('Failed to load privilege types');
    }
  }

  Future<void> _loadUserPrivileges() async {
    final url = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi/UserPrivileges';

    final requestBody = {
      "username": widget.username,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.accessToken}',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['isSuccess'] == true && jsonData['dataBundle'] != null) {
        userPrivileges = List<Map<String, dynamic>>.from(jsonData['dataBundle']);
      }
    } else {
      throw Exception('Failed to load user privileges');
    }
  }

  void _groupPrivilegesByType() {
    groupedPrivileges.clear();

    for (var privilege in allPrivileges) {
      String privilegeType = privilege['PRIVILEGE_TYPE'] ?? 'Unknown';

      if (!groupedPrivileges.containsKey(privilegeType)) {
        groupedPrivileges[privilegeType] = [];
      }

      groupedPrivileges[privilegeType]!.add(privilege);
    }
  }

  void _initializePrivilegeStates() {
    privilegeStates.clear();

    // Initialize all privileges as false
    for (var privilege in allPrivileges) {
      String configId = privilege['PRIVILEGE_CONFIGURATION_ID']?.toString() ?? '';
      privilegeStates[configId] = false;
    }

    // Set user's current privileges as true
    for (var userPrivilege in userPrivileges) {
      String configId = userPrivilege['PRIVILEGE_CONFIGURATION_ID']?.toString() ?? '';
      privilegeStates[configId] = true;
    }
  }

  Future<void> _submitPrivilegeChanges() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Prepare the update data based on the API structure shown in Postman
      List<Map<String, dynamic>> privilegeUpdates = [];

      privilegeStates.forEach((configId, isEnabled) {
        // Find the privilege details from allPrivileges
        final privilege = allPrivileges.firstWhere(
              (p) => p['PRIVILEGE_CONFIGURATION_ID']?.toString() == configId,
          orElse: () => {},
        );

        if (privilege.isNotEmpty) {
          privilegeUpdates.add({
            "PRIVILEGE_TYPE_ID": privilege['PRIVILEGE_TYPE_ID']?.toString() ?? "",
            "AUTHORIZED_ROLE": privilege['AUTHORIZED_ROLE'] ?? "",
            "PRIVILEGE_DATA_ID": privilege['PRIVILEGE_DATA_ID']?.toString() ?? "",
            "PRIVILEGE_CONFIGURATION_ID": configId,
            "PRIVILEGE_TYPE": privilege['PRIVILEGE_TYPE'] ?? "",
            // Send 1 for enabled, 0 for disabled (as integers)
            "isEnabled": isEnabled ? 1 : 0,
          });
        }
      });

      final requestBody = {
        "username": widget.username,
        "privileges": privilegeUpdates,
      };

      print('Request body: ${json.encode(requestBody)}'); // Debug print

      final url = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi/UpdatePrivilegeDataRequested';

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

      // Close loading dialog
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['isSuccess'] == true) {
          _showSuccessMessage('Privileges updated successfully');
          Navigator.pop(context, true); // Return success
        } else {
          String errorMsg = jsonData['errorMessage'] ?? 'Unknown error';
          _showErrorMessage('Failed to update privileges: $errorMsg');
        }
      } else if (response.statusCode == 401) {
        _showErrorMessage('Session expired. Please login again.');
      } else if (response.statusCode == 500) {
        _showErrorMessage('Server error occurred. Please try again later.');
      } else {
        _showErrorMessage('Failed to connect to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      print('Error updating privileges: $e'); // Debug print
      _showErrorMessage('Network error: Please check your connection and try again.');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Widget _buildPrivilegeSection(String privilegeType, List<Map<String, dynamic>> privileges) {
    bool isExpanded = expandedSections.contains(privilegeType);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedSections.remove(privilegeType);
                } else {
                  expandedSections.add(privilegeType);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: isExpanded
                    ? const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                )
                    : BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      privilegeType,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),

          // Privilege Details (only shown when expanded)
          if (isExpanded) ...[
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Location',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Privilege',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Active',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Privilege Rows
                  ...privileges.map((privilege) => _buildPrivilegeRow(privilege)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrivilegeRow(Map<String, dynamic> privilege) {
    String configId = privilege['PRIVILEGE_CONFIGURATION_ID']?.toString() ?? '';
    bool isActive = privilegeStates[configId] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              privilege['PRIVILEGE_TYPE'] ?? '',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              privilege['AUTHORIZED_ROLE'] ?? '',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: isActive,
                  onChanged: (bool value) {
                    setState(() {
                      privilegeStates[configId] = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Colors.orange,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
          color: Colors.grey.shade50,
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
        child: Column(
          children: [
            // Content Area
            Expanded(
              child: isLoading
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF80AF81),),
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
                        'Error Loading Privilege Details',
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
                        onPressed: _loadPrivilegeData,
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
                  : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: groupedPrivileges.entries
                      .map((entry) => _buildPrivilegeSection(entry.key, entry.value))
                      .toList(),
                ),
              ),
            ),

            // Bottom Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitPrivilegeChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF80AF81),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}