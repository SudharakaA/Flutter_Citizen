import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _illnessNameController.dispose();
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
                            'Health Status',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Divider(color: Colors.black, thickness: 1.2),
                        const SizedBox(height: 10),
                        _buildDropdownField(
                          'Illness Type',
                          _selectedIllnesstype,
                          ['Heart Diseases', 'Blood Pressure', 'Diabetes', 'Cancers', 'Other'],
                          (value) {
                           setState(() => _selectedIllnesstype = value);
                           _saveData();
                          widget.clearValidation();
                          },
                          widget.validateOnSubmit && (_selectedIllnesstype== null),
                        ),
                        const SizedBox(height: 15),
                        _buildFormField('Illness Name', _illnessNameController,
                        false,
                        ),
                        const SizedBox(height: 15),
                        _buildDropdownField(
                          'Hospital Name',
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
                          widget.validateOnSubmit && (_selectedHospitalname== null),
                        ),
                        const SizedBox(height: 15),
                        _buildFormField('Illness Description', 
                        _descriptionController,
                        false,
                        ),
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
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        //errorText: showError ? 'This field is required' : null,
      ),
      onChanged: (value) {
        _saveData();
        widget.clearValidation();
      },
    );
  }

  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
    bool showError,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        //errorText: showError ? 'Please select an option' : null,
      ),
      value: selectedValue,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
