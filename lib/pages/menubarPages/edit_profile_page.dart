import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../component/custom_app_bar.dart';
import '../../component/custom_back_button.dart';
import '../../component/request_service/action_button.dart';
import '../../component/project/form_text_field.dart';
import '../../component/request_service/date_picker_field.dart';
import 'package:easy_localization/easy_localization.dart';

class EPPPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const EPPPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<EPPPage> createState() => _EPPPageState();
}

class _EPPPageState extends State<EPPPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  DateTime? _selectedDate;
  bool isLoading = false;

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _friendlyNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _fixedPhoneController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  final TextEditingController _elderIdController = TextEditingController();

  // Dropdown values
  String? _selectedGender;
  String? _selectedMaritalStatus;
  String? _selectedNationality;
  String? _selectedReligion;
  String? _selectedBloodGroup;

  // Dropdown options
  final List<String> genderOptions = ['gender_male'.tr(), 'gender_female'.tr()];
  final List<String> maritalStatusOptions = ['status_single'.tr(), 'status_married'.tr(), 'status_divorced'.tr(), 'status_separated'.tr(), 'status_widowed'.tr()];
  final List<String> nationalityOptions = ['nationality_sinhala'.tr(), 'nationality_tamil'.tr(), 'nationality_muslim'.tr(), 'nationality_berger'.tr(), 'nationality_maley'.tr()];
  final List<String> religionOptions = ['religion_buddhist'.tr(), 'religion_rc'.tr(), 'religion_christian'.tr(), 'religion_sl_tamil'.tr(), 'religion_indian_tamil'.tr(), 'religion_muslim'.tr()];
  final List<String> bloodGroupOptions = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-', 'blood_unknown'.tr()];


  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _friendlyNameController.dispose();
    _addressController.dispose();
    _villageController.dispose();
    _mobileController.dispose();
    _fixedPhoneController.dispose();
    _nicController.dispose();
    _passportController.dispose();
    _elderIdController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      _showValidationError(context, 'dob_required'.tr());
      return;
    }

    setState(() {
      isLoading = true;
    });

    final String apiUrl = dotenv.env['CitizenBasicDataUpdateRequested'] ?? 
        'http://220.247.224.226:8401/CCSHubApi/api/MainApi/CitizenBasicDataUpdateRequested';

    try {
      final requestBody = {
        'CITIZEN_NAME': _nameController.text,
        'FRIENDLY_NAME': _friendlyNameController.text,
        'CITIZEN_ADDRESS': _addressController.text,
        'VILLAGE_NAME': _villageController.text,
        'PRIMARY_CONTACT': _mobileController.text,
        'FIXED_NUMBER': _fixedPhoneController.text,
        'NIC_NUMBER': _nicController.text,
        'PASSPORT_NUMBER': _passportController.text,
        'ELDER_NUMBER': _elderIdController.text,
        'DATE_OF_BIRTH': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'GENDER': _selectedGender,
        'CIVIL_STATUS': _selectedMaritalStatus,
        'NATIONALITY': _selectedNationality,
        'RELIGION': _selectedReligion,
        'BLOOD_GROUP': _selectedBloodGroup,
        'GN_DIVISION_ID': '',
        'CREATED_BY': '',
        'CREATED_BY_NAME': '',
        'CITIZEN_ID': '',
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessMessage(context, 'update_success'.tr());
      } else {
        _showValidationError(context, '${'update_failed'.tr()}: ${response.body}');
      }
    } catch (e) {
      _showValidationError(context, '${'error_occurred'.tr()}: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showValidationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
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
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'citizen_info'.tr(),
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
                            // Text(
                            //   'Basic Details',
                            //   style: GoogleFonts.inter(
                            //     fontSize: screenWidth * 0.04,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            SizedBox(height: screenHeight * 0.005),
                            _buildTextField(context, 'name'.tr(), _nameController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, 'friendly_name'.tr(), _friendlyNameController, false),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, 'address'.tr(), _addressController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, 'village'.tr(), _villageController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, 'mobile'.tr(), _mobileController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, 'fixed'.tr(), _fixedPhoneController, false),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, 'nic'.tr(), _nicController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, 'passport'.tr(), _passportController, false),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, 'elder_id'.tr(), _elderIdController, false),
                            SizedBox(height: screenHeight * 0.01),

                            SizedBox(height: screenHeight * 0.005),
                            DatePickerField(
                              label: 'dob'.tr(),
                              selectedDate: _selectedDate,
                              onDateSelected: (date) {
                                setState(() {
                                  _selectedDate = date;
                                });
                              },

                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'gender'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            _buildDropdownField(context, genderOptions, _selectedGender, (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            }, 'select_gender'.tr()),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'mstatus'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            _buildDropdownField(context, maritalStatusOptions, _selectedMaritalStatus, (value) {
                              setState(() {
                                _selectedMaritalStatus = value;
                              });
                            }, 'select_status'.tr()),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'nationality'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            _buildDropdownField(context, nationalityOptions, _selectedNationality, (value) {
                              setState(() {
                                _selectedNationality = value;
                              });
                            }, 'select_nationality'.tr()),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'religion'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            _buildDropdownField(context, religionOptions, _selectedReligion, (value) {
                              setState(() {
                                _selectedReligion = value;
                              });
                            }, 'select_religion'.tr()),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'blood'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            _buildDropdownField(context, bloodGroupOptions, _selectedBloodGroup, (value) {
                              setState(() {
                                _selectedBloodGroup = value;
                              });
                            }, 'select_blood'.tr()),
                            SizedBox(height: screenHeight * 0.05),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                              child: ActionButton(
                                text: 'update_data'.tr(),
                                onPressed: _submitForm,
                              ),
                            ),
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
        FormTextField(
          controller: controller,
          hint: 'enter'.tr(args: [label]),
          borderRadius: 30,
          textStyle: GoogleFonts.inter(
            fontSize: screenWidth * 0.035,
            color: Colors.black,
          ),
          hintStyle: GoogleFonts.inter(
            fontSize: screenWidth * 0.035,
            color: Colors.grey,
          ),
          validator: isRequired
              ? (value) {
            if (value == null || value.isEmpty) {
              return 'please_enter'.tr(args: [label]);
            }
            return null;
          }
              : null, onChanged: (value) {  },
        ),
      ],
    );
  }

  Widget _buildDropdownField(BuildContext context, List<String> items, String? selectedValue, Function(String?) onChanged, String hint) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
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
          onChanged: (value) {
            onChanged(value);
          },
        ),
      ),
    );
  }
}