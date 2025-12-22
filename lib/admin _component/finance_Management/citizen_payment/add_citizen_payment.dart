import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/custom_app_bar.dart';
import '../../../admin_pages/citizen_management/citizen_data/add_citizen/form_screens.dart';
import '../../../component/request_service/action_button.dart';

class AddCitizenPaymentPage extends StatefulWidget {
  const AddCitizenPaymentPage({super.key});

  @override
  State<AddCitizenPaymentPage> createState() => _AddCitizenPaymentPageState();
}

class _AddCitizenPaymentPageState extends State<AddCitizenPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  final List<String> _locations = [
    'Thamankaduwa - DS Office',
    'Higurakgoda -DS Office',
    'Dimbulagala - DS Office',
    'Lankapura - DS Office',
    'Welikanda - DS Office',
    'Elehera - DS Office'
  ];
  String? _selectedLocation;

  final List<String> _types = ["NIC", "Citizen Reference", "Citizen Code"];
  String? _selectedType;

  final List<Map<String, String>> _mockCitizens = [
    {
      "reference": "REF001",
      "name": "Kamal Perera",
      "nic": "NIC123456",
      "gnOffice": "Galle GN",
      "code": "CODE001"
    },
    {
      "reference": "REF002",
      "name": "Nimal Silva",
      "nic": "NIC789101",
      "gnOffice": "Matara GN",
      "code": "CODE002"
    },
    {
      "reference": "REF003",
      "name": "Sunil Jayasuriya",
      "nic": "NIC111213",
      "gnOffice": "Kandy GN",
      "code": "CODE003"
    }
  ];
  String? _foundReference;
  String? _foundName;
  String? _foundNIC;
  String? _foundGnOffice;

  final List<String> _headerName = [
    'Written test fees - 2025-02-10',
    'Practical test fees - 2025-02-15',
    'Vehical inspection fees - 2025-02-20',
    'Driving license renewal fees - 2025-02-25',
    'Gun permit fees - 2025-03-01',
    'Gun permit fine fees - 2025-03-05',
  ];
  String? _selectedHeaderName;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchCitizen() {
    String key = _searchController.text.trim();
    Map<String, String>? citizen;

    for (final data in _mockCitizens) {
      if ((_selectedType == "NIC" && data["nic"] == key) ||
          (_selectedType == "Citizen Reference" && data["reference"] == key) ||
          (_selectedType == "Citizen Code" && data["code"] == key)) {
        citizen = data;
        break;
      }
    }

    setState(() {
      if (citizen != null) {
        _foundName = citizen["name"];
        _foundReference = citizen["reference"];
        _foundNIC = citizen["nic"];
        _foundGnOffice = citizen["gnOffice"];
      } else {
        _foundName = _foundReference = _foundNIC = _foundGnOffice = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: const Color(0xFF80AF81),
        appBar: const CustomAppBarWidget(leading: CustomBackButton()),
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.all(screenWidth * 0.03),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    "Add Entry to List",
                    style: GoogleFonts.inter(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
                          label: "Search Citizen",
                          value: _selectedType,
                          items: _types,
                          onChanged: (val) {
                            setState(() {
                              _selectedType = val;
                              _searchController.clear();
                              _foundName = _foundReference =
                                  _foundNIC = _foundGnOffice = null;
                            });
                          },
                          validatorMsg: "Please select a search type",
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        if (_selectedType != null)
                          buildTextField(
                            label: " ${_selectedType!}",
                            controller: _searchController,
                            maxLines: 1,
                            validatorMsg:
                                "Please enter a valid ${_selectedType!}",
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        RichText(
                            text: TextSpan(
                                text: "Citizen not found? ",
                                style: GoogleFonts.inter(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                                children: [
                              TextSpan(
                                  text: "New Account",
                                  style: GoogleFonts.inter(
                                    fontSize: screenWidth * 0.035,
                                    color: const Color(0xFF3A7D44),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const FormScreens(),
                                        ),
                                      );
                                    })
                            ])),
                        SizedBox(height: screenHeight * 0.02),
                        if (_foundName != null) ...[
                          buildReadOnlyField(
                            label: "GN Office",
                            value: _foundGnOffice!,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                          buildReadOnlyField(
                            label: "Citizen Reference",
                            value: _foundReference!,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                          buildReadOnlyField(
                            label: "Citizen Name",
                            value: _foundName!,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                          buildReadOnlyField(
                            label: "Citizen NIC",
                            value: _foundNIC!,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        ],
                        buildDropdownField(
                          label: "Header Name",
                          value: _selectedHeaderName,
                          items: _headerName,
                          onChanged: (val) =>
                              setState(() => _selectedHeaderName = val),
                          validatorMsg: "Please select a header name",
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        buildTextField(
                          label: "Payment Amount",
                          controller: TextEditingController(),
                          keyboardType: TextInputType.number,
                          showSearchIcon: false,
                          validatorMsg: "Please enter payment amount",
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        buildTextField(
                          label: "Remarks",
                          controller: TextEditingController(),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          validatorMsg: "",
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          showSearchIcon: false,
                        ),
                        Center(
                          child: ActionButton(
                            text: 'Submit',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Payment Configuration Submitted'),
                                  ),
                                );
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  Navigator.pop(context);
                                });
                                // Add your submission logic here
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ]))));
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool showSearchIcon = true,
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
          validator: (value) {
            if (validatorMsg.isEmpty) return null;
            return value == null || value.isEmpty ? validatorMsg : null;
          },
          decoration: inputDecoration(screenWidth, screenHeight).copyWith(
            hintText: "Enter $label".toLowerCase(),
            hintStyle: TextStyle(
              color: const Color.fromARGB(255, 5, 52, 90),
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: showSearchIcon
                ? IconButton(
                    icon: const Icon(Icons.search, color: Color(0xFF3A7D44)),
                    onPressed: _searchCitizen,
                  )
                : null,
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

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
        LayoutBuilder(
          builder: (context, constraints) {
            return DropdownButtonFormField<String>(
              isExpanded: true, //allows long text to wrap inside dropdown
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
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          overflow: TextOverflow.ellipsis, // avoid overflow
                          softWrap: false,
                        ),
                      ))
                  .toList(),
              onChanged: onChanged,
              validator: (value) => value == null ? validatorMsg : null,
              decoration: inputDecoration(screenWidth, screenHeight),
            );
          },
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
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        borderSide: const BorderSide(color: Colors.black),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget buildReadOnlyField({
    required String label,
    required String value,
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
          initialValue: value,
          enabled: false,
          decoration: inputDecoration(screenWidth, screenHeight),
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.038,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }
}
