import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';





class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddStoreDataState();
}

class _AddStoreDataState extends State<AddUser> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameinitialController = TextEditingController();
  final TextEditingController _namerepresentController = TextEditingController();
  final TextEditingController _callingnameController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _permanentdateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobilenumController = TextEditingController();
  final TextEditingController _landnumController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _profileImage;
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dobController.text = DateTime.now().toString().split(' ')[0];
    _permanentdateController.text = DateTime.now().toString().split(' ')[0];
  }

  final List<String> _gender = [
    'Male',
    'Female',
  ];
  String? _selectedgender;

  final List<String> _locations = [
    'District Secretariate',
    'Divisional Secretariate',
    'Grama Niladhari office',
    'Other Office',
    'General Public',
  ];
  String? _selectedLocation;

  final List<String> _district = [
    'Polonnaruwa - District Office',
  ];
  String? _selecteddistrict;

  final List<String> _section = [
    'Management',
    'Administrative',
    'Human Resource', 'Management',
    'Financial Resource', 'Management',
    'Permit',
    'Land',
    'Planning',
    'Social Service',
    'Samurdhi',
    'Identity card',
    'Registrar',
  ];
  String? _selectedsection;

  final List<String> _designation = [
    'District Secretary',
    'Aerial Photography Technician',
    'Anthropologist',
    'Assistant Auditor',
    'Assistant Chief Secretary 1',
    'Audit Authority',
    'Chief Coordinating Staff Officer II',
    'Deputy director - Mechanical engineering',
    'Deputy Provincial Director',
    'District Manager',
    'District Wildlife Officer',
    'Divisional Superintendent of Post',
  ];
  String? _selecteddesignation;


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: screenHeight * 0.02,
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
              bottom: screenHeight * 0.02
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add New User",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.black38,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextField(
                      label: "Username",
                      controller: _usernameController,
                      validatorMsg: "Please enter Username",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildDropdownField(
                      label: "Gender",
                      value: _selectedgender,
                      items: _gender,
                      onChanged: (val) =>
                          setState(() => _selectedgender = val),
                      validatorMsg: "Please select Gender",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildTextField(
                      label: "Name With Initials",
                      controller: _nameinitialController,
                      validatorMsg: "Please enter Name With Initials",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildTextField(
                      label: "Name With Initials",
                      controller: _namerepresentController,
                      validatorMsg: "Please enter Name With Initials",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildTextField(
                      label: "Calling Name",
                      controller: _callingnameController,
                      validatorMsg: "Please enter Calling Name",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    Text(
                      "Profile Photo",
                      style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                        _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                            : null,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    buildTextField(
                      label: "NIC",
                      controller: _nicController,
                      validatorMsg: "Please enter NIC",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    Text(
                      "Date of Birth",
                      style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: inputDecoration(screenWidth, screenHeight),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "Permanent Date",
                      style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextFormField(
                      controller: _permanentdateController,
                      readOnly: true,
                      decoration: inputDecoration(screenWidth, screenHeight),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    buildTextField(
                      label: "Address",
                      controller: _addressController,
                      maxLines: 6,
                      validatorMsg: "Please enter a Address",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    buildDropdownField(
                      label: "Location Category",
                      value: _selectedLocation,
                      items: _locations,
                      onChanged: (val) =>
                          setState(() => _selectedLocation = val),
                      validatorMsg: "Please select a Location Category",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildDropdownField(
                      label: "District Office",
                      value: _selecteddistrict,
                      items: _district,
                      onChanged: (val) =>
                          setState(() => _selecteddistrict = val),
                      validatorMsg: "Please select a District Office",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildDropdownField(
                      label: "Section",
                      value: _selectedsection,
                      items: _section,
                      onChanged: (val) => setState(() => _selectedsection = val),
                      validatorMsg: "Please select a Section",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildDropdownField(
                      label: "Designation",
                      value: _selecteddesignation,
                      items: _designation,
                      onChanged: (val) => setState(() => _selecteddesignation = val),
                      validatorMsg: "Please select a Designation",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildTextField(
                      label: "Mobile Number",
                      controller: _mobilenumController,
                      validatorMsg: "Please enter Mobile Number",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildTextField(
                      label: "Land Number",
                      controller: _landnumController,
                      validatorMsg: "Please enter Land Number",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildTextField(
                      label: "Email",
                      controller: _emailController,
                      validatorMsg: "Please enter Email",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A7D44),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.01,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(screenWidth * 0.05),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Item submitted successfully!"),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Submit',
                          style: GoogleFonts.inter(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
      ),
    );
  }

  // Reusable text input
  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required String validatorMsg,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          validator: (value) =>
          value == null || value.isEmpty ? validatorMsg : null,
          decoration: inputDecoration(screenWidth, screenHeight).copyWith(
            hintText: "Enter $label".toLowerCase(),
            hintStyle: TextStyle(
              color: const Color.fromARGB(255, 5, 52, 90),
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  // Reusable dropdown input
  Widget buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String validatorMsg,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            "Select $label".toLowerCase(),
            style: TextStyle(
              color: const Color.fromARGB(255, 5, 52, 90),
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
            ),
          ),
          items: items
              .map((String item) =>
              DropdownMenuItem<String>(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? validatorMsg : null,
          decoration: inputDecoration(screenWidth, screenHeight),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  // Common input decoration
  InputDecoration inputDecoration(double screenWidth, double screenHeight) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.012,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        borderSide: const BorderSide(color: Colors.green),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
