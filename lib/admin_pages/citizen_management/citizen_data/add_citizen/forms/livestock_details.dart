import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LivestockDetails extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool validateOnSubmit;
  final VoidCallback clearValidation;

  const LivestockDetails({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.validateOnSubmit,
    required this.clearValidation,
  });

  @override
  State<LivestockDetails> createState() => _LivestockDetailsPageState();
}

class _LivestockDetailsPageState extends State<LivestockDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _animalTypeController = TextEditingController();
  final TextEditingController _productionCategoryController = TextEditingController();
  final TextEditingController _productionAmountController = TextEditingController();
  final TextEditingController _animalCountController = TextEditingController();
  final TextEditingController _livestockDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _animalTypeController.text = prefs.getString('animalType') ?? '';
      _productionCategoryController.text = prefs.getString('productionCategory') ?? '';
      _productionAmountController.text = prefs.getString('productionAmount') ?? '';
      _animalCountController.text = prefs.getString('animalCount') ?? '';
      _livestockDescriptionController.text = prefs.getString('livestockDescription') ?? '';
    });
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('animalType', _animalTypeController.text);
    prefs.setString('productionCategory', _productionCategoryController.text);
    prefs.setString('productionAmount', _productionAmountController.text);
    prefs.setString('animalCount', _animalCountController.text);
    prefs.setString('livestockDescription', _livestockDescriptionController.text);
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
                            'Livestock Details',
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
                        _buildFormField("Animal Type", 
                        _animalTypeController,
                        widget.validateOnSubmit &&  _animalTypeController.text.isEmpty,
                        ),
                        const SizedBox(height: 15),
                        _buildFormField("Production Category",  
                        _productionCategoryController,
                        widget.validateOnSubmit && _productionCategoryController.text.isEmpty,
                        ),
                        const SizedBox(height: 15),
                        _buildFormField("Production Amount", 
                        _productionAmountController,
                        widget.validateOnSubmit && _productionAmountController.text.isEmpty,
                        ),
                        const SizedBox(height: 15),
                        _buildFormField("Animal Count",
                        _animalCountController,
                        widget.validateOnSubmit && _animalCountController.text.isEmpty,
                        ),
                        const SizedBox(height: 15),
                        _buildFormField("Livestock Description", 
                        _livestockDescriptionController,
                        widget.validateOnSubmit && _livestockDescriptionController.text.isEmpty,
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
