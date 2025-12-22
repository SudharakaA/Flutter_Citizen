import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import '../component/profile/profile_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  final String citizenCode;
  final String accessToken;

  const ProfilePage({
    super.key,
    required this.citizenCode,
    required this.accessToken,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _profileDataFuture;
  String? openedSection;

  @override
  void initState() {
    super.initState();
    _profileDataFuture = fetchProfileData();
  }

  Future<Map<String, dynamic>> fetchProfileData() async {
    final String baseUrl = dotenv.env['GetCitizenData'] ?? '';
    final String url = '$baseUrl?citizenCode=${widget.citizenCode}';
    
    debugPrint('Fetching profile with token: ${widget.accessToken}');
    debugPrint('Using citizenCode: ${widget.citizenCode}');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );

    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      if (json['isSuccess'] == true &&
          json['dataBundle'] != null &&
          json['dataBundle']['basic-data'] != null) {
        return json['dataBundle']['basic-data'];
      } else {
        throw Exception('No citizen data found in dataBundle["basic-data"]');
      }
    } else {
      throw Exception('Failed to load profile data (status: ${response.statusCode})');
    }
  }

  Widget _buildDetailsCard(String title, Map<String, dynamic> data, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02, horizontal: screenWidth * 0.005),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FFF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF3A7D44), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 182, 229, 182).withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.tr(),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: screenWidth * 0.045,
                color: const Color(0xFF3A7D44),
              ),
            ),
            SizedBox(height: screenWidth * 0.025),
            ...data.entries.map((e) {
              final localizedKey = e.key.tr();
              return Padding(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.005),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$localizedKey: ",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.035,
                        color: Colors.black87,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${e.value}",
                        style: GoogleFonts.inter(
                          fontSize: screenWidth * 0.035,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String sectionKey, String title, IconData icon, double screenWidth) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          if (openedSection == sectionKey) {
            openedSection = null;
          } else {
            openedSection = sectionKey;
          }
        });
      },
      child: Container(
        width: double.infinity,
        height: screenWidth * 0.1,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
        margin: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title.tr(),
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              icon,
              size: screenWidth * 0.06,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            top: screenHeight * 0.02,
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 224, 237, 224).withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _profileDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    tr('error', args: [snapshot.error.toString()]),
                    style: GoogleFonts.inter(fontSize: screenWidth * 0.04),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    tr('no_data_found'),
                    style: GoogleFonts.inter(fontSize: screenWidth * 0.04),
                  ),
                );
              }

              final data = snapshot.data!;

              final citizenInfo = {
                'citizen_reference': data['CITIZEN_REFERENCE'] ?? '',
                'family_reference': data['FAMILY_REFERENCE'] ?? '',
                'location_reference': data['LOCATION_REFERENCE'] ?? '',
                'nic_number': data['NIC_NUMBER'] ?? '',
                'contact_number': data['PRIMARY_CONTACT'] ?? '',
                'landline_number': data['FIXED_NUMBER'] ?? '',
                'blood_group': data['BLOOD_GROUP'] ?? '',
                'passport': data['PASSPORT_NUMBER'] ?? '',
                'elder_number': data['ELDER_NO'] ?? '',
                'date_of_birth': data['DATE_OF_BIRTH'] ?? '',
                'gender': data['GENDER'] ?? '',
                'nationality': data['NATIONALITY'] ?? '',
                'civil_status': data['CIVIL_STATUS'] ?? '',
                'religion': data['RELIGION'] ?? '',
              };

              final householdInfo = {
                'divisional_secretariat': data['DS_DIVISION'] ?? '',
                'grama_niladari_division': data['GN_DIVISION'] ?? '',
                'village': data['VILLAGE_NAME'] ?? '',
                'house_number': data['HOME_NUMBER'] ?? '',
                'address': data['CITIZEN_ADDRESS'] ?? '',
              };

              final incomeInfo = {
                'income_type': '',
                'designation': '',
                'job_location': '',
                'job_field': '',
                'average_income': '',
                'description': '',
              };
              final healthInfo = {
                'illness_type': '',
                'illness_name': '',
                'hospital_name': '',
                'description': '',
              };
              final subsidiesInfo = {
                'subsidie_type': '',
                'subsidie_amount': '',
                'subsidie_reference': '',
                'description': '',
              };
              final propertyInfo = {
                'property_type': '',
                'property_size': '',
                'registration_number': '',
                'description': '',
              };
              final agrarianInfo = {
                'agrarian_division': '',
                'agrarian_organization': '',
                'agrarian_name': '',
                'paddy_registration_number': '',
                'agrarian_description': '',
              };
              final livestockInfo = {
                'animal_type': '',
                'production_category': '',
                'production_amount': '',
                'animal_count': '',
                'livestock_description': '',
              };
              final vehicleInfo = {
                'vehicle_type': '',
                'vehicle_number': '',
                'vehicle_description': '',
              };
              final disasterInfo = {
                'disaster_type': '',
                'disaster_description': '',
              };

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfileAvatar(imageUrl: 'assets/images/profile_avatar.png', size: screenWidth * 0.18),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    data['CITIZEN_NAME'] ?? 'N/A',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${data['FRIENDLY_NAME'] ?? ''} - ${data['RELATIONSHIP_TYPE'] ?? ''}\n${data['GN_DIVISION'] ?? ''}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: screenWidth * 0.035,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Divider(
                    thickness: 1,
                    color: Colors.black38,
                    indent: screenWidth * 0.05,
                    endIndent: screenWidth * 0.05,
                  ),
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        scrollbarTheme: ScrollbarThemeData(
                          thumbColor: MaterialStateProperty.all(const Color(0xFF3A7D44)),
                          thickness: MaterialStateProperty.all(8.0),
                          radius: const Radius.circular(10),
                          trackVisibility: MaterialStateProperty.all(true),
                        ),
                      ),
                      child: Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        interactive: true,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: EdgeInsets.only(right: screenWidth * 0.03), // Reserve space for scrollbar
                          child: Column(
                            children: [
                              _buildMenuItem('citizen', 'citizen_profile', Icons.person_outline, screenWidth),
                              if (openedSection == 'citizen')
                                _buildDetailsCard('citizen_profile', citizenInfo, screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                              _buildMenuItem('household', 'household_information', Icons.house_outlined, screenWidth),
                              if (openedSection == 'household')
                                _buildDetailsCard('household_information', householdInfo, screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                              _buildMenuItem('income', 'income_information', Icons.monetization_on_outlined, screenWidth),
                              if (openedSection == 'income')
                                _buildDetailsCard('income_information', incomeInfo, screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                              _buildMenuItem('health', 'health_status', Icons.local_hospital_outlined, screenWidth),
                              if (openedSection == 'health')
                                _buildDetailsCard('health_status', healthInfo, screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                              _buildMenuItem('subsidies', 'subsidies_status', Icons.people_outline, screenWidth),
                              if (openedSection == 'subsidies')
                                _buildDetailsCard('subsidies_status', subsidiesInfo, screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                              _buildMenuItem('property', 'property_information', Icons.home_outlined, screenWidth),
                              if (openedSection == 'property')
                                _buildDetailsCard('property_information', propertyInfo, screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                              _buildMenuItem('agrarian', 'agrarian_information', Icons.agriculture_outlined, screenWidth),
                              if (openedSection == 'agrarian')
                                _buildDetailsCard('agrarian_information', agrarianInfo, screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                              _buildMenuItem('livestock', 'livestock_details', Icons.pets_outlined, screenWidth),
                              if (openedSection == 'livestock')
                                _buildDetailsCard('livestock_details', livestockInfo, screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                              _buildMenuItem('vehicle', 'vehicle_information', Icons.directions_car_outlined, screenWidth),
                              if (openedSection == 'vehicle')
                                _buildDetailsCard('vehicle_information', vehicleInfo, screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                              _buildMenuItem('disaster', 'disaster_information', Icons.warning_amber_outlined, screenWidth),
                              if (openedSection == 'disaster')
                                _buildDetailsCard('disaster_information', disasterInfo, screenWidth),
                              SizedBox(height: screenHeight * 0.02),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}