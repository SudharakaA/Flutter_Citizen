import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/custom_app_bar.dart';
import '../../../component/rectangle_with_number.dart';
import '../../../component/document_button.dart';
import '../../../component/required_document_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NICInstructionPage extends StatefulWidget {
  final String requestTypeId;
  final String accessToken;
  final String citizenCode;
  final String title;

  const NICInstructionPage({
    super.key,
    required this.requestTypeId,
    required this.accessToken,
    required this.citizenCode,
    required this.title,
  });

  @override
  State<NICInstructionPage> createState() => _NICInstructionPageState();
}

class _NICInstructionPageState extends State<NICInstructionPage> {
  late Future<List<String>> _flowStepsFuture;

  @override
  void initState() {
    super.initState();
    _flowStepsFuture = fetchFlowSteps();
  }

  Future<List<String>> fetchFlowSteps() async {
    final String baseUrl = dotenv.env['GetAllSericesText'] ?? '';
    final String url = '$baseUrl?languageId=3';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.accessToken}'
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['isSuccess'] == true &&
          jsonResponse['dataBundle'] != null &&
          jsonResponse['dataBundle']['flows'] != null) {
        final List<dynamic> flowSteps = jsonResponse['dataBundle']['flows'];

        // Filter by REQUEST_TYPE_ID
        final filteredFlows = flowSteps
            .where((flow) =>
                flow['REQUEST_TYPE_ID'].toString() == widget.requestTypeId)
            .toList();

        filteredFlows.sort((a, b) =>
            int.parse(a['SEQUENCE_ID']) - int.parse(b['SEQUENCE_ID']));

        return filteredFlows
            .map<String>(
                (flow) => (flow['VIEW_NAME_TEXT'] ?? '').toString().trim())
            .toList();
      } else {
        throw Exception('Invalid data in response');
      }
    } else {
      throw Exception('Failed to load flow instructions');
    }
  }

  Future<List<String>> fetchRequiredDocuments() async {
    const String url =
        'http://220.247.224.226:8401/CCSHubApi/api/MainApi/GetAllSericesText?languageId=3';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.accessToken}'
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['isSuccess'] == true &&
          jsonResponse['dataBundle'] != null &&
          jsonResponse['dataBundle']['documents'] != null) {
        final List<dynamic> documentsList =
            jsonResponse['dataBundle']['documents'];

        final filteredDocs = documentsList
            .where((doc) =>
                doc['REQUEST_TYPE_ID'].toString() == widget.requestTypeId)
            .toList();

        return filteredDocs
            .map<String>(
                (doc) => (doc['DOCUMENT_NAME'] ?? '').toString().trim())
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load required documents');
    }
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
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(
                thickness: 1, color: Colors.black38, indent: 20, endIndent: 20),
            Expanded(
                child: FutureBuilder<List<String>>(
                    future: _flowStepsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("No instructions available."));
                      }

                      final steps = snapshot.data!;
                      return SingleChildScrollView(
                          child: Column(children: [
                        ...steps.asMap().entries.map(
                              (entry) => DetailRectangleWithNumber(
                                number: entry.key + 1,
                                text: entry.value,
                                fontSize: 14,
                              ),
                            ),
                        const SizedBox(height: 20),
                        Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                            ),
                            child: CustomButton(
                              buttonText: "Required Documents",
                              onPressed: () async {
                                List<String> documents = [];
                                try {
                                  documents = await fetchRequiredDocuments();
                                } catch (_) {
                                  documents = [];
                                }
                                // Show dialog with documents or empty if none
                                showDialog(
                                  context: context,
                                  builder: (context) => RequiredDocumentsDialog(
                                    documents: documents,
                                  ),
                                );
                              },
                            ))
                      ]));
                    })),
          ],
        ),
      ),
    );
  }
}
