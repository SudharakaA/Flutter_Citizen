import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';
import '../../component/request_service/action_button.dart';
import '../../component/project/form_text_field.dart';
import '../../component/custom_drawer.dart';

class BusinessInfoForm extends StatefulWidget {
  final String accessToken;
  final String citizenCode;
  final Map<String, String> formData;

  const BusinessInfoForm({
    super.key,
    required this.accessToken,
    required this.citizenCode,
    required this.formData,
  });

  @override
  State<BusinessInfoForm> createState() => _BusinessInfoFormState();
}

class _BusinessInfoFormState extends State<BusinessInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'ASSET_I': TextEditingController(),
    'ASSET_J': TextEditingController(),
    'ASSET_K': TextEditingController(),
    'ASSET_L': TextEditingController(),
    'ASSET_M': TextEditingController(),
    'ASSET_N': TextEditingController(),
    'ASSET_O': TextEditingController(),
    'ASSET_P': TextEditingController(),
    'LIABILITY_Q': TextEditingController(),
    'LIABILITY_R': TextEditingController(),
  };

  final Map<String, String> _fieldLabels = {
    'ASSET_I': 'asset_i'.tr(),
    'ASSET_J': 'asset_j'.tr(),
    'ASSET_K': 'asset_k'.tr(),
    'ASSET_L': 'asset_l'.tr(),
    'ASSET_M': 'asset_m'.tr(),
    'ASSET_N': 'asset_n'.tr(),
    'ASSET_O': 'asset_o'.tr(),
    'ASSET_P': 'asset_p'.tr(),
    'LIABILITY_Q': 'liability_q'.tr(),
    'LIABILITY_R': 'liability_r'.tr(),
  };

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controllers.forEach((key, controller) {
      if (widget.formData.containsKey(key)) {
        controller.text = widget.formData[key]!;
      }
    });
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _clearFormFields() {
    _controllers.forEach((key, controller) {
      controller.clear();
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final formData = {
        ...widget.formData,
        ..._controllers.map((key, controller) => MapEntry(key, controller.text)),
        'CREATED_BY': '',
        'CREATED_BY_NAME': '',
        'CITIZEN_CODE': widget.citizenCode,
        'gnDivisionId': '',
      };

      bool submissionSuccess = false;

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://220.247.224.226:8401/CCSHubApi/api/MainApi/NewSMEDataAdded?citizenCode=${widget.citizenCode}'),
        );

        request.headers['Authorization'] = 'Bearer ${widget.accessToken}';
        formData.forEach((key, value) {
          request.fields[key] = value;
        });

        final response = await request.send();
        final responseBody = await http.Response.fromStream(response);

        if (response.statusCode == 200 || response.statusCode == 201) {
          submissionSuccess = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('submit_success'.tr())),
          );
          _clearFormFields();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${'submit_fail'.tr()}: ${response.reasonPhrase}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'error'.tr()}: $e')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
        Navigator.of(context).pop({
          'formData': formData,
          'submissionSuccess': submissionSuccess,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed section: Basic Info title and Divider
          Center(
            child: Text(
              'basic_info'.tr(),
              style: GoogleFonts.inter(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.black38,
            indent: screenWidth * 0.05,
            endIndent: screenWidth * 0.05,
          ),
          // Scrollable section with visible scrollbar
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
              thumbVisibility: true, 
              interactive: true,
              trackVisibility: true,// Makes the scrollbar always visible
              child: SingleChildScrollView(
                
                      padding: EdgeInsets.only(right: screenWidth * 0.03),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'assets'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      ..._controllers.keys
                          .where((k) => k.startsWith('ASSET_'))
                          .map((key) => Padding(
                                padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                                child: _buildTextField(context, key),
                              )),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'liabilities'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      ..._controllers.keys
                          .where((k) => k.startsWith('LIABILITY_'))
                          .map((key) => Padding(
                                padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                                child: _buildTextField(context, key),
                              )),
                      SizedBox(height: screenHeight * 0.05),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: ActionButton(
                                text: 'back'.tr(),
                                onPressed: () {
                                  final Map<String, String> currentFormData = {
                                    ...widget.formData,
                                    ..._controllers.map((key, controller) =>
                                        MapEntry(key, controller.text)),
                                  };
                                  Navigator.of(context).pop({
                                    'formData': currentFormData,
                                    'submissionSuccess': false,
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Flexible(
                              child: ActionButton(
                                text: _isSubmitting
                                    ? 'submitting'.tr()
                                    : 'submit'.tr(),
                                onPressed: () {
                                  if (!_isSubmitting) {
                                    _submitForm();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String key) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var label = _fieldLabels[key]!;

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
          controller: _controllers[key]!,
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'please_enter'.tr(args: [label]);
            }
            return null;
          }, onChanged: (value) {  },
        ),
      ],
    );
  }
}

class SMEBPage2 extends StatelessWidget {
  final String accessToken;
  final String citizenCode;
  final Map<String, String> formData;

  const SMEBPage2({
    super.key,
    required this.accessToken,
    required this.citizenCode,
    required this.formData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      drawer: CustomDrawer(
        accessToken: accessToken,
        citizenCode: citizenCode,
      ),
      body: SafeArea(
        child: BusinessInfoForm(
          accessToken: accessToken,
          citizenCode: citizenCode,
          formData: formData,
        ),
      ),
    );
  }
}