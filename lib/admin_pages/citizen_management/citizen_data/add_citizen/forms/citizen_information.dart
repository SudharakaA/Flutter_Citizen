import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class CitizenInformationForm extends StatefulWidget {
  final VoidCallback onNext;
  final bool validateOnSubmit;
  final VoidCallback clearValidation;

  const CitizenInformationForm(
      {super.key,
      required this.onNext,
      required this.validateOnSubmit,
      required this.clearValidation});

  @override
  State<CitizenInformationForm> createState() => _CitizenInformationFormState();
}

class _CitizenInformationFormState extends State<CitizenInformationForm> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  DateTime? _selectedDate;
  final PageController _pageController = PageController();
  final GlobalKey<FormState> vehicleFormKey = GlobalKey<FormState>();

  // Text field controllers for personal information form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _friendlyNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _fixedPhoneController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  final TextEditingController _elderCardController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  // Variables to store dropdown selection values
  String? _familyRelation;
  String? _gender;
  String? _maritalStatus;
  String? _nationality;
  String? _religion;
  String? _bloodGroup;

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // Load previously saved form data when the page initializes
  }

  /// Loads previously saved form data from SharedPreferences
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Load text field values from local storage
      _nameController.text = prefs.getString('name') ?? '';
      _friendlyNameController.text = prefs.getString('friendlyName') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _mobileNumberController.text = prefs.getString('mobileNumber') ?? '';
      _fixedPhoneController.text = prefs.getString('fixedPhone') ?? '';
      _nicController.text = prefs.getString('nic') ?? '';
      _passportController.text = prefs.getString('passport') ?? '';
      _elderCardController.text = prefs.getString('elderCard') ?? '';

      // Load and parse saved date
      final savedDate = prefs.getString('dateOfBirth');
      if (savedDate != null && savedDate.isNotEmpty) {
        _selectedDate = DateTime.parse(savedDate);
        _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      }

      // Load dropdown values
      _familyRelation = prefs.getString('familyRelation');
      _gender = prefs.getString('gender');
      _maritalStatus = prefs.getString('maritalStatus');
      _nationality = prefs.getString('nationality');
      _religion = prefs.getString('religion');
      _bloodGroup = prefs.getString('bloodGroup');
    });
  }

  /// Saves all form data to SharedPreferences for persistence
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save text field values
    prefs.setString('name', _nameController.text);
    prefs.setString('friendlyName', _friendlyNameController.text);
    prefs.setString('address', _addressController.text);
    prefs.setString('mobileNumber', _mobileNumberController.text);
    prefs.setString('fixedPhone', _fixedPhoneController.text);
    prefs.setString('nic', _nicController.text);
    prefs.setString('passport', _passportController.text);
    prefs.setString('elderCard', _elderCardController.text);

    // Save date in ISO format
    if (_selectedDate != null) {
      prefs.setString('dateOfBirth', _selectedDate!.toIso8601String());
    }

    // Save dropdown values if they've been selected
    if (_familyRelation != null) {
      prefs.setString('familyRelation', _familyRelation!);
    }
    if (_gender != null) prefs.setString('gender', _gender!);
    if (_maritalStatus != null) {
      prefs.setString('maritalStatus', _maritalStatus!);
    }
    if (_nationality != null) prefs.setString('nationality', _nationality!);
    if (_religion != null) prefs.setString('religion', _religion!);
    if (_bloodGroup != null) prefs.setString('bloodGroup', _bloodGroup!);
  }

  /// Shows date picker and updates the selected date
  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
      _saveData(); // Save data when date is picked
    }
  }

  @override
  void dispose() {
    // Properly dispose of all controllers to prevent memory leaks
    _scrollController.dispose();
    _nameController.dispose();
    _friendlyNameController.dispose();
    _addressController.dispose();
    _mobileNumberController.dispose();
    _fixedPhoneController.dispose();
    _nicController.dispose();
    _passportController.dispose();
    _elderCardController.dispose();
    _dobController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            bottom: screenHeight * 0.01,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.01,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Citizen Information',
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.black38,
                indent: screenWidth * 0.05,
                endIndent: screenWidth * 0.05,
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor: MaterialStateProperty.all(const Color(0xFF508D4E)),
                      trackColor: MaterialStateProperty.all(Colors.transparent),
                      radius: const Radius.circular(10),
                      thickness: MaterialStateProperty.all(6),
                    ),
                  ),
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    interactive: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.only(right: screenWidth * 0.03),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Family Relation Dropdown
                            _buildDropdownWithLabel(
                              context, 
                              "Family Relation",
                              _familyRelation,
                              [
                                "House holder",
                                "Husband",
                                "Son",
                                "Daughter",
                                "Mother",
                                "Father",
                                "Other relative",
                                "Domestic servant",
                                "Resident",
                                "Others",
                                "Wife"
                              ],
                              (value) {
                                setState(() {
                                  _familyRelation = value;
                                });
                                _saveData();
                                widget.clearValidation();
                              },
                              "Please select family relation",
                              widget.validateOnSubmit && _familyRelation == null,
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            _buildTextField(context, "Name", _nameController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, "Friendly Name", _friendlyNameController, false),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, "Address", _addressController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, "Mobile Number", _mobileNumberController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, "Fixed Phone Number", _fixedPhoneController, false),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, "NIC", _nicController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, "Passport Number", _passportController, false),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, "Elder's Identity Card", _elderCardController, false),
                            SizedBox(height: screenHeight * 0.01),

                            // Date of Birth Picker
                            _buildDatePickerField(context),
                            SizedBox(height: screenHeight * 0.01),

                            // Gender Dropdown
                            _buildDropdownWithLabel(
                              context,
                              "Gender",
                              _gender,
                              ["Male", "Female"],
                              (value) {
                                setState(() {
                                  _gender = value;
                                });
                                _saveData();
                                widget.clearValidation();
                              },
                              "Please select gender",
                              widget.validateOnSubmit && _gender == null,
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            // Marital Status Dropdown
                            _buildDropdownWithLabel(
                              context,
                              "Marital Status",
                              _maritalStatus,
                              ["Single", "Married", "Divorced", "Separated", "Widowed"],
                              (value) {
                                setState(() {
                                  _maritalStatus = value;
                                });
                                _saveData();
                                widget.clearValidation();
                              },
                              "Please select marital status",
                              widget.validateOnSubmit && _maritalStatus == null,
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            // Nationality Dropdown
                            _buildDropdownWithLabel(
                              context,
                              "Nationality",
                              _nationality,
                              ["Sinhala", "Tamil", "Muslim", "Berger", "Maley"],
                              (value) {
                                setState(() {
                                  _nationality = value;
                                });
                                _saveData();
                                widget.clearValidation();
                              },
                              "Please select nationality",
                              widget.validateOnSubmit && _nationality == null,
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            // Religion Dropdown
                            _buildDropdownWithLabel(
                              context,
                              "Religion",
                              _religion,
                              [
                                "Buddhist",
                                "Roman Catholic",
                                "Christian",
                                "Sri Lankan Tamil",
                                "Indian Tamil",
                                "Muslim"
                              ],
                              (value) {
                                setState(() {
                                  _religion = value;
                                });
                                _saveData();
                                widget.clearValidation();
                              },
                              "Please select religion",
                              widget.validateOnSubmit && _religion == null,
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            // Blood Group Dropdown
                            _buildDropdownWithLabel(
                              context,
                              "Blood Group",
                              _bloodGroup,
                              [
                                "A+",
                                "A-",
                                "B+",
                                "B-",
                                "O+",
                                "O-",
                                "AB+",
                                "AB-",
                                "Unknown"
                              ],
                              (value) {
                                setState(() {
                                  _bloodGroup = value;
                                });
                                _saveData();
                                widget.clearValidation();
                              },
                              "Please select blood group",
                              widget.validateOnSubmit && _bloodGroup == null,
                            ),
                            SizedBox(height: screenHeight * 0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label, TextEditingController controller, bool isRequired) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    bool showError = widget.validateOnSubmit && isRequired && controller.text.isEmpty;

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
        SizedBox(height: screenHeight * 0.005),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: showError ? Colors.red : Colors.grey),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: controller,
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.035,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: GoogleFonts.inter(
                fontSize: screenWidth * 0.035,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.015,
              ),
            ),
            onChanged: (value) {
              _saveData();
              widget.clearValidation();
            },
          ),
        ),
        if (showError)
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.04, top: 4),
            child: Text(
              'This field is required',
              style: TextStyle(
                color: Colors.red,
                fontSize: screenWidth * 0.03,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    bool showError = widget.validateOnSubmit && _dobController.text.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date of Birth",
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.005),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: showError ? Colors.red : Colors.grey),
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.015,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _dobController.text.isEmpty ? 'Select Date of Birth' : _dobController.text,
                    style: GoogleFonts.inter(
                      fontSize: screenWidth * 0.035,
                      color: _dobController.text.isEmpty ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.04, top: 4),
            child: Text(
              'This field is required',
              style: TextStyle(
                color: Colors.red,
                fontSize: screenWidth * 0.03,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownWithLabel(
    BuildContext context,
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
    String hint,
    bool showError,
  ) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

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
        SizedBox(height: screenHeight * 0.005),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: showError ? Colors.red : Colors.grey),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.02),
                child: Text(
                  hint,
                  style: GoogleFonts.inter(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.002,
              ),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.02),
                    child: Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.035,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.04, top: 4),
            child: Text(
              'Please select an option',
              style: TextStyle(
                color: Colors.red,
                fontSize: screenWidth * 0.03,
              ),
            ),
          ),
      ],
    );
  }
}