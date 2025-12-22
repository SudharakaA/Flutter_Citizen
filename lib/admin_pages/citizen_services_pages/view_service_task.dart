import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../component/request_service/dropdown_selector.dart';
import '../../component/request_service/date_picker_field.dart';
import '../../component/request_service/action_button.dart';
import '../../component/request_service/multi_select_dialog.dart';
import '../../component/custom_back_button.dart';
import '../../component/custom_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class ServicePage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const ServicePage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List<String> selectedServices = [];
  String? selectedServiceStatus;
  DateTime? startDate;
  DateTime? endDate;
  List<Map<String, dynamic>> availableServices = [];
  final List<String> serviceStatuses = ['Request Pending', 'Request Completed', 'Request Rejected'];
  bool isLoadingServices = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    final String baseUrl = dotenv.env['SubjectOfficerRequestTypesRequested'] ?? '';
    final String fetchUrl = '$baseUrl?languageId=3';

    setState(() {
      isLoadingServices = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(fetchUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['isSuccess'] == true) {
          final List<dynamic> dataBundle = jsonResponse['dataBundle'] ?? [];
          setState(() {
            availableServices = dataBundle.map((item) {
              return {
                'id': item['REQUEST_TYPE_ID'].toString(),
                'name': item['REQUEST_TYPE_TEXT']?.toString() ?? 'Unknown',
              };
            }).toList()
              ..sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
            isLoadingServices = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('services_fetched_success'.tr()),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          setState(() {
            isLoadingServices = false;
            errorMessage = jsonResponse['errorMessage'] ?? 'failed_to_fetch_services'.tr();
          });
        }
      } else {
        setState(() {
          isLoadingServices = false;
          errorMessage = 'failed_to_fetch_services'.tr();
        });
      }
    } catch (e) {
      setState(() {
        isLoadingServices = false;
        errorMessage = '${'error_fetching_services'.tr()} $e';
      });
    }
  }

  Future<void> _submitRequest() async {
    final String baseUrl = dotenv.env['ServiceRequestListRequested'] ?? '';
    final String submitUrl = baseUrl;

    setState(() {
      isLoadingServices = true;
    });

    try {
      final body = jsonEncode({
        "requestTypeIdList": selectedServices,
        "requestStatus": selectedServiceStatus,
        "startDate": startDate!.toIso8601String().split('T')[0],
        "endDate": endDate!.toIso8601String().split('T')[0],
        "citizenCode": widget.citizenCode,
      });

      final response = await http.post(
        Uri.parse(submitUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('request_submitted_success'.tr()),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        Navigator.pop(context, {
          'selectedServiceType': selectedServices,
          'selectedRequestType': selectedServiceStatus,
          'startDate': startDate,
          'endDate': endDate,
          'citizenCode': widget.citizenCode,
        });
      } else {
        _showValidationError(context, 'failed_submit_request'.tr());
      }
    } catch (e) {
      _showValidationError(context, '${'error_submit_request'.tr()} $e');
    } finally {
      setState(() {
        isLoadingServices = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      appBar: const CustomAppBarWidget(
        leading: CustomBackButton(),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Column(
                children: [
                  Center(
                    child: Text(
                      'citizen_services'.tr(),
                      style: GoogleFonts.inter(
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

              const SizedBox(height: 16),

              // Service Dropdown
              Center(
                child: Text(
                  'select_service'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              isLoadingServices
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(
                          child: Column(
                            children: [
                              Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _fetchServices,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : DropdownSelector(
                          hintText: selectedServices.isEmpty
                              ? 'nothing_selected'.tr()
                              : '${selectedServices.length} ${'services_selected'.tr()}',
                          onTap: () => _showServicesDialog(context),
                          hasSelection: selectedServices.isNotEmpty,
                        ),
              const SizedBox(height: 24),

              // Service Status Dropdown
              Center(
                child: Text(
                  'select_service_status'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DropdownSelector(
                hintText: selectedServiceStatus ?? 'select_status'.tr(),
                onTap: () => _showServiceStatusDialog(context),
                hasSelection: selectedServiceStatus != null,
              ),
              const SizedBox(height: 24),

              // Time Period Section
              Center(
                child: Text(
                  'select_time_period'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Start Date
              DatePickerField(
                label: 'from'.tr(),
                selectedDate: startDate,
                onDateSelected: (date) {
                  setState(() {
                    startDate = date;
                  });
                },
              ),
              const SizedBox(height: 16),

              // End Date
              DatePickerField(
                label: 'to'.tr(),
                selectedDate: endDate,
                onDateSelected: (date) {
                  setState(() {
                    endDate = date;
                  });
                },
              ),
              const SizedBox(height: 32),

              // View Task Button
              Center(
                child: ActionButton(
                  text: 'view_task'.tr(),
                  icon: Icons.description,
                  onPressed: () {
                    if (selectedServices.isEmpty) {
                      _showValidationError(context, 'please_select_service'.tr());
                    } else if (selectedServiceStatus == null) {
                      _showValidationError(context, 'please_select_service_status'.tr());
                    } else if (startDate == null) {
                      _showValidationError(context, 'please_select_start_date'.tr());
                    } else if (endDate == null) {
                      _showValidationError(context, 'please_select_end_date'.tr());
                    } else if (endDate!.isBefore(startDate!)) {
                      _showValidationError(context, 'end_date_before_start'.tr());
                    } else {
                      _submitRequest();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showValidationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showServicesDialog(BuildContext context) async {
    if (availableServices.isEmpty) {
      _showValidationError(context, 'no_services_available'.tr());
      return;
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: availableServices.map((e) => e['name'] as String).toList(),
          initialSelection: selectedServices
              .map((id) {
                final service = availableServices.firstWhere((service) => service['id'] == id, orElse: () => {'name': 'Unknown'});
                return service['name'] as String;
              })
              .toList(),
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedServices = newSelection
                  .map((name) => availableServices
                      .firstWhere((service) => service['name'] == name, orElse: () => {'id': '0'})['id']
                      .toString())
                  .toList();
            });
          },
        );
      },
    );
  }

  Future<void> _showServiceStatusDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('select_service_status'.tr()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: serviceStatuses
                  .map((status) => ListTile(
                        title: Text(status),
                        onTap: () {
                          setState(() {
                            selectedServiceStatus = status;
                          });
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr()),
            ),
          ],
        );
      },
    );
  }
}