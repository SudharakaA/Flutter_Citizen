import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/custom_rounded_rectangle.dart';
import '../../../component/custom_app_bar.dart';
import '../instructionServicesPages/welfare_instruction_page.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

class WelfareServicePage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const WelfareServicePage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<WelfareServicePage> createState() => _WelfareServicePageState();
}

class _WelfareServicePageState extends State<WelfareServicePage> {
  late Future<List<Map<String, dynamic>>> _welfareServiceFuture;

  @override
  void initState() {
    super.initState();
    _welfareServiceFuture = fetchWelfareService();
  }

  Future<List<Map<String, dynamic>>> fetchWelfareService() async {
    final String baseUrl = dotenv.env['GetAllSericesText'] ?? '';
    final String url = '$baseUrl?languageId=3';
    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.accessToken}'
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['isSuccess'] == true &&
          jsonResponse['dataBundle'] != null &&
          jsonResponse['dataBundle']['types'] != null) {
        final List<dynamic> services = jsonResponse['dataBundle']['types'];

        //filter by REQUEST_TYPE_ID
        final filtered = services
            .where((item) {
              final id = item['REQUEST_TYPE_ID'].toString();
              return id == '30' ||
                  id == '31' ||
                  id == '32' ||
                  id == '33' ||
                  id == '34' ||
                  id == '35' ||
                  id == '36' ||
                  id == '37' ||
                  id == '38' ||
                  id == '39';
            })
            .cast<Map<String, dynamic>>()
            .toList();

        return filtered;
      } else {
        throw Exception('invalid_data_response'.tr());
      }
    } else {
      throw Exception('failed_welfare_services'.tr());
    }
  }

  void navigateToInstructions(
      BuildContext context, Map<String, dynamic> service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WelfareInstructionPage(
          requestTypeId: service['REQUEST_TYPE_ID'].toString(),
          accessToken: widget.accessToken,
          citizenCode: widget.citizenCode,
          title: service['REQUEST_TYPE_TEXT'] ?? 'Service',
        ),
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
              'welfare_and_social_assistance'.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(
                thickness: 1, color: Colors.black38, indent: 20, endIndent: 20),
            Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _welfareServiceFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No services available.'));
                      }

                      final services = snapshot.data!;
                      return ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          final title =
                              service['REQUEST_TYPE_TEXT'] ?? 'Unknown';
                          return CustomRoundedRectangle(
                            title: title,
                            onTap: () =>
                                navigateToInstructions(context, service),
                          );
                        },
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
