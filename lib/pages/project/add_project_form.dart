import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../../model/project.dart';
import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';
import '../../component/request_service/action_button.dart';
import '../../component/project/form_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class AddProjectForm extends StatefulWidget {
  final Function(Project) onSubmit;
  final String accessToken;
  final String citizenCode;

  const AddProjectForm({
    super.key,
    required this.onSubmit,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<AddProjectForm> createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Dropdown options
  final List<String> categoryOptions = ['Public', 'Private'];
  final List<String> typeOptions = ['Construction', 'Purchasing'];
  String selectedCategory = 'Public';
  String selectedType = 'Construction';

  // File picker
  PlatformFile? selectedFile;
  final List<String> allowedExtensions = ['jpg', 'png', 'jpeg', 'pdf'];

  // Scroll controller
  final ScrollController _scrollController = ScrollController();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      const url = 'http://220.247.224.226:8401/CCSHubApi/api/MainApi/NewPlanRequestAdded';
      final project = Project(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: selectedCategory,
        type: selectedType,
        location: _locationController.text,
        description: _descriptionController.text,
        file: selectedFile?.name,
        userName: '',
        friendlyName: '',
        citizenName: '',
        gnDivisionId: '',
      );

      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Authorization'] = 'Bearer ${widget.accessToken}'
        ..fields['USER_NAME'] = project.userName
        ..fields['FRIENDLY_NAME'] = project.friendlyName
        ..fields['CITIZEN_NAME'] = project.citizenName
        ..fields['GN_DIVISIONID'] = project.gnDivisionId
        ..fields['PROJECT_CATEGORY'] = project.category
        ..fields['PROJECT_TYPE'] = project.type
        ..fields['PROJECT_LOCATION'] = project.location
        ..fields['PROJECT_DESCRIPTION'] = project.description
        ..fields['CITIZEN_CODE'] = widget.citizenCode;

      if (selectedFile != null && selectedFile!.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'Files',
            selectedFile!.bytes!,
            filename: selectedFile!.name,
          ),
        );
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        _showSuccessMessage(context, 'project_added_success'.tr());
        widget.onSubmit(project);
        Navigator.of(context).pop();
      } else {
        _showValidationError(context, '${'failed_submit_project'.tr()}: ${response.statusCode}');
      }
    } catch (e) {
      _showValidationError(context, '${'error_submit_project'.tr()}: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFile = result.files.first;
        });
      }
    } catch (e) {
      _showValidationError(context, '${'error_pick_file'.tr()}: $e');
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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            top: screenHeight * 0.02,
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
            bottom: screenHeight * 0.02,
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
                'add_new_project'.tr(),
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
                            Text(
                              'project_category'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCategory,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.002,
                                  ),
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                  items: categoryOptions.map((String value) {
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
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedCategory = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'project_type'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedType,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.002,
                                  ),
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                  items: typeOptions.map((String value) {
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
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedType = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'location'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            FormTextField(
                              controller: _locationController,
                              hint: 'enter_location'.tr(),
                              borderRadius: 30,
                              textStyle: GoogleFonts.inter(
                                fontSize: screenWidth * 0.035,
                                color: Colors.black,
                              ),
                              hintStyle: GoogleFonts.inter(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'please_enter_location'.tr();
                                }
                                return null;
                              }, onChanged: (value) {  },
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'project_description'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            FormTextField(
                              controller: _descriptionController,
                              hint: 'enter_project_description'.tr(),
                              maxLines: 4,
                              borderRadius: 30,
                              textStyle: GoogleFonts.inter(
                                fontSize: screenWidth * 0.035,
                                color: Colors.black,
                              ),
                              hintStyle: GoogleFonts.inter(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'please_enter_description'.tr();
                                }
                                return null;
                              }, onChanged: (value) {  },
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'attach_file'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: _pickFile,
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
                                    selectedFile?.name ?? 'no_file_selected'.tr(),
                                    style: GoogleFonts.inter(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.black54,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(height: screenHeight * 0.04),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ActionButton(
                  text: 'submit_project'.tr(),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}