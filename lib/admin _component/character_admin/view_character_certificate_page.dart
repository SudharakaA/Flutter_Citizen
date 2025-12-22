import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../component/custom_app_bar.dart';
import '../../component/custom_back_button.dart';
import '../../admin _component/character_certificate_popup.dart';

class ViewCharacterCertificatePage extends StatefulWidget {
  const ViewCharacterCertificatePage({super.key});

  @override
  State<ViewCharacterCertificatePage> createState() => _ViewCharacterCertificatePageState();
}

class _ViewCharacterCertificatePageState extends State<ViewCharacterCertificatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicController = TextEditingController();

  @override
  void dispose() {
    _nicController.dispose();
    super.dispose();
  }

  String? _validateNIC(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIC number is required';
    }

    final pattern = RegExp(r'^(\d{9}[vVxX]|\d{10})$');
    if (!pattern.hasMatch(value)) {
      return 'Enter a valid NIC (e.g., 123456789V or 123456789X)';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(screenWidth * 0.03),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "View Page",
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
                const SizedBox(height: 20),

                // NIC Input Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "NIC Number",
                    style: GoogleFonts.inter(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nicController,
                  decoration: InputDecoration(
                    hintText: "Enter NIC number",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.012,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: _validateNIC,
                ),

                const SizedBox(height: 30),

                // Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A7D44),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CharacterCertificatePopup(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'View Data',
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
        ),
      ),
    );
  }
}
