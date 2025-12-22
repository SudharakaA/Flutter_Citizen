import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

import '../../component/request_service/search_bar.dart';
import '../../component/request_service/service_list.dart';
import '../../component/request_service/download_section.dart';
import 'request_details_page2.dart';
import '../../../component/custom_back_button.dart';
import '../../../component/custom_app_bar.dart';

class ServiceDetailsPage extends StatefulWidget {
  final List<String> selectedServices;
  final DateTime startDate;
  final DateTime endDate;
  final String citizenCode;
  final String accessToken;

  const ServiceDetailsPage({
    super.key,
    required this.selectedServices,
    required this.startDate,
    required this.endDate,
    required this.citizenCode,
    required this.accessToken,
  });

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  List<Map<String, dynamic>> requestData = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final body = jsonEncode({
        "requestTypeIdList": widget.selectedServices,
        "startDate": widget.startDate.toIso8601String().split('T')[0],
        "endDate": widget.endDate.toIso8601String().split('T')[0],
        "citizenCode": widget.citizenCode,
      });

      final response = await http.post(
        Uri.parse(
            'http://220.247.224.226:8401/CCSHubApi/api/MainApi/ServiceRequestListRequested'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['dataBundle'] ?? [];
        setState(() {
          requestData = data.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        setState(() {
          errorMessage = 'errorr.fetch_failed'.tr(args: [response.statusCode.toString()]);
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'errorr.fetch_exception'.tr(args: [e.toString()]);
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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'service_details.my_requests'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const SearchBarWidget(),
                const SizedBox(height: 20),
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
                          onPressed: _fetchRequests,
                          child: Text('common.retry'.tr()),
                        ),
                      ],
                    ),
                  )
                      : ServiceListWidget(
                    requestData: requestData,
                    onItemTap: (requestDetails) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestDetailPage(
                            requestDetails: requestDetails,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const DownloadSectionWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}