import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HouseholdInformation extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool validateOnSubmit;
  final VoidCallback clearValidation;

  const HouseholdInformation({
    super.key,
    required this.onNext,
    required this.validateOnSubmit,
    required this.clearValidation, required this.onPrevious, required GlobalKey<FormState> formKey,
  });

  @override
  State<HouseholdInformation> createState() => _HouseholdInformationPageState();
}

class _HouseholdInformationPageState extends State<HouseholdInformation> {
  final _formKey = GlobalKey<FormState>();
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
    _villageController.dispose();
    _houseNumberController.dispose();
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
                            'Household Information',
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
                        widget.validateOnSubmit &&
                            (_selectedDivision == null),
                        ),
                        const SizedBox(height: 5),
                        _buildDropdownField(
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
                        widget.validateOnSubmit &&
                            (_selectedGrama == null),
                        ),
                        const SizedBox(height: 5),
                        _buildFormField('Village', _villageController, 
                        widget.validateOnSubmit &&
                            _villageController.text.isEmpty,),
                        const SizedBox(height: 5),
                        _buildFormField('House Number', _houseNumberController, 
                        widget.validateOnSubmit &&
                            _houseNumberController.text.isEmpty,
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
