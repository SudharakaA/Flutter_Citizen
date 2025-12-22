import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  String? _selectedIncometype;

  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _fieldController = TextEditingController();
  final TextEditingController _averageIncomeController =
      TextEditingController();
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
    _designationController.dispose();
    _locationController.dispose();
    _fieldController.dispose();
    _averageIncomeController.dispose();
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
                  maxWidth: constraints.maxWidth > 600
                      ? 600
                      : constraints.maxWidth * 0.9,
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
                            'Source of Income',
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
                          'Income Type',
                          _selectedIncometype,
                          ['Salary', 'Business', 'Pension', 'Other'],
                          (value) {
                            setState(() {
                              _selectedIncometype = value;
                            });
                            _saveData();
                            widget.clearValidation();
                          },
                          widget.validateOnSubmit && _selectedIncometype == null,
                        ),
                        const SizedBox(height: 5),
                        _buildFormField(
                          'Designation',
                          _designationController,
                          widget.validateOnSubmit &&
                              _designationController.text.isEmpty,
                        ),
                        const SizedBox(height: 5),
                        _buildFormField(
                          'Job Location',
                          _locationController,
                          widget.validateOnSubmit &&
                              _locationController.text.isEmpty,
                        ),
                        const SizedBox(height: 5),
                        _buildFormField(
                          'Job Field',
                          _fieldController,
                          widget.validateOnSubmit &&
                              _fieldController.text.isEmpty,
                        ),
                        const SizedBox(height: 5),
                        _buildFormField(
                          'Average Income',
                          _averageIncomeController,
                          widget.validateOnSubmit &&
                              _averageIncomeController.text.isEmpty,
                        ),
                        const SizedBox(height: 5),
                        _buildFormField(
                          'Income Description',
                          _descriptionController,
                          widget.validateOnSubmit &&
                              _descriptionController.text.isEmpty,
                        ),
                        const SizedBox(height: 20),
                        // Uncomment and update the buttons as needed
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     ElevatedButton(
                        //       onPressed: () {
                        //         _saveData();
                        //         widget.onPrevious();
                        //       },
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: const Color(0xFF80AF81),
                        //       ),
                        //       child: const Text('Previous'),
                        //     ),
                        //     ElevatedButton(
                        //       onPressed: () {
                        //         _saveData();
                        //         widget.onNext();
                        //       },
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: const Color(0xFF80AF81),
                        //       ),
                        //       child: const Text('Next'),
                        //     ),
                        //   ],
                        // ),
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
    String label,
    TextEditingController controller,
    bool showError,
  ) {
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