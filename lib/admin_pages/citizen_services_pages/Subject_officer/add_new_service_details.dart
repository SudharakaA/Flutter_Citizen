import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import '../../citizen_management/citizen_data/add_citizen/form_screens.dart';

class AddServiceDetailsPage extends StatefulWidget {
  const AddServiceDetailsPage({super.key});

  @override
  State<AddServiceDetailsPage> createState() => _AddServiceDetailsPageState();
}

class _AddServiceDetailsPageState extends State<AddServiceDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  final List<String> _services = [
    "Preparation of National ID Cards One Day Service - Thamankaduwa - DS Office",
    "National Identity Cards (initial) - Thamankaduwa - DS Office",
    "Nationa Identity Cards Amendment - Thamankaduwa - DS Office",
    "National Identity Cards (missing) - Thamankaduwa - DS Office",
    "Preparation of National ID Cards One Day Service - Higurakgoda - DS Office",
    "National Identity Cards (initial) - Higurakgoda - DS Office",
    "Nationa Identity Cards Amendment - Higurakgoda - DS Office",
    "National Identity Cards (missing) - Higurakgoda - DS Office",
  ];
  String? _selectedService;

  final List<String> _types = [
    "NIC" , "Citizen Reference", "Citizen Code"
  ];
  String? _selectedType;

  final Map<String, Map<String,String>> _mockCitizens = {
  "123456789V": {"reference": "CIT-001", "name": "Kasun Perera"},
  "987654321V": {"reference": "CIT-002", "name": "Nimal Silva"},
  "200165892300": {"reference": "CIT-003", "name": "Dilani Kumari"},
  };
String? _foundReference;
String? _foundName;
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading : CustomBackButton()),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Add New Service Details',
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Divider(
                thickness: 1,
                color: Colors.black38,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(height: screenHeight * 0.02),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDropdownField(
                      label: "Required Service",
                      value: _selectedService,
                      items: _services,
                      onChanged: (val) => setState(() => _selectedService = val),
                      validatorMsg: "Please select a service",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildDropdownField(
                      label: "Search Citizen",
                      value: _selectedType,
                      items: _types,
                      onChanged: (val) {
                        setState(() {
                          _selectedType = val;
                          _searchController.clear(); // clear field when type changes
                        });
                      },
                      validatorMsg: "Please select a search type",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    if (_selectedType != null)
                      buildTextField(
                        label: " ${_selectedType!}",
                        controller: _searchController,
                        maxLines: 1,
                        validatorMsg: "Please enter a valid ${_selectedType!}",
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    RichText(
                        text: TextSpan(
                            text: "Citizen not found? ",
                            style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.035,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            children: [
                          TextSpan(
                              text: "New Account",
                              style: GoogleFonts.inter(
                                fontSize: screenWidth * 0.035,
                                color: const Color(0xFF3A7D44),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FormScreens(),
                                    ),
                                  );
                                })
                        ])),
                    SizedBox(height: screenHeight * 0.02),
                    if (_foundReference != null && _foundName != null)
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.01),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "Reference: ",
                                style: GoogleFonts.inter(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: _foundReference ?? '',
                                    style: GoogleFonts.inter(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            RichText(
                              text: TextSpan(
                                text: "Name: ",
                                style: GoogleFonts.inter(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: _foundName ?? '',
                                    style: GoogleFonts.inter(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
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
      Row(
        children: [
          Expanded(
            child: TextFormField(
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
          ),
          SizedBox(width: screenWidth * 0.02),
          Container(
            height: screenHeight * 0.06,
            width: screenWidth * 0.15,
            decoration: BoxDecoration(
              color: const Color(0xFF3A7D44),
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String searchKey = _searchController.text.trim();
                  final result = _mockCitizens[searchKey];
                  if(result != null){
                    setState(() {
                      _foundReference = result['reference'];
                      _foundName = result['name'];
                    });
                  } else {
                    setState(() {
                      _foundReference = null;
                      _foundName = null;
                    }) ;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Citizen not found"))
                    );
                  }
                }
              },
            ),
          )
        ],
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
          isExpanded: true,
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