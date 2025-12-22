import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisasterDetailsForm extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;
  final bool validateOnSubmit;
  final VoidCallback clearValidation;

  const DisasterDetailsForm({
    super.key,
    required this.onPrevious,
    required this.onSubmit,
    required this.validateOnSubmit,
    required this.clearValidation,
  });

  @override
  State<DisasterDetailsForm> createState() => _DisasterDetailsFormPageState();
}

class _DisasterDetailsFormPageState extends State<DisasterDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDisasterType;
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDisasterType = prefs.getString('disasterType');
      _descController.text = prefs.getString('disasterDescription') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedDisasterType != null) {
      prefs.setString('disasterType', _selectedDisasterType!);
    }
    prefs.setString('disasterDescription', _descController.text);
  }

  @override
  void dispose() {
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
              child: Column(
                children: [
                  Container(
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
                                'Disaster Details',
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
                              "Disaster Type",
                              _selectedDisasterType,
                              ["Flood", "Drought", "Landslide", "Other"],
                              (value) {
                                setState(() {
                                  _selectedDisasterType = value;
                                });
                                _saveData();
                                widget.clearValidation();
                              },
                              widget.validateOnSubmit &&
                                  _selectedDisasterType == null,
                            ),
                            const SizedBox(height: 5),
                            _buildFormField(
                              "Disaster Description",
                              _descController,
                              widget.validateOnSubmit &&
                                  _descController.text.isEmpty,
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
                            //         widget.onSubmit();
                            //       },
                            //       style: ElevatedButton.styleFrom(
                            //         backgroundColor: const Color(0xFF3A7D44),
                            //         foregroundColor: Colors.white,
                            //         padding: const EdgeInsets.symmetric(
                            //             vertical: 15),
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(6),
                            //         ),
                            //       ),
                            //       child: const Text('Submit'),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Submit Button outside the form container
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 20),
                  //   child: SizedBox(
                  //     width: constraints.maxWidth > 600 ? 150 : 100,
                  //     child: ElevatedButton(
                  //       onPressed: () {
                  //         if (_formKey.currentState!.validate()) {
                  //           _saveData();
                  //           ScaffoldMessenger.of(context).showSnackBar(
                  //             const SnackBar(content: Text('Disaster details submitted successfully!')),
                  //           );
                  //         }
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: const Color(0xFF3A7D44),
                  //         foregroundColor: Colors.white,
                  //         padding: const EdgeInsets.symmetric(vertical: 15),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(6),
                  //         ),
                  //       ),
                  //       child: const Text('Submit'),
                  //     ),
                  //   ),
                  // ),
                ],
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
