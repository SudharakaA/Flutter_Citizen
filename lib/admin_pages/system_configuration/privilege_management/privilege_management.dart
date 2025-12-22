import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../checkbox_dropdown_selector.dart';
import '../action_button.dart';

class PrivilegeManagementPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;
  final List<String> authorizedRoleList;

  const PrivilegeManagementPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
    required this.authorizedRoleList,
  });

  @override
  State<PrivilegeManagementPage> createState() => _PrivilegeManagementPageState();
}

class _PrivilegeManagementPageState extends State<PrivilegeManagementPage> {
  // Selection states
  List<String> selectedDSOfficeStatuses = [];
  List<String> selecteddsOfficeUserStatuses = [];
  List<String> selecteduserPositionStatuses = [];

  // Dropdown options
  List<String> DSOfficeStatuses = [];
  List<String> dsOfficeUserStatuses = [];
  List<String> userPositionStatuses = [];

  // Data storage
  List<Map<String, dynamic>> locationData = [];
  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> privilegeData = [];

  // Loading states
  bool isLoadingLocations = true;
  bool isLoadingUsers = false;
  bool isLoadingPrivileges = false;

  @override
  void initState() {
    super.initState();
    _loadPrivilegedLocations();
    _loadAllUserPrivileges();
  }

  // API 1: Load DS Offices (Locations) - Updated URL
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
            locationData = apiLocationData.map<Map<String, dynamic>>((location) {
              return {
                'LOCATION_ID': location['LOCATION_ID'],
                'LOCATION': location['LOCATION'] ?? '',
                'LOCATION_TYPE': location['LOCATION_TYPE'] ?? '',
                'DS_DIVISION_ID': location['DS_DIVISION_ID'],
                'SECTION_ID': location['SECTION_ID'],
              };
            }).toList();

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

  // API 2: Load Users - Updated URL
  Future<void> _loadUserList() async {
    try {
      setState(() {
        isLoadingUsers = true;
        selecteddsOfficeUserStatuses.clear();
        dsOfficeUserStatuses.clear();
        userData.clear();
      });

      List<int> selectedLocationIds = [];
      for (String selectedOffice in selectedDSOfficeStatuses) {
        int index = DSOfficeStatuses.indexOf(selectedOffice);
        if (index != -1 && index < locationData.length) {
          var locationId = locationData[index]['LOCATION_ID'];
          if (locationId != null) {
            selectedLocationIds.add(int.parse(locationId.toString()));
          }
        }
      }

      if (selectedLocationIds.isEmpty) {
        setState(() {
          isLoadingUsers = false;
        });
        _showError('No valid location IDs found for selected DS offices');
        return;
      }

      final url = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi/UserListRequested';

      final requestBody = {
        "locationIdList": selectedLocationIds,
        "username": widget.citizenCode
      };

      print('Request body for UserListRequested: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
        body: json.encode(requestBody),
      );

      print('UserListRequested response status: ${response.statusCode}');
      print('UserListRequested response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['isSuccess'] == true && jsonData['dataBundle'] != null) {
          final List<dynamic> apiUserData = jsonData['dataBundle'];

          setState(() {
            userData = apiUserData.map<Map<String, dynamic>>((user) {
              return {
                'USER_ID': user['USER_ID'],
                'USERNAME': user['USERNAME'] ?? '',
                'FULL_NAME': user['FULL_NAME'] ?? '',
                'CALLING_NAME': user['CALLING_NAME'] ?? '',
                'EMAIL': user['EMAIL'] ?? '',
                'STATUS': user['STATUS'] ?? '',
                'DESIGNATION': user['DESIGNATION'] ?? '',
                'MOBILE_NUMBER': user['MOBILE_NUMBER'] ?? '',
                'LOCATION': user['LOCATION'] ?? '',
              };
            }).toList();

            dsOfficeUserStatuses = userData.map<String>((user) {
              String username = user['USERNAME'];
              String callingName = user['CALLING_NAME'];
              String fullName = user['FULL_NAME'];

              String displayName = callingName.isNotEmpty ? callingName : fullName;

              if (username.isNotEmpty && displayName.isNotEmpty) {
                return '$displayName ($username)';
              } else if (username.isNotEmpty) {
                return username;
              } else if (displayName.isNotEmpty) {
                return displayName;
              }
              return 'Unknown User';
            }).toList();

            isLoadingUsers = false;
          });
        } else {
          _showError('Failed to load users: ${jsonData['errorMessage'] ?? 'Unknown error'}');
        }
      } else {
        _showError('Failed to connect to server for users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error loading users: $e');
      print('Error in _loadUserList: $e');
    } finally {
      setState(() {
        isLoadingUsers = false;
      });
    }
  }

  // API 3: Load All User Privileges - Updated URL
  Future<void> _loadAllUserPrivileges() async {
    try {
      setState(() {
        isLoadingPrivileges = true;
      });

      // Build URL with query parameter - Updated URL
      final url = Uri.parse(
        'http://220.247.224.226:8401/CCSHubApi/api/MainApi/AllUserPrivileges?username=${widget.citizenCode}',
      );

      print('=== PRIVILEGE LOADING DEBUG ===');
      print('Calling AllUserPrivileges API using GET...');
      print('User authorized roles: ${widget.authorizedRoleList}');
      print('Request URL: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      print('AllUserPrivileges response status: ${response.statusCode}');
      print('AllUserPrivileges response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['isSuccess'] == true && jsonData['dataBundle'] != null) {
          final List<dynamic> apiPrivilegeData = jsonData['dataBundle'];
          print('Total privileges from API: ${apiPrivilegeData.length}');
          setState(() {
            privilegeData = apiPrivilegeData.map<Map<String, dynamic>>((privilege) {
              return {
                'PRIVILEGE_TYPE_ID': privilege['PRIVILEGE_TYPE_ID'],
                'AUTHORIZED_ROLE': privilege['AUTHORIZED_ROLE'] ?? '',
                'PRIVILEGE_CONFIGURATION_ID': privilege['PRIVILEGE_CONFIGURATION_ID'],
                'PRIVILEGE_TYPE': privilege['PRIVILEGE_TYPE'] ?? '',
                'PRIVILEGE_DATA_ID': privilege['PRIVILEGE_DATA_ID'],
              };
            }).toList();

            // Collect unique privilege types
            Set<String> uniquePrivilegeTypes = <String>{};
            for (var privilege in privilegeData) {
              String privilegeType = privilege['PRIVILEGE_TYPE'];
              if (privilegeType.isNotEmpty) {
                uniquePrivilegeTypes.add(privilegeType);
              }
            }
            userPositionStatuses = uniquePrivilegeTypes.toList()..sort();

            print('Unique privilege types: $userPositionStatuses');
            print('Dropdown options count: ${userPositionStatuses.length}');
          });
        } else {
          print('API Error: ${jsonData['errorMessage'] ?? 'Unknown error'}');
          _showError('Failed to load privileges: ${jsonData['errorMessage'] ?? 'Unknown error'}');
        }
      } else {
        print('HTTP Error: Status code ${response.statusCode}');
        _showError('Failed to connect to server for privileges. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in _loadAllUserPrivileges: $e');
      _showError('Error loading privileges: $e');
    } finally {
      setState(() {
        isLoadingPrivileges = false;
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

  void _showValidationError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _validateAndSubmit() {
    if (selectedDSOfficeStatuses.isEmpty) {
      _showValidationError('Please select at least one DS Office.');
      return;
    }

    List<int> selectedLocationIds = [];
    List<String> selectedUsernames = [];
    List<int> selectedPrivilegeConfigIds = [];
    List<int> selectedPrivilegeTypeIds = [];

    // Get location IDs
    for (String selectedOffice in selectedDSOfficeStatuses) {
      int index = DSOfficeStatuses.indexOf(selectedOffice);
      if (index != -1 && index < locationData.length) {
        var locationId = locationData[index]['LOCATION_ID'];
        if (locationId != null) {
          selectedLocationIds.add(int.parse(locationId.toString()));
        }
      }
    }

    // Get usernames
    for (String selectedUser in selecteddsOfficeUserStatuses) {
      int index = dsOfficeUserStatuses.indexOf(selectedUser);
      if (index != -1 && index < userData.length) {
        var username = userData[index]['USERNAME'];
        if (username != null) {
          selectedUsernames.add(username.toString());
        }
      }
    }

    // Get privilege configuration IDs and privilege type IDs
    for (String selectedPrivilegeType in selecteduserPositionStatuses) {
      for (var privilege in privilegeData) {
        String privilegeType = privilege['PRIVILEGE_TYPE'];
        if (privilegeType == selectedPrivilegeType) {
          var privilegeConfigId = privilege['PRIVILEGE_CONFIGURATION_ID'];
          var privilegeTypeId = privilege['PRIVILEGE_TYPE_ID'];

          if (privilegeConfigId != null && !selectedPrivilegeConfigIds.contains(int.parse(privilegeConfigId.toString()))) {
            selectedPrivilegeConfigIds.add(int.parse(privilegeConfigId.toString()));
          }

          if (privilegeTypeId != null && !selectedPrivilegeTypeIds.contains(int.parse(privilegeTypeId.toString()))) {
            selectedPrivilegeTypeIds.add(int.parse(privilegeTypeId.toString()));
          }
        }
      }
    }

    print('Selected Location IDs: $selectedLocationIds');
    print('Selected Usernames: $selectedUsernames');
    print('Selected Privilege Config IDs: $selectedPrivilegeConfigIds');
    print('Selected Privilege Type IDs: $selectedPrivilegeTypeIds');

    // Return the selected data instead of navigating to ViewPrivilege
    Navigator.pop(context, {
      'selectedLocationIds': selectedLocationIds,
      'selectedUsernames': selectedUsernames,
      'selectedPrivilegeConfigIds': selectedPrivilegeConfigIds,
      'selectedPrivilegeTypeIds': selectedPrivilegeTypeIds,
    });
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
                      'Privilege Management',
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

              // DS Office Selection
              const Center(
                child: Text(
                  'Select DS Office',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),

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
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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
                    if (newSelection.isNotEmpty) {
                      _loadUserList();
                    } else {
                      setState(() {
                        selecteddsOfficeUserStatuses.clear();
                        dsOfficeUserStatuses.clear();
                        userData.clear();
                      });
                    }
                  },
                ),

              const SizedBox(height: 24),

              // DS Office User Selection
              const Center(
                child: Text(
                  'Select DS Office User',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),

              if (isLoadingUsers)
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
              else if (dsOfficeUserStatuses.isEmpty)
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      selectedDSOfficeStatuses.isEmpty
                          ? 'Please select a DS Office first'
                          : 'No users available',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                CheckboxDropdownSelector(
                  title: 'DS Office User Status',
                  options: dsOfficeUserStatuses,
                  selectedItems: selecteddsOfficeUserStatuses,
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      selecteddsOfficeUserStatuses = newSelection;
                    });
                  },
                ),

              const SizedBox(height: 24),

              // Management/Privileges Selection
              const Center(
                child: Text(
                  'Select Management',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),

              if (isLoadingPrivileges)
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
              else if (userPositionStatuses.isEmpty)
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'No privileges available',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                CheckboxDropdownSelector(
                  title: 'DS Office Management Status',
                  options: userPositionStatuses,
                  selectedItems: selecteduserPositionStatuses,
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      selecteduserPositionStatuses = newSelection;
                    });
                  },
                ),

              const SizedBox(height: 54),

              // View Privilege Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    text: 'View Privilege',
                    onPressed: _validateAndSubmit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}