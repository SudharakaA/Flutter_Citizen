import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../checkbox_dropdown_selector.dart';
import '../action_button.dart';
import 'view_user_details.dart';

class UserManagementPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;
  final List<String> authorizedRoleList;

  const UserManagementPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
    required this.authorizedRoleList,
  });

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  List<String> selectedDSOfficeStatuses = [];
  List<String> DSOfficeStatuses = [];
  List<Map<String, dynamic>> locationData = []; // Store complete location data
  bool isLoadingLocations = true;

  @override
  void initState() {
    super.initState();
    _loadPrivilegedLocations();
  }

  Future<void> _loadPrivilegedLocations() async {
    try {
      setState(() {
        isLoadingLocations = true;
      });

      final url = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi/PrivilegedLocationsRequested?username=${widget.citizenCode}&viewName=userconfiguration';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['isSuccess'] == true && jsonData['dataBundle'] != null) {
          final List<dynamic> apiLocationData = jsonData['dataBundle'];

          setState(() {
            // Store complete location data
            locationData = apiLocationData.map<Map<String, dynamic>>((location) {
              return {
                'LOCATION_ID': location['LOCATION_ID'],
                'LOCATION': location['LOCATION'] ?? '',
                'LOCATION_TYPE': location['LOCATION_TYPE'] ?? '',
                'DS_DIVISION_ID': location['DS_DIVISION_ID'],
                'SECTION_ID': location['SECTION_ID'],
              };
            }).toList();

            // Create display strings for dropdown
            DSOfficeStatuses = locationData.map<String>((location) {
              String locationName = location['LOCATION'];
              String locationType = location['LOCATION_TYPE'];

              if (locationName.isNotEmpty && locationType.isNotEmpty) {
                return '$locationName - $locationType';
              }
              return locationName.isNotEmpty ? locationName : 'Unknown Location';
            }).toList();

            isLoadingLocations = false;
          });
        } else {
          _showError('Failed to load locations: ${jsonData['errorMessage'] ?? 'Unknown error'}');
        }
      } else {
        _showError('Failed to connect to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error loading locations: $e');
    } finally {
      setState(() {
        isLoadingLocations = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF).withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      'User Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Center(
                child: Text(
                  'Select DS Office',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),

              // Show loading indicator or dropdown
              if (isLoadingLocations)
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (DSOfficeStatuses.isEmpty)
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'No locations available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                CheckboxDropdownSelector(
                  title: 'DS Office Status',
                  options: DSOfficeStatuses,
                  selectedItems: selectedDSOfficeStatuses,
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      selectedDSOfficeStatuses = newSelection;
                    });
                  },
                ),

              const SizedBox(height: 24),

              Center(
                child: ActionButton(
                  text: 'View Users',
                  onPressed: _validateAndSubmit,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    if (selectedDSOfficeStatuses.isEmpty) {
      _showValidationError('Please select at least one DS Office.');
    } else {
      // Get the location IDs for selected DS offices
      List<String> selectedLocationIds = [];

      for (String selectedOffice in selectedDSOfficeStatuses) {
        // Find the index of selected office in DSOfficeStatuses
        int index = DSOfficeStatuses.indexOf(selectedOffice);
        if (index != -1 && index < locationData.length) {
          // Get the LOCATION_ID from locationData
          var locationId = locationData[index]['LOCATION_ID'];
          if (locationId != null) {
            selectedLocationIds.add(locationId.toString());
          }
        }
      }

      print('Selected Location IDs: $selectedLocationIds'); // Debug print

      // Navigate to ViewUserPage with selected location IDs
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewUserPage(
            accessToken: widget.accessToken,
            citizenCode: widget.citizenCode,
            authorizedRoleList: widget.authorizedRoleList,
            selectedLocationIds: selectedLocationIds,
          ),
        ),
      );
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}