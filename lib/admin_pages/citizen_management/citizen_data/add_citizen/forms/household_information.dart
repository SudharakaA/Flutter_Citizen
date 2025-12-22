import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class HouseholdInformation extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool validateOnSubmit;
  final VoidCallback clearValidation;

  const HouseholdInformation({
    super.key,
    required this.onNext,
    required this.validateOnSubmit,
    required this.clearValidation,
    required this.onPrevious,
    required GlobalKey<FormState> formKey,
  });

  @override
  State<HouseholdInformation> createState() => _HouseholdInformationPageState();
}

class _HouseholdInformationPageState extends State<HouseholdInformation> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  String? _selectedDivision;
  String? _selectedGrama;
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      // Load dropdown values
      _selectedDivision = prefs.getString('division');
      _selectedGrama = prefs.getString('grama');
      
      // Load text field values
      _villageController.text = prefs.getString('village') ?? '';
      _houseNumberController.text = prefs.getString('houseNumber') ?? '';
    });
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save dropdown values
    if (_selectedDivision != null) {
      prefs.setString('division', _selectedDivision!);
    }
    
    if (_selectedGrama != null) {
      prefs.setString('grama', _selectedGrama!);
    }
    
    // Save text field values
    prefs.setString('village', _villageController.text);
    prefs.setString('houseNumber', _houseNumberController.text);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _villageController.dispose();
    _houseNumberController.dispose();
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
                'Household Information',
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
                            // Divisional Secretariat Division Dropdown
                            _buildDropdownWithLabel(
                              context,
                              'Divisional Secretariat Division',
                              _selectedDivision,
                              ['Thamankaduwa', 'Higurakgoda', 'Medirigiriya', 'Dimbulagala ', 'Lankapura', 'Welikanda', 'Elehera'],
                              (value) {
                                setState(() {
                                  _selectedDivision = value;
                                });
                                _saveData();
                                widget.clearValidation();
                              },
                              "Please select divisional secretariat division",
                              widget.validateOnSubmit && _selectedDivision == null,
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            // Grama Niladari Division Dropdown
                            _buildDropdownWithLabel(
                              context,
                              'Grama Niladari Division',
                              _selectedGrama,
                              ['Moragaswewa', 'Mahasengama', 'Sinhagama', 'Galoya'],
                              (value) {
                                setState(() {
                                  _selectedGrama = value;
                                });
                                _saveData();
                                widget.clearValidation();
                              },
                              "Please select grama niladari division",
                              widget.validateOnSubmit && _selectedGrama == null,
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            _buildTextField(context, "Village", _villageController, true),
                            SizedBox(height: screenHeight * 0.01),
                            _buildTextField(context, "House Number", _houseNumberController, true),
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