import 'package:citizen_care_system/admin_pages/system_configuration/privilege_management/privilege_management.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../admin _component/citizen_service_task/download_dialog.dart';
import '../../../component/admin_circle_menu/fab_menu.dart';
import '../../../component/admin_circle_menu/hover_tap_button.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../user_configuration/user_management.dart';

class ViewPrivilegeDetailsPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;
  final List<String> authorizedRoleList;
  // Make these optional since they won't be available initially
  final List<String>? selectedLocationIds;
  final List<String>? selectedUserIds;
  final List<String>? selectedPrivilegeIds;
  // Add new parameters for ViewPrivilege component
  final List<int>? selectedLocationIdsInt;
  final List<String>? selectedUsernames;
  final List<int>? selectedPrivilegeConfigIds;
  final List<int>? selectedPrivilegeTypeIds;

  const ViewPrivilegeDetailsPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
    required this.authorizedRoleList,
    this.selectedLocationIds,
    this.selectedUserIds,
    this.selectedPrivilegeIds,
    this.selectedLocationIdsInt,
    this.selectedUsernames,
    this.selectedPrivilegeConfigIds,
    this.selectedPrivilegeTypeIds,
  });

  @override
  State<ViewPrivilegeDetailsPage> createState() => _ViewPrivilegeDetailsPageState();
}

class _ViewPrivilegeDetailsPageState extends State<ViewPrivilegeDetailsPage> {
  // ViewPrivilege component data
  static const String baseUrl = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi';

  List<Map<String, dynamic>> privilegeConfigurations = [];
  List<Map<String, dynamic>> userPrivilegeDetails = [];
  List<Map<String, dynamic>> allowedLocationTypes = [];
  List<Map<String, dynamic>> allLocationTypes = [];
  List<Map<String, dynamic>> userManagementLocations = [];

  Map<String, bool> privilegeStates = {};
  Set<String> expandedSections = {};
  Map<String, List<Map<String, dynamic>>> selectedLocationsMap = {};
  Map<String, String?> dropdownSelections = {};
  Map<String, List<Map<String, dynamic>>> groupedPrivileges = {};

  bool isLoading = false;
  bool isSaving = false;
  String errorMessage = '';
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    // Check if we have data to load
    if (widget.selectedLocationIdsInt != null && widget.selectedLocationIdsInt!.isNotEmpty) {
      hasData = true;
      _loadAllData();
    }
  }

  // Check if we have required data to show the ViewPrivilege component
  bool get _hasRequiredData => widget.selectedLocationIdsInt != null &&
      widget.selectedUsernames != null &&
      widget.selectedPrivilegeConfigIds != null &&
      widget.selectedPrivilegeTypeIds != null;

  Future<void> _loadAllData() async {
    if (!_hasRequiredData) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await Future.wait([
        _loadPrivilegeConfigurations(),
        _loadUserPrivilegeDetails(),
        _loadAllowedLocationTypes(),
        _loadAllLocationTypes(),
        _loadUserManagementLocations(),
      ]);

      _processData();
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading privilege data: $e';
        isLoading = false;
      });
    }
  }

  void _processData() {
    _groupPrivileges();
    _initializePrivilegeStates();
    _initializeSelectedLocations();
    _initializeDropdownSelections();
    setState(() => isLoading = false);
  }

  void _groupPrivileges() {
    groupedPrivileges.clear();

    if (userPrivilegeDetails.isNotEmpty) {
      for (var privilege in userPrivilegeDetails) {
        String key = '${privilege['PRIVILEGE_TYPE'] ?? ''} - ${privilege['AUTHORIZED_ROLE'] ?? ''}';
        groupedPrivileges.putIfAbsent(key, () => []).add(privilege);
      }
    } else if (widget.selectedPrivilegeConfigIds != null) {
      // Fallback for empty userPrivilegeDetails
      String fallbackKey = "Citizen Management - Administrator";
      groupedPrivileges[fallbackKey] = widget.selectedPrivilegeConfigIds!
          .map((id) => {
        'PRIVILEGE_CONFIGURATION_ID': id,
        'PRIVILEGE_TYPE': 'Citizen Management',
        'AUTHORIZED_ROLE': 'Administrator',
        'PRIVILEGE_TYPE_ID': id,
        'PRIVILEGE_DATA_ID': id,
      })
          .toList();
    }
  }

  void _initializePrivilegeStates() {
    privilegeStates.clear();

    for (var privilege in userPrivilegeDetails) {
      String configId = privilege['PRIVILEGE_CONFIGURATION_ID']?.toString() ?? '';
      privilegeStates[configId] = false;
    }

    for (var userLocation in userManagementLocations) {
      String configId = userLocation['PRIVILEGE_CONFIGURATION_ID']?.toString() ?? '';
      privilegeStates[configId] = true;
    }
  }

  void _initializeSelectedLocations() {
    selectedLocationsMap.clear();

    for (var userLocation in userManagementLocations) {
      String key = _getLocationKey(userLocation);
      selectedLocationsMap.putIfAbsent(key, () => []).add(userLocation);
    }
  }

  void _initializeDropdownSelections() {
    dropdownSelections.clear();

    for (var userLocation in userManagementLocations) {
      String key = _getLocationKey(userLocation);
      String locationId = userLocation['LOCATION_ID']?.toString() ?? '';
      dropdownSelections[key] = locationId;
    }
  }

  String _getLocationKey(Map<String, dynamic> location) {
    String privilegeConfigId = location['PRIVILEGE_CONFIGURATION_ID']?.toString() ?? '';
    String locationTypeId = location['LOCATION_TYPE_ID']?.toString() ?? '';
    return '${privilegeConfigId}_$locationTypeId';
  }

  List<Map<String, dynamic>> _getAvailableLocationsForType(String locationTypeId) {
    return allowedLocationTypes
        .where((location) => location['LOCATION_TYPE_ID']?.toString() == locationTypeId)
        .toList();
  }

  // API Methods from ViewPrivilege
  Future<void> _loadPrivilegeConfigurations() async {
    if (widget.selectedPrivilegeConfigIds == null) return;

    final response = await _makePostRequest(
      '$baseUrl/PrivilegeConfigurations',
      {"privilegeConfigurationList": widget.selectedPrivilegeConfigIds!},
    );

    if (response != null) {
      privilegeConfigurations = List<Map<String, dynamic>>.from(response);
    }
  }

  Future<void> _loadUserPrivilegeDetails() async {
    if (widget.selectedPrivilegeTypeIds == null && widget.selectedPrivilegeConfigIds == null) return;

    List<int> privilegeTypeList = widget.selectedPrivilegeTypeIds?.isNotEmpty == true
        ? widget.selectedPrivilegeTypeIds!
        : widget.selectedPrivilegeConfigIds!;

    final response = await _makePostRequest(
      '$baseUrl/GetUserPrivilegeDetailList',
      {
        "privilegeTypeList": privilegeTypeList,
        "username": widget.citizenCode
      },
    );

    if (response != null) {
      userPrivilegeDetails = List<Map<String, dynamic>>.from(response);
    }
  }

  Future<void> _loadAllowedLocationTypes() async {
    if (widget.selectedPrivilegeConfigIds == null) return;

    final response = await _makePostRequest(
      '$baseUrl/GetAllowedLocationTypes',
      {"privilegeConfigurationList": widget.selectedPrivilegeConfigIds!},
    );

    if (response != null) {
      allowedLocationTypes = List<Map<String, dynamic>>.from(response);
    }
  }

  Future<void> _loadAllLocationTypes() async {
    final response = await _makeGetRequest('$baseUrl/GetAllLocationTypes');
    if (response != null) {
      allLocationTypes = List<Map<String, dynamic>>.from(response);
    }
  }

  Future<void> _loadUserManagementLocations() async {
    if (widget.selectedLocationIdsInt == null) return;

    final response = await _makePostRequest(
      '$baseUrl/UserManagementLocationsRequested',
      {
        "locationTypeList": widget.selectedLocationIdsInt!,
        "loggedUser": widget.citizenCode
      },
    );

    if (response != null) {
      userManagementLocations = List<Map<String, dynamic>>.from(response);
    }
  }

  Future<List<Map<String, dynamic>>?> _makePostRequest(String url, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _getHeaders(),
        body: json.encode(body),
      );

      return _parseResponse(response);
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> _makeGetRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: _getHeaders());
      return _parseResponse(response);
    } catch (e) {
      return null;
    }
  }

  Map<String, String> _getHeaders() => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${widget.accessToken}',
  };

  List<Map<String, dynamic>>? _parseResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['isSuccess'] == true && jsonData['dataBundle'] != null) {
        return List<Map<String, dynamic>>.from(jsonData['dataBundle']);
      }
    }
    return null;
  }

  // Update Methods from ViewPrivilege
  Future<void> _updatePrivilegeLocation(String privilegeConfigId, String locationTypeId, String locationTypeName) async {
    String key = '${privilegeConfigId}_$locationTypeId';
    String? selectedLocationId = dropdownSelections[key];

    if (selectedLocationId == null) {
      _showMessage('Please select a location for $locationTypeName', isError: true);
      return;
    }

    _showLoadingDialog();

    try {
      Map<String, dynamic>? selectedLocation = allowedLocationTypes
          .where((loc) => loc['LOCATION_ID']?.toString() == selectedLocationId)
          .firstOrNull;

      if (selectedLocation == null) {
        _hideLoadingDialog();
        _showMessage('Selected location not found', isError: true);
        return;
      }

      final requestBody = {
        "username": widget.citizenCode,
        "PRIVILEGE_CONFIGURATION_ID": privilegeConfigId,
        "LOCATION_TYPE_ID": locationTypeId,
        "LOCATION_ID": selectedLocationId,
        "ALLOWED_LOCATION_LIST": [selectedLocationId],
      };

      final response = await http.post(
        Uri.parse('$baseUrl/UserPrivilegeDetailsUpdated'),
        headers: _getHeaders(),
        body: json.encode(requestBody),
      );

      _hideLoadingDialog();

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['isSuccess'] == true) {
          setState(() {
            selectedLocationsMap[key] = [selectedLocation];
          });
          _showMessage('Location updated successfully for $locationTypeName');
        } else {
          _showMessage('Failed to update location: ${jsonData['errorMessage'] ?? 'Unknown error'}', isError: true);
        }
      } else {
        _showMessage('Failed to connect to server. Status code: ${response.statusCode}', isError: true);
      }
    } catch (e) {
      _hideLoadingDialog();
      _showMessage('Network error: Please check your connection and try again.', isError: true);
    }
  }

  Future<void> _submitPrivilegeChanges(String privilegeGroupName) async {
    _showLoadingDialog();

    try {
      List<Map<String, dynamic>> groupPrivileges = groupedPrivileges[privilegeGroupName] ?? [];
      List<Map<String, dynamic>> privilegeUpdates = groupPrivileges.map((privilege) {
        String configId = privilege['PRIVILEGE_CONFIGURATION_ID']?.toString() ?? '';
        bool isEnabled = privilegeStates[configId] ?? false;

        return {
          "PRIVILEGE_TYPE_ID": privilege['PRIVILEGE_TYPE_ID']?.toString() ?? "",
          "AUTHORIZED_ROLE": privilege['AUTHORIZED_ROLE'] ?? "",
          "PRIVILEGE_DATA_ID": privilege['PRIVILEGE_DATA_ID']?.toString() ?? "",
          "PRIVILEGE_CONFIGURATION_ID": configId,
          "PRIVILEGE_TYPE": privilege['PRIVILEGE_TYPE'] ?? "",
          "isEnabled": isEnabled ? 1 : 0,
        };
      }).toList();

      final requestBody = {
        "username": widget.citizenCode,
        "privileges": privilegeUpdates,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/UserPrivilegeDetailsBulkUpdated'),
        headers: _getHeaders(),
        body: json.encode(requestBody),
      );

      _hideLoadingDialog();

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['isSuccess'] == true) {
          _showMessage('$privilegeGroupName privileges updated successfully');
        } else {
          _showMessage('Failed to update $privilegeGroupName privileges: ${jsonData['errorMessage'] ?? 'Unknown error'}', isError: true);
        }
      } else {
        _showMessage('Failed to connect to server. Status code: ${response.statusCode}', isError: true);
      }
    } catch (e) {
      _hideLoadingDialog();
      _showMessage('Network error: Please check your connection and try again.', isError: true);
    }
  }

  // UI Helper Methods
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 5 : 3),
      ),
    );
  }

  // Navigation to PrivilegeManagementPage with callback
  void _navigateToPrivilegeManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivilegeManagementPage(
          accessToken: widget.accessToken,
          citizenCode: widget.citizenCode,
          authorizedRoleList: widget.authorizedRoleList,
        ),
      ),
    ).then((result) {
      // If result contains the selected data, update this page
      if (result != null && result is Map<String, dynamic>) {
        // Navigate to this same page but with data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ViewPrivilegeDetailsPage(
              accessToken: widget.accessToken,
              citizenCode: widget.citizenCode,
              authorizedRoleList: widget.authorizedRoleList,
              selectedLocationIdsInt: result['selectedLocationIds'],
              selectedUsernames: result['selectedUsernames'],
              selectedPrivilegeConfigIds: result['selectedPrivilegeConfigIds'],
              selectedPrivilegeTypeIds: result['selectedPrivilegeTypeIds'],
            ),
          ),
        );
      }
    });
  }

  // ViewPrivilege component UI methods
  Widget _buildPrivilegeSection(String privilegeGroupName, List<Map<String, dynamic>> groupPrivileges) {
    bool isExpanded = expandedSections.contains(privilegeGroupName);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildSectionHeader(privilegeGroupName, isExpanded),
          if (isExpanded) _buildSectionContent(privilegeGroupName, groupPrivileges),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
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
  );

  Widget _buildSectionHeader(String privilegeGroupName, bool isExpanded) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isExpanded) {
            expandedSections.remove(privilegeGroupName);
          } else {
            expandedSections.add(privilegeGroupName);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: isExpanded
              ? const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))
              : BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                privilegeGroupName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContent(String privilegeGroupName, List<Map<String, dynamic>> groupPrivileges) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTableHeader(),
          const SizedBox(height: 8),
          ...allLocationTypes.map((locationType) =>
              _buildLocationTypeRow(groupPrivileges.first['PRIVILEGE_CONFIGURATION_ID']?.toString() ?? '', locationType)
          ).toList(),
          const SizedBox(height: 16),
          _buildUpdateButton(privilegeGroupName),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('Location Category', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
          Expanded(flex: 3, child: Text('Allowed locations', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('Update', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildLocationTypeRow(String privilegeConfigId, Map<String, dynamic> locationType) {
    String locationTypeName = locationType['LOCATION_TYPE'] ?? 'Unknown Location';
    String locationTypeId = locationType['LOCATION_TYPE_ID']?.toString() ?? '';
    String key = '${privilegeConfigId}_$locationTypeId';
    List<Map<String, dynamic>> availableLocations = _getAvailableLocationsForType(locationTypeId);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(locationTypeName, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center)),
          Expanded(flex: 3, child: _buildLocationDropdown(key, availableLocations)),
          Expanded(flex: 2, child: _buildUpdateLocationButton(privilegeConfigId, locationTypeId, locationTypeName, availableLocations)),
        ],
      ),
    );
  }

  Widget _buildLocationDropdown(String key, List<Map<String, dynamic>> availableLocations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonFormField<String>(
        value: dropdownSelections[key],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.green)),
        ),
        hint: Text(availableLocations.isEmpty ? 'No locations available' : 'Select location', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        items: [
          const DropdownMenuItem<String>(value: null, child: Text('Nothing selected', style: TextStyle(fontSize: 12, color: Colors.grey))),
          ...availableLocations.map((location) {
            String locationId = location['LOCATION_ID']?.toString() ?? '';
            String locationName = location['LOCATION'] ?? location['LOCATION_TYPE'] ?? 'Unknown Location';
            return DropdownMenuItem<String>(
              value: locationId,
              child: Text(locationName, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
            );
          }).toList(),
        ],
        onChanged: availableLocations.isEmpty ? null : (String? newValue) {
          setState(() => dropdownSelections[key] = newValue);
        },
        isExpanded: true,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }

  Widget _buildUpdateLocationButton(String privilegeConfigId, String locationTypeId, String locationTypeName, List<Map<String, dynamic>> availableLocations) {
    return Center(
      child: SizedBox(
        width: 70,
        height: 32,
        child: ElevatedButton(
          onPressed: availableLocations.isEmpty ? null : () => _updatePrivilegeLocation(privilegeConfigId, locationTypeId, locationTypeName),
          style: ElevatedButton.styleFrom(
            backgroundColor: availableLocations.isEmpty ? Colors.grey : Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: const Text('UPDATE', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(String privilegeGroupName) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: isSaving ? null : () => _submitPrivilegeChanges(privilegeGroupName),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: isSaving
            ? const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
            SizedBox(width: 8),
            Text('Updating...', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        )
            : const Text('UPDATE BULK', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildInitialView() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.admin_panel_settings_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            'Privilege Management',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              'Please select DS Office to view privilege details.\nClick on the view list button in the floating menu to start.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Icon(
            Icons.arrow_downward,
            size: 30,
            color: Colors.orange.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'Click the view list icon below',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red.shade400),
            const SizedBox(height: 16),
            const Text('Error Loading Privilege Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 8),
            Text(errorMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadAllData,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4ECDC4), foregroundColor: Colors.white),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (groupedPrivileges.isEmpty) _buildNoDataView(),
          ...groupedPrivileges.entries.map((entry) => _buildPrivilegeSection(entry.key, entry.value)).toList(),
        ],
      ),
    );
  }

  Widget _buildNoDataView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade600, size: 48),
          const SizedBox(height: 12),
          Text('No Privilege Groups Found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange.shade700)),
          const SizedBox(height: 8),
          Text(
            'This might be because:\n• No privileges are configured for this user\n• The API response is empty\n• There\'s an issue with data grouping',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.orange.shade600),
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
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
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
                  Text(
                    'Privilege Management Details',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage user privileges across different locations and services',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: !_hasRequiredData
                  ? _buildInitialView()
                  : isLoading
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF80AF81)),
                  ),
                ),
              )
                  : errorMessage.isNotEmpty
                  ? _buildErrorView()
                  : _buildContentView(),
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
            onTap: _navigateToPrivilegeManagement,
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