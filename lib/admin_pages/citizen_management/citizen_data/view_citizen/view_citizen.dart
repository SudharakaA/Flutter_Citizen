import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewCitizen extends StatefulWidget {
  const ViewCitizen({super.key});

  @override
  State<ViewCitizen> createState() => _ViewCitizenState();
}

class _ViewCitizenState extends State<ViewCitizen> {
  String selectedSearchType = 'NIC';
  final List<String> searchTypes = [
    'NIC',
    'Mobile Number',
    'Citizen Reference',
  ];

  // Data variables
  Map<String, dynamic> incomeInfo = {};
  Map<String, dynamic> healthInfo = {};
  Map<String, dynamic> subsidiesInfo = {};
  Map<String, dynamic> propertyInfo = {};
  Map<String, dynamic> agrarianInfo = {};
  Map<String, dynamic> householdInfo = {};
  Map<String, dynamic> livestockInfo = {};
  Map<String, dynamic> vehicleInfo = {};
  Map<String, dynamic> disasterInfo = {};

  // Track which card to show
  String? openedSection;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      incomeInfo = {
        'Income Type': prefs.getString('incomeType') ?? '',
        'Designation': prefs.getString('designation') ?? '',
        'Job Location': prefs.getString('jobLocation') ?? '',
        'Job Field': prefs.getString('jobField') ?? '',
        'Average Income': prefs.getString('averageIncome') ?? '',
        'Description': prefs.getString('incomeDescription') ?? '',
      };
      healthInfo = {
        'Illness Type': prefs.getString('illnessType') ?? '',
        'Illness Name': prefs.getString('illnessName') ?? '',
        'Hospital Name': prefs.getString('hospitalName') ?? '',
        'Description': prefs.getString('illnessDescription') ?? '',
      };
      subsidiesInfo = {
        'Subsidie Type': prefs.getString('subsidieType') ?? '',
        'Subsidie Amount': prefs.getString('subsidieAmount') ?? '',
        'Subsidie Reference': prefs.getString('subsidieReference') ?? '',
        'Description': prefs.getString('subsidieDescription') ?? '',
      };
      propertyInfo = {
        'Property Type': prefs.getString('propertyType') ?? '',
        'Property Size': prefs.getString('propertySize') ?? '',
        'Registration Number': prefs.getString('regNumber') ?? '',
        'Description': prefs.getString('propertyDescription') ?? '',
      };
      agrarianInfo = {
        'Agrarian Division': prefs.getString('agrarianDivision') ?? '',
        'Agrarian Organization': prefs.getString('agrarianOrganization') ?? '',
        'Agrarian Name': prefs.getString('agrarianName') ?? '',
        'Paddy Registration Number': prefs.getString('paddyRegNo') ?? '',
        'Agrarian Description': prefs.getString('agrarianDescription') ?? '',
      };
      householdInfo = {
        'Divisional Secretariat Division': prefs.getString('division') ?? '',
        'Grama Niladari Division': prefs.getString('grama') ?? '',
        'Village': prefs.getString('village') ?? '',
        'House Number': prefs.getString('houseNumber') ?? '',
      };
      livestockInfo = {
        'Animal Type': prefs.getString('animalType') ?? '',
        'Production Category': prefs.getString('productionCategory') ?? '',
        'Production Amount': prefs.getString('productionAmount') ?? '',
        'Animal Count': prefs.getString('animalCount') ?? '',
        'Livestock Description': prefs.getString('livestockDescription') ?? '',
      };
      vehicleInfo = {
        'Vehicle Type': prefs.getString('vehicleType') ?? '',
        'Vehicle Number': prefs.getString('vehicleNumber') ?? '',
        'Vehicle Description': prefs.getString('vehicleDescription') ?? '',
      };
      disasterInfo = {
        'Disaster Type': prefs.getString('disasterType') ?? '',
        'Disaster Description': prefs.getString('disasterDescription') ?? '',
      };
    });
  }

  // Decorated Card
  Widget _buildDetailsCard(String title, Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 2),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 17,
                color: Color(0xFF3A7D44),
              ),
            ),
            const SizedBox(height: 10),
            ...data.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${e.key}: ",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${e.value}",
                          style: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // Menu item builder with onTap
  Widget _buildMenuItem(String sectionKey, String title, IconData icon) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          if (openedSection == sectionKey) {
            openedSection = null; // Collapse if already open
          } else {
            openedSection = sectionKey;
          }
        });
      },
      child: Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              icon,
              size: 24,
              color: Colors.black,
            ),
            
            // Dropdown icon removed
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 224, 237, 224).withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            'Citizen Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Divider(color: Colors.black, thickness: 1.2),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey[600]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSearchType,
                          items: searchTypes
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSearchType = value!;
                            });
                          },
                          icon: const SizedBox.shrink(), // Remove dropdown icon
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey[600]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Menu Items with data below each (only show card if opened)
                _buildMenuItem('income', 'INCOME INFORMATION', Icons.monetization_on_outlined),
                if (openedSection == 'income')
                  _buildDetailsCard('Income Information', incomeInfo),
                const SizedBox(height: 16),
                _buildMenuItem('health', 'HEALTH STATUS', Icons.local_hospital_outlined),
                if (openedSection == 'health')
                  _buildDetailsCard('Health Status', healthInfo),
                const SizedBox(height: 16),
                _buildMenuItem('subsidies', 'SUBSIDIES STATUS', Icons.people_outline),
                if (openedSection == 'subsidies')
                  _buildDetailsCard('Subsidies Status', subsidiesInfo),
                const SizedBox(height: 16),
                _buildMenuItem('property', 'PROPERTY INFORMATION', Icons.home_outlined),
                if (openedSection == 'property')
                  _buildDetailsCard('Property Information', propertyInfo),
                const SizedBox(height: 16),  
                _buildMenuItem('agrarian', 'AGRARIAN INFORMATION', Icons.agriculture_outlined),
                if (openedSection == 'agrarian')
                  _buildDetailsCard('Agrarian Information', agrarianInfo),
                const SizedBox(height: 16),
                _buildMenuItem('household', 'HOUSEHOLD INFORMATION', Icons.house_outlined),
                if (openedSection == 'household')
                  _buildDetailsCard('Household Information', householdInfo),
                const SizedBox(height: 16),
                _buildMenuItem('livestock', 'LIVESTOCK DETAILS', Icons.pets_outlined),
                if (openedSection == 'livestock')
                  _buildDetailsCard('Livestock Details', livestockInfo),
                const SizedBox(height: 16),
                _buildMenuItem('vehicle', 'VEHICLE INFORMATION', Icons.directions_car_outlined),
                if (openedSection == 'vehicle')
                  _buildDetailsCard('Vehicle Information', vehicleInfo),
                const SizedBox(height: 16),
                _buildMenuItem('disaster', 'DISASTER INFORMATION', Icons.warning_amber_outlined),
                if (openedSection == 'disaster')
                  _buildDetailsCard('Disaster Information', disasterInfo),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}