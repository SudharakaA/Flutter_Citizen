import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../component/custom_app_bar.dart';
import '../../component/custom_back_button.dart';
import './store_management_page.dart';
import '../../component/request_service/action_button.dart';

class ViewStoreData extends StatefulWidget {
  const ViewStoreData({super.key});

  @override
  State<ViewStoreData> createState() => _ViewStoreDataState();
}

class _ViewStoreDataState extends State<ViewStoreData> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _startDateController = TextEditingController();
  DateTime? _selectedStartDate;
  final TextEditingController _endDateController = TextEditingController();
  DateTime? _selectedEndDate;

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  final List<String> _locations = [
    'Thamankaduwa - DS Office',
    'Higurakgoda - DS Office',
    'Dimbulagala - DS Office',
    'Lankapura - DS Office',
    'Welikanda - DS Office',
    'Elehera - DS Office'
  ];
  List<String> _selectedLocations = [];

  final List<String> _type = ["Addition", "Removal"];
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(screenWidth * 0.03),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              height: constraints.maxHeight - (screenHeight * 0.04),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    "View Store Data",
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLabel("Location", screenWidth),
                            SizedBox(height: screenHeight * 0.01),
                            buildMultiSelect(screenWidth, screenHeight),
                            SizedBox(height: screenHeight * 0.03),
                            buildDropDownFeild(
                              label: "Type",
                              value: _selectedType,
                              items: _type,
                              onChanged: (val) =>
                                  setState(() => _selectedType = val),
                              validatorMsg: "Please select a type",
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            ),
                            buildLabel("Start Date", screenWidth),
                            SizedBox(height: screenHeight * 0.01),
                            buildDatePickerField(
                              controller: _startDateController,
                              selectedDate: _selectedStartDate,
                              onDateSelected: (date) {
                                setState(() {
                                  _selectedStartDate = date;
                                  _startDateController.text = formatDate(date);
                                });
                              },
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              validatorText: "Please select a start date",
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            buildLabel("End Date", screenWidth),
                            SizedBox(height: screenHeight * 0.01),
                            buildDatePickerField(
                              controller: _endDateController,
                              selectedDate: _selectedEndDate,
                              onDateSelected: (date) {
                                setState(() {
                                  _selectedEndDate = date;
                                  _endDateController.text = formatDate(date);
                                });
                              },
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              validatorText: "Please select an end date",
                            ),
                            SizedBox(height: screenHeight * 0.03),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: ActionButton(
                      text: 'View Data',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreManagementPage(
                                selectedLocations: _selectedLocations,
                                selectedType: _selectedType,
                                startDate: _selectedStartDate,
                                endDate: _selectedEndDate,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildLabel(String text, double screenWidth) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: screenWidth * 0.04,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildMultiSelect(double screenWidth, double screenHeight) {
    return MultiSelectDialogField(
      items: _locations.map((loc) => MultiSelectItem(loc, loc)).toList(),
      title: const Text("Select Locations"),
      selectedColor: Colors.green,
      buttonText: Text(
        _selectedLocations.isEmpty
            ? "Select locations"
            : "${_selectedLocations.length} items selected",
        style: TextStyle(
          color: const Color.fromARGB(255, 5, 52, 90),
          fontSize: screenWidth * 0.035,
        ),
      ),
      buttonIcon: const Icon(Icons.arrow_drop_down),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      dialogHeight: screenHeight * 0.5,
      dialogWidth: screenWidth * 0.8,
      cancelText: const Text("Cancel", style: TextStyle(color: Colors.red)),
      confirmText: const Text("Apply", style: TextStyle(color: Colors.blue)),
      onConfirm: (values) {
        setState(() => _selectedLocations = values.cast<String>());
      },
      validator: (values) {
        if (values == null || values.isEmpty) {
          return "Please select at least one location";
        }
        return null;
      },
      chipDisplay: MultiSelectChipDisplay.none(),
    );
  }

  Widget buildDropDownFeild({
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
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? validatorMsg : null,
          decoration: inputDecoration(screenWidth, screenHeight),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  Widget buildDatePickerField({
    required TextEditingController controller,
    required DateTime? selectedDate,
    required void Function(DateTime) onDateSelected,
    required double screenWidth,
    required double screenHeight,
    required String validatorText,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedStartDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.green, // Header and selected date
                  onPrimary: Colors.white, // Text on header
                  onSurface: Colors.black, // Default text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green, // Confirm and cancel buttons
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
            },
      validator: (value) =>
          value == null || value.isEmpty ? validatorText : null,
      decoration: inputDecoration(screenWidth, screenHeight).copyWith(
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.green),
      ),
    );
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

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
