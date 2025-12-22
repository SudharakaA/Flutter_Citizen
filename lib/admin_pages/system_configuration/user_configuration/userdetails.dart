import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';

class UserDetailsPage extends StatefulWidget {
  final String accessToken;
  final String username;

  const UserDetailsPage({
    super.key,
    required this.accessToken,
    required this.username,
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Create the request body with username
      final requestBody = {
        "username": widget.username,
      };

      print('Request body: ${json.encode(requestBody)}'); // Debug print

      final url = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi/UserDetailsRequested';

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
          final List<dynamic> userDataArray = jsonData['dataBundle'];

          if (userDataArray.isNotEmpty) {
            final userData = userDataArray[0]; // Get the first (and likely only) user object

            setState(() {
              userDetails = {
                'username': userData['USERNAME'] ?? '',
                'name': userData['NAME_REPRESENTED_BY_INITIALS'] ?? '',
                'friendlyName': userData['CALLING_NAME'] ?? '',
                'locationOfWork': userData['LOCATION'] ?? '', // Use LOCATION instead of LOCATION_ID
                'designation': userData['DESIGNATION'] ?? '', // Use DESIGNATION instead of DESIGNATION_ID
                'dateOfBirth': userData['DATE_OF_BIRTH'] ?? '',
                'contactNumber': userData['MOBILE_NUMBER'] ?? '', // Use MOBILE_NUMBER instead of NIC
                'emailAddress': userData['EMAIL_ADDRESS'] ?? '', // Use EMAIL_ADDRESS instead of PERMANENT_ADDRESS
                'fixedLine': userData['LAND_NUMBER'] ?? '', // Use LAND_NUMBER instead of DISTANCE_FROM_HOME_TO_OFFICE
                'createdAt': userData['CREATED_DTM'] ?? '',
                'createdBy': userData['CREATED_BY_NAME'] ?? '', // Use CREATED_BY_NAME for better display
                'userId': userData['USER_ID'] ?? '',
                'userKey': userData['USER_KEY'] ?? '',
                'gender': userData['GENDER'] ?? '',
                'nameWithInitials': userData['NAME_WITH_INITIALS'] ?? '',
                'sectionId': userData['SECTION_ID'] ?? '',
                'employeeType': userData['EMPLOYEE_TYPE'] ?? '',
                'nic': userData['NIC'] ?? '',
                'permanentAddress': userData['PERMANENT_ADDRESS'] ?? '',
                'accountStatus': userData['ACCOUNT_STATUS'] ?? '',
              };
              isLoading = false;
            });
          } else {
            setState(() {
              errorMessage = 'No user data found in response';
              isLoading = false;
            });
          }
        } else {
          setState(() {
            errorMessage = 'Failed to load user details: ${jsonData['errorMessage'] ?? 'Unknown error'}';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to connect to server. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading user details: $e';
        isLoading = false;
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
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
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
                  'Error Loading User Details',
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
                  onPressed: _loadUserDetails,
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
            // Header with user icon
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
                      Icons.person,
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
                          userDetails!['friendlyName'] ?? 'Unknown User',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          userDetails!['designation'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // User details list
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDetailRow('Username', userDetails!['username'] ?? ''),
                    _buildDetailRow('Name', userDetails!['nameWithInitials'] ?? ''),
                    _buildDetailRow('Friendly Name', userDetails!['friendlyName'] ?? ''),
                    _buildDetailRow('Location of work', userDetails!['locationOfWork'] ?? ''),
                    _buildDetailRow('Designation', userDetails!['designation'] ?? ''),
                    _buildDetailRow('Date of Birth', userDetails!['dateOfBirth'] ?? ''),
                    _buildDetailRow('Contact Number', userDetails!['contactNumber'] ?? ''),
                    _buildDetailRow('Email Address', userDetails!['emailAddress'] ?? ''),
                    _buildDetailRow('Fixed Line', userDetails!['fixedLine'] ?? ''),
                    _buildDetailRow('NIC', userDetails!['nic'] ?? ''),
                    _buildDetailRow('Gender', userDetails!['gender'] ?? ''),
                    _buildDetailRow('Account Status', userDetails!['accountStatus'] ?? ''),
                    _buildDetailRow('Created at', userDetails!['createdAt'] ?? ''),
                    _buildDetailRow('Created by', userDetails!['createdBy'] ?? ''),
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