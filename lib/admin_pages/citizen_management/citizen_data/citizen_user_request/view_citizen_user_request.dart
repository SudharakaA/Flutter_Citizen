import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/citizen_user_request/citizen_user_request.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ViewCitizenUserRequest extends StatefulWidget {
  const ViewCitizenUserRequest({super.key, required List selectedLocations});

  @override
  State<ViewCitizenUserRequest> createState() => _ViewCitizenUserRequestState();
}

class _ViewCitizenUserRequestState extends State<ViewCitizenUserRequest> {
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
    'Bendiwewa - GN Office',
    'Samudragama - GN Office',
    'Ethumalpitiya - GN Office',
    'Sirisangabopedesa - GN Office',
    'Nikawewa',
    'Sinhaudagama',
    'Kadawalawewa',
    'Aluthwewa East',
    'Aluthwewa West',
    'Gananagolla',
    'Weerapedesa',
    'Pulathisipedasa',
    'Parakramasamudraya',
    'Ambanganga',
    'Kalahagala',
    'Pothgulpedesa',
    'Udawela',
    'Mahawelipedesa',
    'Nissankamallapedesa',
    'Thopawewa',
    'Polonnaruwa City',
    'Palugasdamana 1 Ela',
    'Palugasdamana 2 Ela',
    'Palugasdamana 3 Ela',
    'Palugasdamana North',
    'Palugasdamana South',
    'Galthambarawa',
    'Kuruppu Junction',
    'Mahasen Pedesa',
    'Manikkampattiya',
    'Nelumwila',
    'Kaduruwela West',
    'Kaduruwela South',
    'Perakumpedesa',
    'Kaduruwela East',
    'Gallella East',
    'Gallella',
    'Kotaleeya',
    'Kalinga Ela',
    'Damana Gemunupura',
    'Diwlana',
    'Pudoor',
    'Sinharajapura',
    'Onegama',
    'Wijayarajapura',
    'Medamaluwa',
    'Laksauyana',
    'Sri Nissankamallapura',
    'Sewagama',
    'Wewethenna',
    'Monarathenna',
    'Wijayabahupura',
    'Sinhapura',
    'Unagalawehera',
    'Shanthipura',
  ];

  List<String> _selectedLocations = [];

  final List<String> _status = ["Pending", "Approved", "Rejected"];
  String? _selectedStatus;

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
                "View Citizen User Requests",
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
                      "Location",
                      style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    MultiSelectDialogField(
                      items: _locations
                          .map((location) =>
                              MultiSelectItem<String>(location, location))
                          .toList(),
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
                      cancelText:
                          const Text("Cancel", style: TextStyle(color: Colors.red)),
                      confirmText:
                          const Text("Apply", style: TextStyle(color: Colors.blue)),
                      onConfirm: (values) {
                        setState(() {
                          _selectedLocations = values.cast<String>();
                        });
                      },
                      validator: (values) {
                        if (values == null || values.isEmpty) {
                          return "Please select at least one location";
                        }
                        return null;
                      },
                      chipDisplay: MultiSelectChipDisplay.none(),
                    ),
                    SizedBox(height: screenHeight * 0.03),
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedStartDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        setState(() {
                          _selectedStartDate = pickedDate;
                          _startDateController.text = pickedDate != null
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedEndDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        setState(() {
                          _selectedEndDate = pickedDate;
                          _endDateController.text = pickedDate != null
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
                    SizedBox(height: screenHeight * 0.03),
                    buildDropDownField(
                      label: "Status",
                      value: _selectedStatus,
                      items: _status,
                      onChanged: (val) =>
                          setState(() => _selectedStatus = val),
                      validatorMsg: "Please select Status",
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                    SizedBox(height: screenHeight * 0.06),
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
                                builder: (context) => CitizenUserRequest(
                                  selectedLocations: _selectedLocations,
                                  startDate: _selectedStartDate,
                                  endDate: _selectedEndDate,
                                  selectedStatus: _selectedStatus,
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

  Widget buildDropDownField({
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