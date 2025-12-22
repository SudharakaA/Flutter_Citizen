
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';


class AddNewSubject extends StatefulWidget {
  const AddNewSubject({super.key});

  @override
  State<AddNewSubject> createState() => _AddStoreDataState();
}

class _AddStoreDataState extends State<AddNewSubject> {
  final List<String> _locations = [
    'Polonnaruwa - District Office',
    'Thamankaduwa - DS Office',
    'Higurakgoda - DS Office',
    'Medirigiriya - DS Office',
    'Dimbulagala - DS Office',
    'Lankapura - DS Office',
    'Welikanda - DS Office',
    'Elehera - DS Office'
  ];
  String? _selectedLocation;

  final List<String> _username = [
    '',
    '',
  ];
  String? _selectedusername;

  final List<String> _section = [
    'Management',
    'Administrative',
    'Human Resource', 'Management',
    'Financial Resource', 'Management',
    'Permit',
    'Land',
    'Planning',
    'Social Service',
    'Samurdhi',
    'Identity card',
    'Registrar',
  ];
  String? _selectedsection;

  final _formKey = GlobalKey<FormState>();
  final List<String> _subject = [
    'Test Subject',
  ];
  String? _selectedsubject;


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: screenHeight * 0.02,
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
              bottom: screenHeight * 0.02
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
                "Add new Subject",
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
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDropdownField(
                      label: "Location Category",
                      value: _selectedLocation,
                      items: _locations,
                      onChanged: (val) =>
                          setState(() => _selectedLocation = val),
                      validatorMsg: "Please select a Location Category",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildDropdownField(
                      label: "Username",
                      value: _selectedusername,
                      items: _username,
                      onChanged: (val) =>
                          setState(() => _selectedusername = val),
                      validatorMsg: "Please select a Username",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildDropdownField(
                      label: "Section",
                      value: _selectedsection,
                      items: _section,
                      onChanged: (val) =>
                          setState(() => _selectedsection = val),
                      validatorMsg: "Please select Section",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildDropdownField(
                      label: "Subject",
                      value: _selectedsubject,
                      items: _subject,
                      onChanged: (val) => setState(() => _selectedsubject = val),
                      validatorMsg: "Please select a Section",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),

                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A7D44),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.01,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(screenWidth * 0.05),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Item submitted successfully!"),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Submit',
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
            ],
          ),
        ),
      ),
    );
  }

  // Reusable text input
  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required String validatorMsg,
    required double screenWidth,
    required double screenHeight,
  }) {
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
        SizedBox(height: screenHeight * 0.01),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          validator: (value) =>
          value == null || value.isEmpty ? validatorMsg : null,
          decoration: inputDecoration(screenWidth, screenHeight).copyWith(
            hintText: "Enter $label".toLowerCase(),
            hintStyle: TextStyle(
              color: const Color.fromARGB(255, 5, 52, 90),
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  // Reusable dropdown input
  Widget buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String validatorMsg,
    required double screenWidth,
    required double screenHeight,
  }) {
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
        SizedBox(height: screenHeight * 0.01),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            "Select $label".toLowerCase(),
            style: TextStyle(
              color: const Color.fromARGB(255, 5, 52, 90),
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
            ),
          ),
          items: items
              .map((String item) =>
              DropdownMenuItem<String>(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? validatorMsg : null,
          decoration: inputDecoration(screenWidth, screenHeight),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  // Common input decoration
  InputDecoration inputDecoration(double screenWidth, double screenHeight) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.012,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        borderSide: const BorderSide(color: Colors.green),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
