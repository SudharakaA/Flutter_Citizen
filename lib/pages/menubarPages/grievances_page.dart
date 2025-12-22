import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';
import '../../component/request_service/action_button.dart';
import 'package:google_fonts/google_fonts.dart';

class GrievancesPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const GrievancesPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  GrievancePageState createState() => GrievancePageState();
}

class GrievancePageState extends State<GrievancesPage> {
  final TextEditingController _grievanceController = TextEditingController();
  PlatformFile? _selectedFile;
  final List<String> allowedExtensions = ['jpg', 'png', 'jpeg', 'pdf'];
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      _showValidationError(context, 'error_picking_file'.tr(args: [e.toString()]));
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      const String apiUrl =
          'http://220.247.224.226:8401/CCSHubApi/api/MainApi/GrievanceRequest';
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers['Authorization'] = 'Bearer ${widget.accessToken}'
        ..fields['citizenCode'] = widget.citizenCode
        ..fields['friendlyName'] = ''
        ..fields['gnDivisionId'] = ''
        ..fields['requestTypeId'] = ''
        ..fields['requestInBrief'] = _grievanceController.text;

      if (_selectedFile != null && _selectedFile!.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'files',
            _selectedFile!.bytes!,
            filename: _selectedFile!.name,
          ),
        );
      }

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessMessage(context, 'grievance_submitted'.tr());
        _grievanceController.clear();
        setState(() {
          _selectedFile = null;
        });
        Navigator.of(context).pop();
      } else {
        _showValidationError(context, 'submit_failed'.tr(args: [responseBody.body]));
      }
    } catch (e) {
      _showValidationError(context, 'submit_error'.tr(args: [e.toString()]));
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
                'add_new_grievance'.tr(),
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
                              'grievance_description'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: _grievanceController,
                              maxLines: 8,
                              decoration: InputDecoration(
                                hintText: 'enter_grievance_description'.tr(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintStyle: GoogleFonts.inter(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.grey,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: screenHeight * 0.015,
                                ),
                              ),
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.035,
                                color: Colors.black,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter_grievance_validation'.tr();
                                }
                                return null;
                              },
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
                                    _selectedFile?.name ??
                                        'no_file_selected'.tr(),
                                    style: GoogleFonts.inter(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.black54,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
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
                  text: 'submit_grievance'.tr(),
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
