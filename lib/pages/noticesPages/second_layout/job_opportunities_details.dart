import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/details_rectangle.dart';
import '../../../component/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobSupportDetailPage extends StatefulWidget {
  final String itemTitle;
  final String itemText;
  final String accessToken;
  final String citizenCode;

  const JobSupportDetailPage({
    super.key,
    required this.itemTitle,
    required this.itemText,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<JobSupportDetailPage> createState() => _JobSupportDetailPageState();
}

class _JobSupportDetailPageState extends State<JobSupportDetailPage> {
  late Future<Map<String, dynamic>?> _documentFuture;

  @override
  void initState() {
    super.initState();
    _documentFuture = fetchDocumentByTitle(widget.itemTitle);
  }

  Future<Map<String, dynamic>?> fetchDocumentByTitle(String title) async {
    final String baseUrl = dotenv.env['GetAllCCSDocuments_URL'] ?? '';
    final String url =
        '$baseUrl?documetType=Careers&languageId=3&gnDivisionId=3';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['isSuccess'] == true &&
          jsonResponse['dataBundle'] != null) {
        List docs = jsonResponse['dataBundle']['documentTypes'] ?? [];
        List managementData =
            jsonResponse['dataBundle']['managementData'] ?? [];

        final matchingDoc = docs.firstWhere(
          (doc) => doc['DOCUMENT_NAME'] == title,
          orElse: () => {},
        );

        final relatedManagementData = managementData.where((entry) {
          return entry['DOCUMENT_NAME'] == title ||
              entry['CCS_DOCUMENT_ID'] == matchingDoc['CCS_DOCUMENT_ID'];
        }).toList();

        return {
          'document': matchingDoc,
          'services': relatedManagementData,
        };
      }
    }

    return null;
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
        width: double.infinity,
        height: double.infinity,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.itemTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.black38,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>?>(
                future: _documentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'error_loading_services'
                            .tr(args: [snapshot.error.toString()]),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final services =
                      snapshot.data?['services'] as List<dynamic>? ?? [];

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (services.isNotEmpty)
                          ...services.map((service) {
                            return DetailRectangle(
                              child: Text(
                                service['SOME_KEY'] ??
                                    'service_detail_not_specified'.tr(),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          })
                        else
                          DetailRectangle(
                            child: Text(
                              'no_news_available'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
