import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/request_service/action_button.dart';
import './citizen_payment.dart';

class ViewCitizenPaymentPage extends StatefulWidget {
  const ViewCitizenPaymentPage({super.key});

  @override
  State<ViewCitizenPaymentPage> createState() => _ViewCitizenPaymentPageState();
}

class _ViewCitizenPaymentPageState extends State<ViewCitizenPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DateTime? _selectedStartDate;
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
  String? _selectedLocation;

  final List<String> _headerName = [
    'Written test fees - 2025-02-10',
    'Practical test fees - 2025-02-15',
    'Vehical inspection fees - 2025-02-20',
    'Driving license renewal fees - 2025-02-25',
    'Gun permit fees - 2025-03-01',
    'Gun permit fine fees - 2025-03-05',
  ];
  List<String> _selectedHeaderNames = [];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(screenWidth * 0.03),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
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
                  "View Citizen Payment",
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
                          buildLocationDropdown(screenWidth, screenHeight),
                          SizedBox(height: screenHeight * 0.03),
                          buildLabel("Header Name", screenWidth),
                          SizedBox(height: screenHeight * 0.01),
                          MultiSelectDialogField(
                            items: _headerName
                                .map((header) => MultiSelectItem(header, header))
                                .toList(),
                            title: const Text("Select Header Names"),
                            selectedColor: Colors.green,
                            buttonText: Text(
                              _selectedHeaderNames.isEmpty
                                  ? "Select header names"
                                  : "${_selectedHeaderNames.length} selected",
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
                            cancelText: const Text("Cancel",
                                style: TextStyle(color: Colors.red)),
                            confirmText: const Text("Apply",
                                style: TextStyle(color: Colors.green)),
                            onConfirm: (values) {
                              setState(() => _selectedHeaderNames =
                                  values.cast<String>());
                            },
                            validator: (values) {
                              if (values == null || values.isEmpty) {
                                return "Please select at least one header name";
                              }
                              return null;
                            },
                            chipDisplay: MultiSelectChipDisplay.none(),
                          ),
                          SizedBox(height: screenHeight * 0.03),
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
                            builder: (context) => CitizenPaymentPage(
                              selectedLocations: _selectedLocation,
                              selectedHeaderNames: _selectedHeaderNames,
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
      }),
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

  Widget buildLocationDropdown(double screenWidth, double screenHeight) {
    return DropdownButtonFormField<String>(
      value: _selectedLocation,
      hint: Text(
        "Select location",
        style: TextStyle(
          color: const Color.fromARGB(255, 5, 52, 90),
          fontSize: screenWidth * 0.035,
        ),
      ),
      items: _locations
          .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
          .toList(),
      onChanged: (val) {
        setState(() {
          _selectedLocation = val;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please select a location";
        }
        return null;
      },
      decoration: inputDecoration(screenWidth, screenHeight),
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
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(foregroundColor: Colors.green),
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
