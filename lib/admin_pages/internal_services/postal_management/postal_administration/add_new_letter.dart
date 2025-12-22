import 'package:citizen_care_system/admin%20_component/citizen_service_task/action_button.dart';
import 'package:citizen_care_system/admin_pages/citizen_management/citizen_data/info_request/office_data.dart';
import 'package:citizen_care_system/admin_pages/internal_services/postal_management/postal_administration/post_management_details.dart';
import 'package:citizen_care_system/admin_pages/internal_services/postal_management/postal_administration/postal_management_filter_page.dart';
import 'package:citizen_care_system/component/custom_app_bar.dart';
import 'package:citizen_care_system/component/custom_back_button.dart';
import 'package:citizen_care_system/component/request_service/date_picker_field.dart';
import 'package:citizen_care_system/component/request_service/dropdown_selector.dart';
import 'package:citizen_care_system/component/request_service/multi_select_dialog.dart';
import 'package:citizen_care_system/component/popup_select_dropdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddNewLetter extends StatefulWidget {
  const AddNewLetter({super.key});

  @override
  State<AddNewLetter> createState() => _AddNewLetterState();
}

class _AddNewLetterState extends State<AddNewLetter> {
  List<String> selectedLetterSrc = [];
  List<String> availableLetterSrc = [
    'Registered',
    'Normal Post',
    'Email',
    'On Arrival'
  ];
  List<String> selectedLocations = [];
  String? selectedReplyStatus;
  String? selectedProcessStatus;
  DateTime? recievedDate;
  PlatformFile? _uploadFile;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _letterfromController = TextEditingController();
  final TextEditingController _lettertitleController = TextEditingController();
  final TextEditingController _letterrefController = TextEditingController();

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
  Widget _buildTextField(String hinttext, TextEditingController controller) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hinttext,
            hintStyle: const TextStyle(
              color: Colors.grey, // Hint-like color
              fontSize: 16,
            ),
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
      body: SingleChildScrollView(
        child: Container(
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
                        'Add New Record',
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

                //Letter Source Selection
                const Center(
                  child: Text(
                    'Select Letter Source',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownSelector(
                  hintText: selectedLetterSrc.isEmpty
                      ? 'Nothing Selected'
                      : '${selectedLetterSrc.length} Types selected',
                  onTap: () => _showLetterSrcDialog(context),
                  hasSelection: selectedLetterSrc.isNotEmpty,
                ),
                const SizedBox(height: 8),

                //Letter From Text Field
                const Center(
                  child: Text(
                    'Letter From',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField('Enter Letter From', _letterfromController),

                //Letter Title Text Field
                const Center(
                  child: Text(
                    'Letter Title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField('Enter Letter Title', _lettertitleController),

                //Letter Reference Text Field
                const Center(
                  child: Text(
                    'Letter Reference',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField('Enter Letter Reference', _letterrefController),

                //Select Reply Status
                const Center(
                  child: Text(
                    'Reply Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                PopupSelectDropdown(
                    items: const ['Required', 'Not Required'],
                    selectedValue: selectedReplyStatus,
                    hintText: 'Select an Status',
                    onChanged: (value) {
                      setState(() {
                        selectedReplyStatus = value;
                      });
                    }),
                const SizedBox(height: 8),

                //Date Section
                const Center(
                  child: Text(
                    'Set Recieved Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                DatePickerField(
                  label: 'Recieved Date',
                  selectedDate: recievedDate,
                  onDateSelected: (date) {
                    setState(() {
                      recievedDate = date;
                    });
                  },
                ),
                const SizedBox(height: 8),

                //Description Text Field
                const Center(
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Type your description here...",
                  ),
                ),
                const SizedBox(height: 8),

                //Document upload Section
                const Center(
                  child: Text(
                    'Attachment',
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
                        Text('Upload Attachment'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                //Select Process Status
                const Center(
                  child: Text(
                    'Reply Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                PopupSelectDropdown(
                    items: const [
                      'Request Pending',
                      'Request Completed',
                      'Request Rejected'
                    ],
                    selectedValue: selectedProcessStatus,
                    hintText: 'Select an Status',
                    onChanged: (value) {
                      setState(() {
                        selectedProcessStatus = value;
                      });
                    }),
                const SizedBox(height: 8),

                //Location Selection
                const Center(
                  child: Text(
                    'Select Location',
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
                      : '${selectedLocations.length} loactions selected',
                  onTap: () => _showLocationsDialog(context),
                  hasSelection: selectedLocations.isNotEmpty,
                ),
                const SizedBox(height: 8),

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
                        } else if (recievedDate == null) {
                          _showValidationError(
                              context, 'Please select an Expire date');
                        } else if (selectedLetterSrc.isEmpty) {
                          _showValidationError(
                              context, 'Please Select document Type');
                        } else if (_uploadFile == null) {
                          _showValidationError(
                              context, 'Please Upload the document');
                        } else {
                          // If validation passes, navigate to the service details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PostalManagementFilterPage(),
                            ),
                          );
                        }
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 220, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ), 
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PostManagementDetails(),
                            ),
                          );
                      }, child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ],
            ),
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

  Future<void> _showLetterSrcDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: 'Select a Location',
          items: availableLetterSrc,
          initialSelection: selectedLetterSrc,
          onSelectionChanged: (newSelection) {
            setState(() {
              selectedLetterSrc = newSelection;
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
          title: 'Locations',
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
