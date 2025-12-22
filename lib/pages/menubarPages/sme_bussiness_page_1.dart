import 'package:citizen_care_system/pages/menubarPages/smeb_table.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';
import '../../component/request_service/action_button.dart';
import '../../component/project/form_text_field.dart';
import '../../component/custom_drawer.dart';
import 'sme_bussiness_page_2.dart';

class BusinessInfoForm extends StatefulWidget {
  final String? accessToken;
  final String? citizenCode;

  const BusinessInfoForm({
    super.key,
    this.accessToken,
    this.citizenCode,
  });

  @override
  State<BusinessInfoForm> createState() => _BusinessInfoFormState();
}

class _BusinessInfoFormState extends State<BusinessInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'BUSINESS_NAME': TextEditingController(),
    'REGISTRATION_NUMBER': TextEditingController(),
    'CONTACT_NUMBER': TextEditingController(),
    'BUSINESS_YEAR': TextEditingController(),
    'INCOME_A': TextEditingController(),
    'INCOME_B': TextEditingController(),
    'COST_C': TextEditingController(),
    'COST_D': TextEditingController(),
    'COST_E': TextEditingController(),
    'COST_S': TextEditingController(),
    'COST_F': TextEditingController(),
    'COST_G': TextEditingController(),
    'COST_H': TextEditingController(),
  };

  final Map<String, String> _fieldLabels = {
    'BUSINESS_NAME': 'business_name'.tr(),
    'REGISTRATION_NUMBER': 'registration_number'.tr(),
    'CONTACT_NUMBER': 'contact_number'.tr(),
    'BUSINESS_YEAR': 'account_year'.tr(),
    'INCOME_A': 'sales_income'.tr(),
    'INCOME_B': 'other_income'.tr(),
    'COST_C': 'raw_materials_cost'.tr(),
    'COST_D': 'marketing_cost'.tr(),
    'COST_E': 'rent_payments'.tr(),
    'COST_S': 'equipment_value'.tr(),
    'COST_F': 'loan_interest'.tr(),
    'COST_G': 'admin_expenses'.tr(),
    'COST_H': 'depreciation'.tr(),
  };

  Map<String, String> _page2Data = {};

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _clearFormFields() {
    _controllers.forEach((key, controller) => controller.clear());
    setState(() => _page2Data = {});
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
          // Fixed section: Past Records button, Basic Info title, and Divider
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: screenWidth * 0.4, // Reduced width for the button
                child: ActionButton(
                  text: 'past_records'.tr(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SmebTable(
                          citizenCode: widget.citizenCode ?? '',
                          accessToken: widget.accessToken ?? '',
                        ),
                      ),
                    );
                  },
                  backgroundColor: const Color(0xFF3A7D44), // Green color
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
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
                        'basic_details'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      _buildTextField(context, 'BUSINESS_NAME'),
                      SizedBox(height: screenHeight * 0.01),
                      _buildTextField(context, 'REGISTRATION_NUMBER'),
                      SizedBox(height: screenHeight * 0.01),
                      _buildTextField(context, 'CONTACT_NUMBER'),
                      SizedBox(height: screenHeight * 0.01),
                      _buildTextField(context, 'BUSINESS_YEAR'),
                      SizedBox(height: screenHeight * 0.05),
                      Text(
                        'income'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      _buildTextField(context, 'INCOME_A'),
                      SizedBox(height: screenHeight * 0.01),
                      _buildTextField(context, 'INCOME_B'),
                      SizedBox(height: screenHeight * 0.05),
                      Text(
                        'costs'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      _buildTextField(context, 'COST_C'),
                      SizedBox(height: screenHeight * 0.01),
                      _buildTextField(context, 'COST_D'),
                      SizedBox(height: screenHeight * 0.01),
                      _buildTextField(context, 'COST_E'),
                      SizedBox(height: screenHeight * 0.01),
                      _buildTextField(context, 'COST_S'),
                      SizedBox(height: screenHeight * 0.01),
                      _buildTextField(context, 'COST_F'),
                      SizedBox(height: screenHeight * 0.01),
                      _buildTextField(context, 'COST_G'),
                      SizedBox(height: screenHeight * 0.01),
                      _buildTextField(context, 'COST_H'),
                      SizedBox(height: screenHeight * 0.05),
                      Center(
                        child: ActionButton(
                          text: 'next'.tr(),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SMEBPage2(
                                    accessToken: widget.accessToken ?? '',
                                    citizenCode: widget.citizenCode ?? '',
                                    formData: {
                                      ..._controllers.map((key, controller) => MapEntry(key, controller.text)),
                                      ..._page2Data,
                                    },
                                  ),
                                ),
                              );
                              if (result != null && result is Map) {
                                setState(() {
                                  _page2Data = result['formData'] ?? {};
                                  if (result['submissionSuccess'] == true) {
                                    _clearFormFields();
                                  }
                                });
                              }
                            }
                          },
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

  Widget _buildTextField(BuildContext context, String fieldKey) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var label = _fieldLabels[fieldKey]!;

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
          controller: _controllers[fieldKey]!,
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

class SMEBPage1 extends StatelessWidget {
  final String? accessToken;
  final String? citizenCode;

  const SMEBPage1({
    super.key,
    this.accessToken,
    this.citizenCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      drawer: CustomDrawer(
        accessToken: accessToken ?? '',
        citizenCode: citizenCode ?? '',
      ),
      body: SafeArea(
        child: BusinessInfoForm(
          accessToken: accessToken,
          citizenCode: citizenCode,
        ),
      ),
    );
  }
}