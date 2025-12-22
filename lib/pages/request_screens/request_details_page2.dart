import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/admin_circle_menu/fab_menu.dart';
import '../../../component/admin_circle_menu/hover_tap_button.dart';

class RequestDetailPage extends StatelessWidget {
  final Map<String, dynamic> requestDetails;

  const RequestDetailPage({
    super.key,
    required this.requestDetails,
  });

  // Placeholder function for downloading as PDF
  Future<void> _downloadAsPdf(BuildContext context) async {
    // TODO: Implement PDF generation using a package like 'pdf'
    // Example: Create a PDF document with requestDetails and save it
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF download functionality to be implemented'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Placeholder function for downloading as SVG
  Future<void> _downloadAsSvg(BuildContext context) async {
    // TODO: Implement SVG generation using a package like 'flutter_svg'
    // Example: Create an SVG representation of requestDetails and save it
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('SVG download functionality to be implemented'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Placeholder function for downloading as Excel
  Future<void> _downloadAsExcel(BuildContext context) async {
    // TODO: Implement Excel generation using a package like 'excel'
    // Example: Create an Excel file with requestDetails and save it
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Excel download functionality to be implemented'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Function to copy request details to clipboard
  Future<void> _copyToClipboard(BuildContext context) async {
    final detailsString = '''
Request Reference: ${requestDetails['REQUEST_REFERENCE']?.toString() ?? 'N/A'}
Category: ${requestDetails['REQUEST_TYPE']?.toString() ?? 'Unknown Service'}
Created Date: ${requestDetails['CREATED_DTM']?.toString() ?? 'N/A'}
Citizen: ${requestDetails['CITIZEN_NAME']?.toString() ?? 'N/A'}
Assigned Date: ${requestDetails['ASSIGNED_DTM']?.toString() ?? 'N/A'}
Service Status: ${requestDetails['FLOW_NAME']?.toString() ?? 'None'}
''';
    await Clipboard.setData(ClipboardData(text: detailsString));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request details copied to clipboard'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
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
      floatingActionButton: CustomFabMenu(
        menuItems: [
          HoverTapButton(
            icon: Icons.picture_as_pdf,
            onTap: () => _downloadAsPdf(context),
          ),
          HoverTapButton(
            icon: Icons.image,
            onTap: () => _downloadAsSvg(context),
          ),
          HoverTapButton(
            icon: Icons.table_chart,
            onTap: () => _downloadAsExcel(context),
          ),
          HoverTapButton(
            icon: Icons.copy,
            onTap: () => _copyToClipboard(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            top: screenHeight * 0.02,
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request Details',
                  style: GoogleFonts.inter(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black38,
                  indent: screenWidth * 0.05,
                  endIndent: screenWidth * 0.05,
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildDetailRow(context, 'Reference No', requestDetails['REQUEST_REFERENCE']?.toString() ?? 'N/A'),
                SizedBox(height: screenHeight * 0.02),
                _buildDetailRow(context, 'Category', requestDetails['REQUEST_TYPE']?.toString() ?? 'Unknown Service'),
                SizedBox(height: screenHeight * 0.02),
                _buildDetailRow(context, 'Created Date', requestDetails['CREATED_DTM']?.toString() ?? 'N/A'),
                SizedBox(height: screenHeight * 0.02),
                _buildDetailRow(context, 'Citizen', requestDetails['CITIZEN_NAME']?.toString() ?? 'N/A'),
                SizedBox(height: screenHeight * 0.02),
                _buildDetailRow(context, 'Assigned Date', requestDetails['ASSIGNED_DTM']?.toString() ?? 'N/A'),
                SizedBox(height: screenHeight * 0.02),
                _buildDetailRow(context, 'Service Status', requestDetails['FLOW_NAME']?.toString() ?? 'None'),
                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {Color? statusColor}) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$label:',
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              if (statusColor != null) ...[
                Container(
                  width: screenWidth * 0.03,
                  height: screenWidth * 0.03,
                  margin: EdgeInsets.only(right: screenWidth * 0.02),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor,
                  ),
                ),
              ],
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: screenWidth * 0.035,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}