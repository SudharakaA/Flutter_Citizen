import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../../component/custom_app_bar.dart';
import '../../component/custom_back_button.dart';
import '../../login/action_button.dart';
import '../../component/project/form_text_field.dart';
import '../../component/request_service/date_picker_field.dart';
import 'package:easy_localization/easy_localization.dart';

class IFRPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const IFRPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<IFRPage> createState() => _IFRPageState();
}

class _IFRPageState extends State<IFRPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  // Form controllers
  final TextEditingController _applicantNameController = TextEditingController();
  final TextEditingController _applicantAddressController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _informationRequestedController = TextEditingController();
  final TextEditingController _lifePrivacyInfoController = TextEditingController();
  final TextEditingController _otherDetailsController = TextEditingController();
  final TextEditingController _enclosureController = TextEditingController();

  // Date fields
  DateTime? _startDate;
  DateTime? _endDate;

  // Dropdown values
  String? _selectedInstitution;
  String? _selectedInformationRequested;
  String? _selectedLanguage;
  String? _selectedCitizen;

  // Dropdown options
  final List<String> institutionOptions = [
    'Thamankaduwa - DS Office',
    'Higurakgoda - DS Office',
    'Medirigiriya - DS Office',
    'Dimbulagala - DS Office',
    'Lankapura - DS Office',
    'Welikanda - DS Office',
    'Elehera - DS Office'
  ];
  final List<String> informationRequestedOptions = [
    '(A) Monitor Works & Reports',
    '(B) Obtain Notes/Reports',
    '(C) Obtain Material Samples',
    '(D) Retrieve Info in Electronic',
  ];
  final List<String> languageOptions = ['සිංහල', 'English', 'தமிழ்'];
  final List<String> citizenOptions = ['yes', 'no'];

  // File lists
  List<PlatformFile> _selectedFiles = [];
  List<PlatformFile> _enclosureFiles = [];
  final List<String> allowedExtensions = ['jpg', 'png', 'jpeg', 'pdf'];

  @override
  void dispose() {
    _scrollController.dispose();
    _applicantNameController.dispose();
    _applicantAddressController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _informationRequestedController.dispose();
    _lifePrivacyInfoController.dispose();
    _otherDetailsController.dispose();
    _enclosureController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null || _endDate == null) {
      _showValidationError(context, 'please_select_dates'.tr());
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      _showValidationError(context, 'end_date_after_start'.tr());
      return;
    }

    if ((_descriptionController.text.isEmpty && _selectedFiles.isEmpty)) {
      _showValidationError(context, 'please_description_or_file'.tr());
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://220.247.224.226:8401/CCSHubApi/api/MainApi/NewInformationRequestAdded'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer ${widget.accessToken}',
        'Content-Type': 'multipart/form-data',
      });

      request.fields.addAll({
        'CITIZEN_CODE': widget.citizenCode,
        'CITIZEN_NAME': _applicantNameController.text,
        'CITIZEN_ADDRESS': _applicantAddressController.text,
        'CONTACT_NUMBER': _telephoneController.text,
        'EMAIL_ADDRESS': _emailController.text,
        'Description': _descriptionController.text,
        'GN_DIVISION_ID': _selectedInstitution ?? '',
        'INFORMATION_REQUEST': _informationRequestedController.text,
        'FROM_DATE': DateFormat('dd/MM/yyyy').format(_startDate!),
        'TO_DATE': DateFormat('dd/MM/yyyy').format(_endDate!),
        'ExpectedMineData': _selectedInformationRequested ?? '',
        'PREFERRED_LANGUAGE': _selectedLanguage ?? '',
        'PRIVACY_STATEMENT': _lifePrivacyInfoController.text,
        'OTHER_REMARKS': _otherDetailsController.text,
        'Enclosures': _enclosureController.text,
        'CITIZEN_STATUS': _selectedCitizen ?? '',
        'LOCATION_ID': '',
        'CREATED_BY': '',
        'CREATED_BY_NAME': '',
      });

      for (var file in _selectedFiles) {
        if (file.bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'DescriptionFiles',
              file.bytes!,
              filename: file.name,
            ),
          );
        }
      }

      for (var file in _enclosureFiles) {
        if (file.bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'EnclosureFiles',
              file.bytes!,
              filename: file.name,
            ),
          );
        }
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessMessage(context, 'form_success'.tr());
        _clearForm();
      } else {
        _showValidationError(context, 'Failed to submit request. Status: ${response.statusCode}');
      }
    } catch (e) {
      _showValidationError(context, 'Error submitting request: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _clearForm() {
    _applicantNameController.clear();
    _applicantAddressController.clear();
    _telephoneController.clear();
    _emailController.clear();
    _descriptionController.clear();
    _informationRequestedController.clear();
    _lifePrivacyInfoController.clear();
    _otherDetailsController.clear();
    _enclosureController.clear();
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedInstitution = null;
      _selectedInformationRequested = null;
      _selectedLanguage = null;
      _selectedCitizen = null;
      _selectedFiles.clear();
      _enclosureFiles.clear();
    });
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

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFiles = result.files;
        });
      }
    } catch (e) {
      _showValidationError(context, 'Error picking files: $e');
    }
  }

  Future<void> _pickEnclosureFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _enclosureFiles = result.files;
        });
      }
    } catch (e) {
      _showValidationError(context, 'Error picking enclosure files: $e');
    }
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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
                'information_retrieval_application'.tr(),
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
                            _buildTextField(context, 'applicant_name'.tr(), _applicantNameController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, 'applicant_address'.tr(), _applicantAddressController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, 'telephone_number'.tr(), _telephoneController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, 'email_address'.tr(), _emailController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildDescriptionWithFileUpload(context),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'concerned_institution'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            _buildDropdownField(context, institutionOptions, _selectedInstitution, (value) {
                              setState(() {
                                _selectedInstitution = value;
                              });
                            }, 'select_institution'.tr()),
                            SizedBox(height: screenHeight * 0.01),
                            _buildMultiLineTextField(context, 'information_requested'.tr(), _informationRequestedController, true),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'period_info'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Row(
                              children: [
                                Expanded(
                                  child: DatePickerField(
                                    label: 'start_date'.tr(),
                                    selectedDate: _startDate,
                                    onDateSelected: (date) {
                                      setState(() {
                                        _startDate = date;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Expanded(
                                  child: DatePickerField(
                                    label: 'end_date'.tr(),
                                    selectedDate: _endDate,
                                    onDateSelected: (date) {
                                      setState(() {
                                        _endDate = date;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'expected_data'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            _buildDropdownField(context, informationRequestedOptions, _selectedInformationRequested, (value) {
                              setState(() {
                                _selectedInformationRequested = value;
                              });
                            }, 'select_data_type'.tr()),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'preferred_language'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            _buildDropdownField(context, languageOptions, _selectedLanguage, (value) {
                              setState(() {
                                _selectedLanguage = value;
                              });
                            }, 'select_language'.tr()),
                            SizedBox(height: screenHeight * 0.01),
                            _buildMultiLineTextField(context, 'privacy_info.'.tr(), _lifePrivacyInfoController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildMultiLineTextField(context, 'other_details'.tr(), _otherDetailsController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildEnclosureWithFileUpload(context),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'sri_lankan_citizen'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            _buildDropdownField(context, citizenOptions, _selectedCitizen, (value) {
                              setState(() {
                                _selectedCitizen = value;
                              });
                            }, 'select_citizenship_status'.tr()),
                            SizedBox(height: screenHeight * 0.05),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                              child: ActionButton(
                                text: 'submit_request'.tr(),
                                overflow: TextOverflow.ellipsis,
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

  Widget _buildMultiLineTextField(BuildContext context, String label, TextEditingController controller, bool isRequired) {
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
          maxLines: 3,
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

  Widget _buildDescriptionWithFileUpload(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'description_info'.tr(),
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        FormTextField(
          controller: _descriptionController,
          hint: 'Enter description',
          borderRadius: 30,
          maxLines: 3,
          textStyle: GoogleFonts.inter(
            fontSize: screenWidth * 0.035,
            color: Colors.black,
          ),
          hintStyle: GoogleFonts.inter(
            fontSize: screenWidth * 0.035,
            color: Colors.grey,
          ),
          validator: (value) {
            if ((value == null || value.isEmpty) && _selectedFiles.isEmpty) {
              return 'please_description_or_file'.tr();
            }
            return null;
          }, onChanged: (value) {  },
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          children: [
            ElevatedButton(
              onPressed: _pickFiles,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF508D4E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.015,
                ),
              ),
              child: Text(
                'choose_file'.tr(),
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.035,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Text(
                _selectedFiles.isEmpty
                    ? 'no_file_selected'.tr()
                    : '${_selectedFiles.length} file(s) selected',
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.035,
                  color: Colors.black54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (_selectedFiles.isNotEmpty) ...[
          SizedBox(height: screenHeight * 0.01),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: _selectedFiles.asMap().entries.map((entry) {
                int index = entry.key;
                PlatformFile file = entry.value;
                return ListTile(
                  dense: true,
                  leading: Icon(
                    _getFileIcon(file.extension),
                    color: const Color(0xFF508D4E),
                    size: 20,
                  ),
                  title: Text(
                    file.name,
                    style: GoogleFonts.inter(fontSize: screenWidth * 0.035),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    _formatFileSize(file.size),
                    style: GoogleFonts.inter(fontSize: screenWidth * 0.03),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => _removeFile(index),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEnclosureWithFileUpload(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'enclosures'.tr(),
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        //SizedBox(height: screenHeight * 0.01),
        // FormTextField(
        //   controller: _enclosureController,
        //   hint: 'Enter enclosure details',
        //   borderRadius: 30,
        //   maxLines: 3,
        //   textStyle: GoogleFonts.inter(
        //     fontSize: screenWidth * 0.035,
        //     color: Colors.black,
        //   ),
        //   hintStyle: GoogleFonts.inter(
        //     fontSize: screenWidth * 0.035,
        //     color: Colors.grey,
        //   ),
        // ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          children: [
            ElevatedButton(
              onPressed: _pickEnclosureFiles,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF508D4E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.015,
                ),
              ),
              child: Text(
                'choose_file'.tr(),
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.035,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Text(
                _enclosureFiles.isEmpty
                    ? 'no_file_selected'.tr()
                    : '${_enclosureFiles.length} file(s) selected',
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.035,
                  color: Colors.black54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (_enclosureFiles.isNotEmpty) ...[
          SizedBox(height: screenHeight * 0.01),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: _enclosureFiles.asMap().entries.map((entry) {
                int index = entry.key;
                PlatformFile file = entry.value;
                return ListTile(
                  dense: true,
                  leading: Icon(
                    _getFileIcon(file.extension),
                    color: const Color(0xFF508D4E),
                    size: 20,
                  ),
                  title: Text(
                    file.name,
                    style: GoogleFonts.inter(fontSize: screenWidth * 0.035),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    _formatFileSize(file.size),
                    style: GoogleFonts.inter(fontSize: screenWidth * 0.03),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => _removeEnclosureFile(index),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _removeEnclosureFile(int index) {
    setState(() {
      _enclosureFiles.removeAt(index);
    });
  }
}