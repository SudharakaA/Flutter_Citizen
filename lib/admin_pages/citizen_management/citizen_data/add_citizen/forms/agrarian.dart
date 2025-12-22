import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Agrarian extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool validateOnSubmit;
  final VoidCallback clearValidation;

  const Agrarian({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.validateOnSubmit,
    required this.clearValidation,
  });

  @override
  State<Agrarian> createState() => _AgrarianPageState();
}

class _AgrarianPageState extends State<Agrarian> {
  final _formKey = GlobalKey<FormState>();
  String? _agrarianDivision;
  String? _agrarianOrganization;
  String? _agrarianName;
  String? _paddyRegNo;
  String? _agrarianDescription;

  final TextEditingController _agrarianDivisionController = TextEditingController();
  final TextEditingController _agrarianOrganizationController = TextEditingController();
  final TextEditingController _agrarianNameController = TextEditingController();
  final TextEditingController _paddyRegNoController = TextEditingController();
  final TextEditingController _agrarianDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _agrarianDivision = prefs.getString('agrarianDivision');
      _agrarianOrganization = prefs.getString('agrarianOrganization');
      _agrarianName = prefs.getString('agrarianName');
      _paddyRegNo = prefs.getString('paddyRegNo');
      _agrarianDescription = prefs.getString('agrarianDescription');
      _agrarianDivisionController.text = _agrarianDivision ?? '';
      _agrarianOrganizationController.text = _agrarianOrganization ?? '';
      _agrarianNameController.text = _agrarianName ?? '';
      _paddyRegNoController.text = _paddyRegNo ?? '';
      _agrarianDescriptionController.text = _agrarianDescription ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('agrarianDivision', _agrarianDivisionController.text);
    prefs.setString('agrarianOrganization', _agrarianOrganizationController.text);
    prefs.setString('agrarianName', _agrarianNameController.text);
    prefs.setString('paddyRegNo', _paddyRegNoController.text);
    prefs.setString('agrarianDescription', _agrarianDescriptionController.text);
  }

  @override
  void dispose() {
    _agrarianDivisionController.dispose();
    _agrarianOrganizationController.dispose();
    _agrarianNameController.dispose();
    _paddyRegNoController.dispose();
    _agrarianDescriptionController.dispose();
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
                            'Agrarian Information',
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
                        _buildFormField('Agrarian Division', 
                        _agrarianDivisionController,
                        widget.validateOnSubmit && _agrarianDivisionController.text.isEmpty,
                        ),
                        const SizedBox(height: 15),
                        _buildFormField('Agrarian Organization', 
                        _agrarianOrganizationController,
                        widget.validateOnSubmit && _agrarianOrganizationController.text.isEmpty,
                        ),
                        const SizedBox(height: 15),
                        _buildFormField('Agrarian Name', 
                        _agrarianNameController,
                        widget.validateOnSubmit && _agrarianOrganizationController.text.isEmpty,
                        ),
                        const SizedBox(height: 15),
                        _buildFormField('Paddy Registration Number', 
                        _paddyRegNoController,
                        widget.validateOnSubmit &&_paddyRegNoController.text.isEmpty,
                        ),
                        const SizedBox(height: 15),
                        _buildFormField('Agrarian Description', 
                        _agrarianDescriptionController
                      ,
                      widget.validateOnSubmit && _agrarianDescriptionController.text.isEmpty,
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
        errorText: showError ? 'This field is required' : null,
      ),
      onChanged: (value) {
        _saveData();
        widget.clearValidation();
      },
    );
  }

}
