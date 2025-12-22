import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';

class SubsidiesForm extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool validateOnSubmit;
  final VoidCallback clearValidation;

  const SubsidiesForm({
    super.key,
    required this.onNext,
    required this.validateOnSubmit,
    required this.clearValidation,
    required this.onPrevious,
  });

  @override
  State<SubsidiesForm> createState() => _SubsidiesFormState();
}

class _SubsidiesFormState extends State<SubsidiesForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSubsidietype;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedSubsidietype = prefs.getString('subsidieType');
      _amountController.text = prefs.getString('subsidieAmount') ?? '';
      _referenceController.text = prefs.getString('subsidieReference') ?? '';
      _descriptionController.text =
          prefs.getString('subsidieDescription') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedSubsidietype != null) {
      prefs.setString('subsidieType', _selectedSubsidietype!);
    }
    prefs.setString('subsidieAmount', _amountController.text);
    prefs.setString('subsidieReference', _referenceController.text);
    prefs.setString('subsidieDescription', _descriptionController.text);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
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
                            'Subsidies',
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
                          'Subsidie Type',
                          _selectedSubsidietype,
                          [
                            'Aswasuma',
                            'Samurdhi aid',
                            'Illness aid',
                            'Public',
                            'Other'
                          ],
                          (value) {
                            setState(() {
                              _selectedSubsidietype = value;
                            });
                            _saveData();
                            widget.clearValidation();
                          },
                          widget.validateOnSubmit &&
                              (_selectedSubsidietype == null),
                        ),
                        const SizedBox(height: 5),
                        _buildFormField(
                          'Subsidie Amount',
                          _amountController,
                          widget.validateOnSubmit &&
                              _amountController.text.isEmpty,
                        ),
                        const SizedBox(height: 5),
                        _buildFormField(
                          'Subsidie Reference',
                          _referenceController,
                          widget.validateOnSubmit &&
                              _referenceController.text.isEmpty,
                        ),
                        const SizedBox(height: 5),
                        _buildFormField(
                          'Subsidie Description',
                          _descriptionController,
                          widget.validateOnSubmit &&
                              _descriptionController.text.isEmpty,
                        ),
                        const SizedBox(height: 20),
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