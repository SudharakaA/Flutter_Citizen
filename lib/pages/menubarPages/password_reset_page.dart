import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../component/custom_back_button.dart';
import '../../component/request_service/action_button.dart';
import '../../component/project/form_text_field.dart';
import '../../component/custom_app_bar.dart';

class PSRPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const PSRPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<PSRPage> createState() => _PSRPageState();
}

class _PSRPageState extends State<PSRPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitPasswordChange() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        _showValidationError(context, 'password_mismatch'.tr());
        return;
      }
      setState(() {
        isLoading = true;
      });
      // TODO: Implement password change API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('password_change_success'.tr()),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
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
                'change_password'.tr(),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'old_password'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        FormTextField(
                          controller: _oldPasswordController,
                          hint: 'enter_old_password'.tr(),
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
                              return 'enter_old_password'.tr();
                            }
                            return null;
                          }, onChanged: (value) {  },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'new_password'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        FormTextField(
                          controller: _newPasswordController,
                          hint: 'enter_new_password'.tr(),
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
                              return 'enter_new_password'.tr();
                            }
                            return null;
                          }, onChanged: (value) {  },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'confirm_new_password'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        FormTextField(
                          controller: _confirmPasswordController,
                          hint: 'confirm_new_password_hint'.tr(),
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
                              return 'confirm_new_password_hint'.tr();
                            }
                            return null;
                          }, onChanged: (value) {  },
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: ActionButton(
                            text: 'change_password'.tr(),
                            onPressed: _submitPasswordChange,
                          ),
                        ),
                      ],
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
}