import 'package:citizen_care_system/admin%20_component/citizen_service_task/download_dialog.dart';
import 'package:citizen_care_system/admin%20_component/store_admin/add_new_store_data.dart';
import 'package:citizen_care_system/admin%20_component/store_admin/edit_store_data.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/citizen_user_request/view_citizen_user_request.dart';
import 'package:citizen_care_system/component/admin_circle_menu/fab_menu.dart';
import 'package:citizen_care_system/component/admin_circle_menu/hover_tap_button.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CitizenUserRequest extends StatefulWidget {
  final List<String>? selectedLocations;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedStatus;

  const CitizenUserRequest({
    super.key,
    this.selectedLocations,
    this.startDate,
    this.endDate,
    this.selectedStatus,
  });

  @override
  State<CitizenUserRequest> createState() => _CitizenUserRequestPageState();
}

class _CitizenUserRequestPageState extends State<CitizenUserRequest> {
  List<Map<String, dynamic>> storeData = [];
  int? selectedRowIndex;
  TextEditingController searchController = TextEditingController();
  ScrollController horizontalScroll = ScrollController();
  String searchQuery = '';

  List<Map<String, dynamic>> dummyStoreData = [
    {
      'Reference': 'P/TK/156/1/010487',
      'Created': '2024-10-01',
      'Location': 'Bendiwewa - GN Office',
      'Citizen Name': 'ඉංදික ගුණරත්න',
      'NIC Number': '813214172V',
      'Address': '1, නිකවැව ,නිකවැව',
      'Contact Number': '072-5861240',
      'Current Status': 'Pending'
    },
    {
      'Reference': 'P/TK/156/09/010516',
      'Created': '2024-11-01',
      'Location': 'Bendiwewa - GN Office',
      'Citizen Name': 'ඇල්පිටියේ ගෙදර චමිලා මෙලනි',
      'NIC Number': '613214172V',
      'Address': '1, නිකවැව ,නිකවැව',
      'Contact Number': '072-5861240',
      'Current Status': 'Approved'
    },
    {
      'Reference': 'P/TK/156/09/010516',
      'Created': '2024-12-01',
      'Location': 'Samudragama - GN Office',
      'Citizen Name': 'විතාරන ගෙදර ප්‍රියංගනී',
      'NIC Number': '813214172V',
      'Address': '1, නිකවැව ,නිකවැව',
      'Contact Number': '072-5861240',
      'Current Status': 'Approved'
    },
  ];

  final List<String> columnLabels = [
    'Reference',
    'Created',
    'Location',
    'Citizen Name',
    'NIC Number',
    'Address',
    'Contact Number',
    'Current Status',
  ];

  @override
  void initState() {
    super.initState();
    _filterData();
  }

  @override
  void dispose() {
    searchController.dispose();
    horizontalScroll.dispose();
    super.dispose();
  }

  void _filterData() {
    if ((widget.selectedLocations == null || widget.selectedLocations!.isEmpty) &&
        widget.startDate == null &&
        widget.endDate == null &&
        widget.selectedStatus == null &&
        searchQuery.isEmpty) {
      storeData = [];
      return;
    }

    storeData = dummyStoreData.where((data) {
      final matchesLocation = widget.selectedLocations == null ||
          widget.selectedLocations!.contains(data['Location']);

      final createdAt = DateTime.tryParse(data['Created']);
      final matchesStartDate = widget.startDate == null ||
          (createdAt != null && createdAt.isAfter(widget.startDate!.subtract(const Duration(days: 1))));
      final matchesEndDate = widget.endDate == null ||
          (createdAt != null && createdAt.isBefore(widget.endDate!.add(const Duration(days: 1))));

      final matchesStatus = widget.selectedStatus == null ||
          widget.selectedStatus == data['Current Status'];

      final matchesSearch = searchQuery.isEmpty ||
          (data['NIC Number']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

      return matchesLocation && matchesStartDate && matchesEndDate && matchesStatus && matchesSearch;
    }).toList();
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
              'Citizen User Request',
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
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _filterData();
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.03),
            ],

            Scrollbar(
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
                                        onPressed: () {},
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
                  builder: (context) => const ViewCitizenUserRequest(selectedLocations: []),
                ),
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
