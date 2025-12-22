import 'package:citizen_care_system/admin_pages/system_configuration/user_configuration/editeuserdetails.dart';
import 'package:citizen_care_system/admin_pages/system_configuration/user_configuration/paigination.dart';
import 'package:citizen_care_system/admin_pages/system_configuration/user_configuration/privilegedetailspage.dart';
import 'package:citizen_care_system/admin_pages/system_configuration/user_configuration/searchbar.dart';
import 'package:citizen_care_system/admin_pages/system_configuration/user_configuration/user_management.dart';
import 'package:citizen_care_system/admin_pages/system_configuration/user_configuration/useraction.dart';
import 'package:citizen_care_system/admin_pages/system_configuration/user_configuration/userdetails.dart';
import 'package:citizen_care_system/component/admin_circle_menu/fab_menu.dart';
import 'package:citizen_care_system/component/admin_circle_menu/hover_tap_button.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../admin _component/citizen_service_task/download_dialog.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import 'package:citizen_care_system/admin_pages/citizen_services_pages/view_service_task.dart';


import 'datatable.dart';


class ViewUserPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;
  final List<String> authorizedRoleList;
  final List<String>? selectedServiceType;
  final String? selectedRequestType;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? selectedLocationIds;

  const ViewUserPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
    required this.authorizedRoleList,
    this.selectedServiceType,
    this.selectedRequestType,
    this.startDate,
    this.endDate,
    this.selectedLocationIds,
  });

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
  final List<String> columnLabels = [
    'Actions',
    'Username',
    'Calling name',
    'Designation',
    'Work Location',
    'Mobile number',
  ];

  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> filteredUserList = [];
  bool isLoadingUsers = true;
  bool isProcessing = false;

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Pagination
  int currentPage = 1;
  int itemsPerPage = 7;
  List<Map<String, dynamic>> paginatedUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUserList();
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
      _searchQuery = _searchController.text.toLowerCase();
      currentPage = 1; // Reset to first page when searching
      _filterUsers();
      _updatePaginatedUsers();
    });
  }

  void _filterUsers() {
    if (_searchQuery.isEmpty) {
      filteredUserList = List.from(userList);
    } else {
      filteredUserList = userList.where((user) {
        return (user['username']?.toLowerCase().contains(_searchQuery) ?? false) ||
            (user['callingName']?.toLowerCase().contains(_searchQuery) ?? false) ||
            (user['designation']?.toLowerCase().contains(_searchQuery) ?? false) ||
            (user['workLocation']?.toLowerCase().contains(_searchQuery) ?? false) ||
            (user['mobileNumber']?.toLowerCase().contains(_searchQuery) ?? false);
      }).toList();
    }
  }

  void _updatePaginatedUsers() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    if (endIndex > filteredUserList.length) {
      endIndex = filteredUserList.length;
    }

    paginatedUsers = filteredUserList.sublist(startIndex, endIndex);
  }

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      _updatePaginatedUsers();
    });
  }

  int get totalPages => (filteredUserList.length / itemsPerPage).ceil();

  Future<void> _loadUserList() async {
    try {
      setState(() {
        isLoadingUsers = true;
      });

      final requestBody = {
        "locationIdList": widget.selectedLocationIds ?? []
      };

      final url = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi/UserListRequested';

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
          final List<dynamic> userData = jsonData['dataBundle'];

          setState(() {
            userList = userData.map<Map<String, dynamic>>((user) {
              return {
                'username': user['USERNAME'] ?? '',
                'callingName': user['CALLING_NAME'] ?? '',
                'designation': user['DESIGNATION'] ?? '',
                'workLocation': user['LOCATION'] ?? '',
                'mobileNumber': user['MOBILE_NUMBER'] ?? '',
              };
            }).toList();

            _filterUsers();
            _updatePaginatedUsers();
            isLoadingUsers = false;
          });
        } else {
          _showError('Failed to load users: ${jsonData['errorMessage'] ?? 'Unknown error'}');
        }
      } else {
        _showError('Failed to connect to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error loading users: $e');
    } finally {
      setState(() {
        isLoadingUsers = false;
      });
    }
  }

  // Results Summary Widget
  Widget _buildResultsSummary() {
    if (isLoadingUsers) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 100,
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
    if (_searchQuery.isNotEmpty) {
      summaryText = 'Found ${filteredUserList.length} users matching "$_searchQuery"';
    } else {
      summaryText = 'Total ${userList.length} users';
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

  // API Functions
  Future<void> _resetPassword(Map<String, dynamic> user) async {
    try {
      setState(() {
        isProcessing = true;
      });

      final requestBody = {"username": user['username']};
      final url = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi/ResetPasswordRequested';

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
        if (jsonData['isSuccess'] == true) {
          _showSuccessDialog(
            'Password Reset Successful',
            'Password has been reset successfully for ${user['callingName']}.',
          );
        } else {
          _showErrorDialog('Password Reset Failed', jsonData['errorMessage'] ?? 'Unknown error occurred');
        }
      } else {
        _showErrorDialog('Connection Error', 'Failed to connect to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Error', 'Error resetting password: $e');
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<void> _deleteUser(Map<String, dynamic> user) async {
    try {
      setState(() {
        isProcessing = true;
      });

      final requestBody = {
        "username": user['username'],
        "createdBy": widget.citizenCode,
        "createdByName": "Kavinda"
      };

      final url = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi/UserTerminationRequested';

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
        if (jsonData['isSuccess'] == true) {
          _showSuccessDialog(
            'User Deleted Successfully',
            'User ${user['callingName']} has been deleted successfully.',
          );
          _loadUserList();
        } else {
          _showErrorDialog('Delete Failed', jsonData['errorMessage'] ?? 'Unknown error occurred');
        }
      } else {
        _showErrorDialog('Connection Error', 'Failed to connect to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Error', 'Error deleting user: $e');
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  // Dialog Functions
  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              const SizedBox(width: 10),
              Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          content: Text(message, style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 30),
              const SizedBox(width: 10),
              Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
          content: Text(message, style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
            builder: (context) => ViewUserPage(
              accessToken: widget.accessToken,
              citizenCode: widget.citizenCode,
              authorizedRoleList: widget.authorizedRoleList,
              selectedServiceType: result['selectedServiceType'],
              selectedRequestType: result['selectedRequestType'],
              startDate: result['startDate'],
              endDate: result['endDate'],
              selectedLocationIds: widget.selectedLocationIds,
            ),
          ),
        );
      }
    });
  }

  void _showUserActions(Map<String, dynamic> user) {
    UserActionsComponent.showUserActions(
      context: context,
      user: user,
      accessToken: widget.accessToken,
      onViewDetails: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsPage(
              accessToken: widget.accessToken,
              username: user['username'] ?? '',
            ),
          ),
        );
      },
      onEditUser: () async {
        Navigator.pop(context);
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditUserPage(
              accessToken: widget.accessToken,
              username: user['username'] ?? '',
              userData: user,
            ),
          ),
        );
        if (result == true) {
          _loadUserList();
        }
      },
      onPrivilegeDetails: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrivilegeDetailsPage(
              accessToken: widget.accessToken,
              username: user['username'] ?? '',
            ),
          ),
        );
      },
      onResetPassword: () {
        Navigator.pop(context);
        UserActionsComponent.showPasswordResetConfirmation(
          context: context,
          user: user,
          isProcessing: isProcessing,
          onConfirm: () {
            Navigator.pop(context);
            _resetPassword(user);
          },
        );
      },
      onDeleteUser: () {
        Navigator.pop(context);
        UserActionsComponent.showDeleteConfirmation(
          context: context,
          user: user,
          isProcessing: isProcessing,
          onConfirm: () {
            Navigator.pop(context);
            _deleteUser(user);
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
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
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
                'User Management',
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
              UserSearchComponent(
                searchController: _searchController,
                searchQuery: _searchQuery,
                onClear: () {
                  _searchController.clear();
                },
              ),

              // Results Summary
              _buildResultsSummary(),

              // Loading overlay
              if (isProcessing)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // Enhanced Data Table with Loading State
              Expanded(
                child: !isLoadingUsers && filteredUserList.isEmpty && _searchQuery.isNotEmpty
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
                        'No users found matching "$_searchQuery"',
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
                    : !isLoadingUsers && userList.isEmpty
                    ? const Center(
                  child: Text(
                    '           No users found.\nPlease First Select DS Office',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : Column(
                  children: [
                    Expanded(
                      child: UserDataTableComponent(
                        columnLabels: columnLabels,
                        paginatedUsers: paginatedUsers,
                        isLoadingUsers: isLoadingUsers,
                        isProcessing: isProcessing,
                        onUserActions: _showUserActions,
                      ),
                    ),
                    // Pagination Component
                    if (!isLoadingUsers && filteredUserList.isNotEmpty)
                      PaginationComponent(
                        currentPage: currentPage,
                        totalPages: totalPages,
                        totalItems: filteredUserList.length,
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
      // Floating Action Menu
      floatingActionButton: CustomFabMenu(
        menuItems: [
          HoverTapButton(
            icon: Icons.add,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserManagementPage(
                    accessToken: widget.accessToken,
                    citizenCode: widget.citizenCode,
                    authorizedRoleList: widget.authorizedRoleList,
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
                  builder: (context) => UserManagementPage(
                    accessToken: widget.accessToken,
                    citizenCode: widget.citizenCode,
                    authorizedRoleList: widget.authorizedRoleList,
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