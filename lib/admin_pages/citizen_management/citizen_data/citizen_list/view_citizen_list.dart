import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/citizen_list/citizen_list.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../component/request_service/action_button.dart';

// Main widget for viewing citizen list data
class ViewCitizenListPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const ViewCitizenListPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<ViewCitizenListPage> createState() => _ViewCitizenListPageState();
}

class _ViewCitizenListPageState extends State<ViewCitizenListPage> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, String>> _gnDivisions = [];
  String? _selectedLocationId;
  String? _selectedLocationName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  // Fetch locations from the API
  Future<void> _fetchLocations() async {
    final url = Uri.parse(
      'http://220.247.224.226:8401/CCSHubApi/api/MainApi/ViewCitizenGNDivisionsRequested?username=${widget.citizenCode}',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['dataBundle'];

        setState(() {
          _gnDivisions = data
              .map<Map<String, String>>((e) => {
                    'id': e['LOCATION_ID'].toString(),
                    'name': e['LOCATION'].toString(),
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load GN divisions");
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading GN divisions: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      body: SingleChildScrollView(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
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
                "View Citizen List",
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
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                            isExpanded: true, // <-- Important
                            decoration: inputDecoration(screenWidth, screenHeight),
                            items: _gnDivisions.map((division) {
                              return DropdownMenuItem<String>(
                                value: division['id'],
                                child: Text(
                                  division['name']!,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLocationId = value;
                                _selectedLocationName =
                                    _gnDivisions.firstWhere((e) => e['id'] == value)['name'];
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a location';
                              }
                              return null;
                            },
                            hint: const Text("Select a location"),
                            value: _selectedLocationId,
                          ),
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: ActionButton(
                        text: "View Data",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CitizenList(
                                  selectedLocationId: _selectedLocationId!,
                                  selectedLocationName: _selectedLocationName!,
                                  accessToken: widget.accessToken,
                                  citizenCode: widget.citizenCode,
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
            ],
          ),
        ),
        ),
      ),
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
