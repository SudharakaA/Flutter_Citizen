import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
        backgroundColor: const Color(0xFF80AF81),
        appBar: const CustomAppBarWidget(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth > 600
                        ? 600
                        : constraints.maxWidth * 0.9,
                  ),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey, // Using the form key for validation
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Citizen Information',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Divider(
                            color: Colors.black,
                            thickness: 1.2,
                          ),
                          const SizedBox(height: 10),

                          // Form fields - starting with dropdowns and text fields
                          _buildDropdownField(
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
                            widget.validateOnSubmit && _familyRelation == null,
                          ),
                          const SizedBox(height: 5),

                          _buildFormField(
                            "Name",
                            _nameController,
                            widget.validateOnSubmit &&
                                _nameController.text.isEmpty,
                          ), // Required field
                          const SizedBox(height: 5),
                          _buildFormField(
                            "Friendly Name",
                            _friendlyNameController,
                            false,
                          ), // Optional field
                          const SizedBox(height: 5),
                          _buildFormField(
                            "Address",
                            _addressController,
                            widget.validateOnSubmit &&
                                _nameController.text.isEmpty,
                          ), // Required field
                          const SizedBox(height: 5),
                          _buildFormField(
                            "Mobile Number",
                            _mobileNumberController,
                            widget.validateOnSubmit &&
                                _nameController.text.isEmpty,
                          ), // Required field
                          const SizedBox(height: 5),
                          _buildFormField(
                            "Fixed Phone Number",
                            _fixedPhoneController,
                           false,
                          ), // Optional field
                          const SizedBox(height: 5),
                          _buildFormField(
                            "NIC",
                            _nicController,
                            widget.validateOnSubmit &&
                                _nameController.text.isEmpty,
                          ), // Required field (National ID Card)
                          const SizedBox(height: 5),
                          _buildFormField(
                            "Passport Number",
                            _passportController,
                           false,
                          ), // Optional field
                          const SizedBox(height: 5),
                          _buildFormField(
                            "Elder's Identity Card",
                            _elderCardController,
                            false,
                          ), // Optional field
                          const SizedBox(height: 5),

                          // Date of Birth Picker Field
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              controller: _dobController,
                              readOnly:
                                  true, // Makes field non-editable directly
                              onTap: () =>
                                  _pickDate(context), // Show date picker on tap
                              decoration: InputDecoration(
                                labelText: "Date of Birth",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                suffixIcon:
                                    const Icon(Icons.calendar_today),
                                errorText: widget.validateOnSubmit && _dobController.text.isEmpty
                                    ? 'This field is required'
                                    : null, // Calendar icon
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          // More dropdown fields for demographic information
                          _buildDropdownField(
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
                            widget.validateOnSubmit && _gender == null,
                          ),
                          const SizedBox(height: 5),
                          _buildDropdownField(
                            "Marital Status",
                            _maritalStatus,
                            [
                              "Single",
                              "Married",
                              "Divorced",
                              "Separated",
                              "Widowed"
                            ],
                            (value) {
                              setState(() {
                                _maritalStatus = value;
                              });
                              _saveData();
                              widget.clearValidation(); // Auto-save
                            },
                            widget.validateOnSubmit && _maritalStatus == null,
                          ),
                          const SizedBox(height: 5),
                          _buildDropdownField(
                            "Nationality",
                            _nationality,
                            ["Sinhala", "Tamil", "Muslim", "Berger", "Maley"],
                            (value) {
                              setState(() {
                                _nationality = value;
                              });
                              _saveData();
                              widget.clearValidation(); // Auto-save
                            },
                            widget.validateOnSubmit && _nationality == null,
                          ),
                          const SizedBox(height: 5),
                          _buildDropdownField(
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
                            widget.validateOnSubmit && _religion == null,
                          ),
                          const SizedBox(height: 5),
                          _buildDropdownField(
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
                            widget.validateOnSubmit && _bloodGroup == null,
                          ),
                          const SizedBox(height: 20),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     ElevatedButton(
                          //       onPressed: () {
                          //         _saveData();
                          //         widget.onNext();
                          //       },
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor: const Color(0xFF80AF81),
                          //       ),
                          //       child: const Text('Next'),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  /// Helper method to build a form text field with consistent styling
  Widget _buildFormField(
    String label,
    TextEditingController controller,
    bool showError,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          errorText: showError ? 'This field is required' : null,
        ),
        onChanged: (value) {
          _saveData();
          widget.clearValidation();
        },
      ),
    );
  }

  /// Helper method to build a dropdown field with consistent styling
  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
    bool showError,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          errorText: showError ? 'Please select an option' : null,
        ),
        value: selectedValue,
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
