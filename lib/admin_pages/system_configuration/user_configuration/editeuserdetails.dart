import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';

class EditUserPage extends StatefulWidget {
  final String accessToken;
  final String username;
  final Map<String, dynamic> userData;

  const EditUserPage({
    super.key,
    required this.accessToken,
    required this.username,
    required this.userData,
  });

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Form Controllers
  late TextEditingController _usernameController;
  late TextEditingController _nameWithInitialsController;
  late TextEditingController _nameRepresentedByInitialsController;
  late TextEditingController _callingNameController;
  late TextEditingController _nicController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _permanentDateController;
  late TextEditingController _addressController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _landNumberController;
  late TextEditingController _emailController;
  late TextEditingController _designationController;
  late TextEditingController _epfNumberController;

  // Dropdown values
  String? selectedGender;
  String? selectedLocationCategory;
  String? selectedDistrictOffice;
  String? selectedSection;
  String? selectedDesignationId;
  String? selectedLocationId;

  // Profile image
  File? _profileImage;
  bool _isLoading = false;
  bool _isLoadingUserDetails = true;

  // Complete user data from API
  Map<String, dynamic> completeUserData = {};

  // Dropdown options
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> locationCategoryOptions = ['District Secretariat', 'Provincial Office', 'Central Office'];
  final List<String> districtOfficeOptions = [
    'Polonnaruwa - District Office',
    'Anuradhapura - District Office',
    'Kurunegala - District Office'
  ];
  final List<String> sectionOptions = ['Administration', 'Finance', 'IT', 'HR'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchUserDetails();
  }

  void _initializeControllers() {
    // Initialize empty controllers first
    _usernameController = TextEditingController();
    _nameWithInitialsController = TextEditingController();
    _nameRepresentedByInitialsController = TextEditingController();
    _callingNameController = TextEditingController();
    _nicController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _permanentDateController = TextEditingController();
    _addressController = TextEditingController();
    _mobileNumberController = TextEditingController();
    _landNumberController = TextEditingController();
    _emailController = TextEditingController();
    _designationController = TextEditingController();
    _epfNumberController = TextEditingController();
  }

  Future<void> _fetchUserDetails() async {
    try {
      setState(() {
        _isLoadingUserDetails = true;
      });

      final requestBody = {
        "username": widget.username
      };

      print('Fetching user details for username: ${widget.username}');
      print('Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('http://220.247.224.226:8401/CCSHubApi/api/MainApi/UserDetailsRequested'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
        body: json.encode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['isSuccess'] == true && jsonData['dataBundle'] != null && jsonData['dataBundle'].isNotEmpty) {
          final userData = jsonData['dataBundle'][0];
          completeUserData = userData;

          // Populate form fields with backend data
          _populateFormFields(userData);

        } else {
          _showSnackBar('Failed to load user details: ${jsonData['errorMessage'] ?? 'No data found'}');
        }
      } else {
        _showSnackBar('Failed to connect to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error loading user details: $e');
      print('Error fetching user details: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUserDetails = false;
        });
      }
    }
  }

  void _populateFormFields(Map<String, dynamic> userData) {
    setState(() {
      // Populate text controllers with backend data
      _usernameController.text = userData['USERNAME']?.toString() ?? '';
      _nameWithInitialsController.text = userData['NAME_WITH_INITIALS']?.toString() ?? '';
      _nameRepresentedByInitialsController.text = userData['NAME_REPRESENTED_BY_INITIALS']?.toString() ?? '';
      _callingNameController.text = userData['CALLING_NAME']?.toString() ?? '';
      _nicController.text = userData['NIC']?.toString() ?? '';
      _dateOfBirthController.text = userData['DATE_OF_BIRTH']?.toString() ?? '';
      _permanentDateController.text = _formatDate(userData['PERMANENT_DATE']?.toString());
      _addressController.text = userData['PERMANENT_ADDRESS']?.toString() ?? '';
      _mobileNumberController.text = userData['MOBILE_NUMBER']?.toString() ?? '';
      _landNumberController.text = userData['LAND_NUMBER']?.toString() ?? '';
      _emailController.text = userData['EMAIL_ADDRESS']?.toString() ?? '';
      _designationController.text = userData['DESIGNATION']?.toString() ?? '';
      _epfNumberController.text = userData['EPF_NUMBER']?.toString() ?? '';

      // Set dropdown values
      selectedGender = userData['GENDER']?.toString();
      selectedDistrictOffice = userData['LOCATION']?.toString();
      selectedDesignationId = userData['DESIGNATION_ID']?.toString();
      selectedLocationId = userData['LOCATION_ID']?.toString();

      // Set default values for dropdowns not in backend
      selectedLocationCategory = 'District Secretariat';
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      // Handle different date formats from backend
      if (dateStr.contains('/')) {
        // Format: "7/10/2011 12:00:00 AM"
        final parts = dateStr.split(' ')[0].split('/');
        if (parts.length == 3) {
          final month = parts[0].padLeft(2, '0');
          final day = parts[1].padLeft(2, '0');
          final year = parts[2];
          return '$year/$month/$day';
        }
      }
      return dateStr;
    } catch (e) {
      return dateStr ?? '';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameWithInitialsController.dispose();
    _nameRepresentedByInitialsController.dispose();
    _callingNameController.dispose();
    _nicController.dispose();
    _dateOfBirthController.dispose();
    _permanentDateController.dispose();
    _addressController.dispose();
    _mobileNumberController.dispose();
    _landNumberController.dispose();
    _emailController.dispose();
    _designationController.dispose();
    _epfNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e');
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF80AF81),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy/MM/dd').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Use the complete backend data structure for updating
      final requestBody = {
        "USER_ID": completeUserData['USER_ID']?.toString() ?? "",
        "USERNAME": _usernameController.text,
        "NAME_WITH_INITIALS": _nameWithInitialsController.text,
        "NAME_REPRESENTED_BY_INITIALS": _nameRepresentedByInitialsController.text,
        "CALLING_NAME": _callingNameController.text,
        "GENDER": selectedGender ?? "",
        "NIC": _nicController.text,
        "DATE_OF_BIRTH": _dateOfBirthController.text,
        "PERMANENT_DATE": _permanentDateController.text,
        "PERMANENT_ADDRESS": _addressController.text,
        "MOBILE_NUMBER": _mobileNumberController.text,
        "LAND_NUMBER": _landNumberController.text,
        "EMAIL_ADDRESS": _emailController.text,
        "DESIGNATION": _designationController.text,
        "DESIGNATION_ID": selectedDesignationId ?? completeUserData['DESIGNATION_ID']?.toString() ?? "",
        "LOCATION": selectedDistrictOffice ?? "",
        "LOCATION_ID": selectedLocationId ?? completeUserData['LOCATION_ID']?.toString() ?? "",
        "SECTION_ID": completeUserData['SECTION_ID']?.toString() ?? "",
        "EPF_NUMBER": _epfNumberController.text,
        // Keep other backend fields unchanged
        "EMPLOYEE_TYPE": completeUserData['EMPLOYEE_TYPE']?.toString() ?? "",
        "USER_KEY": completeUserData['USER_KEY']?.toString() ?? "",
        "CREATED_BY": completeUserData['CREATED_BY']?.toString() ?? "",
        "CREATED_DTM": completeUserData['CREATED_DTM']?.toString() ?? "",
      };

      print('Submit request body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('http://220.247.224.226:8401/CCSHubApi/api/MainApi/UpdateUserDetailsRequested'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
        body: json.encode(requestBody),
      );

      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['isSuccess'] == true) {
          _showSnackBar('User details updated successfully!');
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navigator.pop(context, true); // Return true to indicate success
          }
        } else {
          _showSnackBar('Failed to update user: ${jsonData['errorMessage'] ?? 'Unknown error'}');
        }
      } else {
        _showSnackBar('Failed to connect to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error updating user: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: message.contains('success') ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: readOnly ? Colors.grey.shade200 : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF80AF81), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF80AF81), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
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
        child: _isLoadingUserDetails
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading user details...'),
            ],
          ),
        )
            : Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Personal Details Section
                Text(
                  'Personal Details',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black26),
                const SizedBox(height: 16),

                // Row 1: Username, Gender
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _usernameController,
                        label: 'Username',
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdown(
                        label: 'Gender',
                        value: selectedGender,
                        items: genderOptions,
                        onChanged: (value) => setState(() => selectedGender = value),
                      ),
                    ),
                  ],
                ),

                _buildTextField(
                  controller: _nameWithInitialsController,
                  label: 'Name With Initials',
                  validator: (value) => value?.isEmpty == true ? 'This field is required' : null,
                ),

                // Row 2: Name Represented By Initials, Calling Name
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _nameRepresentedByInitialsController,
                        label: 'Pull Name',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _callingNameController,
                        label: 'Calling Name',
                      ),
                    ),
                  ],
                ),

                // Profile Photo Section
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Profile Photo',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),


                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _profileImage != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _profileImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                const SizedBox(height: 16),

                // Row 3: NIC, Date of Birth
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _nicController,
                        label: 'NIC',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _dateOfBirthController,
                        label: 'Date of Birth',
                        readOnly: true,
                        onTap: () => _selectDate(_dateOfBirthController),
                      ),
                    ),
                  ],
                ),

                // Row 4: Permanent Date, EPF Number
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _permanentDateController,
                        label: 'Permanent Date',
                        readOnly: true,
                        onTap: () => _selectDate(_permanentDateController),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _epfNumberController,
                        label: 'EPF Number',
                      ),
                    ),
                  ],
                ),

                _buildTextField(
                  controller: _addressController,
                  label: 'Permanent Address',
                  maxLines: 2,
                ),

                // Location Details
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: 'Location Category',
                        value: selectedLocationCategory,
                        items: locationCategoryOptions,
                        onChanged: (value) => setState(() => selectedLocationCategory = value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdown(
                        label: 'District Office',
                        value: selectedDistrictOffice,
                        items: districtOfficeOptions,
                        onChanged: (value) => setState(() => selectedDistrictOffice = value),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: 'Section',
                        value: selectedSection,
                        items: sectionOptions,
                        onChanged: (value) => setState(() => selectedSection = value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _designationController,
                        label: 'Designation',
                      ),
                    ),
                  ],
                ),

                // Contact Details Section
                Text(
                  'Contact Details',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black26),
                const SizedBox(height: 16),

                // Contact fields
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _mobileNumberController,
                        label: 'Mobile Number',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _landNumberController,
                        label: 'Land Number',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),

                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isNotEmpty == true && !value!.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Submit and Cancel buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          'Submit',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}