import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EducationInformation extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool validateOnSubmit;
  final VoidCallback clearValidation;

  const EducationInformation({
    super.key,
    required this.onNext,
    required this.validateOnSubmit,
    required this.clearValidation, required this.onPrevious,
  });

  @override
  State<EducationInformation> createState() => _EducationInformationPageState();
}

class _EducationInformationPageState extends State<EducationInformation> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEducationLevel;
  String? _selectedInstitute;
  String? _selectedEducatedYear;
  final TextEditingController _qualificationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedEducationLevel = prefs.getString('educationLevel');
      _selectedInstitute = prefs.getString('institute');
      _selectedEducatedYear = prefs.getString('educatedYear');
      _qualificationController.text = prefs.getString('qualification') ?? '';
      _descriptionController.text = prefs.getString('description') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedEducationLevel != null) {
      prefs.setString('educationLevel', _selectedEducationLevel!);
    }
    if (_selectedInstitute != null) {
      prefs.setString('institute', _selectedInstitute!);
    }
    if (_selectedEducatedYear != null) {
      prefs.setString('educatedYear', _selectedEducatedYear!);
    }
    prefs.setString('qualification', _qualificationController.text);
    prefs.setString('description', _descriptionController.text);
  }

  @override
  void dispose() {
    _qualificationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth > 600 ? 600 : constraints.maxWidth * 0.9,
                ),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Education Information',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Divider(
                          color: Colors.black,
                          thickness: 1.2,
                        ),
                        const SizedBox(height: 10),
                        _buildDropdownField(
                          "Education Level",
                          _selectedEducationLevel,
                          [
                            "Passed O/L",
                            "Passed A/L",
                            "Passed PHD",
                            "Graduated",
                            "Went to school up to grade 8",
                            "Never went to school",
                            "Other"
                          ],
                          (value) {
                          setState(() {
                            _selectedEducationLevel= value;
                          });
                          _saveData();
                          widget.clearValidation();
                        },
                        widget.validateOnSubmit &&
                            (_selectedEducationLevel == null),
                        ),
                        const SizedBox(height: 5),
                        _buildDropdownField(
                          "Institution",
                          _selectedInstitute,
                          ["University of Moratuwa", "HND", "NDT"],
                          (value) {
                          setState(() {
                            _selectedInstitute= value;
                          });
                          _saveData();
                          widget.clearValidation();
                        },
                        widget.validateOnSubmit &&
                            (_selectedInstitute == null),
                        ),
                        const SizedBox(height: 5),
                        _buildDropdownField(
                          "Educated Year",
                          _selectedEducatedYear,
                          List<String>.generate(100, (index) => (DateTime.now().year - index).toString()),
                          (value) {
                          setState(() {
                            _selectedEducatedYear= value;
                          });
                          _saveData();
                          widget.clearValidation();
                        },
                        widget.validateOnSubmit &&
                            (_selectedEducatedYear == null),
                        ),
                        const SizedBox(height: 5),
                        _buildFormField("Qualification Type", 
                        _qualificationController, 
                        widget.validateOnSubmit &&
                           _qualificationController.text.isEmpty,
                            ),
                        const SizedBox(height: 5),
                        _buildFormField("Education Description", 
                        _descriptionController, widget.validateOnSubmit &&
                           _descriptionController.text.isEmpty,),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

   Widget _buildFormField(
      String label, TextEditingController controller, bool showError) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          errorText: showError ? 'This field is required' : null,
        ),
        onChanged: (value) {
          _saveData();
          widget.clearValidation();
        },
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
    bool showError,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          errorText: showError ? 'Please select an option' : null,
        ),
        value: selectedValue,
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
