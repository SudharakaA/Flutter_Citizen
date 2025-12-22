import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../component/custom_back_button.dart';
import '../../component/expandable_help_section.dart';
import '../noticesPages/second_layout/gov_news_details.dart';
import '../../component/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GovernmentNewsPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const GovernmentNewsPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<GovernmentNewsPage> createState() => _GovernmentNewsPageState();
}

class _GovernmentNewsPageState extends State<GovernmentNewsPage> {
  late Future<List<Map<String, dynamic>>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = fetchNews();
  }

  Future<List<Map<String, dynamic>>> fetchNews() async {
    final String baseUrl = dotenv.env['GetAllCCSDocuments_URL'] ?? '';
    final String url =
        '$baseUrl?documetType=Government Notices&languageId=3&gnDivisionId=3';
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.accessToken}'
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['isSuccess'] == true &&
          jsonResponse['dataBundle'] != null &&
          jsonResponse['dataBundle']['documentTypes'] != null) {
        List docs = jsonResponse['dataBundle']['documentTypes'];

        return docs
            .map<Map<String, dynamic>>((doc) => {
                  'name': doc['DOCUMENT_NAME'] ?? '',
                  'text': doc['DOCUMENT_TEXT'] ?? '',
                })
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('failed_to_load_gov_news_data'.tr());
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'government_news'.tr(),
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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _newsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'error_loading_gov_news'
                            .tr(args: [snapshot.error.toString()]),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('no_gov_news_docs_found'.tr()),
                    );
                  }

                  final List<Map<String, dynamic>> documents = snapshot.data!;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ExpandableHelpSection(
                          title: 'government_news'.tr(),
                          items: documents
                              .map((doc) => doc['name'] as String)
                              .toList(),
                          onItemTap: (selectedItem) {
                            final doc = documents.firstWhere(
                                (element) => element['name'] == selectedItem,
                                orElse: () => {'text': ''});

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GovNewsSupportDetailPage(
                                  itemTitle: selectedItem,
                                  itemText: doc['text'] ?? '',
                                  accessToken: widget.accessToken,
                                  citizenCode: widget.citizenCode,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
