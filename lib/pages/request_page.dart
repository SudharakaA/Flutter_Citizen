import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../component/request_service/dropdown_selector.dart';
import '../component/request_service/date_picker_field.dart';
import '../component/request_service/action_button.dart';
import '../component/request_service/multi_select_dialog.dart';
import 'request_screens/request_details_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class RequestPage extends StatefulWidget {
  final String accessToken;
  final String citizenCode;

  const RequestPage({
    super.key,
    required this.accessToken,
    required this.citizenCode,
  });

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage>
    with SingleTickerProviderStateMixin {
  List<String> selectedServices = [];
  List<Map<String, dynamic>> availableServices = [];
  DateTime? startDate;
  DateTime? endDate;
  late AnimationController _animationController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _fetchServices();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchServices() async {
    final String baseUrl = dotenv.env['AllRequestTextsRequested'] ?? '';
    final String fetchUrl = '$baseUrl?languageId=3';

    setState(() {
      isLoading = true;
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
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['dataBundle'] ?? [];
        setState(() {
          availableServices = data.map((item) {
            return {
              'id': item['REQUEST_TYPE_ID'].toString(),
              'name': item['REQUEST_TYPE_TEXT'].toString(),
            };
          }).toList();
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
        _showValidationError(context, 'failed_to_fetch_services'.tr());
      }
    } catch (e) {
      _showValidationError(context, '${'error_fetching_services'.tr()} $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _submitRequest() async {
    final String baseUrl = dotenv.env['ServiceRequestListRequested'] ?? '';
    final String submitUrl = baseUrl;
    setState(() {
      isLoading = true;
    });

    try {
      final body = jsonEncode({
        "requestTypeIdList": selectedServices,
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsPage(
              selectedServices: selectedServices,
              startDate: startDate!,
              endDate: endDate!,
              citizenCode: widget.citizenCode,
              accessToken: widget.accessToken,
            ),
          ),
        );
      } else {
        _showValidationError(context, 'failed_submit_request'.tr());
      }
    } catch (e) {
      _showValidationError(context, '${'error_submit_request'.tr()} $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF80AF81),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            top: screenHeight * 0.02,
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'my_requests'.tr(),
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.black38,
                indent: screenWidth * 0.05,
                endIndent: screenWidth * 0.05,
              ),
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor: MaterialStateProperty.all(
                          const Color(0xFF1A5319)),
                      thickness: MaterialStateProperty.all(8.0),
                      radius: const Radius.circular(10),
                    ),
                  ),
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    interactive: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'select_service'.tr(),
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          DropdownSelector(
                            hintText: selectedServices.isEmpty
                                ? 'nothing_selected'.tr()
                                : '${selectedServices.length} ${'services_selected'.tr()}',
                            onTap: () => _showServicesDialog(context),
                            hasSelection: selectedServices.isNotEmpty,
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          Text(
                            'select_time_period'.tr(),
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          DatePickerField(
                            label: 'from'.tr(),
                            selectedDate: startDate,
                            onDateSelected: (date) {
                              setState(() {
                                startDate = date;
                              });
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          DatePickerField(
                            label: 'to'.tr(),
                            selectedDate: endDate,
                            onDateSelected: (date) {
                              setState(() {
                                endDate = date;
                              });
                            },
                          ),
                          SizedBox(height: screenHeight * 0.01),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              ActionButton(
                text: 'view_task'.tr(),
                onPressed: () {
                  if (selectedServices.isEmpty) {
                    _showValidationError(
                        context, 'please_select_service'.tr());
                  } else if (startDate == null) {
                    _showValidationError(
                        context, 'please_select_start_date'.tr());
                  } else if (endDate == null) {
                    _showValidationError(
                        context, 'please_select_end_date'.tr());
                  } else if (endDate!.isBefore(startDate!)) {
                    _showValidationError(
                        context, 'end_date_before_start'.tr());
                  } else {
                    _submitRequest();
                  }
                },
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
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: availableServices.map((e) => e['name'].toString()).toList(),
          initialSelection: selectedServices,
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedServices = newSelection
                  .map((name) => availableServices
                  .firstWhere((service) => service['name'] == name)['id']
                  .toString())
                  .toList();
            });
          },
        );
      },
    );
  }
}
