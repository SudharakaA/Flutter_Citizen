import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SourceOfIncomeForm extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool validateOnSubmit;
  final VoidCallback clearValidation;

  const SourceOfIncomeForm({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.validateOnSubmit,
    required this.clearValidation,
  });

  @override
  State<SourceOfIncomeForm> createState() => _SourceOfIncomeFormPageState();
}

class _SourceOfIncomeFormPageState extends State<SourceOfIncomeForm> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  String? _selectedIncometype;

  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _fieldController = TextEditingController();
  final TextEditingController _averageIncomeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIncometype = prefs.getString('incomeType');
      _designationController.text = prefs.getString('designation') ?? '';
      _locationController.text = prefs.getString('jobLocation') ?? '';
      _fieldController.text = prefs.getString('jobField') ?? '';
      _averageIncomeController.text = prefs.getString('averageIncome') ?? '';
      _descriptionController.text = prefs.getString('incomeDescription') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedIncometype != null) {
      prefs.setString('incomeType', _selectedIncometype!);
    }
    prefs.setString('designation', _designationController.text);
    prefs.setString('jobLocation', _locationController.text);
    prefs.setString('jobField', _fieldController.text);
    prefs.setString('averageIncome', _averageIncomeController.text);
    prefs.setString('incomeDescription', _descriptionController.text);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _designationController.dispose();
    _locationController.dispose();
    _fieldController.dispose();
    _averageIncomeController.dispose();
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
                'Source of Income',
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
                            // Income Type Dropdown
                            _buildDropdownWithLabel(
                              context,
                              "Income Type",
                              _selectedIncometype,
                              ['Salary', 'Business', 'Pension', 'Other'],
                              (value) {
                                setState(() {
                                  _selectedIncometype = value;
                                });
                                _saveData();
                                widget.clearValidation();
                              },
                              "Please select income type",
                              widget.validateOnSubmit && _selectedIncometype == null,
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            _buildTextField(
                              context,
                              "Designation",
                              _designationController,
                              widget.validateOnSubmit && _designationController.text.isEmpty,
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            _buildTextField(
                              context,
                              "Job Location",
                              _locationController,
                              widget.validateOnSubmit && _locationController.text.isEmpty,
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            _buildTextField(
                              context,
                              "Job Field",
                              _fieldController,
                              widget.validateOnSubmit && _fieldController.text.isEmpty,
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            _buildTextField(
                              context,
                              "Average Income",
                              _averageIncomeController,
                              widget.validateOnSubmit && _averageIncomeController.text.isEmpty,
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            _buildTextField(
                              context,
                              "Income Description",
                              _descriptionController,
                              widget.validateOnSubmit && _descriptionController.text.isEmpty,
                            ),
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

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
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