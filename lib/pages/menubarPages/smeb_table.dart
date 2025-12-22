import 'package:citizen_care_system/pages/menubarPages/smeb_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';

class SmebTable extends StatefulWidget {
  final String citizenCode;
  final String accessToken;

  const SmebTable({
    super.key,
    required this.citizenCode,
    required this.accessToken,
  });

  @override
  State<SmebTable> createState() => _SmebTableState();
}

class _SmebTableState extends State<SmebTable> {
  List<Map<String, dynamic>> CitizenSMEDataListRequested =
      []; // Changed to support list
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchBusinessDetails();
  }

  Future<void> _fetchBusinessDetails() async {
    final String baseUrl = dotenv.env['CitizenSMEDataListRequested'] ?? '';
    final String url = '$baseUrl?citizenCode=${widget.citizenCode}';

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final body = jsonEncode({
        "citizenCode": widget.citizenCode,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final dynamic data = responseData['dataBundle'];
        setState(() {
          if (data is List) {
            CitizenSMEDataListRequested = data.cast<Map<String, dynamic>>();
          } else if (data is Map<String, dynamic>) {
            CitizenSMEDataListRequested = [data];
          } else {
            CitizenSMEDataListRequested = [];
          }
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to fetch business details: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching business details: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'SME Business List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 5),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _fetchBusinessDetails,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : CitizenSMEDataListRequested.isEmpty
                            ? const Center(
                                child: Text(
                                  'No business details found.',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                itemCount: CitizenSMEDataListRequested.length,
                                itemBuilder: (context, index) {
                                  final business =
                                      CitizenSMEDataListRequested[index];
                                  return ListTile(
                                    title: Text(
                                      business['BUSINESS_NAME']?.toString() ??
                                          'N/A',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Reg No: ${business['REGISTRATION_NUMBER']?.toString() ?? 'N/A'}',
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SmebDetailView(
                                            businessDetails: business,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
