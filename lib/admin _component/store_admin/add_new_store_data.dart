import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../component/custom_app_bar.dart';
import '../../component/custom_back_button.dart';
import '../../component/request_service/action_button.dart';

class AddStoreData extends StatefulWidget {
  const AddStoreData({super.key});

  @override
  State<AddStoreData> createState() => _AddStoreDataState();
}

class _AddStoreDataState extends State<AddStoreData> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toString().split(' ')[0];
  }

  final List<String> _locations = [
    'Thamankaduwa - DS Office',
    'Higurakgoda -DS Office',
    'Dimbulagala - DS Office',
    'Lankapura - DS Office',
    'Welikanda - DS Office',
    'Elehera - DS Office'
  ];
  String? _selectedLocation;

  final List<String> _category = [
    'Paper',
    'Books',
    'Pens and Pencils',
    'Computer Ribbons',
    'Electrical Items',
    'Cleaning Materials'
  ];
  String? _selectedCategory;

  final List<String> _good = [
    'A4',
    'A3',
    'B4',
    'Legal',
    'Pulscap',
    'Ronio Sheet',
    'Half Sheet',
    'Typing Tisue',
    'A4 Colour'
  ];
  String? _selectedGood;

  final List<String> _addingMethod = ['New Purchase', 'Donation'];
  String? _selectedAddingMethod;

  final List<String> _unit = ['Units', 'Kg', 'Meters'];
  String? _selectedUnit;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: screenHeight * 0.02,
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
              bottom: screenHeight * 0.02),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add New Store Data",
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.black38,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(height: screenHeight * 0.02),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDropdownField(
                      label: "Location",
                      value: _selectedLocation,
                      items: _locations,
                      onChanged: (val) =>
                          setState(() => _selectedLocation = val),
                      validatorMsg: "Please select a location",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildDropdownField(
                      label: "Item Category",
                      value: _selectedCategory,
                      items: _category,
                      onChanged: (val) =>
                          setState(() => _selectedCategory = val),
                      validatorMsg: "Please select a category",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildDropdownField(
                      label: "Good Name",
                      value: _selectedGood,
                      items: _good,
                      onChanged: (val) => setState(() => _selectedGood = val),
                      validatorMsg: "Please select a good",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildDropdownField(
                      label: "Adding Method",
                      value: _selectedAddingMethod,
                      items: _addingMethod,
                      onChanged: (val) =>
                          setState(() => _selectedAddingMethod = val),
                      validatorMsg: "Please select a method",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildTextField(
                      label: "Item Quantity",
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      validatorMsg: "Please enter item quantity",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    buildDropdownField(
                      label: "Item Unit",
                      value: _selectedUnit,
                      items: _unit,
                      onChanged: (val) => setState(() => _selectedUnit = val),
                      validatorMsg: "Please select a unit",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    Text(
                      "Action Date",
                      style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: inputDecoration(screenWidth, screenHeight),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    buildTextField(
                      label: "Description",
                      controller: _descriptionController,
                      maxLines: 6,
                      validatorMsg: "Please enter a description",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Center(
                      child: ActionButton(
                        text: 'Submit',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Item submitted successfully!"),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable text input
  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required String validatorMsg,
    required double screenWidth,
    required double screenHeight,
  }) {
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
        SizedBox(height: screenHeight * 0.01),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          validator: (value) =>
              value == null || value.isEmpty ? validatorMsg : null,
          decoration: inputDecoration(screenWidth, screenHeight).copyWith(
            hintText: "Enter $label".toLowerCase(),
            hintStyle: TextStyle(
              color: const Color.fromARGB(255, 5, 52, 90),
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  // Reusable dropdown input
  Widget buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String validatorMsg,
    required double screenWidth,
    required double screenHeight,
  }) {
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
        SizedBox(height: screenHeight * 0.01),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            "Select $label".toLowerCase(),
            style: TextStyle(
              color: const Color.fromARGB(255, 5, 52, 90),
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
            ),
          ),
          items: items
              .map((String item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? validatorMsg : null,
          decoration: inputDecoration(screenWidth, screenHeight),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  // Common input decoration
  InputDecoration inputDecoration(double screenWidth, double screenHeight) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.012,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        borderSide: const BorderSide(color: Colors.green),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
