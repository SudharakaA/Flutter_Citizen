import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthStatus extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool validateOnSubmit;
  final VoidCallback clearValidation;

  const HealthStatus({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.validateOnSubmit,
    required this.clearValidation,
  });

  @override
  State<HealthStatus> createState() => _HealthStatusPageState();
}

class _HealthStatusPageState extends State<HealthStatus> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  String? _selectedHospitalname;
  String? _selectedIllnesstype;

  final TextEditingController _illnessNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIllnesstype = prefs.getString('illnessType');
      _selectedHospitalname = prefs.getString('hospitalName');
      _illnessNameController.text = prefs.getString('illnessName') ?? '';
      _descriptionController.text = prefs.getString('illnessDescription') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedIllnesstype != null) prefs.setString('illnessType', _selectedIllnesstype!);
    if (_selectedHospitalname != null) prefs.setString('hospitalName', _selectedHospitalname!);
    prefs.setString('illnessName', _illnessNameController.text);
    prefs.setString('illnessDescription', _descriptionController.text);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _illnessNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Health Status',
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
                            // Illness Type Dropdown
                            _buildDropdownWithLabel(
                              context,
                              "Illness Type",
                              _selectedIllnesstype,
                              ['Heart Diseases', 'Blood Pressure', 'Diabetes', 'Cancers', 'Other'],
                              (value) {
                                setState(() => _selectedIllnesstype = value);
                                _saveData();
                                widget.clearValidation();
                              },
                              "Please select illness type",
                              widget.validateOnSubmit && (_selectedIllnesstype == null),
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            _buildTextField(context, "Illness Name", _illnessNameController, false),
                            SizedBox(height: screenHeight * 0.01),

                            // Hospital Name Dropdown
                            _buildDropdownWithLabel(
                              context,
                              "Hospital Name",
                              _selectedHospitalname,
                              [
                                'General Hospital Polonnaruwa',
                                'Hingurakgoda Hospital',
                                'Jayanthipura Hospital',
                                'Galamuna Hospital',
                                'Other'
                              ],
                              (value) {
                                setState(() => _selectedHospitalname = value);
                                _saveData();
                                widget.clearValidation();
                              },
                              "Please select hospital",
                              widget.validateOnSubmit && (_selectedHospitalname == null),
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            _buildTextField(context, "Illness Description", _descriptionController, false),
                            SizedBox(height: screenHeight * 0.05),
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
    bool showError = widget.validateOnSubmit && isRequired && controller.text.isEmpty;

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
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: showError ? Colors.red : Colors.grey),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: controller,
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.035,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: GoogleFonts.inter(
                fontSize: screenWidth * 0.035,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.015,
              ),
            ),
            onChanged: (value) {
              _saveData();
              widget.clearValidation();
            },
          ),
        ),
        if (showError)
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.04, top: 4),
            child: Text(
              'This field is required',
              style: TextStyle(
                color: Colors.red,
                fontSize: screenWidth * 0.03,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownWithLabel(
    BuildContext context,
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
    String hint,
    bool showError,
  ) {
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
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: showError ? Colors.red : Colors.grey),
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
              onChanged: onChanged,
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.04, top: 4),
            child: Text(
              'Please select an option',
              style: TextStyle(
                color: Colors.red,
                fontSize: screenWidth * 0.03,
              ),
            ),
          ),
      ],
    );
  }
}