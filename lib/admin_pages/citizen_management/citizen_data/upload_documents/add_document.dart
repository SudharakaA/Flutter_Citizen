import 'package:citizen_care_system/admin%20_component/citizen_service_task/action_button.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/info_request/office_data.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/upload_documents/upload_documents_filter_page.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:citizen_care_system/component/request_service/date_picker_field.dart';
import 'package:citizen_care_system/component/request_service/dropdown_selector.dart';
import 'package:citizen_care_system/component/request_service/multi_select_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddDocument extends StatefulWidget {
  const AddDocument({super.key});

  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  DateTime? expireDate;
  PlatformFile? _uploadFile;
  List<String> selectedLocations = [];
  List<String> selectedDocTypes = []; //initial
  List<String> availableDocTypes = [
    //available
    'Sesonal Meeting Decisions(Agriculture Help)',
    'Cultivations Advice(Agriculture Help)',
    'Price Commitee Decisions(Agriculture Help)',
    'Purchasing Harvest(Agriculture Help)',
    'Farmer News(Agriculture Help)',
    'Central Government(Government Notices)',
    'Provincial Council(Government Notices)',
    'District Secretariat(Government Notices)',
    'Grama Niladari(Government Notices)',
    'Divisional Secretatriat(Government Notices)',
    'Government Sector(Carrers)',
    'Private Sector(Carrers)',
    'Foreign(Carrers)'
        'Business Advice(Bussines Assistance)',
    'Business Training(Business Assistance)'
  ];

  final TextEditingController _titleController = TextEditingController();

  // Function to select a file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      _uploadFile = result.files.first;
      // setState(() {
      //   _uploadFile = result.files.first;
      // });
    }
  }

  //Text Field Builder
  Widget _buildTextField(String hinttext) {
    return Column(
      children: [
        const Text(
          'Title',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: hinttext,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
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
          // ignore: deprecated_member_use
          color: const Color(0xFFE3E3E3).withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Column(
                children: [
                  Center(
                    child: Text(
                      'Add Document',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              _buildTextField('Document Title'),

              // Service Dropdown
              // const Center(
              //   child: Text(
              //     'Document type',
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),

              const Center(
                child: Text(
                  'Select Document type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DropdownSelector(
                hintText: selectedDocTypes.isEmpty
                    ? 'Nothing Selected'
                    : '${selectedDocTypes.length} Types selected',
                onTap: () => _showDocTypesDialog(context),
                hasSelection: selectedDocTypes.isNotEmpty,
              ),
              const SizedBox(height: 8),

              //Date Section
              const Center(
                child: Text(
                  'Set Expire Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Expire Date
              DatePickerField(
                label: 'Expire Date',
                selectedDate: expireDate,
                onDateSelected: (date) {
                  setState(() {
                    expireDate = date;
                  });
                },
              ),
              const SizedBox(height: 8),

              //Document upload Section
              const Center(
                child: Text(
                  'Document',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickFile,
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file_rounded),
                      Text('Upload Document'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              //Allowed Locations
              const Center(
                child: Text(
                  'Select Locations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DropdownSelector(
                hintText: selectedLocations.isEmpty
                    ? 'Nothing Selected'
                    : '${selectedLocations.length} Types selected',
                onTap: () => _showLocationsDialog(context),
                hasSelection: selectedLocations.isNotEmpty,
              ),
              const SizedBox(height: 20),

              // View Task Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionButton(
                    text: 'Submit',
                    icon: Icons.description,
                    onPressed: () {
                      // Validate
                      if (_titleController.text.trim().isEmpty) {
                        _showValidationError(
                            context, 'Please Enter a Document Title');
                      } else if (expireDate == null) {
                        _showValidationError(
                            context, 'Please select an Expire date');
                      } else if (selectedDocTypes.isEmpty) {
                        _showValidationError(
                            context, 'Please Select document Type');
                      } else if (_uploadFile == null) {
                        _showValidationError(
                            context, 'Please Upload the document');
                      } else if (selectedLocations.isEmpty) {
                        _showValidationError(
                            context, 'Please Select a Location');
                      } else {
                        // If validation passes, navigate to the service details page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadDocumentsFilterPage(),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 38,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 220, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UploadDocumentsFilterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show a validation error message
  void _showValidationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showDocTypesDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: 'Select Document type',
          items: availableDocTypes,
          initialSelection: selectedDocTypes,
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedDocTypes = newSelection;
            });
          },
        );
      },
    );
  }

  Future<void> _showLocationsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: 'Select a Location',
          items: OfficeData.availableOffcies,
          initialSelection: selectedLocations,
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedLocations = newSelection;
            });
          },
        );
      },
    );
  }
}
