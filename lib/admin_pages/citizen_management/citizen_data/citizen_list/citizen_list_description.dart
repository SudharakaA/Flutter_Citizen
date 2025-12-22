import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:citizen_care_system/component/profile/profile_avatar.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';

class CitizenListDescription extends StatefulWidget {
  final Map<String, dynamic> citizenData;

  const CitizenListDescription({
    super.key,
    required this.citizenData,
  });

  @override
  State<CitizenListDescription> createState() => _CitizenListDescriptionState();
}

class _CitizenListDescriptionState extends State<CitizenListDescription> {
  String? openedSection;

  Widget _buildDetailsCard(String title, Map<String, dynamic> data, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02, horizontal: screenWidth * 0.005),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FFF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A7D44), width: 1.5),
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
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: screenWidth * 0.045,
                color: const Color(0xFF3A7D44),
              ),
            ),
            SizedBox(height: screenWidth * 0.025),
            ...data.entries.map((e) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.005),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${e.key}: ",
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
                title,
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

  Widget _buildRelativeCard(Map<String, dynamic> relative, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A7D44), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.06,
                  backgroundColor: const Color(0xFF80AF81),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: screenWidth * 0.06,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        relative['name'] ?? 'N/A',
                        style: GoogleFonts.inter(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        relative['relationship'] ?? 'N/A',
                        style: GoogleFonts.inter(
                          fontSize: screenWidth * 0.035,
                          color: const Color(0xFF3A7D44),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.025),
            Row(
              children: [
                Icon(Icons.badge_outlined, size: screenWidth * 0.04, color: Colors.grey.shade600),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'NIC: ${relative['nic'] ?? 'N/A'}',
                  style: GoogleFonts.inter(
                    fontSize: screenWidth * 0.032,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.01),
            Row(
              children: [
                Icon(Icons.phone_outlined, size: screenWidth * 0.04, color: Colors.grey.shade600),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Contact: ${relative['contact'] ?? 'N/A'}',
                  style: GoogleFonts.inter(
                    fontSize: screenWidth * 0.032,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.01),
            Row(
              children: [
                Icon(Icons.person_outline, size: screenWidth * 0.04, color: Colors.grey.shade600),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Gender: ${relative['gender'] ?? 'N/A'}',
                  style: GoogleFonts.inter(
                    fontSize: screenWidth * 0.032,
                    color: Colors.black87,
                  ),
                ),
              ],
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

    // Sample citizen info (you can replace this with actual data)
    final citizenInfo = {
      'Citizen Reference': widget.citizenData['Reference'] ?? 'N/A',
      'Family Reference': 'Not Available',
      'Location Reference': 'Not Available',
      'NIC Number': widget.citizenData['NIC Number'] ?? 'N/A',
      'Contact Number': widget.citizenData['Contact Number'] ?? 'N/A',
      'Landline Number': 'Not Available',
      'Blood Group': 'Not Available',
      'Passport Number': 'Not Available',
      'Elder Number': 'Not Available',
      'Date of Birth': 'Not Available',
      'Gender': widget.citizenData['Gender'] ?? 'N/A',
      'Nationality': 'Sri Lankan',
      'Civil Status': 'Not Available',
      'Religion': 'Not Available',
    };

    final householdInfo = {
      'Divisional Secretariat': 'Not Available',
      'Grama Niladari Division': 'Not Available',
      'Village': 'Not Available',
      'House Number': 'Not Available',
      'Address': widget.citizenData['Address'] ?? 'N/A',
      'Province': 'Not Available',
      'District': 'Not Available',
    };

    final incomeInfo = {
      'Income Type': 'Not Available',
      'Designation': 'Not Available',
      'Job Location': 'Not Available',
      'Job Field': 'Not Available',
      'Average Income': 'Not Available',
      'Employment Status': 'Not Available',
      'Description': 'Not Available',
    };

    final healthInfo = {
      'Illness Type': 'Not Available',
      'Illness Name': 'Not Available',
      'Hospital Name': 'Not Available',
      'Health Status': 'Not Available',
      'Chronic Diseases': 'Not Available',
      'Disabilities': 'Not Available',
      'Medical History': 'Not Available',
      'Description': 'Not Available',
    };

    final subsidiesInfo = {
      'Subsidie Type': 'Not Available',
      'Subsidie Amount': 'Not Available',
      'Subsidie Reference': 'Not Available',
      'Samurdhi': 'Not Available',
      'Elderly Allowance': 'Not Available',
      'Disability Allowance': 'Not Available',
      'Other Benefits': 'Not Available',
      'Description': 'Not Available',
    };

    final propertyInfo = {
      'Property Type': 'Not Available',
      'Property Size': 'Not Available',
      'Registration Number': 'Not Available',
      'Property Value': 'Not Available',
      'Ownership Status': 'Not Available',
      'Description': 'Not Available',
    };

    final agrarianInfo = {
      'Agrarian Division': 'Not Available',
      'Agrarian Organization': 'Not Available',
      'Agrarian Name': 'Not Available',
      'Paddy Registration Number': 'Not Available',
      'Land Size': 'Not Available',
      'Crop Type': 'Not Available',
      'Agrarian Description': 'Not Available',
    };

    final livestockInfo = {
      'Animal Type': 'Not Available',
      'Production Category': 'Not Available',
      'Production Amount': 'Not Available',
      'Animal Count': 'Not Available',
      'Livestock Description': 'Not Available',
    };

    final vehicleInfo = {
      'Vehicle Type': 'Not Available',
      'Vehicle Number': 'Not Available',
      'Vehicle Model': 'Not Available',
      'Registration Year': 'Not Available',
      'Vehicle Description': 'Not Available',
    };

    final disasterInfo = {
      'Disaster Type': 'Not Available',
      'Disaster Date': 'Not Available',
      'Damage Level': 'Not Available',
      'Assistance Received': 'Not Available',
      'Disaster Description': 'Not Available',
    };

    // Sample relatives data (you can replace this with actual API data)
    final List<Map<String, dynamic>> relatives = [
      {
        'name': 'John Doe',
        'relationship': 'Father',
        'nic': '197012345678',
        'contact': '0771234567',
        'gender': 'Male',
      },
      {
        'name': 'Jane Doe',
        'relationship': 'Mother',
        'nic': '197523456789',
        'contact': '0779876543',
        'gender': 'Female',
      },
      {
        'name': 'Mike Doe',
        'relationship': 'Brother',
        'nic': '199534567890',
        'contact': '0771122334',
        'gender': 'Male',
      },
      {
        'name': 'Sarah Doe',
        'relationship': 'Sister',
        'nic': '199845678901',
        'contact': '0779988776',
        'gender': 'Female',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(leading: CustomBackButton()),
      body: Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileAvatar(
              imageUrl: 'assets/images/profile_avatar.png',
              size: screenWidth * 0.18,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              widget.citizenData['Citizen Name'] ?? 'N/A',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${widget.citizenData['Relationship'] ?? 'N/A'}\n${widget.citizenData['Address'] ?? 'N/A'}',
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
                    padding: EdgeInsets.only(right: screenWidth * 0.03),
                    child: Column(
                      children: [
                        _buildMenuItem('citizen', 'Citizen Profile', Icons.person_outline, screenWidth),
                        if (openedSection == 'citizen')
                          _buildDetailsCard('Citizen Profile', citizenInfo, screenWidth),
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildMenuItem('relatives', 'Family & Relatives', Icons.family_restroom_outlined, screenWidth),
                        if (openedSection == 'relatives')
                          Container(
                            margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02, horizontal: screenWidth * 0.005),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FFF9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF3A7D44), width: 1.5),
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
                                    'Family & Relatives',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w800,
                                      fontSize: screenWidth * 0.045,
                                      color: const Color(0xFF3A7D44),
                                    ),
                                  ),
                                  SizedBox(height: screenWidth * 0.025),
                                  ...relatives.map((relative) => _buildRelativeCard(relative, screenWidth)),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildMenuItem('household', 'Household Information', Icons.house_outlined, screenWidth),
                        if (openedSection == 'household')
                          _buildDetailsCard('Household Information', householdInfo, screenWidth),
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildMenuItem('income', 'Income Information', Icons.monetization_on_outlined, screenWidth),
                        if (openedSection == 'income')
                          _buildDetailsCard('Income Information', incomeInfo, screenWidth),
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildMenuItem('health', 'Health Status', Icons.local_hospital_outlined, screenWidth),
                        if (openedSection == 'health')
                          _buildDetailsCard('Health Status', healthInfo, screenWidth),
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildMenuItem('subsidies', 'Subsidies Status', Icons.people_outline, screenWidth),
                        if (openedSection == 'subsidies')
                          _buildDetailsCard('Subsidies Status', subsidiesInfo, screenWidth),
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildMenuItem('property', 'Property Information', Icons.home_outlined, screenWidth),
                        if (openedSection == 'property')
                          _buildDetailsCard('Property Information', propertyInfo, screenWidth),
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildMenuItem('agrarian', 'Agrarian Information', Icons.agriculture_outlined, screenWidth),
                        if (openedSection == 'agrarian')
                          _buildDetailsCard('Agrarian Information', agrarianInfo, screenWidth),
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildMenuItem('livestock', 'Livestock Details', Icons.pets_outlined, screenWidth),
                        if (openedSection == 'livestock')
                          _buildDetailsCard('Livestock Details', livestockInfo, screenWidth),
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildMenuItem('vehicle', 'Vehicle Information', Icons.directions_car_outlined, screenWidth),
                        if (openedSection == 'vehicle')
                          _buildDetailsCard('Vehicle Information', vehicleInfo, screenWidth),
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildMenuItem('disaster', 'Disaster Information', Icons.warning_amber_outlined, screenWidth),
                        if (openedSection == 'disaster')
                          _buildDetailsCard('Disaster Information', disasterInfo, screenWidth),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
