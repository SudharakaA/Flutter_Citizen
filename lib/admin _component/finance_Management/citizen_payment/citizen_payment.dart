import 'package:flutter/material.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/admin_circle_menu/fab_menu.dart';
import '../../../component/admin_circle_menu/hover_tap_button.dart';
import '../citizen_payment/add_citizen_payment.dart';
import '../../../admin _component/citizen_service_task/download_dialog.dart';
import '../citizen_payment/view_citizen_payment.dart';

class CitizenPaymentPage extends StatefulWidget {
  final String? selectedLocations;
  final List<String>? selectedHeaderNames;
  final DateTime? startDate;
  final DateTime? endDate;

  const CitizenPaymentPage({
    super.key,
    this.selectedLocations,
    this.selectedHeaderNames,
    this.startDate,
    this.endDate,
  });

  @override
  State<CitizenPaymentPage> createState() => _CitizenPaymentPageState();
}

class _CitizenPaymentPageState extends State<CitizenPaymentPage> {
  List<Map<String, dynamic>> storeData = [];
  int? selectedRowIndex;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  List<Map<String, dynamic>> dummyStoreData = [
    {
      'citizenName': 'Sarath Kumara',
      'nic': '123456789V',
      'gNDivision': 'Thamankaduwa',
      'headerName': 'Written test fees - 2025-02-10',
      'location': 'Thamankaduwa - DS Office',
      'createdAt': '2025-05-01',
      'createdBy': 'Admin A',
      'amount': 100,
      'updatedAt': '2025-01-01',
    },
    {
      'citizenName': 'Akila Perera',
      'nic': '56321479V',
      'gNDivision': 'Higurakgoda',
      'headerName': 'Written test fees - 2025-02-10',
      'location': 'Higurakgoda - DS Office',
      'createdAt': '2025-06-05',
      'createdBy': 'Admin A',
      'amount': 150,
      'updatedAt': '2025-01-01',
    },
    {
      'citizenName': 'Supun Perera',
      'nic': '856321479V',
      'gNDivision': 'Higurakgoda',
      'headerName': 'Written test fees - 2025-02-10',
      'location': 'Higurakgoda - DS Office',
      'createdAt': '2025-07-01',
      'createdBy': 'Admin A',
      'amount': 200,
      'updatedAt': '2025-01-01',
    },
  ];

  final List<String> columnLabels = [
    'Citizen Name',
    'NIC Number',
    'GN Division',
    'Reason of Payment',
    'Head No',
    'Amount',
    '',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.selectedLocations != null ||
        widget.selectedHeaderNames != null ||
        widget.startDate != null ||
        widget.endDate != null) {
      _filterData();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterData() {
    final filtered = dummyStoreData.where((data) {
      final matchesLocation = widget.selectedLocations == null ||
          widget.selectedLocations == data['location'];

      final matchesType = widget.selectedHeaderNames == null ||
          widget.selectedHeaderNames!.contains(data['headerName']);

      final createdAt = DateTime.tryParse(data['createdAt']);
      final matchesStartDate = widget.startDate == null ||
          (createdAt != null &&
              createdAt.isAfter(
                  widget.startDate!.subtract(const Duration(days: 1))));
      final matchesEndDate = widget.endDate == null ||
          (createdAt != null &&
              createdAt.isBefore(widget.endDate!.add(const Duration(days: 1))));

      final matchesSearch = searchQuery.isEmpty ||
          data.values.any((value) => value
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()));

      return matchesLocation &&
          matchesType &&
          matchesStartDate &&
          matchesEndDate &&
          matchesSearch;
    }).toList();

    setState(() {
      storeData = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      body: Container(
          margin: EdgeInsets.all(screenWidth * 0.03),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
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
                "Citizen Payment",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const Divider(
                thickness: 1,
                color: Colors.black38,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(height: screenHeight * 0.02),
              // Search Bar - Only visible when storeData is not empty
              if (storeData.isNotEmpty) ...[
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
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
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.015),
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

              // Data Table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor:
                      WidgetStateProperty.all(Colors.grey.shade300),
                  columns: columnLabels
                      .map((label) => DataColumn(
                            label: Text(label,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ))
                      .toList(),
                  rows: storeData.isEmpty
                      ? [
                          DataRow(
                              cells: List.generate(
                            columnLabels.length,
                            (_) => const DataCell(Text('-')),
                          ))
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
                                DataCell(Text(row['citizenName'] ?? '')),
                                DataCell(Text(row['nic'] ?? '')),
                                DataCell(Text(row['gNDivision'] ?? '')),
                                DataCell(Text(row['headerName'] ?? '')),
                                DataCell(Text(row['createdAt'] ?? '')),
                                DataCell(Text(row['amount']?.toString() ?? '')),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.description),
                                      onPressed: () {
                                        // Handle Edit
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.print),
                                      onPressed: () {
                                        // Handle Print
                                      },
                                    ),
                                  ],
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
            ],
          )),
      floatingActionButton: CustomFabMenu(
        menuItems: [
          HoverTapButton(
            icon: Icons.add,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddCitizenPaymentPage()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.view_list,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewCitizenPaymentPage()),
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
          )
        ],
      ),
    );
  }
}
