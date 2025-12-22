// Import necessary packages and project files
import 'package:citizen_care_system/admin%20_component/citizen_service_task/download_dialog.dart';
import 'package:citizen_care_system/admin%20_component/store_admin/add_new_store_data.dart';
import 'package:citizen_care_system/admin%20_component/store_admin/edit_store_data.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/citizen_list/view_citizen_list.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/citizen_list/citizen_list_description.dart';
import 'package:citizen_care_system/component/admin_circle_menu/fab_menu.dart';
import 'package:citizen_care_system/component/admin_circle_menu/hover_tap_button.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CitizenList extends StatefulWidget {
  final String selectedLocationId;
  final String selectedLocationName;
  final String accessToken;
  final String citizenCode;


  const CitizenList({
    super.key, 
    required this.selectedLocationId,
     required this.selectedLocationName,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<CitizenList> createState() => _CitizenListPageState();
}

class _CitizenListPageState extends State<CitizenList> {
  List<Map<String, dynamic>> storeData = [];
  int? selectedRowIndex;
  TextEditingController searchController = TextEditingController();
  ScrollController horizontalScroll = ScrollController();
  String searchQuery = '';

  int _currentPage = 0;
  final int _rowsPerPage = 10; // Number of rows per page

 
  final List<String> columnLabels = [
    'Reference',
    'Citizen Name',
    'NIC Number',
    'Address',
    'Contact Number',
    'Gender',
    'Relationship',
  ];

  @override
  void initState() {
    super.initState();
     _fetchCitizenData();
  }

  @override
  void dispose() {
    searchController.dispose();
    horizontalScroll.dispose();
    super.dispose();
  }

  Future<void> _fetchCitizenData() async {
    final url  = Uri.parse(
      'http://220.247.224.226:8401/CCSHubApi/api/MainApi/ListCitizenListRequested?username=${widget.citizenCode}&gnDivisionId=${widget.selectedLocationId}',
    );

    try{
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );
      if(response.statusCode == 200){
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['dataBundle'];

        setState(() {
          storeData = data.map<Map<String, dynamic>>((e) => {
          'Reference': e['CITIZEN_REFERENCE'] ?? '',
          'Citizen Name': e['CITIZEN_NAME'] ?? '',
          'NIC Number': e['NIC_NUMBER'] ?? '',
          'Address': e['CITIZEN_ADDRESS'] ?? '',
          'Contact Number': e['PRIMARY_CONTACT'] ?? '',
          'Gender': e['GENDER'] ?? '',
          'Relationship': e['RELATIONSHIP_TYPE'] ?? '',
          }).toList();
        });
      } else {
        throw Exception('Failed to load citizen data');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching data: $error')),
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
      body: Container(
        margin: EdgeInsets.all(screenWidth * 0.03),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Citizen List',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(thickness: 1, color: Colors.black38, indent: 20, endIndent: 20),
            SizedBox(height: screenHeight * 0.02),

            if (storeData.isNotEmpty) ...[
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search NIC',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenWidth * 0.035,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: const BorderSide(color: Colors.green, width: 2.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.015,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    storeData = storeData.where((data) {
                      return data['NIC Number']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;
                    }).toList();
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
            
            Expanded(
            child : Scrollbar(
              controller: horizontalScroll,
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 8.0,
              radius: const Radius.circular(4),
              scrollbarOrientation: ScrollbarOrientation.bottom,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: horizontalScroll,
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor: WidgetStateProperty.all(Colors.grey.shade300),
                  columns: [
                    ...columnLabels.map((label) => DataColumn(
                          label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                        )),
                    const DataColumn(label: Text("")),
                  ],
                  rows: storeData.isEmpty
                      ? [
                          DataRow(
                            cells: List.generate(
                              columnLabels.length + 1,
                              (_) => const DataCell(Text('-')),
                            ),
                          ),
                        ]
                      : List<DataRow>.generate(
                          storeData.length,
                          (index) {
                            final row = storeData[index];
                            final isSelected = selectedRowIndex == index;

                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  return isSelected
                                      ? const Color.fromARGB(255, 202, 241, 156)
                                      : null;
                                },
                              ),
                              cells: [
                                ...columnLabels.map((label) => DataCell(Text(row[label] ?? ''))),
                                DataCell(SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.description, size: 20),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CitizenListDescription(
                                                citizenData: row,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.download, size: 20),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.key, size: 20),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                              onSelectChanged: (_) {
                                setState(() {
                                  selectedRowIndex = index;
                                });
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
            ),
            if(storeData.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon : const Icon(Icons.arrow_back),
                  onPressed: _currentPage > 0 ? () {
                    setState(() {
                      _currentPage --;
                    });
                  } : null,
                ),
                Text ('Page ${_currentPage + 1} of ${((storeData.length - 1) / _rowsPerPage).ceil() + 1}'),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: (_currentPage + 1) * _rowsPerPage < storeData.length
                      ? () {
                    setState(() {
                      _currentPage++;
                    });
                  } : null,
                )
              ]
            )
          ],
        ),
      ),
      floatingActionButton: CustomFabMenu(
        menuItems: [
          HoverTapButton(
            icon: Icons.add,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddStoreData()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.edit,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditStoreData()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.view_list,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewCitizenListPage(accessToken: widget.accessToken, citizenCode: widget.citizenCode)), // Pass correct parameter names
              );
            },
          ),
          HoverTapButton(
            icon: Icons.download,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const DownloadDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
}
