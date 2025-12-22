import 'package:citizen_care_system/admin_pages/training_pages/training_request_pages/training_request.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ViewTrainingRequestDetails extends StatefulWidget {
  const ViewTrainingRequestDetails({super.key});

  @override
  State<ViewTrainingRequestDetails> createState() => _ViewTrainingRequestDetailsState();
}

class _ViewTrainingRequestDetailsState extends State<ViewTrainingRequestDetails> {
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

  final List<String> _serviceTypes = [
    'State Finance', 
    'Code of Institution', 
    'Office Procedures', 
    'Computer Training',
    'Other Computer Software Training',
    'Rules Acts',
    'Language Training',
    'Productivity Training',
    'Training programs related to disaster management',
    'Training programs related to construction sector',
    'Human resource development training',
    'Environmental Conservation and Management',
    'Agriculture and Livestock Training',
    'Sports',
    'Health Sector',
    'Other Training Programs',
    'Test',
  ];
  List<String> _selectedServiceTypes = [];

  final List<String> _requestType = [
    'Requested', 
    'Allocated', 
    'Participated', 
    'Not Participated', 
    'Rejected',
  ];
  String? _selectedRequestType;

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
            bottom: screenHeight * 0.02,
          ),
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
                "View Training Request Data",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.black38,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Service Type",
                      style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    MultiSelectDialogField(
                      items: _serviceTypes
                          .map((location) =>
                              MultiSelectItem<String>(location, location))
                          .toList(),
                      title: const Text("Select Services"),
                      selectedColor: Colors.green,
                      buttonText: Text(
                        _selectedServiceTypes.isEmpty
                            ? "Select Services"
                            : "${_selectedServiceTypes.length} items selected",
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
                      cancelText:
                          const Text("Cancel", style: TextStyle(color: Colors.red)),
                      confirmText:
                          const Text("Apply", style: TextStyle(color: Colors.blue)),
                      onConfirm: (values) {
                        setState(() {
                          _selectedServiceTypes = values.cast<String>();
                        });
                      },
                      validator: (values) {
                        if (values == null || values.isEmpty) {
                          return "Please select at least one service";
                        }
                        return null;
                      },
                      chipDisplay: MultiSelectChipDisplay.none(),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    buildDropDownFeild(
                      label: "Request Type",
                      value: _selectedRequestType,
                      items: _requestType,
                      onChanged: (val) => 
                      setState(() => _selectedRequestType = val),
                      validatorMsg: "Please select a request type",
                      screenWidth: screenWidth, 
                      screenHeight: screenHeight,
                    ),
                    Text(
                      "Start Date",
                      style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextFormField(
                      controller: _startDateController,
                      readOnly: true,
                      onTap: () async {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); 
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedStartDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        setState(() {
                          _selectedStartDate = pickedDate;
                          _startDateController.text =
                pickedDate != null
                  ? "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}"
                  : '';
                        });
                                            },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a start date";
                        }
                        return null;
                      },
                      decoration:
                          inputDecoration(screenWidth, screenHeight).copyWith(
                        suffixIcon: const Icon(Icons.calendar_today,
                            color: Colors.green),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "End Date",
                      style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextFormField(
                      controller: _endDateController,
                      readOnly: true,
                      onTap: () async {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); 
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedEndDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        setState(() {
                          _selectedEndDate = pickedDate;
                          _endDateController.text =
                pickedDate != null
                  ? "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}"
                  : '';
                        });
                                            },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a end date";
                        }
                        return null;
                      },
                      decoration:
                          inputDecoration(screenWidth, screenHeight).copyWith(
                        suffixIcon: const Icon(Icons.calendar_today,
                            color: Colors.green),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.14),
                     Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A7D44),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.01,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TrainingRequestPage(
                                  selectedServiceType: _selectedServiceTypes,
                                  selectedRequestType: _selectedRequestType,
                                  startDate: _selectedStartDate,
                                  endDate: _selectedEndDate,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'View Data',
                          style: GoogleFonts.inter(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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

  //Reusable dropdown input
  Widget buildDropDownFeild({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String validatorMsg,
    required double screenWidth,
    required double screenHeight,
  }){
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

  //common input decoration
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
