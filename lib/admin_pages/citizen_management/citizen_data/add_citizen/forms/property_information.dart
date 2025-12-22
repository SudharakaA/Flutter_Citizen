import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyInformation extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool validateOnSubmit;
  final VoidCallback clearValidation;

  const PropertyInformation({
    super.key,
    required this.onNext,
    required this.validateOnSubmit,
    required this.clearValidation, required this.onPrevious,
  });

  @override
  State<PropertyInformation> createState() => _PropertyInformationPageState();
}

class _PropertyInformationPageState extends State<PropertyInformation> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPropertytype;

  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPropertytype = prefs.getString('propertyType');
      _sizeController.text = prefs.getString('propertySize') ?? '';
      _regNoController.text = prefs.getString('regNumber') ?? '';
      _descController.text = prefs.getString('propertyDescription') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedPropertytype != null) prefs.setString('propertyType', _selectedPropertytype!);
    prefs.setString('propertySize', _sizeController.text);
    prefs.setString('regNumber', _regNoController.text);
    prefs.setString('propertyDescription', _descController.text);
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _regNoController.dispose();
    _descController.dispose();
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
                            'Property Information',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Divider(color: Colors.black, thickness: 1.2),
                        const SizedBox(height: 10),
                        _buildDropdownField(
                          'Property Type',
                          _selectedPropertytype,
                          ['Land', 'Paddy field'],
                          (value) {
                          setState(() {
                            _selectedPropertytype= value;
                          });
                          _saveData();
                          widget.clearValidation();
                          },
                        widget.validateOnSubmit &&
                            (_selectedPropertytype == null),
                        ),
                        const SizedBox(height: 15),
                        _buildFormField('Property Size', 
                        _sizeController,
                        widget.validateOnSubmit && _sizeController.text.isEmpty,
                        ),
                        const SizedBox(height: 15),
                        _buildFormField('Registration Number', 
                        _regNoController,
                        widget.validateOnSubmit && _regNoController.text.isEmpty,
                        ),
                        const SizedBox(height: 15),
                        _buildFormField('Property Description', 
                        _descController,
                        widget.validateOnSubmit && _descController.text.isEmpty,),
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
        errorText: showError ? 'This field is required' : null,
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
        errorText: showError ? 'Please select an option' : null,
      ),
      value: selectedValue,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
