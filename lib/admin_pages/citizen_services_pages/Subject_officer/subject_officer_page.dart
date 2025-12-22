import 'package:citizen_care_system/admin _component/citizen_service_task/download_dialog.dart';
import 'package:citizen_care_system/component/admin_circle_menu/fab_menu.dart';
import 'package:citizen_care_system/component/admin_circle_menu/hover_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/custom_back_button.dart';
import '../Subject_officer/add_new_service_details.dart';
import 'package:citizen_care_system/admin_pages/citizen_services_pages/view_service_task.dart';
import 'package:easy_localization/easy_localization.dart';

class SubjectOfficerPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;
  final List<String>? selectedServiceType;
  final String? selectedRequestType;
  final DateTime? startDate;
  final DateTime? endDate;

  const SubjectOfficerPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
    this.selectedServiceType,
    this.selectedRequestType,
    this.startDate,
    this.endDate,
  });

  @override
  State<SubjectOfficerPage> createState() => _SubjectOfficerPageState();
}

class _SubjectOfficerPageState extends State<SubjectOfficerPage> {
  final List<String> columnLabels = [
    'Reference',
    'Created',
    'Citizen',
    'Assign Type',
    'Assign To',
    'Assigned Date',
    'Service Status',
    'Actions',
  ];

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateToViewPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicePage(
          accessToken: widget.accessToken,
          citizenCode: widget.citizenCode,
        ),
      ),
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectOfficerPage(
              accessToken: widget.accessToken,
              citizenCode: widget.citizenCode,
              selectedServiceType: result['selectedServiceType'],
              selectedRequestType: result['selectedRequestType'],
              startDate: result['startDate'],
              endDate: result['endDate'],
            ),
          ),
        );
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
              'citizen_services'.tr(),
              style: GoogleFonts.inter(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
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
            Expanded(
              child: _buildContent(screenWidth, screenHeight),
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
                MaterialPageRoute(builder: (context) => const AddServiceDetailsPage()),
              );
            },
          ),
          HoverTapButton(
            icon: Icons.view_list,
            onTap: _navigateToViewPage,
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

  Widget _buildContent(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade300),
        columns: columnLabels
            .map((label) => DataColumn(
                  label: Text(
                    label.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ))
            .toList(),
        rows: const [], // Empty rows since no data is fetched
      ),
    );
  }
}